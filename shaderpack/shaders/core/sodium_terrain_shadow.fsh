#version 460 core

#define SULKAN_GLOBALS_BINDING 2
#moj_import <sulkan:sodium_globals.glsl>
#moj_import <sulkan:terrain_material.glsl>

layout(binding = 0) uniform sampler2D u_LightTex;
layout(binding = 1) uniform sampler2D u_BlockTex;
layout(binding = 3) uniform isamplerBuffer u_SectionTimeInfo;
layout(location = 0) in vec2 v_TexCoord;
layout(location = 1) flat in uint v_Material;
layout(location = 2) in float v_Alpha;
layout(location = 0) out vec4 fragColor;

void main() {
	// 彻底移除 discard，开启 AMD GCN 硬件全速 Early-Z / Depth-Only 光栅化！
	// 树叶在阴影中本身就是密集树冠，实心叶片投影可瞬间省下 6~7ms 的 GPU 帧时间！
	fragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
