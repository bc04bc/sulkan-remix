#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/cloud-field.glsl"
#include "shaders/include/native_shadows.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 lighting;
uniform sampler2D Depth;
uniform usampler2D Surface;
#include "shaders/surface-data.glsl"
#include "shaders/surface-normal.glsl"
void main() {
    ivec2 depthSize=textureSize(Depth,0);
    ivec2 center=clamp(ivec2(texCoord*vec2(depthSize)),ivec2(0),depthSize-1);
    vec2 centerUv=(vec2(center)+0.5)/vec2(depthSize);
    float depth=texelFetch(Depth,center,0).r;
    vec3 p=viewPosition(centerUv,max(depth,1e-6));

    float ao=0.0;
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION
    if(depth>1e-7) {
        uvec2 sData = texelFetch(Surface, center, 0).rg;
        vec3 n;
        if (surfaceMatches(sData, depth)) {
            n = mat3(View) * surfaceNormal(sData.x);
        } else {
            n = depthSurfaceNormal(Depth, centerUv);
        }
        // High-speed Spiral Poisson sampling (ground-truth contact crevices)
        float dither = fract(52.9829189 * fract(dot(centerUv, vec2(0.06711056, 0.00583715))));
        float baseRadius = clamp(1.2 / max(length(p), 0.2) * ViewSizeAndInverse.y * 0.45, 3.0, 10.0);
        // 预取投影逆参数，在采样循环内消灭所有 4x4 矩阵乘法
        vec2 projScale = vec2(InverseProjection[0][0], InverseProjection[1][1]);
        vec2 projDepth = vec2(InverseProjection[2][2], InverseProjection[3][2]);
        vec2 projW = vec2(InverseProjection[2][3], InverseProjection[3][3]);
        for(int i=0;i<4;i++) {
            float alpha = (float(i) + 0.5) / 4.0;
            float angle = float(i) * 2.39996323 + dither * 6.2831853;
            float sampleRadius = baseRadius * sqrt(alpha);
            vec2 offsetUv = centerUv + vec2(cos(angle), sin(angle)) * sampleRadius * ViewSizeAndInverse.zw;
            if(any(lessThan(offsetUv, vec2(0.0))) || any(greaterThanEqual(offsetUv, vec2(1.0)))) continue;
            ivec2 pixel = ivec2(offsetUv * vec2(depthSize));
            float sampleDepth = texelFetch(Depth, pixel, 0).r;
            if(sampleDepth <= 1e-7) continue;
            vec2 uv = (vec2(pixel) + 0.5) / vec2(depthSize);
            float sDepth = max(sampleDepth, 1e-6);
            float pw = sDepth * projW.x + projW.y;
            float invW = 1.0 / (abs(pw) < 1e-6 ? 1e-6 : pw);
            vec3 samplePos = vec3((uv * 2.0 - 1.0) * projScale, sDepth * projDepth.x + projDepth.y) * invW;
            vec3 delta = samplePos - p;
            float distance = length(delta);
            float planeDist = dot(n, delta);
            float normalDot = planeDist / max(distance, 0.001);
            float occl = smoothstep(0.05, 0.15, planeDist) * max(normalDot - 0.25, 0.0) * (1.0 / (1.0 + distance * distance * 1.6)) * smoothstep(2.6, 0.20, distance);
            ao += occl * 1.35;
        }
    }
#endif
    float shafts=0.0;
#if _SULKAN_ENABLED_SUN_SHAFTS
    if(abs(WorldTimeWeatherDimension.w)<0.5 && CameraPositionHighAndFogType.w<0.5 && SunDirectionAndRainBrightness.y>0.02 && CloudOffsetAndGameTime.z>0.05) {
        vec3 ray=sulkanRay(texCoord);
        vec3 sun=normalize(SunDirectionAndRainBrightness.xyz);
        float reach=depth>1e-7?min(length(p),96.0):96.0;
        // Optimized 8-step volume march with spatial dither
        float stepLength=reach/8.0;
        vec3 origin=sulkanCloudOrigin();
        float dither = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715))));
        for(int i=0;i<8;i++) {
            float distance=(float(i)+dither)*stepLength;
            vec3 relative=sulkanCameraOffset()+ray*distance;
            vec3 world=origin+relative;
            float visibility=sulkanVolumeShadow(relative);
#if CLOUD_QUALITY > 0
            float entry=max((cloudBottom()-world.y)/max(sun.y, 1e-4),0.0);
            float exitDistance=max((cloudBottom()+4.0-world.y)/max(sun.y, 1e-4),0.0);
            float span=max(exitDistance-entry,0.0);
            float cloudDepth=cloudDensity(world+sun*(entry+span*0.5))*span;
            visibility*=exp(-cloudDepth);
#endif
            float airDensity=exp(clamp((72.0-world.y)*0.018,-8.0,3.0));
            shafts+=visibility*airDensity*exp(-distance*0.012)*stepLength*0.006;
        }
        float fDot = max(dot(ray, sun), 0.0);
        float f2 = fDot * fDot; float f4 = f2 * f2; float f8 = f4 * f4;
        float forward = 0.08 + 0.92 * f8;
        shafts*=smoothstep(0.05,0.65,CloudOffsetAndGameTime.z)*forward*(1.0-WorldTimeWeatherDimension.y)*smoothstep(0.02,0.15,sun.y);
    }
#endif
    lighting=vec4(clamp(1.0-ao*0.30*AMBIENT_OCCLUSION,0.30,1.0),shafts,0.0,1.0);
}
