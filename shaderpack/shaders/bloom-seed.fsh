#version 450
#include "shaders/common.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
void main() {
    vec2 px = 0.5 / vec2(textureSize(Source,0));
    vec3 c = (texture(Source,texCoord+px).rgb + texture(Source,texCoord-px).rgb + texture(Source,texCoord+vec2(px.x,-px.y)).rgb + texture(Source,texCoord+vec2(-px.x,px.y)).rgb)*0.25;
    float brightness = max(c.r, max(c.g, c.b));
    // 1. 提高起跳阈值，让普通白天景物（<0.70）绝对不泛白光
    float contribution = smoothstep(0.70, 1.60, brightness);
    vec3 bloomColor = c * contribution;
    // 2. 核心防核爆机制：Karis / Reinhard 软封顶，把输入给模糊器的最大能量温和限制在 2.5 以内
    float bloomLuma = max(bloomColor.r, max(bloomColor.g, bloomColor.b));
    bloomColor *= 1.0 / (1.0 + bloomLuma * 0.4);
    color = vec4(bloomColor, 1.0);
}
