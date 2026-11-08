#version 450
#include "shaders/common.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
void main() {
    vec2 d = 1.25 / vec2(textureSize(Source, 0));
    vec3 c = texture(Source, texCoord).rgb * 0.20;
    c += texture(Source, texCoord + vec2( d.x,  d.y)).rgb * 0.20;
    c += texture(Source, texCoord + vec2(-d.x,  d.y)).rgb * 0.20;
    c += texture(Source, texCoord + vec2( d.x, -d.y)).rgb * 0.20;
    c += texture(Source, texCoord + vec2(-d.x, -d.y)).rgb * 0.20;
    color = vec4(c, 1.0);
}
