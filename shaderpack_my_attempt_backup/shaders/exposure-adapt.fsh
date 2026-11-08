#version 450
#include "shaders/common.glsl"
uniform sampler2D Meter;
uniform sampler2D Previous;
layout(location=0) out float exposure;
void main() {
    vec2 total=vec2(0);
    for(int y=0;y<18;y++) for(int x=0;x<32;x++) total+=texelFetch(Meter,ivec2(x,y),0).rg;
    float previous=texelFetch(Previous,ivec2(0),0).r;
    bool valid=previous>=0.4 && previous<=4.0 && !isnan(previous) && !isinf(previous);
    if(total.y<=0.0001) { exposure=valid?previous:1.0; return; }

    float daylight=smoothstep(-0.12,0.12,SunDirectionAndRainBrightness.y);
    
    // Target middle gray:
    // 0.22 in daylight (crisp, luminous, sunny photographic key), 0.045 at night
    float middleGray = mix(0.045, 0.22, daylight);
    if(abs(WorldTimeWeatherDimension.w)>=0.5) middleGray = 0.16;

    float measuredLuma = total.x / total.y;
    // Detect dark environments (deep unlit caves)
    float deepCave = smoothstep(-4.5, -6.8, measuredLuma);

    // Dynamic exposure latitude:
    // High headroom for daylight [0.75, 1.90] so overcast days, villages & forests are bright & clear
    // Deep caves adapt up to 2.45
    float maxExp = mix(mix(1.70, 2.45, deepCave), 1.90, daylight);
    float minExp = 0.75;

    float targetEv = clamp((log2(middleGray) - measuredLuma) * 0.70, log2(minExp), log2(maxExp));

    if(!valid) previous = 1.0;
    float previousEv = log2(previous);
    float difference = targetEv - previousEv;
    if(abs(difference) < 0.02) { exposure = previous; return; }

    float seconds = clamp(TimeDeltaFrame.y, 0.0, 0.1);
    float timeConstant = difference < 0.0 ? 1.2 : 2.6;
    exposure = clamp(exp2(mix(previousEv, targetEv, 1.0 - exp(-seconds / timeConstant))), minExp, maxExp);
}
