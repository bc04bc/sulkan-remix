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
#ifdef ALPHA_CUTOUT
	uint cutoffIndex = (v_Material >> 1u) & 3u;
	// 仅草丛、花朵等细小剪影植物 (cutoff == 0.1) 保留 alpha discard 测试。
	// 树叶 (cutoffIndex == 2u) 在阴影图渲染时直接当作实体处理：
	// 1. 彻底激活 GPU Depth-only (Z-only) 全速深度光栅化通道，避免森林中数以百万计的树叶片元阻塞显存带宽与 TMU
	// 2. 避免日光穿过微小镂空缝隙在地面形成高频的摩尔纹条纹与阴影失真
	if (cutoffIndex == 1u) {
		if (textureLod(u_BlockTex, v_TexCoord, 0.0).a < 0.1) discard;
	}
#endif
	fragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
