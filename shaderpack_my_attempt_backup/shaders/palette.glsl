// RTX Remix-calibrated natural lighting and water palette.
vec3 portLightPalette() {
    float noon = clamp(SunDirectionAndRainBrightness.y, 0.0, 1.0);
    float daylight = smoothstep(-0.12, 0.12, SunDirectionAndRainBrightness.y);
    // Warm natural sunlight (luminous, punchy, D60 daylight, ~5600K)
    vec3 noonLight = vec3(1.22, 1.15, 1.02) * 1.45;
    // Rich golden amber sunset / golden hour (warm honey sunlight, vibrant autumn glow)
    vec3 sunsetLight = mix(vec3(1.24, 0.92, 0.58), vec3(1.30, 0.75, 0.42), pow(1.0 - noon, 1.8)) * 1.55;
    // Luminous silver-blue moonlight (balanced for night readability without blowout)
    vec3 nightLight = vec3(0.065, 0.090, 0.145) * 0.55;
    vec3 clearLight = mix(nightLight, mix(sunsetLight, noonLight, noon), daylight);
    // Overcast/rain lighting: preserves visibility on rainy days & nights
    vec3 wetLight = mix(vec3(0.024, 0.030, 0.045), vec3(0.28, 0.26, 0.24) * 1.05 + noon * vec3(0.0, 0.02, 0.06), daylight) * 2.2;
    return mix(clearLight, wetLight, WorldTimeWeatherDimension.y);
}
// Water fog depth absorption
float portWaterFog(float distanceInWater) { return 1.0 - exp(-max(distanceInWater, 0.0) / 48.0); }
