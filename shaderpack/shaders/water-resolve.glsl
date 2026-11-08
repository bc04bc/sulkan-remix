uniform sampler2D WaterReflection;

// 半分辨率水面反射解析：采用硬件双线性插值采样，免除昂贵的逐像素 4 邻域重投影循环
vec3 resolveWaterReflection(vec2 uv, uvec2 data, vec3 position, vec3 local) {
    vec4 reflected = texture(WaterReflection, uv);
    if(reflected.a <= 0.001) return local;
    vec3 normal = surfaceNormal(data.x);
    vec3 toEye = normalize(sulkanCameraOffset() - position);
    float fresnel = surfaceFresnel(data, normal, toEye);
    return mix(local, reflected.rgb, fresnel * WATER_REFLECTION_STRENGTH * surfaceVisibility(data));
}
