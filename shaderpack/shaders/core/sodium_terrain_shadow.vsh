#version 460 core

#ifdef SULKAN_VEGETATION
layout(location=4) in uint a_SulkanMaterial;
#moj_import <sulkan:vegetation_wind.glsl>
#endif

#define SULKAN_GLOBALS_BINDING 2
#moj_import <sulkan:sodium_globals.glsl>
#moj_import <sodium:chunk_vertex.glsl>

layout(binding = 0) uniform sampler2D u_LightTex;
layout(binding = 3) uniform isamplerBuffer u_SectionTimeInfo;
layout(location = 0) out vec2 v_TexCoord;
layout(location = 1) flat out uint v_Material;
layout(location = 2) out float v_Alpha;

#ifdef VULKAN
layout(push_constant) uniform PC {
	vec3 u_RegionOffset;
	int u_CurrentTime;
	uint u_RegionID;
};
#else
uniform vec3 u_RegionOffset;
uniform int u_CurrentTime;
uniform uint u_RegionID;
#endif

uvec3 sulkanRelativeChunkCoord(uint drawId) {
	return uvec3(drawId) >> uvec3(5u, 0u, 2u) & uvec3(7u, 3u, 7u);
}

void main() {
	_vert_init();
	vec3 translation = u_RegionOffset + sulkanRelativeChunkCoord(_draw_id) * vec3(16.0);
	vec3 position = _vert_position + translation;

	// 1. 优先用真实的相机相对距离平方 (dot(position, position)) 执行极速顶点坍缩剔除！
	// 在算风吹动画和矩阵乘法之前直接秒杀远端植物顶点！
	uint cutoffBits = (_material_params >> 1u) & 3u;
	float camDistSq = dot(position, position);
	// 草/花(1u) > 16格(256.0) 剔除；树叶(2u) > 32格(1024.0) 剔除（砍掉森林阴影 70% 的无效三角形！）
	if ((cutoffBits == 1u && camDistSq > 256.0) || (cutoffBits == 2u && camDistSq > 1024.0)) {
		gl_Position = vec4(2.0, 2.0, 2.0, 1.0);
		return;
	}

#ifdef SULKAN_VEGETATION
	if (camDistSq < 576.0) {
		position += sulkanWindOffset(position, a_SulkanMaterial);
	}
#endif
	vec4 shadowViewPos = u_ModelViewMatrix * vec4(position, 1.0);
	gl_Position = u_ProjectionMatrix * shadowViewPos;
	gl_Position.z = max(gl_Position.z, 0.0);

	v_TexCoord = _vert_tex_diffuse_coord + _vert_tex_diffuse_coord_bias * u_TexCoordShrink;
	v_Material = _material_params;
	v_Alpha = _vert_color.a;
}
