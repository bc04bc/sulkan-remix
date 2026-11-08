#version 450
#include "shaders/common.glsl"
#include "shaders/terrain-globals.glsl"
#include "shaders/include/terrain_material.glsl"
#include "shaders/palette.glsl"
#include "shaders/include/native_shadows.glsl"
#include "shaders/environment.glsl"
#include "shaders/specular.glsl"
#include "shaders/held-light.glsl"
uniform sampler2D u_BlockTex;
uniform sampler2D u_LightTex;
#ifdef SULKAN_TRANSLUCENT
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
#endif
#include "shaders/surface-data.glsl"
#include "shaders/ice.glsl"
layout(location=0) in vec4 tint;
layout(location=1) in vec2 uv;
layout(location=2) in vec3 relativePosition;
layout(location=3) in vec2 lightLevel;
layout(location=4) in float fade;
layout(location=5) flat in uint materialId;
layout(location=6) flat in uint terrainMaterial;
layout(location=0) out vec4 color;
layout(location=1) out uvec2 surfaceData;

void main() {
    // 1. 严格遵守 Vulkan SPIR-V 规范：偏导数放在任何 discard 前执行，杜绝 Quad 导数发散
    vec3 crossNormal = cross(dFdx(relativePosition), dFdy(relativePosition));

    // 2. 真正的 Cutout 硬件位检测：Sodium 将 Alpha 阈值编码在 terrainMaterial 的 bit 1..2 中！
    uint cutoffBits = (terrainMaterial >> 1u) & 3u;
    bool isCutout = (cutoffBits != 0u) || (materialId >= 2u && materialId <= 5u);

    // 3. 极速 Alpha Cutout 剔除：使用 textureLod 0 避免各向异性过滤阻塞，透明像素立即退出！
    vec4 base;
    if (isCutout) {
        base = textureLod(u_BlockTex, uv, 0.0) * tint;
        float threshold = (cutoffBits == 1u) ? 0.1 : ((cutoffBits == 2u) ? 0.5 : 0.1);
        if (base.a < threshold) discard;
    } else {
        base = sulkanSampleTerrainMaterial(u_BlockTex, uv, terrainMaterial) * tint;
    }

#ifdef SULKAN_TRANSLUCENT
    if (base.a <= 1.0/255.0) discard;
#endif

    vec3 eyeDirection = normalize(sulkanCameraOffset() - relativePosition);
    vec3 geomNormal = crossNormal * inversesqrt(max(dot(crossNormal, crossNormal), 1e-12));
    if (dot(geomNormal, eyeDirection) < 0.0) geomNormal = -geomNormal;
    vec3 normal = geomNormal;

    vec3 albedo = toLinear(base.rgb);
    float distSq = dot(relativePosition, relativePosition);
    float worldDistance = sqrt(distSq);
    float overworld = 1.0 - step(0.5, abs(WorldTimeWeatherDimension.w));
    float daylight = sulkanDay();
    vec3 sunDirection = daylight > 0.5 ? SunDirectionAndRainBrightness.xyz : MoonDirectionAndPhase.xyz;
    float skyLight = lightLevel.y * lightLevel.y;

    float texLuma = dot(albedo, vec3(0.299, 0.587, 0.114));
    float microOccl = clamp(0.82 + (texLuma - 0.35) * 0.45, 0.72, 1.15);
    float axisShade = 1.0 - 0.12 * abs(geomNormal.x) - 0.06 * abs(geomNormal.z) - 0.18 * max(-geomNormal.y, 0.0);

    vec3 zenithSky = mix(vec3(0.012, 0.020, 0.045), vec3(0.28, 0.46, 0.78), daylight);
    vec3 groundBounce = portLightPalette() * vec3(0.42, 0.35, 0.24) * (0.4 + 0.6 * daylight);
    float hemiWeight = normal.y * 0.5 + 0.5;
    vec3 skyFill = mix(groundBounce * 0.45, zenithSky, hemiWeight) * axisShade;
    skyFill = mix(skyFill, vec3(dot(skyFill, vec3(0.299, 0.587, 0.114))), WorldTimeWeatherDimension.y * 0.65);

    float shadow = 1.0;
    float sunVisibility = 0.0;
    vec3 lighting;
    vec3 storedNormal = geomNormal;
    bool enhancedWater = false;
    float hdrBoost = 0.0;
    bool ice = false;
    float iceRoughness = 0.0;

    if (isCutout) {
        // ================= [100% 激活的极速树叶/植物通道] =================
        // 完全不采样 4 级联 Shadow Map！仅仅在近处 16 格内做 1 次极速单点采样，
        // 彻底解除 15 层重叠树叶的纹理缓存阻塞！
        float sunDot = dot(normal, sunDirection);
        float sunFacing = max(abs(sunDot), 0.35);

#if SHADOW_QUALITY > 0
        if (distSq < 256.0 && lightLevel.y > 0.82) {
            vec4 clip = ShadowViewProjection[0] * vec4(relativePosition + geomNormal * 0.08 + LightDirection.xyz * 0.18, 1.0);
            vec3 coord = vec3(clip.xy * 0.5 + 0.5, clip.z);
            sunVisibility = step(coord.z - 0.0035, textureLod(SulkanShadowMap0, coord.xy, 0.0).r);
        } else {
            // 利用原版光照高度梯度直接生成丝滑的树冠体积阴影（0 纹理采样！）
            float canopy = clamp((lightLevel.y - 0.58) * 2.4, 0.0, 1.0);
            sunVisibility = canopy * canopy;
        }
        shadow = mix(1.0, mix(ShadowParams.z, 1.0, sunVisibility), ShadowParams.x);
#else
        sunVisibility = 1.0;
#endif
        vec3 direct = portLightPalette() * sunFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
        float sss = max(dot(-eyeDirection, sunDirection), 0.0) * sunVisibility * daylight * (1.0 - WorldTimeWeatherDimension.y);
        vec3 leafGlow = albedo * portLightPalette() * (sss * sss * 0.45);
        lighting = vec3(0.022) + skyLight * (skyFill * 0.48 + direct * 0.92 + leafGlow);

    } else {
        // ================= [固体与半透明地形通道] =================
        ice = (materialId >= 12u && materialId <= 14u);
        if (ice) normal = sulkanIceDetail(relativePosition, normal, iceRoughness);
        if (materialId == 12u) albedo = vec3(0.72, 0.86, 0.92);
        storedNormal = ice ? normal : geomNormal;

        float sunDot = dot(normal, sunDirection);
        float sunFacing = max(sunDot, 0.0);

#if SHADOW_QUALITY > 0
        shadow = mix(1.0, ShadowParams.z, ShadowParams.x);
        if (sunFacing > 0.0 && lightLevel.y > 1.0/30.0 + 1e-4) {
            shadow = sulkanTerrainShadows(relativePosition, geomNormal, false, sunVisibility);
        }
#else
        sunVisibility = 1.0;
#endif
        float directFacing = smoothstep(-0.05, 0.95, sunDot) * sunFacing;
        vec3 direct = portLightPalette() * directFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
        vec3 giFill = groundBounce * (1.0 - hemiWeight * 0.6) * smoothstep(0.1, 0.9, lightLevel.y) * 0.28;
        lighting = vec3(0.020) + skyLight * (skyFill * 0.45 + giFill + direct * 1.05);

        float shadowContrast = (1.0 - shadow) * daylight * (1.0 - WorldTimeWeatherDimension.y);
        lighting *= mix(vec3(1.0), vec3(0.70, 0.78, 0.92), shadowContrast * skyLight * 0.55);
    }

    // 火把与方块光源
    float bl = lightLevel.x;
    float blockLight = bl * bl * bl * (bl * 1.8 + 0.2);
    vec3 torchPalette = mix(vec3(1.6, 0.45, 0.12), vec3(1.8, 1.15, 0.65), bl * bl);
    vec3 warmBlock = mix(vec3(1.0), torchPalette, clamp(LIGHT_WARMTH, 0.0, 1.5));
    lighting += warmBlock * blockLight * microOccl * 1.65;

    vec3 vanillaLight = texture(u_LightTex, lightLevel * (15.0/16.0)).rgb;
    vec3 heldLight = sulkanHeldLight(relativePosition, normal);
    vec3 surface = albedo * (mix(toLinear(vanillaLight), max(lighting, vec3(0.0)), overworld) + heldLight);

    float nearSource = smoothstep(0.65, 1.0, lightLevel.x);
    surface += torchPalette * (nearSource * nearSource * 0.06 * clamp(LIGHT_WARMTH, 0.0, 1.5));

    if (!isCutout) {
        float wet = 0.0;
        if (materialId != 1u && overworld > 0.5 && CameraPositionHighAndFogType.w < 0.5) {
            wet = WET_SURFACES * WorldTimeWeatherDimension.y * smoothstep(0.88, 1.0, lightLevel.y) * smoothstep(0.0, 0.7, normal.y);
            if (materialId >= 9u) wet = 0.0;
            surface *= 1.0 - 0.22 * wet;
            float materialWeight = (materialId >= 6u && materialId <= 8u) ? MATERIAL_SHEEN : 0.0;
            float microRough = clamp(1.0 - (texLuma - 0.35) * 0.65, 0.75, 1.25);
            float roughness = mix(0.68, materialId == 6u ? 0.22 : (materialId == 8u ? 0.62 : 0.42), materialWeight) * microRough;
            float distAa = smoothstep(12.0, 64.0, worldDistance) * 0.25;
            roughness = clamp(roughness + distAa, 0.15, 0.95);
            float reflectance = mix(0.035, 0.18, materialId == 6u ? materialWeight : 0.0);
            if (ice) {
                roughness = mix(0.24, 0.46, iceRoughness);
                reflectance = 0.025;
            }
            
            if (sunVisibility > 0.01) {
                float highlight = sulkanSunSpecular(normal, eyeDirection, mix(roughness, 0.22, wet), reflectance);
                surface += portLightPalette() * highlight * sunVisibility * skyLight;
            }
            float envReflect = max(wet, (materialId == 6u ? 0.15 : 0.0) * materialWeight);
            if (envReflect > 0.001) {
                float t = 1.0 - max(dot(normal, eyeDirection), 0.0);
                float t2 = t * t;
                float fresnel = 0.02 + 0.18 * (t2 * t2 * t);
                surface += sulkanSky(reflect(-eyeDirection, normal)) * envReflect * fresnel * skyLight;
            }
        }

        float emission = 0.0;
        if (materialId == 9u) emission = smoothstep(0.15, 0.60, max(albedo.r, max(albedo.g, albedo.b)));
        if (materialId == 10u) emission = smoothstep(0.12, 0.5, albedo.r) * 0.8;
        if (materialId == 11u) emission = smoothstep(0.08, 0.4, albedo.r - max(albedo.g, albedo.b)) * 0.9;
        if (emission > 0.0) {
            vec3 emissiveColor = albedo * sqrt(max(albedo, vec3(0.01)));
            surface = mix(surface, emissiveColor * 0.95, clamp(emission * EMISSIVE_ACCENTS, 0.0, 0.95));
        }
        if (materialId == 9u && emission > 0.05) hdrBoost = 3.0;
        else if (materialId == 6u && (sunVisibility > 0.4 || wet > 0.3)) hdrBoost = 2.0;
        else if (materialId == 10u || materialId == 11u) hdrBoost = 1.0;
    }

    base.rgb = pow(max(surface, vec3(0.0)), vec3(1.0/2.2));

#ifdef SULKAN_TRANSLUCENT
#if WATER_ENABLED == 1
    if (materialId == 1u && CameraPositionHighAndFogType.w < 0.5) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 worldXZ = relativePosition.xz + mod(CameraPositionHighAndFogType.xz, vec2(4096.0)) + CameraPositionLowAndFarPlane.xz;
        float t = TimeDeltaFrame.x * 0.25;
        vec2 wave = vec2(cos(dot(worldXZ, vec2(2.2, 1.24)) + t * 1.2), sin(dot(worldXZ, vec2(-1.12, 2.48)) - t * 0.9));
        vec2 refractedUv = clamp(screenUv + wave * WATER_WAVES * 0.0008 / (1.0 + worldDistance * 0.025), ViewSizeAndInverse.zw, vec2(1.0) - ViewSizeAndInverse.zw);
        float surfaceDistance = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        if (backDistance < surfaceDistance) refractedUv = screenUv;
        backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        float thickness = clamp(backDistance - surfaceDistance, 0.0, 160.0);
        vec3 waterNormal = normalize(normal + vec3(wave.x, 0.0, wave.y) * (0.018 * WATER_WAVES));
        vec3 waterTint = mix(vec3(0.035, 0.21, 0.28), tint.rgb * vec3(0.2, 0.65, 0.75), 0.25);
        vec4 background = linearSample(Opaque, refractedUv);
        if (background.a > 0.0) {
            vec3 absorption = exp(-thickness * WATER_DENSITY * vec3(0.16, 0.065, 0.035));
            vec3 waterLighting = mix(toLinear(vanillaLight), max(lighting, vec3(0.0)), overworld) + heldLight;
            vec3 scattering = toLinear(waterTint) * waterLighting;
            vec3 transmission = toLinear(background.rgb) * absorption + scattering * (1.0 - absorption);
            storedNormal = waterNormal;
            enhancedWater = true;
            vec3 waterColor = transmission;
            waterColor += portLightPalette() * sulkanSunSpecular(waterNormal, eyeDirection, 0.16, 0.02) * sunVisibility * skyLight * overworld;
            base = vec4(pow(max(waterColor, vec3(0.0)), vec3(1.0/2.2)), 1.0);
        }
    }
#endif
    if (materialId == 12u) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 distortion = (mat3(View) * normal).xy * 0.0007 / (1.0 + worldDistance * 0.025);
        vec2 refractedUv = clamp(screenUv + distortion, ViewSizeAndInverse.zw, vec2(1.0) - ViewSizeAndInverse.zw);
        float front = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDepth = texture(OpaqueDepth, refractedUv).r;
        if (backDepth > 1e-7 && length(viewPosition(refractedUv, backDepth)) < front) refractedUv = screenUv;
        backDepth = texture(OpaqueDepth, refractedUv).r;
        float thickness = backDepth > 1e-7 ? clamp(length(viewPosition(refractedUv, backDepth)) - front, 0.0, 12.0) : 1.0;
        vec4 background = linearSample(Opaque, refractedUv);
        vec3 transmission = background.a > 0.0 ? toLinear(background.rgb) : sulkanSky(normalize(relativePosition));
        vec3 absorption = exp(-thickness * vec3(0.04, 0.016, 0.008));
        vec3 iceColor = transmission * absorption + albedo * (vec3(1.0) - absorption) * 0.25;
        float haze = mix(0.025, 0.085, smoothstep(0.2, 0.85, iceRoughness));
        haze = clamp(haze + 0.015 * (1.0 - exp(-thickness * 0.3)), 0.0, 0.10);
        iceColor = mix(iceColor, albedo * (lighting + heldLight) * 0.65, haze);
        iceColor += portLightPalette() * sulkanSunSpecular(normal, eyeDirection, mix(0.24, 0.46, iceRoughness), 0.025) * sunVisibility * skyLight * overworld;
        base = vec4(pow(max(iceColor, vec3(0.0)), vec3(1.0/2.2)), 1.0);
    }
#endif

    float sphericalFog = clamp((worldDistance - u_EnvironmentFog.x) / max(u_EnvironmentFog.y - u_EnvironmentFog.x, 0.001), 0.0, 1.0);
    if (overworld > 0.5 && CameraPositionHighAndFogType.w < 0.5) sphericalFog = 0.0;
    float cylinder = max(length(relativePosition.xz), abs(relativePosition.y));
    float renderFog = clamp((cylinder - u_RenderFog.x) / max(u_RenderFog.y - u_RenderFog.x, 0.001), 0.0, 1.0);
    float fog = max(1.0 - fade, max(materialId == 1u && CameraPositionHighAndFogType.w < 0.5 ? 0.0 : sphericalFog, renderFog)) * u_FogColor.a;
    vec3 fogColor = u_FogColor.rgb;
    if (overworld > 0.5 && CameraPositionHighAndFogType.w < 0.5) {
        float skyAccess = min(smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z), smoothstep(0.01, 0.5, skyLight));
        fogColor = mix(fogColor, pow(sulkanSky(normalize(relativePosition)), vec3(1.0/2.2)), skyAccess);
    }
    vec3 finalOut = mix(base.rgb, fogColor, fog);
    float outDither = (fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5) * 1.5;
    color = vec4(clamp(finalOut + outDither / 255.0, 0.0, 1.0), base.a);
    surfaceData = uvec2(encodeSurface(storedNormal, skyLight, 1.0 - fog, enhancedWater, hdrBoost), floatBitsToUint(gl_FragCoord.z));
    if (ice) surfaceData.x |= 0x20000000u;
#ifdef SULKAN_TRANSLUCENT
    if (!enhancedWater) surfaceData.x |= 0xc0000000u;
#endif
}
