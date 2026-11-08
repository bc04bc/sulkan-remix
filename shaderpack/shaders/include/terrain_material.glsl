// Sodium's packed material ABI, shared by visible terrain and shadow casters.
float sulkanMaterialAlphaCutoff(uint material) {
    const float cutoff[4] = float[4](0.0, 0.1, 0.5, 1.0);
    return cutoff[(material >> 1u) & 3u];
}

vec4 sulkanSampleTerrainMaterial(sampler2D atlas, vec2 uv, uint material) {
    // 使用硬件原生 texture(..., bias) 代替手动求导的 textureGrad，
    // 不仅省去两次屏幕偏导数寄存器占用，还能避免斜视角树叶触发极端各向异性采样阻塞！
    return (material & 1u) != 0u ? texture(atlas, uv, -0.5) : textureLod(atlas, uv, 0.0);
}
