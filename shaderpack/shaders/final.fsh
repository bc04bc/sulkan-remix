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
// 十字+对角 9-Tap 增强型 FXAA 3.11 + AMD CAS 自适应微锐化内核
// 在感知空间（Perceptual Gamma Space）加权计算，彻底解决高光吞噬暗部轮廓与单像素锯齿漏检问题
float aaLuma(vec3 c) {
    vec3 p = sqrt(clamp(c, vec3(0.0), vec3(16.0)));
    return dot(p, vec3(0.299, 0.587, 0.114));
}

vec3 antialiasAndSharpen(vec2 uv) {
    vec3 center = texture(Source, uv).rgb;
#if ANTIALIASING == 1
    vec2 pixel = 1.0 / vec2(textureSize(Source, 0));
    
    // 1. 采样正十字相邻像素（精准捕捉水平与垂直方块几何锯齿）
    vec3 n = texture(Source, uv + vec2( 0.0, -pixel.y)).rgb;
    vec3 s = texture(Source, uv + vec2( 0.0,  pixel.y)).rgb;
    vec3 w = texture(Source, uv + vec2(-pixel.x,  0.0)).rgb;
    vec3 e = texture(Source, uv + vec2( pixel.x,  0.0)).rgb;
    
    float lM = aaLuma(center);
    float lN = aaLuma(n), lS = aaLuma(s), lW = aaLuma(w), lE = aaLuma(e);
    float lMin = min(lM, min(min(lN, lS), min(lW, lE)));
    float lMax = max(lM, max(max(lN, lS), max(lW, lE)));
    float range = lMax - lMin;
    
    // 2. Non-edge flat texture area: AMD CAS adaptive sharpening with deadzone for 8-bit banding
    if (range < max(0.03, lMax * 0.10)) {
        vec3 crossMean = (n + s + w + e) * 0.25;
        float sharpenMask = smoothstep(0.004, 0.012, range) * (1.0 - clamp(range * 8.0, 0.0, 1.0));
        return max(center + (center - crossMean) * (0.16 * sharpenMask), vec3(0.0));
    }
    
    // 3. 边缘区域：采样半像素对角线（±0.5 pixel 硬件双线性插值），计算精确切线方向
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
    
    // 4. 在感知空间执行反走样混合（防止亮色高光吞噬暗部轮廓）
    vec3 rgbA = 0.5 * (
        sqrt(max(texture(Source, uv + dir * (1.0/3.0 - 0.5)).rgb, vec3(0.0))) +
        sqrt(max(texture(Source, uv + dir * (2.0/3.0 - 0.5)).rgb, vec3(0.0)))
    );
    vec3 rgbB = rgbA * 0.5 + 0.25 * (
        sqrt(max(texture(Source, uv + dir * -0.5).rgb, vec3(0.0))) +
        sqrt(max(texture(Source, uv + dir *  0.5).rgb, vec3(0.0)))
    );
    float lB = dot(rgbB, vec3(0.299, 0.587, 0.114));
    vec3 resolved = (lB < lMin || lB > lMax) ? (rgbA * rgbA) : (rgbB * rgbB);
    
    // 结合亚像素对比度进一步平滑孤立噪点（如远处樱花树叶）
    float subpix = clamp(abs(((lN + lS + lW + lE) * 0.25) - lM) / max(range, 1e-4), 0.0, 1.0);
    subpix = smoothstep(0.0, 1.0, subpix);
    vec3 crossPerceptual = (sqrt(max(n,0.0)) + sqrt(max(s,0.0)) + sqrt(max(w,0.0)) + sqrt(max(e,0.0))) * 0.25;
    return mix(resolved, crossPerceptual * crossPerceptual, subpix * 0.35);
#else
    return center;
#endif
}
void main() {
    vec3 c = antialiasAndSharpen(texCoord);
#if _SULKAN_ENABLED_BLOOM_STRENGTH
    vec3 bloom = BLOOM_STRENGTH * (texture(Bloom,texCoord).rgb * 0.65 + texture(Wide,texCoord).rgb * 0.35);
    // 暗部背景吃满光晕（夜晚/矿洞氛围拉满），亮部背景自动衰减防止过曝死白
    c += bloom * (1.0 / (1.0 + dot(c, vec3(0.299, 0.587, 0.114)) * 0.5));
#endif
#if AUTO_EXPOSURE == 1
    c*=texelFetch(Exposure,ivec2(0),0).r;
#endif
    DoCompTonemap(c);
    // Keep the saved COLOR_GRADE key: 0=Off, .25=Natural, .5=Realistic, 1=Vibrant.
    // Off retains required tonemapping but adds no artistic color grading.
    float luminance=dot(c,vec3(0.2126,0.7152,0.0722));
    float day=smoothstep(-0.14,0.12,SunDirectionAndRainBrightness.y);
    float overworld=1.0-step(0.5,abs(WorldTimeWeatherDimension.w));
    if(COLOR_GRADE>0.0 && COLOR_GRADE<0.5) {
        // Neutral palette with restrained saturation; no warm/cool split.
        c=mix(vec3(luminance),c,0.96);
    } else if(COLOR_GRADE>=0.5) {
        DoBSLColorSaturation(c);
        if(COLOR_GRADE>0.5) {
            float luma=dot(c,vec3(0.2126,0.7152,0.0722));
            float chroma=max(c.r,max(c.g,c.b))-min(c.r,min(c.g,c.b));
            c=mix(vec3(luma),c,1.0+0.20*(1.0-clamp(chroma,0.0,1.0)));
            c=c+0.12*c*(1.0-c)*(2.0*c-1.0);
        }
    }
    luminance=clamp(dot(c,vec3(0.2126,0.7152,0.0722)),0.0,1.0);
    float grade=COLOR_GRADE>=0.5?(COLOR_GRADE>0.5?0.65:0.5)*overworld:0.0;
    vec3 tone=mix(vec3(-0.025,0.005,0.035),vec3(0.04,0.012,-0.025)*day,
        smoothstep(0.15,0.8,luminance));
    c+=tone*(4.0*luminance*(1.0-luminance))*grade;
    float finalDither = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5;
    color = vec4(clamp(c + finalDither / 255.0, 0.0, 1.0), 1.0);
}
