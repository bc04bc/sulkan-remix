#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/ground-mist.glsl"
#include "shaders/surface-normal.glsl"
#include "shaders/surface-data.glsl"
#include "shaders/specular.glsl"
#include "shaders/held-light.glsl"
#include "shaders/include/native_shadows.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 hdr;
uniform sampler2D Scene;
uniform usampler2D Surface;
uniform sampler2D Weather;
uniform sampler2D Depth;
uniform sampler2D HandDepth;
#if CLOUD_QUALITY > 0
uniform sampler2D Clouds;
uniform sampler2D CloudDistance;
#endif
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS
uniform sampler2D Lighting;
#endif
#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
#include "shaders/water-resolve.glsl"
#endif

void main() {
    vec3 c = toLinear(texture(Scene, texCoord).rgb);
    // 无条件前置计算屏幕亮度梯度（1-cycle 硬件 Quad 差分），用于后续构建零成本材质凹凸微法线！
    float rawLuma = dot(c, vec3(0.299, 0.587, 0.114));
    vec2 lumaGrad = vec2(dFdx(rawLuma), dFdy(rawLuma));

    uvec2 surface = texture(Surface, texCoord).rg;
    vec2 lightL = surfaceLightLevel(surface);
    // 1-Cycle 硬件差分获取方块光在屏幕上的入射方向（用于生成非太阳光源的凹凸立体阴影与高光！）
    vec2 blGrad = vec2(dFdx(lightL.x), dFdy(lightL.x));

    float depth = texture(Depth, texCoord).r;
    float handDepth = texture(HandDepth, texCoord).r;
    if (handDepth > 1e-7) {
        if (HandProjectionValid.x > 0.5 && abs(WorldTimeWeatherDimension.w) < 0.5 && CameraPositionHighAndFogType.w < 0.5) {
            vec3 position = mat3(InverseView) * viewPosition(texCoord, handDepth, InverseHandProjection);
            vec3 normal = mat3(InverseView) * depthSurfaceNormal(HandDepth, texCoord, InverseHandProjection);
            if (dot(normal, normal) > 0.5) {
                // 手持光源激活时，让手中物品的高亮部位（如火把火焰、灯笼芯）直接产生强烈的 HDR 自发光与 Bloom 光晕！
                float handEmit = smoothstep(0.35, 0.75, max(c.r, max(c.g, c.b))) * step(0.5, HeldLightPositionRadius.w);
                c += c * HeldLightColor.rgb * (handEmit * 3.2 * HELD_LIGHTING);
                c += (c + vec3(0.18)) * sulkanHeldLight(position, normal) * 0.85;
                float specular = sulkanSunSpecular(normal, normalize(-position), 0.55, 0.035);
                if (specular > 0.0) c += portLightPalette() * specular * sulkanDirectShadow(position, normal) * smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z);
            }
        }
        hdr = vec4(c, 1.0); return;
    }

    bool nativeSurface = surfaceMatches(surface, depth);
    bool sky = depth <= 1e-7;
    vec3 ray = sulkanRay(texCoord);
    vec3 viewSurface = sky ? vec3(0) : viewPosition(texCoord, depth);
    float distanceToScene = sky ? 60000.0 : min(length(viewSurface), 60000.0);
    bool overworld = abs(WorldTimeWeatherDimension.w) < 0.5;
    bool air = CameraPositionHighAndFogType.w < 0.5;

    // Depth-aware upsampling
    vec2 size = ceil(ViewSizeAndInverse.xy * 0.5), q = texCoord * size - 0.5, f = fract(q);
    ivec2 origin = ivec2(floor(q));
    vec4 light = vec4(0.0); vec4 cloud = vec4(0.0); float total = 0.0;
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS || CLOUD_QUALITY > 0
    float projZ2 = InverseProjection[2][3];
    float projZ3 = InverseProjection[3][3];
    float centerDenom = depth * projZ2 + projZ3;
    float centerLinZ = depth <= 1e-7 ? 60000.0 : abs(1.0 / (abs(centerDenom) < 1e-6 ? 1e-6 : centerDenom));
    for (int y = 0; y < 2; y++) for (int x = 0; x < 2; x++) {
        ivec2 pixel = clamp(origin + ivec2(x, y), ivec2(0), ivec2(size) - 1);
        vec2 uv = (vec2(pixel) + 0.5) / size;
        float d = texture(Depth, uv).r;
        float sampleDenom = d * projZ2 + projZ3;
        float sampleLinZ = d <= 1e-7 ? 60000.0 : abs(1.0 / (abs(sampleDenom) < 1e-6 ? 1e-6 : sampleDenom));
        float weight = (x == 0 ? 1.0 - f.x : f.x) * (y == 0 ? 1.0 - f.y : f.y);
        float separation = abs(sampleLinZ - centerLinZ) / max(centerLinZ * 0.02, 0.3);
        weight *= 1.0 / (1.0 + separation * separation);
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS
        light += texelFetch(Lighting, pixel, 0) * weight;
#else
        light += vec4(1.0, 0.0, 0.0, 0.0) * weight;
#endif
#if CLOUD_QUALITY > 0
        vec4 sampleCloud = texelFetch(Clouds, pixel, 0);
        if (texture(CloudDistance, uv).r > distanceToScene) sampleCloud = vec4(0.0);
        cloud += sampleCloud * weight;
#endif
        total += weight;
    }
#endif
    if (total > 1e-5) { light /= total; cloud /= total; } else { light = vec4(1.0, 0.0, 0.0, 0.0); cloud = vec4(0.0); }

    // =========================================================================
    // 延迟物理光照与材质质感引擎（Deferred Physically Based Lighting & Texturing）
    // =========================================================================
    if (!sky && nativeSurface && overworld && air) {
        vec3 albedo = c;
        vec3 position = mat3(InverseView) * viewSurface;
        vec3 normal = surfaceNormal(surface.x);
        vec3 toEye = normalize(sulkanCameraOffset() - position);
        uint matId = surfaceMaterialId(surface);
        bool isWater = (matId == 1u);
        bool isPlant = (matId >= 2u && matId <= 5u);
        bool isLeaves = (matId == 5u);
        bool isIce = (matId >= 12u && matId <= 14u);

        float daylight = sulkanDay();
        vec3 sunDirection = daylight > 0.5 ? SunDirectionAndRainBrightness.xyz : MoonDirectionAndPhase.xyz;
        float skyLight = lightL.y * lightL.y;

        // 1. 贴图微表面遮蔽（Micro-Occlusion）与轴向体素立体感（Voxel Axis Shading）
        float microOccl = isWater ? 1.0 : clamp(0.80 + (rawLuma - 0.35) * 0.50, 0.68, 1.18);
        float axisShade = 1.0 - 0.13 * abs(normal.x) - 0.06 * abs(normal.z) - 0.20 * max(-normal.y, 0.0);

        // 2. 屏幕空间免贴图凹凸微法线（Screen-Space Albedo Bump）：
        // 利用砖缝/木纹/矿石的明暗梯度偏转高光法线，距离超过 32 格平滑淡出防止摩尔纹！
        vec3 specNormal = normal;
        if (!isWater && !isPlant) {
            float bumpFade = (1.0 - smoothstep(10.0, 36.0, distanceToScene)) * MATERIAL_SHEEN;
            vec3 camRight = vec3(InverseView[0][0], InverseView[0][1], InverseView[0][2]);
            vec3 camUp    = vec3(InverseView[1][0], InverseView[1][1], InverseView[1][2]);
            vec3 bumpOffset = (camRight * lumaGrad.x + camUp * lumaGrad.y) * (2.2 * bumpFade);
            // 剥离法线方向分量，仅在切平面内扰动
            bumpOffset -= normal * dot(normal, bumpOffset);
            specNormal = normalize(normal - clamp(bumpOffset, vec3(-0.35), vec3(0.35)));
        }

        // 3. 半球天空环境光与暖色地面反弹光（Fake GI Bounce）
        vec3 zenithSky = mix(vec3(0.012, 0.020, 0.045), vec3(0.28, 0.46, 0.78), daylight);
        vec3 groundBounce = portLightPalette() * vec3(0.44, 0.36, 0.25) * (0.4 + 0.6 * daylight);
        float hemiWeight = specNormal.y * 0.5 + 0.5;
        vec3 skyFill = mix(groundBounce * 0.45, zenithSky, hemiWeight) * axisShade;
        skyFill = mix(skyFill, vec3(dot(skyFill, vec3(0.299, 0.587, 0.114))), WorldTimeWeatherDimension.y * 0.65);

        // 4. 级联阴影采样（利用 G-Buffer 单次执行优势，恢复所有可见像素的高精度投影）
        float sunDot = dot(normal, sunDirection);
        float sunFacing = isPlant ? max(abs(sunDot), 0.35) : max(sunDot, 0.0);
        float shadow = 1.0;
        float sunVisibility = 0.0;
#if SHADOW_QUALITY > 0
        shadow = mix(1.0, ShadowParams.z, ShadowParams.x);
        if ((sunFacing > 0.0 || isPlant) && lightL.y > 1.0/30.0 + 1e-4) {
            vec3 sNorm = (isPlant && sunDot < 0.0) ? -normal : normal;
            shadow = sulkanTerrainShadows(position, sNorm, isPlant, sunVisibility);
        }
#else
        sunVisibility = 1.0;
#endif

        vec3 lighting;
        if (isLeaves) {
            // 树叶专属：柔和包裹漫反射 + 逆光翡翠次表面散射 (Canopy SSS)
            float exposure = exp2(-3.5 * (1.0 - clamp(lightL.y, 0.0, 1.0)));
            vec3 leafSky = skyFill * 0.45 * mix(0.42, 1.0, exposure);
            float wrapFacing = clamp((sunDot + 0.45) / 1.45, 0.0, 1.0);
            vec3 direct = portLightPalette() * wrapFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
            
            float forwardDot = max(dot(-toEye, sunDirection), 0.0);
            float forwardScatter = forwardDot * forwardDot * forwardDot;
            float sss = (0.30 * wrapFacing + 0.70 * forwardScatter) * exposure * sunVisibility * daylight * (1.0 - WorldTimeWeatherDimension.y);
            vec3 leafGlow = pow(max(albedo, vec3(0.01)), vec3(0.75)) * portLightPalette() * (sss * 0.65);
            lighting = vec3(0.024) + skyLight * (leafSky + direct * 0.92 + leafGlow);
        } else {
            // 固体、草地与水体光照
            float directFacing = isPlant ? sunFacing : smoothstep(-0.05, 0.95, dot(specNormal, sunDirection)) * sunFacing;
            vec3 direct = portLightPalette() * directFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
            vec3 giFill = groundBounce * (1.0 - hemiWeight * 0.6) * smoothstep(0.1, 0.9, lightL.y) * 0.28;
            lighting = vec3(0.020) + skyLight * (skyFill * 0.45 + giFill + direct * 1.08);
        }

        // 晴天阴影冷色调瑞利染色（消除阴影发灰，提升通透对比度）
        float shadowContrast = (1.0 - shadow) * daylight * (1.0 - WorldTimeWeatherDimension.y);
        if (isPlant) shadowContrast *= max(sunDot, 0.25);
        lighting *= mix(vec3(1.0), vec3(0.66, 0.76, 0.92), shadowContrast * skyLight * 0.58);

        // 5. 非太阳光方向性阴影 + 彩色光源渲染 (Directional & Colored Block Lighting)
        float bl = lightL.x;
        float blockLight = bl * bl * bl * (bl * 1.8 + 0.2);

        // 重构方块光源 3D 入射向量：让砖块缝隙和背向火把的侧面产生真实的立体阴影！
        vec3 camRight = vec3(InverseView[0][0], InverseView[0][1], InverseView[0][2]);
        vec3 camUp    = vec3(InverseView[1][0], InverseView[1][1], InverseView[1][2]);
        vec3 blockLightDir = camRight * blGrad.x + camUp * blGrad.y;
        float blGradLen = length(blockLightDir);
        float blockDirShade = 1.0;
        float blockSpec = 0.0;
        if (blGradLen > 1e-5 && !isPlant && !isWater) {
            vec3 pDir = normalize(blockLightDir / blGradLen + toEye * 0.35);
            // 朝向火把的微凹凸面受光增强，背向火把的凹陷处压暗产生非太阳光阴影！
            blockDirShade = clamp(0.62 + 0.68 * dot(specNormal, pDir), 0.45, 1.35);
            // 火把/灯笼在矿石和石砖表面的暖色微高光
            vec3 bHalf = normalize(pDir + toEye);
            blockSpec = pow(max(dot(specNormal, bHalf), 0.0), 16.0) * bl * bl * MATERIAL_SHEEN * 0.35;
        }
        // 结合 SSAO 深度强化角落接触阴影（让火把照亮的墙角、箱子底有深邃投影）
        float blockContactShadow = mix(1.0, light.x * light.x, 0.65);

        // 基础普朗克色温 + 局部发光材质色彩注入（灵魂蓝、红石红、海晶青、紫水晶紫）
        vec3 torchPalette = mix(vec3(1.65, 0.42, 0.10), vec3(1.85, 1.20, 0.68), bl * bl);
        vec3 warmBlock = mix(vec3(1.0), torchPalette, clamp(LIGHT_WARMTH, 0.0, 1.5));
        if (matId >= 9u && matId <= 11u) {
            // 发光体自身及紧邻像素直接继承其贴图的纯粹色相（灵魂火把自动泛蓝光，红石泛红光！）
            vec3 chroma = albedo / max(rawLuma, 0.05);
            warmBlock = mix(warmBlock, chroma * 1.45, 0.75);
        }
        // 叠加来自 lighting.fsh 半分辨率屏幕空间的彩色光照扩散（Screen-Space Colored Light Bleeding）
        if (abs(light.b) + abs(light.a) > 1e-4) {
            vec3 bleedOffset = vec3(light.b, -(light.b + light.a) * 0.45, light.a) * 1.25;
            warmBlock = mix(warmBlock, max(warmBlock + bleedOffset, vec3(0.05)), clamp(bl * 1.5, 0.0, 0.75));
        }

        lighting += warmBlock * (blockLight * microOccl * blockDirShade * blockContactShadow * 1.70);

        // 逆光边缘菲涅尔金边（Rim Light）：勾勒方块与树冠立体轮廓
        float rimN = 1.0 - max(dot(specNormal, toEye), 0.0);
        float rimS = max(dot(-toEye, sunDirection), 0.0);
        float rim = (rimN * rimN * rimN * rimN) * (rimS * rimS * rimS) * (1.0 - max(normal.y, 0.0));
        lighting += portLightPalette() * (rim * sunVisibility * skyLight * 0.32);

        // 调用带 4-Step 屏幕空间动态遮挡阴影与高光的升级版手持光源！
        vec3 heldLight = sulkanHeldLightAdvanced(position, specNormal, toEye, 0.45, Depth);
        c = albedo * (lighting + heldLight) + warmBlock * blockSpec;

        float nearSource = smoothstep(0.65, 1.0, lightL.x);
        c += warmBlock * (nearSource * nearSource * 0.05 * clamp(LIGHT_WARMTH, 0.0, 1.5));

        // 6. PBR 微表面高光、金属环境反射与水体波光
        if (isWater) {
            // 水体太阳波光高光（Glints）
            if (sunVisibility > 0.01) {
                c += portLightPalette() * sulkanSunSpecular(normal, toEye, 0.14, 0.025) * sunVisibility * skyLight;
            }
        } else if (!isPlant) {
            float wet = WET_SURFACES * WorldTimeWeatherDimension.y * smoothstep(0.88, 1.0, lightL.y) * smoothstep(0.0, 0.7, normal.y);
            if (matId >= 9u) wet = 0.0;
            c *= (1.0 - 0.22 * wet);

            float materialWeight = (matId >= 6u && matId <= 8u) ? MATERIAL_SHEEN : 0.0;
            // 纹理暗部（砖缝）粗糙，亮部（晶体/抛光面）光滑
            float microRough = clamp(1.0 - (rawLuma - 0.35) * 0.75, 0.70, 1.30);
            float roughness = mix(0.66, matId == 6u ? 0.20 : (matId == 8u ? 0.58 : 0.38), materialWeight) * microRough;
            roughness = clamp(roughness + smoothstep(12.0, 64.0, distanceToScene) * 0.22, 0.14, 0.95);
            float reflectance = mix(0.038, 0.22, matId == 6u ? materialWeight : 0.0);
            if (isIce) { roughness = 0.28 * microRough; reflectance = 0.035; }

            if (sunVisibility > 0.01) {
                float highlight = sulkanSunSpecular(specNormal, toEye, mix(roughness, 0.20, wet), reflectance);
                // 金属高光带自身色泽（金块泛金光，铜块泛铜光）
                vec3 specTint = (matId == 6u) ? mix(vec3(1.0), albedo * 1.25, 0.60) : vec3(1.0);
                c += portLightPalette() * specTint * highlight * sunVisibility * skyLight;
            }
            float envReflect = max(wet, (matId == 6u ? 0.18 : (matId == 7u ? 0.04 : 0.0)) * materialWeight);
            if (envReflect > 0.001) {
                float nv = 1.0 - max(dot(specNormal, toEye), 0.0);
                float nv2 = nv * nv;
                float fresnel = reflectance + (1.0 - reflectance) * (nv2 * nv2 * nv);
                vec3 specTint = (matId == 6u) ? mix(vec3(1.0), albedo * 1.2, 0.65) : vec3(1.0);
                c += sulkanSky(reflect(-toEye, specNormal)) * specTint * envReflect * fresnel * skyLight * (1.0 - roughness * 0.5);
            }

            // 自发光方块与微光植物
            float emission = 0.0;
            if (matId == 9u) emission = smoothstep(0.15, 0.60, max(albedo.r, max(albedo.g, albedo.b)));
            if (matId == 10u) emission = smoothstep(0.12, 0.5, albedo.r) * 0.8;
            if (matId == 11u) emission = smoothstep(0.08, 0.4, albedo.r - max(albedo.g, albedo.b)) * 0.9;
            if (emission > 0.0) {
                vec3 emissiveColor = albedo * sqrt(max(albedo, vec3(0.01)));
                c = mix(c, emissiveColor * 0.95, clamp(emission * EMISSIVE_ACCENTS, 0.0, 0.95));
            }
        }
    }

#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
    if (nativeSurface && surfaceReflective(surface) && air) {
        vec3 position = mat3(InverseView) * viewSurface;
        c = toLinear(resolveWaterReflection(texCoord, surface, position, pow(max(c, vec3(0)), vec3(1.0/2.2))));
    }
#endif

    // SSAO 接触阴影遮挡
    if (!sky && !(nativeSurface && surfaceTransparent(surface))) c *= light.x;

    // HDR Boost 阶梯倍增
    if (nativeSurface) {
        float boost = surfaceHdrBoost(surface);
        float luma = max(c.r, max(c.g, c.b));
        c *= mix(1.0, boost, smoothstep(0.2, 0.85, luma));
    }

    // 非地形表面（原版实体、掉落物、粒子）：补充太阳高光与升级版手持光
    if (!sky && !nativeSurface) {
        vec3 position = mat3(InverseView) * viewSurface;
        vec3 normal = normalize(mat3(InverseView) * depthSurfaceNormal(Depth, texCoord) + vec3(0, 1e-8, 0));
        if (overworld && air) {
            vec3 toEye = normalize(sulkanCameraOffset() - position);
            float specular = sulkanSunSpecular(normal, toEye, 0.55, 0.035);
            if (specular > 0.0) c += portLightPalette() * specular * sulkanDirectShadow(position, normal) * smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z);
        }
        c += sqrt(max(c, vec3(0))) * sulkanHeldLight(position, normal) * 0.85;
    }

    // 大气透视、天空与丁达尔体积光
    if (overworld && air) {
        vec3 skyColor = sulkanSky(ray);
        if (sky) c = skyColor + sulkanCelestials(ray);
        else {
            float distance = min(distanceToScene, 1500.0);
            float skyAccess = smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z);
            if (nativeSurface) skyAccess = min(skyAccess, smoothstep(0.01, 0.5, surfaceSky(surface)));
            float fog = sulkanGroundMist(ray, distance) * skyAccess;
            if (nativeSurface) {
                float gbufFog = 1.0 - surfaceVisibility(surface);
                fog = max(fog, gbufFog);
            }
            float towardSun = max(dot(ray, SunDirectionAndRainBrightness.xyz), 0.0);
            float horizon = 1.0 - smoothstep(0.0, 0.5, abs(ray.y));
            vec3 distanceTint = mix(vec3(0.88, 0.97, 1.10), vec3(1.12, 1.01, 0.88),
                towardSun * towardSun * horizon);
            float distanceGrade = DISTANCE_COLOR * sulkanDay() * (1.0 - WorldTimeWeatherDimension.y);
            float ts2 = towardSun * towardSun;
            float mie = (ts2 * ts2 * towardSun) * (1.0 - WorldTimeWeatherDimension.y) * sulkanDay();
            vec3 mistColor = sulkanSky(normalize(vec3(ray.x, 0.25, ray.z))) * 0.70 + portLightPalette() * mie * 0.35;
            c = mix(c, mistColor * mix(vec3(1.0), distanceTint, distanceGrade * 0.5), fog);
        }
        c = c * (1.0 - cloud.a) + cloud.rgb;
        c += portLightPalette() * light.y * SUN_SHAFTS * 0.8;
    }

    vec4 weather = texture(Weather, texCoord);
    float weatherAlpha = clamp(weather.a, 0.0, 1.0);
    vec3 weatherColor = toLinear(weather.rgb / max(weatherAlpha, 1e-5));
    c = c * (1.0 - weatherAlpha) + weatherColor * weatherAlpha;
    hdr = vec4(max(c, vec3(0.0)), 1.0);
}
