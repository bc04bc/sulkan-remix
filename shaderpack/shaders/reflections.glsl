// Reflected view ray, coarse march/refinement,
// edge confidence, geometric rejection and shared cloud/sky background.
// Native implementation uses Vulkan [0,1] reversed depth, and current-frame opaque color.
#include "shaders/cloud-volume.glsl"
bool reflectionProject(vec3 position, out vec2 screen) {
    vec4 clip=Projection*vec4(position,1.0);
    if(clip.w<=0.001) return false;
    screen=clip.xy/clip.w*0.5+0.5;
    return all(greaterThan(screen,vec2(0.0))) && all(lessThan(screen,vec2(1.0))) && clip.z/clip.w>=0.0 && clip.z/clip.w<=1.0;
}

vec4 sulkanSceneReflection(vec3 worldPosition, vec3 worldNormal, vec3 reflectedRay) {
    vec3 origin=mat3(View)*(worldPosition+worldNormal*0.06);
    vec3 direction=normalize(mat3(View)*reflectedRay);
    float previous=0.0, distance=0.15;
    float previousDelta=-1e20;
    // 极速 4~6 步光线步进，深度优化纹理单元吞吐
    int steps = WATER_REFLECTION_QUALITY == 1 ? 4 : 6;
    float growth = WATER_REFLECTION_QUALITY == 1 ? 0.42 : 0.28;
    for(int i=0; i<6; i++) {
        if(i >= steps || distance > 192.0) break;
        vec3 point=origin+direction*distance;
        vec2 screen;
        if(!reflectionProject(point,screen)) break;
        float depth=texture(OpaqueDepth,screen).r;
        float coarseDelta=-1e20;
        if(depth>1e-7) {
            vec3 surface=viewPosition(screen,depth);
            float delta=surface.z-point.z;
            coarseDelta=delta;
            if(delta>=0.0 && (previousDelta<0.0 || delta<previousDelta)) {
                float lo=previous, hi=distance;
                // 2-step rapid binary refinement
                for(int refine=0;refine<2;refine++) {
                    float mid=(lo+hi)*0.5;
                    vec3 candidate=origin+direction*mid;
                    vec2 coord;
                    if(!reflectionProject(candidate,coord)) { hi=mid; continue; }
                    float d=texture(OpaqueDepth,coord).r;
                    float error=d>1e-7?viewPosition(coord,d).z-candidate.z:-1.0;
                    if(error>=0.0) hi=mid; else lo=mid;
                }
                point=origin+direction*hi;
                if(!reflectionProject(point,screen)) break;
                depth=texture(OpaqueDepth,screen).r;
                surface=viewPosition(screen,max(depth,1e-7));
                // 适度放宽厚度容差，命中率大幅提升，无需跑昂贵的 5-tap 十字修复
                float thickness=0.25+length(surface)*0.015;
                vec3 worldHit=mat3(InverseView)*surface;
                if(depth>1e-7 && abs(surface.z-point.z)<thickness && dot(worldHit-worldPosition,worldNormal)>0.03 && length(worldHit-worldPosition)>0.12) {
                    ivec2 size=textureSize(Opaque,0);
                    ivec2 pixel=clamp(ivec2(screen*vec2(size)),ivec2(0),size-1);
                    vec4 sampleColor=texelFetch(Opaque,pixel,0);
                    if(sampleColor.a>0.001) {
                        float edge=min(min(screen.x,screen.y),min(1.0-screen.x,1.0-screen.y));
                        float confidence=smoothstep(0.0,max(ViewSizeAndInverse.z,ViewSizeAndInverse.w),edge)*(1.0-smoothstep(144.0,192.0,hi));
                        return vec4(sampleColor.rgb,confidence);
                    }
                }
            }
        }
        previousDelta=coarseDelta;
        previous=distance;
        distance+=0.15+distance*growth;
    }
    // 未命中直接返回 0.0，优雅回退至天空背景，彻底消灭 15 次全矩阵乘法雪崩
    return vec4(0.0);
}
// Sky/background seen where tracing misses, or alone where tracing is skipped.
vec3 sulkanReflectionBackground(vec3 position, vec3 direction, float skyLight, vec3 localColor, bool clouds) {
    vec3 background=localColor*0.35;
    float skyAccess=min(smoothstep(0.02,0.65,skyLight),smoothstep(0.05,0.65,CloudOffsetAndGameTime.z));
    if(abs(WorldTimeWeatherDimension.w)<0.5 && skyAccess>0.001) {
        vec3 environment=sulkanSky(direction)+sulkanCelestials(direction);
        if(clouds && direction.y > 0.01) {
            vec3 cloudPos = sulkanCloudOrigin() + position + direction * ((cloudBottom() + 2.0 - (sulkanCloudOrigin().y + position.y)) / direction.y);
            vec4 cField = cloudField(cloudPos);
            vec3 cloudLit = sulkanSky(vec3(0,1,0)) * 0.65 + portLightPalette() * 0.85;
            environment = mix(environment, cloudLit * cField.rgb, cField.a * smoothstep(0.01, 0.15, direction.y));
        }
        background=mix(background,pow(max(environment,vec3(0)),vec3(1.0/2.2)),skyAccess);
    }
    return background;
}
vec3 sulkanWaterReflection(vec3 position, vec3 normal, vec3 direction, float skyLight, vec3 localColor) {
    vec4 scene=sulkanSceneReflection(position,normal,direction);
    if(scene.a>0.999) return scene.rgb;
    return mix(sulkanReflectionBackground(position,direction,skyLight,localColor,true),scene.rgb,scene.a);
}
