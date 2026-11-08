// 64-bit G-Buffer Packing for Sulkan Hybrid Deferred Pipeline
// surface.x (32 bits):
// [ 0..15] (16 bits): Octahedral compressed normal (8 bits oct.x, 8 bits oct.y, 0..255)
// [16..23] ( 8 bits): Block light level (0..255)
// [24..31] ( 8 bits): Sky light level (0..255)
//
// surface.y (32 bits):
// [ 0..23] (24 bits): Monotonic depth floatBitsToUint(z) >> 8u
// [24..27] ( 4 bits): materialId (0..15)
// [28..30] ( 3 bits): visibility = 1.0 - fog (0..7)
// [   31 ] ( 1 bit ): transparent flag (1 for translucent cutouts/glass, 0 for solid/enhanced water)

uint packOctNormal(vec3 n) {
    n /= (abs(n.x) + abs(n.y) + abs(n.z) + 1e-6);
    vec2 oct = (n.z >= 0.0) ? n.xy : (1.0 - abs(n.yx)) * mix(vec2(-1.0), vec2(1.0), greaterThanEqual(n.xy, vec2(0.0)));
    uvec2 u = uvec2(clamp(round(oct * 127.5 + 127.5), 0.0, 255.0));
    return u.x | (u.y << 8u);
}

vec3 unpackOctNormal(uint packedNormal) {
    vec2 oct = vec2(packedNormal & 0xFFu, (packedNormal >> 8u) & 0xFFu) * (2.0 / 255.0) - 1.0;
    vec3 n = vec3(oct.x, oct.y, 1.0 - abs(oct.x) - abs(oct.y));
    if (n.z < 0.0) {
        vec2 s = mix(vec2(-1.0), vec2(1.0), greaterThanEqual(n.xy, vec2(0.0)));
        n.xy = (1.0 - abs(n.yx)) * s;
    }
    return normalize(n);
}

uvec2 packGbuffer(vec3 normal, vec2 lightLevel, uint materialId, float visibility, bool isTransparent, float depthZ) {
    uint octN = packOctNormal(normal);
    uint blockL = uint(clamp(round(lightLevel.x * 255.0), 0.0, 255.0));
    uint skyL   = uint(clamp(round(lightLevel.y * 255.0), 0.0, 255.0));
    uint surfX  = octN | (blockL << 16u) | (skyL << 24u);

    uint depth24 = floatBitsToUint(depthZ) >> 8u;
    uint matId   = materialId & 0x0Fu;
    uint vis3    = uint(clamp(round(visibility * 7.0), 0.0, 7.0));
    uint trans   = isTransparent ? 0x80000000u : 0u;
    uint surfY   = depth24 | (matId << 24u) | (vis3 << 28u) | trans;

    return uvec2(surfX, surfY);
}

// 24-bit depth matching: tolerance of +/-1 bucket (256 ULPs) in monotonic integer space
bool surfaceMatches(uvec2 data, float depth) {
    if (data.y == 0u || depth <= 1e-7) return false;
    int a = int(data.y & 0x00FFFFFFu);
    int b = int(floatBitsToUint(depth) >> 8u);
    return abs(a - b) <= 1;
}

vec3 surfaceNormal(uint packedX) {
    return unpackOctNormal(packedX & 0xFFFFu);
}

vec3 surfaceNormal(uvec2 data) {
    return surfaceNormal(data.x);
}

float surfaceBlockLight(uvec2 data) {
    return float((data.x >> 16u) & 0xFFu) / 255.0;
}

float surfaceSkyLight(uvec2 data) {
    return float((data.x >> 24u) & 0xFFu) / 255.0;
}

vec2 surfaceLightLevel(uvec2 data) {
    return vec2(surfaceBlockLight(data), surfaceSkyLight(data));
}

float surfaceSky(uvec2 data) {
    return surfaceSkyLight(data);
}

uint surfaceMaterialId(uvec2 data) {
    return (data.y >> 24u) & 0x0Fu;
}

float surfaceVisibility(uvec2 data) {
    return float((data.y >> 28u) & 0x07u) / 7.0;
}

bool surfaceTransparent(uvec2 data) {
    return (data.y & 0x80000000u) != 0u;
}

bool surfaceWater(uvec2 data) {
    return surfaceMaterialId(data) == 1u;
}

bool surfaceIce(uvec2 data) {
    uint m = surfaceMaterialId(data);
    return m >= 12u && m <= 14u;
}

bool surfaceReflective(uvec2 data) {
    return surfaceWater(data) || surfaceIce(data);
}

float surfaceHdrBoost(uvec2 data) {
    uint m = surfaceMaterialId(data);
    if (m == 9u) return 3.0; // Lava, glowstone, sea lantern
    if (m == 6u) return 2.0; // Metal highlights
    if (m == 10u || m == 11u) return 1.5; // Redstone, glowing berries
    return 1.0;
}

float surfaceFresnel(uvec2 data, vec3 normal, vec3 toEye) {
    float f0 = surfaceIce(data) ? 0.04 : 0.02;
    return f0 + (1.0 - f0) * pow(clamp(1.0 - abs(dot(normal, toEye)), 0.0, 1.0), 5.0);
}
