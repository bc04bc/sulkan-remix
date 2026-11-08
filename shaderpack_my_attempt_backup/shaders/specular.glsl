// RTX Remix-style Cook-Torrance GGX Microfacet Specular BRDF.
// Evaluates D_GGX (Trowbridge-Reitz), G_Smith (Schlick-GGX), and F_Schlick with colored F0.

vec3 sulkanPbrSpecular(vec3 normal, vec3 toEye, vec3 lightDir, float roughness, vec3 f0) {
    vec3 light = normalize(lightDir + vec3(0.0, 1e-5, 0.0));
    float nl = dot(normal, light);
    float nv = max(dot(normal, toEye), 0.0);
    // Soft cutoff at grazing light angles to eliminate penumbra/grazing flickering
    float faceLit = smoothstep(0.0, 0.06, nl);
    if (faceLit <= 0.0 || nv <= 0.0) return vec3(0.0);

    vec3 halfway = light + toEye;
    halfway *= inversesqrt(max(dot(halfway, halfway), 1e-8));
    float nh = max(dot(normal, halfway), 0.0);
    float vh = max(dot(toEye, halfway), 0.0);

    // Alpha = roughness^2 (Disney perceptual roughness reparameterization)
    float a = max(roughness * roughness, 0.02);
    float a2 = a * a;

    // Normal Distribution Function D(H)
    float dDenom = nh * nh * (a2 - 1.0) + 1.0;
    float d = a2 / (3.14159265 * dDenom * dDenom);

    // Smith-Schlick Shadowing-Masking G(L, V)
    float k = (roughness + 1.0) * (roughness + 1.0) * 0.125;
    float gV = nv / (nv * (1.0 - k) + k);
    float gL = max(nl, 0.0) / (max(nl, 0.0) * (1.0 - k) + k);
    float g = gV * gL;

    // Fresnel-Schlick F(V, H) supporting conductive colored metals
    vec3 f = f0 + (max(vec3(1.0 - roughness), f0) - f0) * pow(clamp(1.0 - vh, 0.0, 1.0), 5.0);

    // Specular radiance = (D * G * F / (4 * N.V * N.L)) * N.L
    vec3 specular = (d * g * f) / (4.0 * max(nv, 0.001)) * faceLit;

    return min(specular, vec3(5.0));
}

vec3 sulkanPbrSunSpecular(vec3 normal, vec3 toEye, float roughness, vec3 f0) {
    float daylight = smoothstep(-0.14, 0.12, SunDirectionAndRainBrightness.y);
    vec3 lightDir = daylight > 0.5 ? SunDirectionAndRainBrightness.xyz : MoonDirectionAndPhase.xyz;
    float lightAltitude = daylight > 0.5 ? SunDirectionAndRainBrightness.y : MoonDirectionAndPhase.y;
    float weatherFade = smoothstep(0.0, 0.12, lightAltitude) * (1.0 - WorldTimeWeatherDimension.y * 0.7);
    return sulkanPbrSpecular(normal, toEye, lightDir, roughness, f0) * weatherFade;
}

// Backward-compatible dielectric scalar highlight
float sulkanSunSpecular(vec3 normal, vec3 toEye, float roughness, float reflectance) {
    return sulkanPbrSunSpecular(normal, toEye, roughness, vec3(reflectance)).r;
}
