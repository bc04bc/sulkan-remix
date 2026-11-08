#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/surface-data.glsl"
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
uniform sampler2D Depth;
uniform sampler2D HandDepth;
uniform sampler2D Scene;
uniform usampler2D Surface;
#include "shaders/reflections.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 reflection;

void main() {
    reflection=vec4(0);
#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
    if(CameraPositionHighAndFogType.w>0.5) return;
    ivec2 depthSize=textureSize(Depth,0);
    // 半分辨率目标（scale: 0.5）：每个片元对应全分辨率 2x2 块，直接映射全分辨率几何与深度
    ivec2 selected=ivec2(gl_FragCoord.xy)*2;
    if(selected.x>=depthSize.x || selected.y>=depthSize.y) return;

    float nearest=texelFetch(Depth,selected,0).r;
    uvec2 data=texelFetch(Surface,selected,0).rg;
    // 关键 Early-Out：表面不可反光、不匹配或处于手部深度时立即退出，0 射线步进开销！
    if(!surfaceReflective(data) || !surfaceMatches(data,nearest)
        || texelFetch(HandDepth,selected,0).r>1e-7) return;

    vec2 uv=(vec2(selected)+0.5)/vec2(depthSize);
    vec3 position=mat3(InverseView)*viewPosition(uv,nearest);
    vec3 normal=surfaceNormal(data.x);
    vec3 toEye=normalize(sulkanCameraOffset()-position);
    vec3 ray=reflect(-toEye,normal);
    vec3 local=texelFetch(Scene,selected,0).rgb;
    // 掠射角极小（垂直视线）时仅保留微弱环境背景，跳过繁重的 SSR 步进
    float weight=surfaceFresnel(data,normal,toEye)*WATER_REFLECTION_STRENGTH*surfaceVisibility(data);
    if(weight<0.035) {
        reflection=vec4(sulkanReflectionBackground(position,ray,surfaceSky(data),local,false),1.0);
        return;
    }
    reflection=vec4(sulkanWaterReflection(position,normal,ray,surfaceSky(data),local),1.0);
#endif
}
