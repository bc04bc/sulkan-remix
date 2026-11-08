// RTX Remix-style ACES Filmic tone mapping with shadow detail preservation.
#define TM_WHITE_PATH 1.0
#define TM_DARK_DESATURATION 0.12
#define T_VIBRANCE 1.0

float GetLuminance(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }
float max0(float x) { return max(0.0, x); }
vec3 clamp01(vec3 x) { return clamp(x, 0.0, 1.0); }

// Krzysztof Narkowicz ACES filmic curve (fitted for real-time rendering)
// Maps linear HDR scene radiance directly to sRGB display output with natural filmic S-curve
vec3 ACESFilm(vec3 x) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

void DoCompTonemap(inout vec3 color) {
    // 1. Photographic exposure
    color = max(color * TM_EXPOSURE, vec3(0.0));

    float initialLuminance = GetLuminance(color);

    // 2. Luminance-based contrast adjustment (preserves hue/chroma)
    if (abs(TM_CONTRAST - 1.0) > 0.001) {
        float luma = max(initialLuminance, 1e-5);
        vec3 chroma = color / luma;
        luma = pow(luma, TM_CONTRAST);
        color = chroma * luma;
    }

    // 3. ACES Filmic mapping (high dynamic range compression directly to display)
    vec3 colorOut = ACESFilm(color);

    // 4. RTX Remix-style Shadow Readability Guard:
    // Subtly lifts the extreme toe of ACES in deep shadows so caves don't crush to pitch black,
    // while preserving deep contrast at night without washing out the darks.
    const float darkLiftStart = 0.14;
    float darkLift = 1.0 - smoothstep(0.0, darkLiftStart, initialLuminance);
    vec3 smoothToe = pow(max(color, vec3(0.0)), vec3(1.0 / 2.2));
    colorOut = mix(colorOut, smoothToe, darkLift * 0.48);

    color = clamp01(colorOut);
}

void DoBSLColorSaturation(inout vec3 color) {
    float saturationFactor = T_SATURATION;

    float grayVibrance = (color.r + color.g + color.b) / 3.0;
    float graySaturation = grayVibrance;
    if (saturationFactor < 1.00) graySaturation = dot(color, vec3(0.2126, 0.7152, 0.0722));

    float mn = min(color.r, min(color.g, color.b));
    float mx = max(color.r, max(color.g, color.b));
    float sat = (1.0 - (mx - mn)) * (1.0 - mx) * grayVibrance * 3.5;
    vec3 lightness = vec3((mn + mx) * 0.5);

    color = mix(color, mix(color, lightness, 1.0 - T_VIBRANCE), sat);
    color = mix(color, lightness, (1.0 - lightness) * (2.0 - T_VIBRANCE) / 2.0 * abs(T_VIBRANCE - 1.0));
    color = color * saturationFactor - graySaturation * (saturationFactor - 1.0);
}
