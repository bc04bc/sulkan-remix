// 升级版手持光源：支持物理平方反比强化、微凹凸高光与屏幕空间实时遮挡阴影 (SS-Contact Shadow)
vec3 sulkanHeldLight(vec3 position, vec3 normal) {
#if _SULKAN_ENABLED_HELD_LIGHTING
    float radius = HeldLightPositionRadius.w;
    vec3 lightPos = HeldLightPositionRadius.xyz;
    vec3 delta = lightPos - position;
    float distanceSquared = dot(delta, delta);
    if (radius <= 0.0 || distanceSquared >= radius * radius) return vec3(0.0);

    float invDist = inversesqrt(max(distanceSquared, 1e-6));
    vec3 lightDir = delta * invDist;
    // 允许轻微的包裹光（0.15），防止方块正交转角过于死板，同时强化朝向面对比度
    float facing = clamp((dot(normal, lightDir) + 0.15) / 1.15, 0.0, 1.0);
    if (facing <= 0.0) return vec3(0.0);

    float edge = 1.0 - distanceSquared / (radius * radius);
    // 强化近身 1~5 格的发光亮度，还原真实火把/灯笼的照亮感
    float attenuation = (edge * edge) / (0.65 + distanceSquared * 0.042);

    return HeldLightColor.rgb * (HELD_LIGHTING * 1.45 * attenuation * facing);
#else
    return vec3(0.0);
#endif
}

// 手持光源专属：屏幕空间接触阴影 + 动态PBR高光（仅在 atmosphere.fsh 中调用，全屏仅算 1 次！）
vec3 sulkanHeldLightAdvanced(vec3 position, vec3 specNormal, vec3 toEye, float roughness, sampler2D depthTex) {
#if _SULKAN_ENABLED_HELD_LIGHTING
    float radius = HeldLightPositionRadius.w;
    vec3 lightPos = HeldLightPositionRadius.xyz;
    vec3 delta = lightPos - position;
    float distSq = dot(delta, delta);
    if (radius <= 0.0 || distSq >= radius * radius) return vec3(0.0);

    float invDist = inversesqrt(max(distSq, 1e-6));
    vec3 lightDir = delta * invDist;
    float facing = clamp((dot(specNormal, lightDir) + 0.12) / 1.12, 0.0, 1.0);
    if (facing <= 0.0) return vec3(0.0);

    // --- 4-Step 屏幕空间手持光动态阴影 (Screen-Space Raymarched Shadow) ---
    float shadow = 1.0;
    vec3 viewStart = mat3(View) * (position + specNormal * 0.05);
    vec3 viewEnd   = mat3(View) * lightPos;
    vec3 viewStep  = (viewEnd - viewStart) * 0.20; // 取前 80% 路程分 4 步检测遮挡物
    float dither = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715))));
    float projZ2 = InverseProjection[2][3];
    float projZ3 = InverseProjection[3][3];

    for (int i = 0; i < 4; i++) {
        vec3 sampleView = viewStart + viewStep * (float(i) + 0.3 + dither * 0.7);
        vec4 clip = Projection * vec4(sampleView, 1.0);
        if (clip.w <= 0.05) continue;
        vec2 suv = (clip.xy / clip.w) * 0.5 + 0.5;
        if (any(lessThan(suv, vec2(0.0))) || any(greaterThan(suv, vec2(1.0)))) continue;
        float d = textureLod(depthTex, suv, 0.0).r;
        if (d <= 1e-7) continue;
        float denom = d * projZ2 + projZ3;
        if (abs(denom) < 1e-6) continue;
        float sceneZ = -1.0 / denom; // 视图空间负Z
        float rayZ   = sampleView.z;
        float depthDiff = sceneZ - rayZ; // 如果 sceneZ > rayZ（更靠近相机 0），说明有方块挡住了火把光！
        if (depthDiff > 0.08 && depthDiff < 1.8) {
            shadow *= 0.22; // 产生深邃的动态遮挡投影
        }
    }

    float edge = 1.0 - distSq / (radius * radius);
    float attenuation = (edge * edge) / (0.60 + distSq * 0.04);

    // 手持光源在石头/矿石/水面上的动态高光 (Blinn-Phong / GGX 近似)
    vec3 halfVec = normalize(lightDir + toEye);
    float nh = max(dot(specNormal, halfVec), 0.0);
    float specPower = exp2(clamp((1.0 - roughness) * 7.0, 2.0, 7.0));
    float spec = pow(nh, specPower) * (1.0 - roughness * 0.7) * 0.45;

    return HeldLightColor.rgb * (HELD_LIGHTING * 1.5 * attenuation * shadow * (facing + spec));
#else
    return vec3(0.0);
#endif
}
