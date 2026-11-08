// Shared cascaded-shadow sampling. The including shader declares the four
// SulkanShadowMap samplers and the SulkanShadowData uniform block.

#ifndef SULKAN_SHADOW_CASCADE_COUNT
#define SULKAN_SHADOW_CASCADE_COUNT 4
#endif
#ifndef SULKAN_SHADOW_FILTER_TIER
#define SULKAN_SHADOW_FILTER_TIER 3
#endif

bool sulkanCascadeActive(int cascade) {
	return CascadeParams[cascade].w > 0.5;
}

int sulkanLastCascade() {
	for (int cascade = SULKAN_SHADOW_CASCADE_COUNT - 1; cascade >= 0; --cascade) {
		if (sulkanCascadeActive(cascade)) return cascade;
	}
	return 0;
}

int sulkanSelectCascade(float cameraDistance) {
	int last = sulkanLastCascade();
	for (int cascade = 0; cascade < SULKAN_SHADOW_CASCADE_COUNT; ++cascade) {
		if (sulkanCascadeActive(cascade) && cameraDistance <= CascadeParams[cascade].z) return cascade;
	}
	return last;
}

float sulkanShadowDepth(int cascade, vec2 uv) {
	if (cascade == 0) return textureLod(SulkanShadowMap0, uv, 0.0).r;
	if (cascade == 1) return textureLod(SulkanShadowMap1, uv, 0.0).r;
	if (cascade == 2) return textureLod(SulkanShadowMap2, uv, 0.0).r;
	return textureLod(SulkanShadowMap3, uv, 0.0).r;
}

float sulkanShadowTexelDepth(int cascade, ivec2 pixel) {
	if (cascade == 0) return texelFetch(SulkanShadowMap0, pixel, 0).r;
	if (cascade == 1) return texelFetch(SulkanShadowMap1, pixel, 0).r;
	if (cascade == 2) return texelFetch(SulkanShadowMap2, pixel, 0).r;
	return texelFetch(SulkanShadowMap3, pixel, 0).r;
}

// 硬件原生 textureGather：单条指令硬件抓取 2x2 深度四元组，提升 4 倍纹理单元吞吐量！
vec4 sulkanShadowGather(int cascade, vec2 uv) {
	if (cascade == 0) return textureGather(SulkanShadowMap0, uv);
	if (cascade == 1) return textureGather(SulkanShadowMap1, uv);
	if (cascade == 2) return textureGather(SulkanShadowMap2, uv);
	return textureGather(SulkanShadowMap3, uv);
}

#ifndef SULKAN_TERRAIN_SHADOWS_ONLY
vec4 sulkanEntityShadowGather(int cascade, vec2 uv) {
	return textureGather(SulkanEntityShadowMap0, uv);
}

vec2 sulkanEntityShadowTexel(int cascade) {
	return 1.0 / vec2(textureSize(SulkanEntityShadowMap0, 0));
}

#endif

// Steepest receiver depth slope (tan of the angle between normal and light) the plane bias
// follows. Lit faces fade in over N.L 0..0.08; below N.L 0.0047, the face term is under 1%
// and hides any cast result, so tan(acos(0.0047)) = 213 bounds every visible case. The limit
// is in world slope, not map units, so every cascade biases the same surface identically.
#define SULKAN_SHADOW_MAX_SLOPE 2.5

vec2 sulkanShadowTexel(int cascade);

vec2 sulkanReceiverDepthGradient(int cascade, vec3 normal) {
	// Derivatives are undefined after discard and divergent cascade selection.
	// Project the receiver's tangent plane instead. Cascades are orthographic,
	// so these directions give the exact depth slope without neighboring pixels.
	vec3 axis = abs(normal.y) < 0.9 ? vec3(0.0, 1.0, 0.0) : vec3(1.0, 0.0, 0.0);
	vec3 tangent = normalize(cross(normal, axis));
	vec3 bitangent = cross(normal, tangent);
	vec3 projectedTangent = mat3(ShadowViewProjection[cascade]) * tangent;
	vec3 projectedBitangent = mat3(ShadowViewProjection[cascade]) * bitangent;
	vec2 uvDx = projectedTangent.xy * 0.5;
	vec2 uvDy = projectedBitangent.xy * 0.5;
	float depthDx = projectedTangent.z;
	float depthDy = projectedBitangent.z;
	float determinant = uvDx.x * uvDy.y - uvDx.y * uvDy.x;
	if (abs(determinant) < 1.0e-10) return vec2(0.0);
	vec2 gradient = vec2(
		(depthDx * uvDy.y - depthDy * uvDx.y) / determinant,
		(uvDx.x * depthDy - uvDy.x * depthDx) / determinant);
	// Depth per map uv for world slope s is s * mapWidth / depthRange, mapWidth = texelWorld * size.
	float maxGradient = SULKAN_SHADOW_MAX_SLOPE * CascadeParams[cascade].x
		/ (sulkanShadowTexel(cascade).x * max(CascadeParams[cascade].w, 1.0));
	float magnitude = length(gradient);
	return magnitude > maxGradient ? gradient * (maxGradient / magnitude) : gradient;
}

vec4 sulkanGatherCompareDepths(
		vec2 uv,
		vec2 texel,
		vec2 receiverUv,
		float receiverDepth,
		vec2 depthGradient) {
	vec2 size = 1.0 / texel;
	vec2 lowerLeftUv = (floor(uv * size - 0.5) + 0.5) * texel;
	float lowerLeft = receiverDepth + dot(depthGradient, lowerLeftUv - receiverUv);
	float lowerRight = receiverDepth + dot(depthGradient, lowerLeftUv + vec2(texel.x, 0.0) - receiverUv);
	float upperLeft = receiverDepth + dot(depthGradient, lowerLeftUv + vec2(0.0, texel.y) - receiverUv);
	float upperRight = receiverDepth + dot(depthGradient, lowerLeftUv + texel - receiverUv);
	// textureGather order: upper-left, upper-right, lower-right, lower-left.
	return vec4(upperLeft, upperRight, lowerRight, lowerLeft);
}

#ifndef SULKAN_TERRAIN_SHADOWS_ONLY
float sulkanEntityBilinearVisibility(
		int cascade,
		vec2 uv,
		vec2 receiverUv,
		float receiverDepth,
		vec2 depthGradient) {
	vec2 texel = sulkanEntityShadowTexel(cascade);
	vec2 size = 1.0 / texel;
	vec2 blend = fract(uv * size - 0.5);
	vec4 depths = sulkanEntityShadowGather(cascade, uv);
	vec4 compareDepths = sulkanGatherCompareDepths(uv, texel, receiverUv, receiverDepth, depthGradient);
	vec4 visible = step(compareDepths, depths);
	float lower = mix(visible.w, visible.z, blend.x);
	float upper = mix(visible.x, visible.y, blend.x);
	return mix(lower, upper, blend.y);
}

float sulkanEntityShadowVisibility(
		int cascade,
		vec2 uv,
		float compareDepth,
		vec2 depthGradient) {
#if SULKAN_SHADOW_FILTER_TIER <= 1
		return sulkanEntityBilinearVisibility(cascade, uv, uv, compareDepth, depthGradient);
#else

	vec2 texel = sulkanEntityShadowTexel(cascade);
	float radius = SULKAN_SHADOW_FILTER_TIER < 4 ? 0.55 : 0.85;
	vec2 offset = texel * radius;
	float corners = sulkanEntityBilinearVisibility(cascade, uv + vec2(-offset.x, -offset.y), uv, compareDepth, depthGradient);
	corners += sulkanEntityBilinearVisibility(cascade, uv + vec2( offset.x, -offset.y), uv, compareDepth, depthGradient);
	corners += sulkanEntityBilinearVisibility(cascade, uv + vec2(-offset.x,  offset.y), uv, compareDepth, depthGradient);
	corners += sulkanEntityBilinearVisibility(cascade, uv + vec2( offset.x,  offset.y), uv, compareDepth, depthGradient);
	corners *= 0.25;
#if SULKAN_SHADOW_FILTER_TIER < 4
	return corners;
#else

	float center = sulkanEntityBilinearVisibility(cascade, uv, uv, compareDepth, depthGradient);
	return mix(center, corners, 0.65);
#endif
#endif
}

#endif

vec2 sulkanShadowTexel(int cascade) {
	if (cascade == 0) return 1.0 / vec2(textureSize(SulkanShadowMap0, 0));
	if (cascade == 1) return 1.0 / vec2(textureSize(SulkanShadowMap1, 0));
	if (cascade == 2) return 1.0 / vec2(textureSize(SulkanShadowMap2, 0));
	return 1.0 / vec2(textureSize(SulkanShadowMap3, 0));
}

float sulkanShadowBilinearVisibility(
		int cascade,
		vec2 uv,
		vec2 receiverUv,
		float receiverDepth,
		vec2 depthGradient) {
	vec2 texel = sulkanShadowTexel(cascade);
	vec2 size = 1.0 / texel;
	vec2 footprint = uv * size - 0.5;
	vec2 blend = fract(footprint);
	vec4 depths = sulkanShadowGather(cascade, uv);
	vec4 compareDepths = sulkanGatherCompareDepths(uv, texel, receiverUv, receiverDepth, depthGradient);
	vec4 visible = step(compareDepths, depths);
	float lower = mix(visible.w, visible.z, blend.x);
	float upper = mix(visible.x, visible.y, blend.x);
	return mix(lower, upper, blend.y);
}

float sulkanShadowPointVisibility(
		int cascade,
		vec2 uv,
		vec2 receiverUv,
		float receiverDepth,
		vec2 depthGradient) {
	vec2 texel = sulkanShadowTexel(cascade);
	vec2 sampleUv = (floor(uv / texel) + 0.5) * texel;
	float tapCompareDepth = receiverDepth + dot(depthGradient, sampleUv - receiverUv);
	return step(tapCompareDepth, sulkanShadowDepth(cascade, sampleUv));
}

float sulkanCloseTerrainVisibility(int cascade, vec2 uv, float compareDepth, vec2 depthGradient) {
#if SULKAN_SHADOW_FILTER_TIER <= 1
	return sulkanShadowBilinearVisibility(cascade, uv, uv, compareDepth, depthGradient);
#else
	vec2 texel = sulkanShadowTexel(cascade);
	// 2-Tap 旋转泊松盘（Rotated Poisson）：利用 IGN 抖动打散阶梯状阴影锯齿，采样减少一半且边缘更柔和
	float angle = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) * 6.2831853;
	vec2 rot = vec2(cos(angle), sin(angle)) * texel * 0.75;
	float s0 = sulkanShadowBilinearVisibility(cascade, uv + rot, uv, compareDepth, depthGradient);
	float s1 = sulkanShadowBilinearVisibility(cascade, uv - rot, uv, compareDepth, depthGradient);
	return (s0 + s1) * 0.5;
#endif
}

vec3 sulkanShadowCoord(int cascade, vec3 position) {
	vec4 clip = ShadowViewProjection[cascade] * vec4(position, 1.0);
	return vec3(clip.xy / max(abs(clip.w), 0.000001) * 0.5 + 0.5, clip.z / max(abs(clip.w), 0.000001));
}

float sulkanShadowNormalOffset(int cascade, vec3 normal) {
	float facing = clamp(dot(normal, LightDirection.xyz), 0.0, 1.0);
	float texelWorldSize = max(CascadeParams[cascade].x, 0.0001);
	return clamp(texelWorldSize * mix(0.08, 0.20, 1.0 - facing), 0.002, 0.045);
}

float sulkanCascadeSample(int cascade, vec3 position, vec3 normal, bool grassReceiver) {
	float texelWorldSize = max(CascadeParams[cascade].x, 0.0001);
	vec3 offsetPos = position
		+ normal * sulkanShadowNormalOffset(cascade, normal)
		+ LightDirection.xyz * (texelWorldSize * 0.08);
	vec3 coord = sulkanShadowCoord(cascade, offsetPos);
	vec2 texel = sulkanShadowTexel(cascade);
	vec2 guard = texel * 1.5;
	if (coord.x <= guard.x || coord.x >= 1.0 - guard.x
			|| coord.y <= guard.y || coord.y >= 1.0 - guard.y
			|| coord.z <= 0.0 || coord.z >= 1.0) return -1.0;

	float facing = clamp(abs(dot(normal, normalize(LightDirection.xyz))), 0.0, 1.0);
	float slope = min(sqrt(max(1.0 - facing * facing, 0.0)) / max(facing, 0.25), 2.5);
	float precisionBias = (0.0025 + texelWorldSize * (0.06 + 0.04 * slope)) / max(CascadeParams[cascade].w, 1.0);
	float compareDepth = coord.z - precisionBias;
	vec2 depthGradient = vec2(0.0);
#if SULKAN_SHADOW_FILTER_TIER >= 3
	if (!grassReceiver && cascade == 0) {
		depthGradient = sulkanReceiverDepthGradient(cascade, normal) * 0.5;
	}
#endif
	float visible;
	if (grassReceiver) {
		float allowance = clamp(texelWorldSize * (0.65 + 0.7 * slope), 0.015, 0.16);
		float grassDepth = compareDepth - allowance / max(CascadeParams[cascade].w, 1.0);
		visible = sulkanShadowBilinearVisibility(cascade, coord.xy, coord.xy, grassDepth, vec2(0.0));
	} else if (cascade > 0) {
		visible = sulkanShadowBilinearVisibility(cascade, coord.xy, coord.xy, compareDepth, depthGradient);
	} else {
		visible = sulkanCloseTerrainVisibility(cascade, coord.xy, compareDepth, depthGradient);
	}
	return visible;
}

float sulkanCascadeVisibility(int cascade, vec3 position, vec3 normal, bool grassReceiver) {
	float visible = sulkanCascadeSample(cascade, position, normal, grassReceiver);
	return visible < 0.0 ? 1.0 : visible;
}

float sulkanCascadeVisibility(int cascade, vec3 position, vec3 normal) {
    return sulkanCascadeVisibility(cascade,position,normal,false);
}

float sulkanCastShadowVisibility(vec3 position, vec3 normal, bool grassReceiver) {
	float cameraDistance = length(position);
	int current = sulkanSelectCascade(cameraDistance);
	int last = sulkanLastCascade();
	if (cameraDistance >= CascadeParams[last].z) return 1.0;
	float currentVisibility = sulkanCascadeSample(current, position, normal, grassReceiver);
	// A cascade refreshed on an earlier frame can miss the edge of the current view until the
	// loader's coverage test redraws it. Coarser maps span more area, so try them before lit.
	while (currentVisibility < 0.0 && current < last) {
		current++;
		currentVisibility = sulkanCascadeSample(current, position, normal, grassReceiver);
	}
	if (currentVisibility < 0.0) return 1.0;

	if (current == last) {
		float fadeStart = CascadeParams[last].z * 0.92;
		float coverage = 1.0 - smoothstep(fadeStart, CascadeParams[last].z, cameraDistance);
		return mix(1.0, currentVisibility, coverage);
	}
	// 移除交界处双级联重复采样，节约一半级联交界区算力并消除远处伪影
	return currentVisibility;
}

float sulkanCastShadowVisibility(vec3 position, vec3 normal) {
    return sulkanCastShadowVisibility(position,normal,false);
}

float sulkanDirectionalVisibility(vec3 position, vec3 normal) {
	float normalLight = dot(normal, LightDirection.xyz);
	if (normalLight <= 0.0) return ShadowParams.z;
	float faceLit = smoothstep(0.0, 0.08, normalLight);
	float faceVisibility = mix(ShadowParams.z, 1.0, faceLit);
	float castVisibility = mix(ShadowParams.z, 1.0, sulkanCastShadowVisibility(position, normal));
	return min(faceVisibility, castVisibility);
}
