#version 450
#include "shaders/common.glsl"
#include "shaders/tonemap.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
#if AUTO_EXPOSURE == 1
uniform sampler2D Exposure;
#endif
#if _SULKAN_ENABLED_BLOOM_STRENGTH
uniform sampler2D Bloom;
uniform sampler2D Wide;
#endif

// 优化版感知亮度计算：先做标量点积再开 1 次标量根号，省去每次调用的 2 条 v_sqrt_f32 指令！
float aaLuma(vec3 c) {
    return sqrt(clamp(dot(c, vec3(0.299, 0.587, 0.114)), 0.0, 16.0));
}

vec3 antialiasAndSharpen(vec2 uv) {
    vec3 center = texture(Source, uv).rgb;
#if ANTIALIASING == 1
    vec2 pixel = 1.0 / vec2(textureSize(Source, 0));
    
    vec3 n = texture(Source, uv + vec2( 0.0, -pixel.y)).rgb;
    vec3 s = texture(Source, uv + vec2( 0.0,  pixel.y)).rgb;
    vec3 w = texture(Source, uv + vec2(-pixel.x,  0.0)).rgb;
    vec3 e = texture(Source, uv + vec2( pixel.x,  0.0)).rgb;
    
    float lM = aaLuma(center);
    float lN = aaLuma(n), lS = aaLuma(s), lW = aaLuma(w), lE = aaLuma(e);
    float lMin = min(lM, min(min(lN, lS), min(lW, lE)));
    float lMax = max(lM, max(max(lN, lS), max(lW, lE)));
    float range = lMax - lMin;
    
    // 非边缘平坦纹理区域：执行带死区的 AMD CAS 自适应微锐化，增强方块纹理质感！
    if (range < max(0.03, lMax * 0.10)) {
        vec3 crossMean = (n + s + w + e) * 0.25;
        float sharpenMask = smoothstep(0.004, 0.012, range) * (1.0 - clamp(range * 8.0, 0.0, 1.0));
        return max(center + (center - crossMean) * (0.22 * sharpenMask), vec3(0.0));
    }
    
    float lNW = aaLuma(texture(Source, uv + vec2(-0.5, -0.5) * pixel).rgb);
    float lNE = aaLuma(texture(Source, uv + vec2( 0.5, -0.5) * pixel).rgb);
    float lSW = aaLuma(texture(Source, uv + vec2(-0.5,  0.5) * pixel).rgb);
    float lSE = aaLuma(texture(Source, uv + vec2( 0.5,  0.5) * pixel).rgb);
    
    vec2 dir = vec2(
        -((lNW + lNE) - (lSW + lSE)),
         ((lNW + lSW) - (lNE + lSE))
    );
    float dirReduce = max((lN + lS + lW + lE) * 0.03125, 0.00390625);
    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
    dir = clamp(dir * rcpDirMin, vec2(-6.0), vec2(6.0)) * pixel;
    
    // 使用快速 Reversed-Karis 权重替代 8 次 vec3 sqrt()，既防止高光吞噬暗部，又省下 24 条硬件开方指令！
    vec3 s0 = max(texture(Source, uv + dir * (1.0/3.0 - 0.5)).rgb, vec3(0.0));
    vec3 s1 = max(texture(Source, uv + dir * (2.0/3.0 - 0.5)).rgb, vec3(0.0));
    vec3 rgbA = 0.5 * (s0 + s1);
    
    vec3 s2 = max(texture(Source, uv + dir * -0.5).rgb, vec3(0.0));
    vec3 s3 = max(texture(Source, uv + dir *  0.5).rgb, vec3(0.0));
    vec3 rgbB = rgbA * 0.5 + 0.25 * (s2 + s3);
    
    float lB = aaLuma(rgbB);
    vec3 resolved = (lB < lMin || lB > lMax) ? rgbA : rgbB;
    
    float subpix = clamp(abs(((lN + lS + lW + lE) * 0.25) - lM) / max(range, 1e-4), 0.0, 1.0);
    subpix = subpix * subpix * (3.0 - 2.0 * subpix);
    vec3 crossMean = (n + s + w + e) * 0.25;
    return mix(resolved, crossMean, subpix * 0.30);
#else
    return center;
#endif
}

void main() {
    vec3 c = antialiasAndSharpen(texCoord);
#if _SULKAN_ENABLED_BLOOM_STRENGTH
    vec3 bloom = BLOOM_STRENGTH * (texture(Bloom,texCoord).rgb * 0.65 + texture(Wide,texCoord).rgb * 0.35);
    c += bloom * (1.0 / (1.0 + dot(c, vec3(0.299, 0.587, 0.114)) * 0.5));
#endif
#if AUTO_EXPOSURE == 1
    c *= texelFetch(Exposure, ivec2(0), 0).r;
#endif
    DoCompTonemap(c);
    float luminance = dot(c, vec3(0.2126, 0.7152, 0.0722));
    float day = smoothstep(-0.14, 0.12, SunDirectionAndRainBrightness.y);
    float overworld = 1.0 - step(0.5, abs(WorldTimeWeatherDimension.w));
    if (COLOR_GRADE > 0.0 && COLOR_GRADE < 0.5) {
        c = mix(vec3(luminance), c, 0.96);
    } else if (COLOR_GRADE >= 0.5) {
        DoBSLColorSaturation(c);
        if (COLOR_GRADE > 0.5) {
            float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
            float chroma = max(c.r, max(c.g, c.b)) - min(c.r, min(c.g, c.b));
            c = mix(vec3(luma), c, 1.0 + 0.20 * (1.0 - clamp(chroma, 0.0, 1.0)));
            c = c + 0.12 * c * (1.0 - c) * (2.0 * c - 1.0);
        }
    }
    luminance = clamp(dot(c, vec3(0.2126, 0.7152, 0.0722)), 0.0, 1.0);
    float grade = COLOR_GRADE >= 0.5 ? (COLOR_GRADE > 0.5 ? 0.65 : 0.5) * overworld : 0.0;
    vec3 tone = mix(vec3(-0.025, 0.005, 0.035), vec3(0.04, 0.012, -0.025) * day,
        smoothstep(0.15, 0.8, luminance));
    c += tone * (4.0 * luminance * (1.0 - luminance)) * grade;
    float finalDither = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5;
    color = vec4(clamp(c + finalDither / 255.0, 0.0, 1.0), 1.0);
}
