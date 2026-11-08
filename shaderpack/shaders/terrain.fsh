#version 450
#include "shaders/common.glsl"
#include "shaders/terrain-globals.glsl"
#include "shaders/include/terrain_material.glsl"
#include "shaders/environment.glsl"
#include "shaders/surface-data.glsl"

#ifdef SULKAN_TRANSLUCENT
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
#endif

uniform sampler2D u_BlockTex;
uniform sampler2D u_LightTex;

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
    // 1. 无条件前置求导：1-cycle 完成 2x2 Quad 寄存器差分，为硬件提前释放死 Lane 做准备
    vec3 dPosX = dFdx(relativePosition);
    vec3 dPosY = dFdy(relativePosition);
    vec2 dUvX  = dFdx(uv);
    vec2 dUvY  = dFdy(uv);

    // 2. 硬件 Cutout 极速检测与提前退出（死片元立即终止，无需保留 Helper Lane）
    uint cutoffBits = (terrainMaterial >> 1u) & 3u;
    vec4 base = ((terrainMaterial & 1u) != 0u ? textureGrad(u_BlockTex, uv, dUvX, dUvY) : textureLod(u_BlockTex, uv, 0.0)) * tint;
    if (cutoffBits != 0u && base.a < (cutoffBits == 1u ? 0.1 : 0.5)) discard;
#ifdef SULKAN_TRANSLUCENT
    if (base.a <= 1.0/255.0) discard;
#endif

    // 3. 存活片元求几何法线
    vec3 crossNormal = cross(dPosX, dPosY);
    vec3 geomNormal = crossNormal * inversesqrt(max(dot(crossNormal, crossNormal), 1e-12));
    if (dot(geomNormal, sulkanCameraOffset() - relativePosition) < 0.0) geomNormal = -geomNormal;

    // 4. 计算能见度（加入 IGN 抖动，让 3-bit 量化在远景边界丝滑无色带）
    float cylinder = max(length(relativePosition.xz), abs(relativePosition.y));
    float renderFog = clamp((cylinder - u_RenderFog.x) / max(u_RenderFog.y - u_RenderFog.x, 0.001), 0.0, 1.0);
    float fog = max(1.0 - fade, renderFog) * u_FogColor.a;
    float dither = (fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5) / 7.0;
    float visibility = clamp(1.0 - fog + dither, 0.0, 1.0);

    // 5. 下界/末地/水下等非主世界陆地环境极简回退（原版光照与雾直通）
    float overworld = 1.0 - step(0.5, abs(WorldTimeWeatherDimension.w));
    if (overworld < 0.5 || CameraPositionHighAndFogType.w >= 0.5) {
        vec3 vanillaLight = toLinear(texture(u_LightTex, lightLevel * (15.0/16.0)).rgb);
        base.rgb = mix(toLinear(base.rgb) * vanillaLight, toLinear(u_FogColor.rgb), fog);
        base.rgb = pow(max(base.rgb, vec3(0.0)), vec3(1.0/2.2));
    }

#ifdef SULKAN_TRANSLUCENT
#if WATER_ENABLED == 1
    // 半透明水体背景折射与物理吸收
    if (materialId == 1u && CameraPositionHighAndFogType.w < 0.5) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 worldXZ = relativePosition.xz + mod(CameraPositionHighAndFogType.xz, vec2(4096.0)) + CameraPositionLowAndFarPlane.xz;
        float t = TimeDeltaFrame.x * 0.25;
        vec2 wave = vec2(cos(dot(worldXZ, vec2(2.2, 1.24)) + t * 1.2), sin(dot(worldXZ, vec2(-1.12, 2.48)) - t * 0.9));
        vec2 refractedUv = clamp(screenUv + wave * WATER_WAVES * 0.0008, ViewSizeAndInverse.zw, vec2(1.0) - ViewSizeAndInverse.zw);
        float surfaceDist = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDepth = texture(OpaqueDepth, refractedUv).r;
        float backDist = backDepth > 1e-7 ? length(viewPosition(refractedUv, backDepth)) : surfaceDist;
        if (backDist < surfaceDist) {
            refractedUv = screenUv;
            backDepth = texture(OpaqueDepth, refractedUv).r;
            backDist = backDepth > 1e-7 ? length(viewPosition(refractedUv, backDepth)) : surfaceDist;
        }
        float thickness = clamp(max(backDist - surfaceDist, 0.0), 0.0, 160.0);
        vec4 bg = texture(Opaque, refractedUv);
        if (bg.a > 0.0) {
            vec3 absorption = exp(-thickness * WATER_DENSITY * vec3(0.16, 0.065, 0.035));
            vec3 waterTint = mix(vec3(0.035, 0.21, 0.28), tint.rgb * vec3(0.2, 0.65, 0.75), 0.25);
            // 注意：因为 G-Buffer 中的 bg.rgb 尚未打光，这里保持纯 Albedo 传输，统一交由 atmosphere.fsh 进行物理打光与高光合成！
            vec3 trans = toLinear(bg.rgb) * absorption + toLinear(waterTint) * (1.0 - absorption);
            base.rgb = pow(max(trans, vec3(0.0)), vec3(1.0/2.2));
            geomNormal = normalize(geomNormal + vec3(wave.x, 0.0, wave.y) * (0.018 * WATER_WAVES));
        }
    }
#endif
#endif

    color = base;

    // 6. 写入 64-bit 紧凑 G-Buffer
    bool isTransparent = false;
#ifdef SULKAN_TRANSLUCENT
    isTransparent = (materialId != 1u);
#endif
    surfaceData = packGbuffer(geomNormal, lightLevel, materialId, visibility, isTransparent, gl_FragCoord.z);
}
