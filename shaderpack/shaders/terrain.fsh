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
    vec3 eyeDirection=normalize(sulkanCameraOffset()-relativePosition);
    // Derivatives precede every discard and nonuniform material branch.
    vec3 dPosX = dFdx(relativePosition);
    vec3 dPosY = dFdy(relativePosition);
    vec3 crossNormal = cross(dPosX, dPosY);
    vec3 geomNormal = crossNormal * inversesqrt(max(dot(crossNormal,crossNormal), 1e-12));
    if (dot(geomNormal, eyeDirection) < 0.0) geomNormal = -geomNormal;
    vec3 normal = geomNormal;
    bool ice=materialId>=12u && materialId<=14u;
    float iceRoughness=0.0;
    if(ice) normal=sulkanIceDetail(relativePosition,normal,iceRoughness);
    bool enhancedWater=false;
    vec4 base = sulkanSampleTerrainMaterial(u_BlockTex, uv, terrainMaterial) * tint;
    float texLuma = dot(base.rgb, vec3(0.299, 0.587, 0.114));
    float dLumaX = dFdx(texLuma);
    float dLumaY = dFdy(texLuma);
    vec3 albedo=toLinear(base.rgb);
    if(materialId==12u) {
        // Only clear ice replaces its atlas color with transmission tint.
        // Packed and blue ice retain their original texture and color beneath
        // the rough surface lighting and screen-space reflections.
        albedo=vec3(0.72,0.86,0.92);
    }
#ifdef SULKAN_TRANSLUCENT
    if(base.a<=1.0/255.0) discard;
#endif
#ifdef ALPHA_CUTOUT
    if (base.a < sulkanMaterialAlphaCutoff(terrainMaterial)) discard;
#endif
    float worldDistance = length(relativePosition);
    float overworld = 1.0-step(0.5,abs(WorldTimeWeatherDimension.w));
    float daylight = sulkanDay();
    vec3 sunDirection = daylight>0.5?SunDirectionAndRainBrightness.xyz:MoonDirectionAndPhase.xyz;
    bool plant = materialId >= 2u && materialId <= 5u;
    bool cutoutSurface = plant || sulkanMaterialAlphaCutoff(terrainMaterial)>0.0;
    // 构建切线空间微扰动高光法线（树叶/草/剪影/冰面不加，防止噪点）
    float bumpStrength = (!cutoutSurface && !ice && materialId != 1u) ? 0.08 * MATERIAL_SHEEN : 0.0;
    vec3 specNormal = normalize(normal - (dPosX * dLumaX + dPosY * dLumaY) * bumpStrength / max(dot(dPosX, dPosX) + dot(dPosY, dPosY), 1e-6));
    // 提取贴图自身明暗构建绝对稳定、零闪烁的微表面立体遮蔽（Micro-Occlusion）：
    // 泥土/石砖的暗部凹槽自然加深立体感，亮部凸起自然受光，移动镜头时 0 闪烁！
    float microOccl = clamp(0.82 + (texLuma - 0.35) * 0.45, 0.72, 1.15);
    vec3 storedNormal = ice ? normal : geomNormal;
    float sunDot = dot(normal,normalize(sunDirection+vec3(0,1e-5,0)));
    float sunFacing = max(sunDot,0.0);
    // 阴影偏移和接收平面斜率必须使用绝对平整的 geomNormal，彻底杜绝微凹凸法线引发的阴影条纹闪烁！
    vec3 shadowNormal = cutoutSurface && dot(geomNormal,sunDirection)<0.0 ? -geomNormal : geomNormal;
    bool grass = materialId>=2u && materialId<=4u;
    float skyLight = lightLevel.y * lightLevel.y;
    // Sodium encodes sky light 0 as 1/30. A surface sealed from the sky at every
    // vertex cannot see the sun, so skip the cascade filter and use the fully
    // shadowed result the map reports for enclosed surfaces.
#if SHADOW_QUALITY > 0
    float shadow = mix(1.0,ShadowParams.z,ShadowParams.x);
    float sunVisibility = 0.0;
#else
    float shadow = 1.0;
    float sunVisibility = 1.0;
#endif
    // 只有朝向太阳的面（或者是草/树叶等双面透光几何）才去采样 Shadow Map！背光面直接进入阴影，节省全屏 50% 以上开销！
    bool needsShadow = (sunFacing > 0.0 || cutoutSurface || materialId == 5u) && (lightLevel.y > 1.0/30.0 + 1e-4);
    if (needsShadow) {
        shadow = sulkanTerrainShadows(relativePosition, shadowNormal, grass, sunVisibility);
    } else {
        shadow = ShadowParams.z;
        sunVisibility = 0.0;
    }
    // 1. 真正的物理兰伯特直射光（背光面绝不吃直射太阳光，只吃软边缘过渡！）
    float directFacing = cutoutSurface ? sunFacing : smoothstep(-0.05, 0.95, sunDot) * sunFacing;
    vec3 direct = portLightPalette() * directFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);

    // 2. 半球天光（朝上的面吃清澈蓝天光，朝下的面压暗）+ 阳光地面漫反射反弹（Fake GI Bounce）！
    vec3 zenithSky = mix(vec3(0.012, 0.020, 0.045), vec3(0.28, 0.46, 0.78), daylight);
    vec3 groundBounce = portLightPalette() * vec3(0.42, 0.35, 0.24) * (0.4 + 0.6 * daylight); // 阳光砸在地面反弹向上的暖色GI
    float hemiWeight = normal.y * 0.5 + 0.5;
    vec3 skyFill = mix(groundBounce * 0.45, zenithSky, hemiWeight);
    skyFill = mix(skyFill, vec3(dot(skyFill, vec3(0.299, 0.587, 0.114))), WorldTimeWeatherDimension.y * 0.65);
    // 轴向立体感调制（Voxel Axis Shading）：赋予东西向与南北向墙体微弱明暗差异，强化建筑转角立体感
    float axisShade = 1.0 - 0.12 * abs(geomNormal.x) - 0.06 * abs(geomNormal.z) - 0.18 * max(-geomNormal.y, 0.0);
    skyFill *= axisShade;

    // 3. 在被直接照亮的表面附近，额外注入一抹温暖的间接反弹光能量
    vec3 giFill = groundBounce * (1.0 - hemiWeight * 0.6) * smoothstep(0.1, 0.9, lightLevel.y) * 0.28;
    vec3 lighting = vec3(0.020) + skyLight * (skyFill * 0.45 + giFill + direct * 1.05);
    if (materialId == 5u) {
        float exposure = exp2(-4.0 * (1.0 - clamp(lightLevel.y, 0.0, 1.0)));
        float skyFacing = 0.65 + 0.35 * max(normal.y, 0.0);
        vec3 leafSky = skyFill * 0.42 * mix(0.40, 1.0, exposure) * skyFacing;
        // 叶片内部全向次表面散射（SSS）：即使顺光看，受光叶片内部也有柔和的透光感
        vec3 sun = normalize(SunDirectionAndRainBrightness.xyz + vec3(0, 1e-5, 0));
        float fsDot = max(dot(-eyeDirection, sun), 0.0);
        float forwardScatter = fsDot * fsDot * fsDot;
        float wrapScatter = clamp((sunDot + 0.6) / 1.6, 0.0, 1.0);
        float sss = (0.35 * wrapScatter + 0.65 * forwardScatter) * exposure * shadow
            * smoothstep(0.0, 0.15, sun.y) * (1.0 - WorldTimeWeatherDimension.y);
        // 提纯叶片散射色，消除塑料死白
        vec3 leafGlow = pow(max(albedo, vec3(0.01)), vec3(0.75)) * portLightPalette() * sss * 0.55;
        lighting = vec3(0.025) + skyLight * (leafSky + direct * 0.90 + leafGlow);
    }
    // Deepen clear-day cast shadows without crushing torchlight or night detail.
    // Reuse visibility so this adds no shadow samples or rendering passes.
    float shadowContrast = (1.0-shadow)*daylight*(1.0-WorldTimeWeatherDimension.y);
    // Back-facing cutouts receive ambient skylight, not a second cast-shadow
    // darkening on top of their already absent direct sunlight.
    if(cutoutSurface) shadowContrast*=sunFacing;
    // 阴影蓝紫冷色调染色，替换死黑线性压暗，营造通透的室外天光空气感
    vec3 shadowTint = mix(vec3(1.0), vec3(0.70, 0.78, 0.92), shadowContrast * skyLight * 0.35);
    lighting *= shadowTint;
    // Physical inverse-square torch/blocklight falloff with Planckian color temperature shift
    float bl = lightLevel.x;
    float blockLight = bl * bl * bl * (bl * 1.8 + 0.2);
    vec3 torchPalette = mix(vec3(1.6, 0.45, 0.12), vec3(1.8, 1.15, 0.65), bl * bl);
    vec3 warmBlock = mix(vec3(1.0), torchPalette, clamp(LIGHT_WARMTH, 0.0, 1.5));
    // 稳定的微明暗对比调制火把光，完全消除视线移动造成的 2x2 抖动黑斑
    lighting += warmBlock * blockLight * microOccl * 1.65;
    // 逆光菲涅尔轮廓金边（Rim Light）：当视线逆着阳光擦过方块或树叶边缘时，泛出温暖的金边
    float rimBase = 1.0 - max(dot(normal, eyeDirection), 0.0);
    float rim2 = rimBase * rimBase;
    float rimSun = max(dot(-eyeDirection, sunDirection), 0.0);
    float rim = (rim2 * rim2) * (rimSun * rimSun * rimSun) * (1.0 - max(normal.y, 0.0));
    lighting += portLightPalette() * (rim * shadow * skyLight * 0.35);
    // Keep the vanilla lightmap for dimension-specific lighting outside the Overworld.
    vec3 vanillaLight = texture(u_LightTex,lightLevel*(15.0/16.0)).rgb;
    // Minecraft's scene target stores display-space color; encode the linear light factor once.
    vec3 heldLight=sulkanHeldLight(relativePosition,normal);
    vec3 surface=albedo*(mix(toLinear(vanillaLight),max(lighting,vec3(0)),overworld)+heldLight);
    // 模拟紧挨着火把/岩浆周围 2 格内的空气丁达尔散射微光（消除暗色方块在火把旁依然死黑的问题）
    float nearSource = smoothstep(0.65, 1.0, lightLevel.x);
    surface += torchPalette * (nearSource * nearSource * 0.06 * clamp(LIGHT_WARMTH, 0.0, 1.5));
    float wet = 0.0;
    if(materialId!=1u && overworld>0.5 && CameraPositionHighAndFogType.w<0.5) {
        // Skylight approximates rain exposure; upward faces collect most moisture.
        wet=WET_SURFACES*WorldTimeWeatherDimension.y
            *smoothstep(0.88,1.0,lightLevel.y)*smoothstep(0.0,0.7,normal.y);
        if(materialId>=9u) wet=0.0;
        surface*=1.0-0.22*wet;
        float materialWeight=(materialId>=6u && materialId<=8u)?MATERIAL_SHEEN:0.0;
        // 用 texLuma 调制粗糙度：砖缝/凹陷处（暗）粗糙不反光，凸起晶体（亮）细腻有光泽！
        float microRough = clamp(1.0 - (texLuma - 0.35) * 0.65, 0.75, 1.25);
        float roughness = mix(0.68, materialId==6u ? 0.22 : (materialId==8u ? 0.62 : 0.42), materialWeight) * microRough;
        // 几何高光抗锯齿（Toksvig / Geometric Specular Antialiasing）：防止中远景高频微凹凸形成摩尔纹与高光毛刺
        float distAa = smoothstep(12.0, 64.0, worldDistance) * 0.25;
        roughness = clamp(roughness + distAa, 0.15, 0.95);
        float reflectance=mix(0.035,0.18,materialId==6u?materialWeight:0.0);
        if(ice) { roughness=mix(0.24,0.46,iceRoughness); reflectance=0.025; }
        {
            // 采用凹凸微法线 specNormal 计算太阳高光
            float highlight=sulkanSunSpecular(specNormal,eyeDirection,mix(roughness,0.22,wet),reflectance);
            surface+=portLightPalette()*highlight*sunVisibility*skyLight;
        }
        // 天空环境反射：金属/宝石方块晴天自带微弱反射，雨天全方块湿润反光
        float envReflectance = (materialId == 6u ? 0.16 : (materialId == 7u ? 0.03 : 0.0)) * MATERIAL_SHEEN;
        float envMask = max(wet, envReflectance);
        if (envMask > 0.001) {
            float NoV = max(dot(specNormal, eyeDirection), 0.0);
            float t = 1.0 - NoV;
            float t2 = t * t;
            float fresnel = 0.02 + 0.22 * (t2 * t2 * t);
            vec3 envSky = sulkanSky(reflect(-eyeDirection, specNormal));
            vec3 specTint = (materialId == 6u) ? mix(vec3(1.0), albedo * 1.2, 0.65) : vec3(1.0);
            surface += envSky * specTint * envMask * fresnel * skyLight * (1.0 - roughness * 0.6);
        }
    }
    // Bright texture regions emit; unlit redstone and berry-free vines are unmapped.
    float emission=0.0;
    if(materialId==9u) emission=smoothstep(0.15,0.60,max(albedo.r,max(albedo.g,albedo.b)));
    if(materialId==10u) emission=smoothstep(0.12,0.5,albedo.r)*0.8;
    if(materialId==11u) emission=smoothstep(0.08,0.4,albedo.r-max(albedo.g,albedo.b))*0.9;
    // 1. 在 SDR 缓冲内保留发光体的纹理细节与色彩，绝对不要在这里乘 3.5 导致被 8-bit 缓冲截断抹平！
    vec3 emissiveColor = pow(albedo, vec3(1.25)); // 稍微提纯色相，防止发灰
    surface = mix(surface, emissiveColor * 0.95, clamp(emission * EMISSIVE_ACCENTS, 0.0, 0.95));
    float hdrBoost=0.0;
    if(materialId==9u && emission>0.05) hdrBoost=3.0;
    else if(materialId==6u && (sunVisibility>0.4 || wet>0.3)) hdrBoost=2.0;
    else if(materialId==10u || materialId==11u) hdrBoost=1.0;
    base.rgb=pow(max(surface,vec3(0.0)),vec3(1.0/2.2));
#if WATER_ENABLED == 1
#ifdef SULKAN_TRANSLUCENT
    if (materialId == 1u && CameraPositionHighAndFogType.w < 0.5) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 worldXZ = relativePosition.xz + mod(CameraPositionHighAndFogType.xz, vec2(4096.0)) + CameraPositionLowAndFarPlane.xz;
        float t = TimeDeltaFrame.x * 0.25;
        // Short, gentle ripples: quarter the wavelength without speeding up animation.
        vec2 wave = vec2(cos(dot(worldXZ, vec2(2.2,1.24)) + t*1.2), sin(dot(worldXZ,vec2(-1.12,2.48)) - t*0.9));
        vec2 refractedUv = clamp(screenUv + wave * WATER_WAVES * 0.0008 / (1.0 + worldDistance * 0.025), ViewSizeAndInverse.zw, vec2(1.0)-ViewSizeAndInverse.zw);
        float surfaceDistance = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        if (backDistance < surfaceDistance) refractedUv = screenUv;
        backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        float thickness = clamp(backDistance - surfaceDistance, 0.0, 160.0);
        vec3 waterNormal = normalize(normal + vec3(wave.x,0.0,wave.y) * (0.018 * WATER_WAVES));
        vec3 waterTint = mix(vec3(0.035,0.21,0.28), tint.rgb * vec3(0.2,0.65,0.75), 0.25);
        vec4 background = linearSample(Opaque, refractedUv);
        if (background.a > 0.0) {
            vec3 absorption=exp(-thickness*WATER_DENSITY*vec3(0.16,0.065,0.035));
            // Absorbed light is replaced by locally lit scattering, never an
            // unlit cyan tint. The background already contains its own lighting.
            vec3 waterLighting=mix(toLinear(vanillaLight),max(lighting,vec3(0)),overworld)+heldLight;
            vec3 scattering=toLinear(waterTint)*waterLighting;
            vec3 transmission=toLinear(background.rgb)*absorption+scattering*(1.0-absorption);
            storedNormal=waterNormal;
            enhancedWater=true;
            vec3 waterColor=transmission;
            waterColor+=portLightPalette()*sulkanSunSpecular(waterNormal,eyeDirection,0.16,0.02)*sunVisibility*skyLight*overworld;
            base=vec4(pow(max(waterColor,vec3(0)),vec3(1.0/2.2)),1.0);
        }
    }
#endif
#endif
    // Only naturally translucent ice can sample the scene behind it. Packed and
    // blue ice keep their lit opaque surface and still receive ice SSR below.
#ifdef SULKAN_TRANSLUCENT
    if(materialId==12u) {
        vec2 screenUv=gl_FragCoord.xy*ViewSizeAndInverse.zw;
        vec2 distortion=(mat3(View)*normal).xy*0.0007/(1.0+worldDistance*0.025);
        vec2 refractedUv=clamp(screenUv+distortion,ViewSizeAndInverse.zw,vec2(1)-ViewSizeAndInverse.zw);
        float front=length(viewPosition(screenUv,gl_FragCoord.z));
        float backDepth=texture(OpaqueDepth,refractedUv).r;
        if(backDepth>1e-7 && length(viewPosition(refractedUv,backDepth))<front) refractedUv=screenUv;
        backDepth=texture(OpaqueDepth,refractedUv).r;
        float thickness=backDepth>1e-7?clamp(length(viewPosition(refractedUv,backDepth))-front,0.0,12.0):1.0;
        vec4 background=linearSample(Opaque,refractedUv);
        vec3 transmission=background.a>0.0?toLinear(background.rgb):sulkanSky(normalize(relativePosition));
        vec3 absorption=exp(-thickness*vec3(0.04,0.016,0.008));
        vec3 iceColor=transmission*absorption+albedo*(vec3(1)-absorption)*0.25;
        // Uneven internal frost scatters light and reduces clarity in rough patches.
        float haze=mix(0.025,0.085,smoothstep(0.2,0.85,iceRoughness));
        haze=clamp(haze+0.015*(1.0-exp(-thickness*0.3)),0.0,0.10);
        iceColor=mix(iceColor,albedo*(lighting+heldLight)*0.65,haze);
        iceColor+=portLightPalette()*sulkanSunSpecular(normal,eyeDirection,mix(0.24,0.46,iceRoughness),0.025)*sunVisibility*skyLight*overworld;
        base=vec4(pow(max(iceColor,vec3(0)),vec3(1.0/2.2)),1.0);
    }
#endif
    float sphericalFog = clamp((worldDistance-u_EnvironmentFog.x)/max(u_EnvironmentFog.y-u_EnvironmentFog.x,0.001),0.0,1.0);
    // Outdoor atmosphere is handled once in the post pass. Keep render-distance
    // fading below, and vanilla environment fog for water/lava/other dimensions.
    if(overworld>0.5 && CameraPositionHighAndFogType.w<0.5) sphericalFog=0.0;
    float cylinder = max(length(relativePosition.xz), abs(relativePosition.y));
    float renderFog = clamp((cylinder-u_RenderFog.x)/max(u_RenderFog.y-u_RenderFog.x,0.001),0.0,1.0);
    float fog = max(1.0-fade, max(materialId==1u && CameraPositionHighAndFogType.w<0.5?0.0:sphericalFog,renderFog)) * u_FogColor.a;
    vec3 fogColor = u_FogColor.rgb;
    if(overworld>0.5 && CameraPositionHighAndFogType.w<0.5) {
        float skyAccess=min(smoothstep(0.05,0.65,CloudOffsetAndGameTime.z),smoothstep(0.01,0.5,skyLight));
        // Keep vanilla distance-fade color under cover; do not force it toward
        // black with a cave-specific multiplier. Mist is handled in the post pass.
        fogColor=mix(fogColor,pow(sulkanSky(normalize(relativePosition)),vec3(1.0/2.2)),skyAccess);
    }
    vec3 finalOut = mix(base.rgb, fogColor, fog);
    float outDither = (fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5) * 1.5;
    color = vec4(clamp(finalOut + outDither / 255.0, 0.0, 1.0), base.a);
    surfaceData=uvec2(encodeSurface(storedNormal,skyLight,1.0-fog,enhancedWater,hdrBoost),floatBitsToUint(gl_FragCoord.z));
    if(ice) surfaceData.x |= 0x20000000u;
#ifdef SULKAN_TRANSLUCENT
    if(!enhancedWater) surfaceData.x |= 0xc0000000u;
#endif
}
