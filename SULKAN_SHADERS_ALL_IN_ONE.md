# SULKAN SHADERS ALL IN ONE

## sulkan.json

`glsl
{
  "version": 1,
  "name": "Sulkan RTX Remix",
  "budgetMiB": 1024,
  "textures": {
    "vanilla-clouds": {
      "source": "$minecraft/clouds",
      "filter": "nearest",
      "wrap": "repeat"
    }
  },
  "materials": {
    "minecraft:ice": 12,
    "minecraft:frosted_ice": 12,
    "minecraft:packed_ice": 13,
    "minecraft:blue_ice": 14,
    "minecraft:iron_block": 6,
    "minecraft:gold_block": 6,
    "minecraft:copper_block": 6,
    "minecraft:cut_copper": 6,
    "minecraft:netherite_block": 6,
    "minecraft:stone": 7,
    "minecraft:andesite": 7,
    "minecraft:granite": 7,
    "minecraft:diorite": 7,
    "minecraft:polished_andesite": 7,
    "minecraft:polished_granite": 7,
    "minecraft:polished_diorite": 7,
    "minecraft:oak_planks": 8,
    "minecraft:spruce_planks": 8,
    "minecraft:birch_planks": 8,
    "minecraft:jungle_planks": 8,
    "minecraft:acacia_planks": 8,
    "minecraft:dark_oak_planks": 8,
    "minecraft:mangrove_planks": 8,
    "minecraft:cherry_planks": 8,
    "minecraft:pale_oak_planks": 8,
    "minecraft:lava": 9,
    "minecraft:glowstone": 9,
    "minecraft:sea_lantern": 9,
    "minecraft:shroomlight": 9,
    "minecraft:redstone_lamp[lit=true]": 9,
    "minecraft:glow_lichen": 10,
    "minecraft:cave_vines[berries=true]": 10,
    "minecraft:cave_vines_plant[berries=true]": 10,
    "minecraft:redstone_ore[lit=true]": 11,
    "minecraft:deepslate_redstone_ore[lit=true]": 11,
    "minecraft:water": 1,
    "minecraft:short_grass": 2,
    "minecraft:fern": 2,
    "minecraft:tall_grass[half=lower]": 3,
    "minecraft:tall_grass[half=upper]": 4,
    "minecraft:large_fern[half=lower]": 3,
    "minecraft:large_fern[half=upper]": 4,
    "minecraft:oak_leaves": 5,
    "minecraft:birch_leaves": 5,
    "minecraft:spruce_leaves": 5,
    "minecraft:jungle_leaves": 5,
    "minecraft:acacia_leaves": 5,
    "minecraft:dark_oak_leaves": 5,
    "minecraft:mangrove_leaves": 5,
    "minecraft:cherry_leaves": 5,
    "minecraft:azalea_leaves": 5,
    "minecraft:flowering_azalea_leaves": 5,
    "minecraft:pale_oak_leaves": 5,
    "minecraft:diamond_block": 6,
    "minecraft:emerald_block": 6,
    "minecraft:amethyst_block": 6,
    "minecraft:rail": 6,
    "minecraft:powered_rail": 6,
    "minecraft:detector_rail": 6,
    "minecraft:activator_rail": 6,
    "minecraft:iron_door": 6,
    "minecraft:iron_trapdoor": 6,
    "minecraft:smooth_quartz": 6,
    "minecraft:deepslate_bricks": 7,
    "minecraft:cracked_deepslate_bricks": 7,
    "minecraft:polished_deepslate": 7,
    "minecraft:polished_blackstone": 7,
    "minecraft:polished_blackstone_bricks": 7,
    "minecraft:stone_bricks": 7,
    "minecraft:cracked_stone_bricks": 7,
    "minecraft:mossy_stone_bricks": 7,
    "minecraft:bricks": 7,
    "minecraft:smooth_sandstone": 7,
    "minecraft:smooth_red_sandstone": 7,
    "minecraft:mud_bricks": 7,
    "minecraft:torch": 9,
    "minecraft:wall_torch": 9,
    "minecraft:soul_torch": 9,
    "minecraft:soul_wall_torch": 9,
    "minecraft:lantern": 9,
    "minecraft:soul_lantern": 9,
    "minecraft:crying_obsidian": 9,
    "minecraft:beacon": 9,
    "minecraft:end_rod": 9,
    "minecraft:magma_block": 9,
    "minecraft:campfire": 9,
    "minecraft:soul_campfire": 9,
    "minecraft:iron_chain": 6,
    "minecraft:copper_chain": 6
  },
  "scenePrograms": [
    {
      "pipeline": "sodium:pipeline/solid_terrain",
      "vertex": "shaders/terrain.vsh",
      "fragment": "shaders/terrain.fsh",
      "textures": {
        "Opaque": "$terrainOpaque",
        "OpaqueDepth": "$terrainOpaqueDepth"
      },
      "writes": [
        "surface.data"
      ]
    },
    {
      "pipeline": "sodium:pipeline/cutout_terrain",
      "vertex": "shaders/terrain.vsh",
      "fragment": "shaders/terrain.fsh",
      "textures": {
        "Opaque": "$terrainOpaque",
        "OpaqueDepth": "$terrainOpaqueDepth"
      },
      "writes": [
        "surface.data"
      ]
    },
    {
      "pipeline": "sodium:pipeline/translucent_terrain",
      "vertex": "shaders/terrain.vsh",
      "fragment": "shaders/terrain.fsh",
      "textures": {
        "Opaque": "$terrainOpaque",
        "OpaqueDepth": "$terrainOpaqueDepth"
      },
      "writes": [
        "surface.data"
      ]
    }
  ],
  "options": {
    "ANTIALIASING": {
      "label": "Antialiasing",
      "default": 1,
      "values": [
        0,
        1
      ]
    },
    "COLOR_GRADE": {
      "label": "Color Style",
      "default": 0.5,
      "values": [
        0,
        0.25,
        0.5,
        1
      ]
    },
    "DISTANCE_COLOR": {
      "label": "Distance colors",
      "default": 1,
      "values": [
        0,
        0.5,
        1
      ]
    },
    "WET_SURFACES": {
      "label": "Rain-wet surfaces",
      "default": 0.5,
      "values": [
        0,
        0.25,
        0.5,
        0.75,
        1
      ]
    },
    "MATERIAL_SHEEN": {
      "label": "Material highlights",
      "default": 0.5,
      "values": [
        0,
        0.25,
        0.5,
        0.75,
        1
      ]
    },
    "EMISSIVE_ACCENTS": {
      "label": "Glowing blocks and plants",
      "default": 0.5,
      "values": [
        0,
        0.25,
        0.5,
        0.75,
        1
      ]
    },
    "VEGETATION_WIND": {
      "label": "Vegetation wind strength",
      "default": 1,
      "values": [
        0,
        0.5,
        1,
        1.5
      ]
    },
    "TM_EXPOSURE": {
      "label": "Exposure",
      "default": 1,
      "values": [
        0.6,
        0.8,
        1,
        1.2,
        1.4
      ]
    },
    "TM_CONTRAST": {
      "label": "Contrast",
      "default": 1.05,
      "values": [
        0.85,
        1,
        1.05,
        1.15,
        1.3
      ]
    },
    "T_SATURATION": {
      "label": "Saturation",
      "default": 1,
      "values": [
        0.8,
        0.9,
        1,
        1.1,
        1.2
      ]
    },
    "LIGHT_WARMTH": {
      "label": "Light warmth",
      "default": 1,
      "values": [
        0,
        0.5,
        1,
        1.5
      ]
    },
    "BLOOM_STRENGTH": {
      "label": "Bloom strength",
      "default": 0.06,
      "values": [
        0,
        0.06,
        0.12,
        0.2,
        0.3
      ]
    },
    "ATMOSPHERE": {
      "label": "Atmospheric haze",
      "default": 1,
      "values": [
        0,
        0.5,
        1,
        1.5,
        2
      ]
    },
    "WATER_ENABLED": {
      "label": "Water refraction",
      "default": 1,
      "values": [
        0,
        1
      ]
    },
    "WATER_WAVES": {
      "label": "Water waves",
      "default": 1,
      "values": [
        0,
        0.5,
        1,
        1.5
      ]
    },
    "WATER_DENSITY": {
      "label": "Water fog density",
      "default": 1,
      "values": [
        0.5,
        1,
        1.5,
        2
      ]
    },
    "SHADOW_QUALITY": {
      "label": "Shadow quality",
      "default": 1,
      "values": [
        0,
        1,
        2,
        3,
        4
      ]
    },
    "SHADOW_DISTANCE": {
      "label": "Shadow distance (blocks)",
      "default": 64,
      "values": [
        64,
        96,
        128,
        192,
        256
      ]
    },
    "CLOUD_QUALITY": {
      "label": "Cloud quality",
      "default": 0,
      "values": [
        0,
        1,
        2,
        3,
        4
      ]
    },
    "CLOUD_COVERAGE": {
      "label": "Cloud density (preserves vanilla shape)",
      "default": 0.5,
      "values": [
        0.25,
        0.5,
        0.75,
        1
      ]
    },
    "CLOUD_HEIGHT_OFFSET": {
      "label": "Cloud height offset from vanilla",
      "default": 0,
      "values": [
        -64,
        0,
        64
      ]
    },
    "SUN_SIZE": {
      "label": "Sun size",
      "default": 1,
      "values": [
        0.75,
        1,
        1.5
      ]
    },
    "SUN_SHAFTS": {
      "label": "Sun shafts",
      "default": 0,
      "values": [
        0,
        0.5,
        1,
        1.5,
        2
      ]
    },
    "AMBIENT_OCCLUSION": {
      "label": "Contact shading",
      "default": 1,
      "values": [
        0,
        0.5,
        1,
        1.5,
        2
      ]
    },
    "WATER_REFLECTION_QUALITY": {
      "label": "Water / ice reflection quality",
      "default": 1,
      "values": [
        0,
        1,
        2,
        3,
        4
      ]
    },
    "WATER_REFLECTION_STRENGTH": {
      "label": "Water / ice reflection strength",
      "default": 1,
      "values": [
        0,
        0.5,
        1
      ]
    },
    "HELD_LIGHTING": {
      "label": "Held-item light",
      "default": 1,
      "values": [
        0,
        0.5,
        1,
        1.5,
        2
      ]
    },
    "AUTO_EXPOSURE": {
      "label": "Auto exposure",
      "default": 1,
      "values": [
        0,
        1
      ]
    }
  },
  "resources": {
    "scene.hdr": {
      "format": "RGBA16_FLOAT"
    },
    "bloom.seed": {
      "format": "RGBA16_FLOAT",
      "scale": 0.25
    },
    "bloom.soft": {
      "format": "RGBA16_FLOAT",
      "scale": 0.25
    },
    "bloom.wide": {
      "format": "RGBA16_FLOAT",
      "scale": 0.0625
    },
    "display": {
      "format": "RGBA8_UNORM"
    },
    "clouds.hdr": {
      "format": "RGBA16_FLOAT",
      "scale": 0.5
    },
    "clouds.distance": {
      "format": "R32_FLOAT",
      "scale": 0.5
    },
    "lighting.half": {
      "format": "RG16_FLOAT",
      "scale": 0.5
    },
    "surface.data": {
      "format": "RG32_UINT"
    },
    "water.reflection": {
      "format": "RGBA16_FLOAT",
      "scale": 1
    },
    "exposure.meter": {
      "format": "RG32_FLOAT",
      "size": [
        32,
        18,
        1
      ]
    },
    "exposure.adapted": {
      "format": "R32_FLOAT",
      "size": [
        1,
        1,
        1
      ],
      "history": true
    }
  },
  "passes": [
    {
      "name": "clouds",
      "fragment": "shaders/clouds.fsh",
      "reads": {
        "Depth": "$depth",
        "VanillaClouds": "$texture/vanilla-clouds"
      },
      "writes": [
        "clouds.hdr",
        "clouds.distance"
      ]
    },
    {
      "name": "lighting",
      "fragment": "shaders/lighting.fsh",
      "reads": {
        "Depth": "$depth",
        "VanillaClouds": "$texture/vanilla-clouds",
        "Surface": "surface.data"
      },
      "writes": [
        "lighting.half"
      ]
    },
    {
      "name": "water-reflections",
      "fragment": "shaders/water-reflections.fsh",
      "reads": {
        "Surface": "surface.data",
        "Depth": "$depth",
        "HandDepth": "$handDepth",
        "Opaque": "$terrainOpaque",
        "OpaqueDepth": "$terrainOpaqueDepth",
        "Scene": "$scene",
        "VanillaClouds": "$texture/vanilla-clouds"
      },
      "writes": [
        "water.reflection"
      ]
    },
    {
      "name": "atmosphere",
      "fragment": "shaders/atmosphere.fsh",
      "reads": {
        "Scene": "$scene",
        "Weather": "$weather",
        "Depth": "$depth",
        "HandDepth": "$handDepth",
        "Clouds": "clouds.hdr",
        "CloudDistance": "clouds.distance",
        "Lighting": "lighting.half",
        "Surface": "surface.data",
        "WaterReflection": "water.reflection"
      },
      "writes": [
        "scene.hdr"
      ],
      "readConditions": {
        "Clouds": [
          "CLOUD_QUALITY"
        ],
        "CloudDistance": [
          "CLOUD_QUALITY"
        ],
        "Lighting": [
          "AMBIENT_OCCLUSION",
          "SUN_SHAFTS"
        ],
        "WaterReflection": [
          [
            "WATER_ENABLED",
            "WATER_REFLECTION_QUALITY",
            "WATER_REFLECTION_STRENGTH"
          ]
        ]
      }
    },
    {
      "name": "bloom-seed",
      "fragment": "shaders/bloom-seed.fsh",
      "reads": {
        "Source": "scene.hdr"
      },
      "writes": [
        "bloom.seed"
      ],
      "linearReads": [
        "Source"
      ]
    },
    {
      "name": "bloom-soft",
      "fragment": "shaders/blur-y.fsh",
      "reads": {
        "Source": "bloom.seed"
      },
      "writes": [
        "bloom.soft"
      ],
      "linearReads": [
        "Source"
      ]
    },
    {
      "name": "bloom-wide",
      "fragment": "shaders/bloom-wide.fsh",
      "reads": {
        "Source": "bloom.soft"
      },
      "writes": [
        "bloom.wide"
      ],
      "linearReads": [
        "Source"
      ]
    },
    {
      "name": "exposure-meter",
      "fragment": "shaders/exposure-meter.fsh",
      "reads": {
        "Source": "scene.hdr",
        "Depth": "$depth",
        "HandDepth": "$handDepth"
      },
      "writes": [
        "exposure.meter"
      ]
    },
    {
      "name": "exposure-adapt",
      "fragment": "shaders/exposure-adapt.fsh",
      "reads": {
        "Meter": "exposure.meter",
        "Previous": "exposure.adapted@previous"
      },
      "writes": [
        "exposure.adapted"
      ]
    },
    {
      "name": "final",
      "fragment": "shaders/final.fsh",
      "reads": {
        "Source": "scene.hdr",
        "Bloom": "bloom.soft",
        "Wide": "bloom.wide",
        "Exposure": "exposure.adapted"
      },
      "writes": [
        "display"
      ],
      "linearReads": [
        "Source",
        "Bloom",
        "Wide"
      ],
      "readConditions": {
        "Bloom": [
          "BLOOM_STRENGTH"
        ],
        "Wide": [
          "BLOOM_STRENGTH"
        ],
        "Exposure": [
          "AUTO_EXPOSURE"
        ]
      }
    }
  ],
  "present": "display",
  "shadows": true,
  "environment": {
    "sky": true,
    "clouds": true
  },
  "sceneTargets": [
    "surface.data"
  ]
}
`

## shaders/terrain.vsh

`glsl
#version 450
#include "shaders/terrain-globals.glsl"
#include "shaders/include/vegetation_wind.glsl"
layout(location=0) in uvec2 a_Position;
layout(location=1) in vec4 a_Color;
layout(location=2) in uvec2 a_TexCoord;
layout(location=3) in uvec4 a_LightAndData;
layout(location=4) in uint a_SulkanMaterial;
uniform sampler2D u_LightTex;
uniform isamplerBuffer u_SectionTimeInfo;
layout(push_constant) uniform PC { vec3 u_RegionOffset; int u_CurrentTime; uint u_RegionID; };
layout(location=0) out vec4 tint;
layout(location=1) out vec2 uv;
layout(location=2) out vec3 relativePosition;
layout(location=3) out vec2 lightLevel;
layout(location=4) out float fade;
layout(location=5) flat out uint materialId;
layout(location=6) flat out uint terrainMaterial;
void main() {
    // Decode the compact 20-bit XYZ and section index defined by Sodium's mesh ABI.
    vec3 local;
    for (uint axis=0u; axis<3u; ++axis) {
        uint value = (((a_Position.x >> (axis*10u)) & 1023u) << 10u) | ((a_Position.y >> (axis*10u)) & 1023u);
        local[axis] = float(value) / 32768.0 - 8.0;
    }
    uint section = a_LightAndData.w;
    vec3 sectionOffset = vec3((section >> 5u) & 7u, section & 3u, (section >> 2u) & 7u) * 16.0;
    relativePosition = local + sectionOffset + u_RegionOffset;
    relativePosition += sulkanWindOffset(relativePosition, a_SulkanMaterial);
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(relativePosition, 1.0);
    vec2 lightUv = vec2(a_LightAndData.xy) / 256.0;
    tint = a_Color;
    lightLevel = clamp(lightUv * (16.0/15.0), 0.0, 1.0);
    uv = vec2(a_TexCoord & 32767u) / 32768.0 + (vec2(a_TexCoord >> 15u) * 2.0 - 1.0) * u_TexCoordShrink;
    int birth = texelFetch(u_SectionTimeInfo, int(u_RegionID * 256u + section)).r;
    fade = birth < 0 ? 1.0 : clamp(float(u_CurrentTime - birth) * u_FadePeriodInv, 0.0, 1.0);
    materialId = a_SulkanMaterial & 65535u;
    terrainMaterial = a_LightAndData.z;
}

`

## shaders/terrain.fsh

`glsl
#version 450
#include "shaders/common.glsl"
#include "shaders/terrain-globals.glsl"
#include "shaders/include/terrain_material.glsl"
#include "shaders/palette.glsl"
#include "shaders/include/native_shadows.glsl"
#include "shaders/environment.glsl"
#include "shaders/specular.glsl"
#include "shaders/held-light.glsl"
uniform sampler2D u_BlockTex;
uniform sampler2D u_LightTex;
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
#include "shaders/surface-data.glsl"
#include "shaders/ice.glsl"
layout(location=0) in vec4 tint;
layout(location=1) in vec2 uv;
layout(location=2) in vec3 relativePosition;
layout(location=3) in vec2 lightLevel;
layout(location=4) in float fade;
layout(location=5) flat in uint materialId;
layout(location=6) flat in uint terrainMaterial;
layout(location=0) out vec4 color;
layout(location=1) out uvec2 surfaceData;
void main() {
    vec3 eyeDirection=normalize(sulkanCameraOffset()-relativePosition);
    // Derivatives precede every discard and nonuniform material branch.
    vec3 crossNormal = cross(dFdx(relativePosition), dFdy(relativePosition));
    vec3 geomNormal = crossNormal * inversesqrt(max(dot(crossNormal,crossNormal), 1e-12));
    if (dot(geomNormal, eyeDirection) < 0.0) geomNormal = -geomNormal;
    vec3 normal = geomNormal;
    bool ice=materialId>=12u && materialId<=14u;
    float iceRoughness=0.0;
    if(ice) normal=sulkanIceDetail(relativePosition,normal,iceRoughness);
    bool enhancedWater=false;
    vec4 base = sulkanSampleTerrainMaterial(u_BlockTex, uv, terrainMaterial) * tint;
    vec3 albedo=toLinear(base.rgb);
    if(materialId==12u) {
        // Only clear ice replaces its atlas color with transmission tint.
        // Packed and blue ice retain their original texture and color beneath
        // the rough surface lighting and screen-space reflections.
        albedo=vec3(0.72,0.86,0.92);
    }
#ifdef SULKAN_TRANSLUCENT
    if(base.a<=1.0/255.0) discard;
#endif
#ifdef ALPHA_CUTOUT
    if (base.a < sulkanMaterialAlphaCutoff(terrainMaterial)) discard;
#endif
    float worldDistance = length(relativePosition);
    float overworld = 1.0-step(0.5,abs(WorldTimeWeatherDimension.w));
    float daylight = sulkanDay();
    vec3 sunDirection = daylight>0.5?SunDirectionAndRainBrightness.xyz:MoonDirectionAndPhase.xyz;
    bool plant = materialId >= 2u && materialId <= 5u;
    bool cutoutSurface = plant || sulkanMaterialAlphaCutoff(terrainMaterial)>0.0;
    // 提取贴图自身明暗构建绝对稳定、零闪烁的微表面立体遮蔽（Micro-Occlusion）：
    // 泥土/石砖的暗部凹槽自然加深立体感，亮部凸起自然受光，移动镜头时 0 闪烁！
    float texLuma = dot(albedo, vec3(0.299, 0.587, 0.114));
    float microOccl = clamp(0.82 + (texLuma - 0.35) * 0.45, 0.72, 1.15);
    vec3 storedNormal = ice ? normal : geomNormal;
    float sunDot = dot(normal,normalize(sunDirection+vec3(0,1e-5,0)));
    float sunFacing = max(sunDot,0.0);
    // 阴影偏移和接收平面斜率必须使用绝对平整的 geomNormal，彻底杜绝微凹凸法线引发的阴影条纹闪烁！
    vec3 shadowNormal = cutoutSurface && dot(geomNormal,sunDirection)<0.0 ? -geomNormal : geomNormal;
    bool grass = materialId>=2u && materialId<=4u;
    float skyLight = pow(lightLevel.y,2.0);
    // Sodium encodes sky light 0 as 1/30. A surface sealed from the sky at every
    // vertex cannot see the sun, so skip the cascade filter and use the fully
    // shadowed result the map reports for enclosed surfaces.
#if SHADOW_QUALITY > 0
    float shadow = mix(1.0,ShadowParams.z,ShadowParams.x);
    float sunVisibility = 0.0;
#else
    float shadow = 1.0;
    float sunVisibility = 1.0;
#endif
    if(lightLevel.y > 1.0/30.0+1e-4)
        shadow = sulkanTerrainShadows(relativePosition,shadowNormal,grass,sunVisibility);
    // 1. 真正的物理兰伯特直射光（背光面绝不吃直射太阳光，只吃软边缘过渡！）
    float directFacing = cutoutSurface ? sunFacing : smoothstep(-0.05, 0.95, sunDot) * sunFacing;
    vec3 direct = portLightPalette() * directFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);

    // 2. 半球天光（朝上的面吃清澈蓝天光，朝下的面压暗）+ 阳光地面漫反射反弹（Fake GI Bounce）！
    vec3 zenithSky = mix(vec3(0.012, 0.020, 0.045), vec3(0.28, 0.46, 0.78), daylight);
    vec3 groundBounce = portLightPalette() * vec3(0.42, 0.35, 0.24) * (0.4 + 0.6 * daylight); // 阳光砸在地面反弹向上的暖色GI
    float hemiWeight = normal.y * 0.5 + 0.5;
    vec3 skyFill = mix(groundBounce * 0.45, zenithSky, hemiWeight);
    skyFill = mix(skyFill, vec3(dot(skyFill, vec3(0.299, 0.587, 0.114))), WorldTimeWeatherDimension.y * 0.65);

    // 3. 在被直接照亮的表面附近，额外注入一抹温暖的间接反弹光能量
    vec3 giFill = groundBounce * (1.0 - hemiWeight * 0.6) * smoothstep(0.1, 0.9, lightLevel.y) * 0.28;
    vec3 lighting = vec3(0.020) + skyLight * (skyFill * 0.45 + giFill + direct * 1.05);
    if (materialId == 5u) {
        float exposure = exp2(-4.0 * (1.0 - clamp(lightLevel.y, 0.0, 1.0)));
        float skyFacing = 0.65 + 0.35 * max(normal.y, 0.0);
        vec3 leafSky = skyFill * 0.42 * mix(0.40, 1.0, exposure) * skyFacing;
        // 叶片内部全向次表面散射（SSS）：即使顺光看，受光叶片内部也有柔和的透光感
        vec3 sun = normalize(SunDirectionAndRainBrightness.xyz + vec3(0, 1e-5, 0));
        float forwardScatter = pow(max(dot(-eyeDirection, sun), 0.0), 3.0);
        float wrapScatter = clamp((sunDot + 0.6) / 1.6, 0.0, 1.0);
        float sss = (0.35 * wrapScatter + 0.65 * forwardScatter) * exposure * shadow
            * smoothstep(0.0, 0.15, sun.y) * (1.0 - WorldTimeWeatherDimension.y);
        // 提纯叶片散射色，消除塑料死白
        vec3 leafGlow = pow(max(albedo, vec3(0.01)), vec3(0.75)) * portLightPalette() * sss * 0.55;
        lighting = vec3(0.025) + skyLight * (leafSky + direct * 0.90 + leafGlow);
    }
    // Deepen clear-day cast shadows without crushing torchlight or night detail.
    // Reuse visibility so this adds no shadow samples or rendering passes.
    float shadowContrast = (1.0-shadow)*daylight*(1.0-WorldTimeWeatherDimension.y);
    // Back-facing cutouts receive ambient skylight, not a second cast-shadow
    // darkening on top of their already absent direct sunlight.
    if(cutoutSurface) shadowContrast*=sunFacing;
    lighting *= 1.0-0.28*shadowContrast*skyLight;
    // Physical inverse-square torch/blocklight falloff with Planckian color temperature shift
    float bl = lightLevel.x;
    float blockLight = bl * bl * bl * (bl * 1.8 + 0.2);
    vec3 torchPalette = mix(vec3(1.6, 0.45, 0.12), vec3(1.8, 1.15, 0.65), bl * bl);
    vec3 warmBlock = mix(vec3(1.0), torchPalette, clamp(LIGHT_WARMTH, 0.0, 1.5));
    // 稳定的微明暗对比调制火把光，完全消除视线移动造成的 2x2 抖动黑斑
    lighting += warmBlock * blockLight * microOccl * 1.65;
    // 逆光菲涅尔轮廓金边（Rim Light）：当视线逆着阳光擦过方块或树叶边缘时，泛出温暖的金边
    float rim = pow(1.0 - max(dot(normal, eyeDirection), 0.0), 4.0) * pow(max(dot(-eyeDirection, sunDirection), 0.0), 3.0) * (1.0 - max(normal.y, 0.0));
    lighting += portLightPalette() * (rim * shadow * skyLight * 0.35);
    // Keep the vanilla lightmap for dimension-specific lighting outside the Overworld.
    vec3 vanillaLight = texture(u_LightTex,lightLevel*(15.0/16.0)).rgb;
    // Minecraft's scene target stores display-space color; encode the linear light factor once.
    vec3 heldLight=sulkanHeldLight(relativePosition,normal);
    vec3 surface=albedo*(mix(toLinear(vanillaLight),max(lighting,vec3(0)),overworld)+heldLight);
    // 模拟紧挨着火把/岩浆周围 2 格内的空气丁达尔散射微光（消除暗色方块在火把旁依然死黑的问题）
    float nearSource = smoothstep(0.65, 1.0, lightLevel.x);
    surface += torchPalette * (nearSource * nearSource * 0.06 * clamp(LIGHT_WARMTH, 0.0, 1.5));
    float wet = 0.0;
    if(materialId!=1u && overworld>0.5 && CameraPositionHighAndFogType.w<0.5) {
        // Skylight approximates rain exposure; upward faces collect most moisture.
        wet=WET_SURFACES*WorldTimeWeatherDimension.y
            *smoothstep(0.88,1.0,lightLevel.y)*smoothstep(0.0,0.7,normal.y);
        if(materialId>=9u) wet=0.0;
        surface*=1.0-0.22*wet;
        float materialWeight=(materialId>=6u && materialId<=8u)?MATERIAL_SHEEN:0.0;
        // 用 texLuma 调制粗糙度：砖缝/凹陷处（暗）粗糙不反光，凸起晶体（亮）细腻有光泽！
        float microRough = clamp(1.0 - (texLuma - 0.35) * 0.65, 0.75, 1.25);
        float roughness = mix(0.68, materialId==6u ? 0.22 : (materialId==8u ? 0.62 : 0.42), materialWeight) * microRough;
        // 几何高光抗锯齿（Toksvig / Geometric Specular Antialiasing）：防止中远景高频微凹凸形成摩尔纹与高光毛刺
        float distAa = smoothstep(12.0, 64.0, worldDistance) * 0.25;
        roughness = clamp(roughness + distAa, 0.15, 0.95);
        float reflectance=mix(0.035,0.18,materialId==6u?materialWeight:0.0);
        if(ice) { roughness=mix(0.24,0.46,iceRoughness); reflectance=0.025; }
        {
            float highlight=sulkanSunSpecular(normal,eyeDirection,mix(roughness,0.22,wet),reflectance);
            surface+=portLightPalette()*highlight*sunVisibility*skyLight;
        }
        if(wet>0.0) {
            // Analytic sky sheen stays visible under overcast skies. No reflection tracing.
            float fresnel=0.02+0.18*pow(1.0-max(dot(normal,eyeDirection),0.0),5.0);
            surface+=sulkanSky(reflect(-eyeDirection,normal))*wet*fresnel*skyLight;
        }
    }
    // Bright texture regions emit; unlit redstone and berry-free vines are unmapped.
    float emission=0.0;
    if(materialId==9u) emission=smoothstep(0.15,0.60,max(albedo.r,max(albedo.g,albedo.b)));
    if(materialId==10u) emission=smoothstep(0.12,0.5,albedo.r)*0.8;
    if(materialId==11u) emission=smoothstep(0.08,0.4,albedo.r-max(albedo.g,albedo.b))*0.9;
    // 1. 在 SDR 缓冲内保留发光体的纹理细节与色彩，绝对不要在这里乘 3.5 导致被 8-bit 缓冲截断抹平！
    vec3 emissiveColor = pow(albedo, vec3(1.25)); // 稍微提纯色相，防止发灰
    surface = mix(surface, emissiveColor * 0.95, clamp(emission * EMISSIVE_ACCENTS, 0.0, 0.95));
    float hdrBoost=0.0;
    if(materialId==9u && emission>0.05) hdrBoost=3.0;
    else if(materialId==6u && (sunVisibility>0.4 || wet>0.3)) hdrBoost=2.0;
    else if(materialId==10u || materialId==11u) hdrBoost=1.0;
    base.rgb=pow(max(surface,vec3(0.0)),vec3(1.0/2.2));
#if WATER_ENABLED == 1
    if (materialId == 1u && CameraPositionHighAndFogType.w < 0.5) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 worldXZ = relativePosition.xz + mod(CameraPositionHighAndFogType.xz, vec2(4096.0)) + CameraPositionLowAndFarPlane.xz;
        float t = TimeDeltaFrame.x * 0.25;
        // Short, gentle ripples: quarter the wavelength without speeding up animation.
        vec2 wave = vec2(cos(dot(worldXZ, vec2(2.2,1.24)) + t*1.2), sin(dot(worldXZ,vec2(-1.12,2.48)) - t*0.9));
        vec2 refractedUv = clamp(screenUv + wave * WATER_WAVES * 0.0008 / (1.0 + worldDistance * 0.025), ViewSizeAndInverse.zw, vec2(1.0)-ViewSizeAndInverse.zw);
        float surfaceDistance = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        if (backDistance < surfaceDistance) refractedUv = screenUv;
        backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        float thickness = clamp(backDistance - surfaceDistance, 0.0, 160.0);
        vec3 waterNormal = normalize(normal + vec3(wave.x,0.0,wave.y) * (0.018 * WATER_WAVES));
        vec3 waterTint = mix(vec3(0.035,0.21,0.28), tint.rgb * vec3(0.2,0.65,0.75), 0.25);
        vec4 background = linearSample(Opaque, refractedUv);
        if (background.a > 0.0) {
            vec3 absorption=exp(-thickness*WATER_DENSITY*vec3(0.16,0.065,0.035));
            // Absorbed light is replaced by locally lit scattering, never an
            // unlit cyan tint. The background already contains its own lighting.
            vec3 waterLighting=mix(toLinear(vanillaLight),max(lighting,vec3(0)),overworld)+heldLight;
            vec3 scattering=toLinear(waterTint)*waterLighting;
            vec3 transmission=toLinear(background.rgb)*absorption+scattering*(1.0-absorption);
            storedNormal=waterNormal;
            enhancedWater=true;
            vec3 waterColor=transmission;
            waterColor+=portLightPalette()*sulkanSunSpecular(waterNormal,eyeDirection,0.16,0.02)*sunVisibility*skyLight*overworld;
            base=vec4(pow(max(waterColor,vec3(0)),vec3(1.0/2.2)),1.0);
        }
    }
#endif
    // Only naturally translucent ice can sample the scene behind it. Packed and
    // blue ice keep their lit opaque surface and still receive ice SSR below.
#ifdef SULKAN_TRANSLUCENT
    if(materialId==12u) {
        vec2 screenUv=gl_FragCoord.xy*ViewSizeAndInverse.zw;
        vec2 distortion=(mat3(View)*normal).xy*0.0007/(1.0+worldDistance*0.025);
        vec2 refractedUv=clamp(screenUv+distortion,ViewSizeAndInverse.zw,vec2(1)-ViewSizeAndInverse.zw);
        float front=length(viewPosition(screenUv,gl_FragCoord.z));
        float backDepth=texture(OpaqueDepth,refractedUv).r;
        if(backDepth>1e-7 && length(viewPosition(refractedUv,backDepth))<front) refractedUv=screenUv;
        backDepth=texture(OpaqueDepth,refractedUv).r;
        float thickness=backDepth>1e-7?clamp(length(viewPosition(refractedUv,backDepth))-front,0.0,12.0):1.0;
        vec4 background=linearSample(Opaque,refractedUv);
        vec3 transmission=background.a>0.0?toLinear(background.rgb):sulkanSky(normalize(relativePosition));
        vec3 absorption=exp(-thickness*vec3(0.04,0.016,0.008));
        vec3 iceColor=transmission*absorption+albedo*(vec3(1)-absorption)*0.25;
        // Uneven internal frost scatters light and reduces clarity in rough patches.
        float haze=mix(0.025,0.085,smoothstep(0.2,0.85,iceRoughness));
        haze=clamp(haze+0.015*(1.0-exp(-thickness*0.3)),0.0,0.10);
        iceColor=mix(iceColor,albedo*(lighting+heldLight)*0.65,haze);
        iceColor+=portLightPalette()*sulkanSunSpecular(normal,eyeDirection,mix(0.24,0.46,iceRoughness),0.025)*sunVisibility*skyLight*overworld;
        base=vec4(pow(max(iceColor,vec3(0)),vec3(1.0/2.2)),1.0);
    }
#endif
    float sphericalFog = clamp((worldDistance-u_EnvironmentFog.x)/max(u_EnvironmentFog.y-u_EnvironmentFog.x,0.001),0.0,1.0);
    // Outdoor atmosphere is handled once in the post pass. Keep render-distance
    // fading below, and vanilla environment fog for water/lava/other dimensions.
    if(overworld>0.5 && CameraPositionHighAndFogType.w<0.5) sphericalFog=0.0;
    float cylinder = max(length(relativePosition.xz), abs(relativePosition.y));
    float renderFog = clamp((cylinder-u_RenderFog.x)/max(u_RenderFog.y-u_RenderFog.x,0.001),0.0,1.0);
    float fog = max(1.0-fade, max(materialId==1u && CameraPositionHighAndFogType.w<0.5?0.0:sphericalFog,renderFog)) * u_FogColor.a;
    vec3 fogColor = u_FogColor.rgb;
    if(overworld>0.5 && CameraPositionHighAndFogType.w<0.5) {
        float skyAccess=min(smoothstep(0.05,0.65,CloudOffsetAndGameTime.z),smoothstep(0.01,0.5,skyLight));
        // Keep vanilla distance-fade color under cover; do not force it toward
        // black with a cave-specific multiplier. Mist is handled in the post pass.
        fogColor=mix(fogColor,pow(sulkanSky(normalize(relativePosition)),vec3(1.0/2.2)),skyAccess);
    }
    vec3 finalOut = mix(base.rgb, fogColor, fog);
    float outDither = (fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5) * 1.5;
    color = vec4(clamp(finalOut + outDither / 255.0, 0.0, 1.0), base.a);
    surfaceData=uvec2(encodeSurface(storedNormal,skyLight,1.0-fog,enhancedWater,hdrBoost),floatBitsToUint(gl_FragCoord.z));
    if(ice) surfaceData.x |= 0x20000000u;
#ifdef SULKAN_TRANSLUCENT
    if(!enhancedWater) surfaceData.x |= 0xc0000000u;
#endif
}

`

## shaders/lighting.fsh

`glsl
#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/cloud-field.glsl"
#include "shaders/include/native_shadows.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 lighting;
uniform sampler2D Depth;
uniform usampler2D Surface;
#include "shaders/surface-data.glsl"
#include "shaders/surface-normal.glsl"
void main() {
    ivec2 depthSize=textureSize(Depth,0);
    ivec2 center=clamp(ivec2(texCoord*vec2(depthSize)),ivec2(0),depthSize-1);
    vec2 centerUv=(vec2(center)+0.5)/vec2(depthSize);
    float depth=texelFetch(Depth,center,0).r;
    vec3 p=viewPosition(centerUv,max(depth,1e-6));

    float ao=0.0;
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION
    if(depth>1e-7) {
        uvec2 sData = texelFetch(Surface, center, 0).rg;
        vec3 n;
        if (surfaceMatches(sData, depth)) {
            n = mat3(View) * surfaceNormal(sData.x);
        } else {
            n = depthSurfaceNormal(Depth, centerUv);
        }
        // High-speed Spiral Poisson sampling (ground-truth contact crevices)
        float dither = fract(52.9829189 * fract(dot(centerUv, vec2(0.06711056, 0.00583715))));
        float baseRadius = clamp(1.2 / max(length(p), 0.2) * ViewSizeAndInverse.y * 0.45, 3.0, 10.0);
        // 预取投影逆参数，在采样循环内消灭所有 4x4 矩阵乘法
        vec2 projScale = vec2(InverseProjection[0][0], InverseProjection[1][1]);
        vec2 projDepth = vec2(InverseProjection[2][2], InverseProjection[3][2]);
        vec2 projW = vec2(InverseProjection[2][3], InverseProjection[3][3]);
        for(int i=0;i<4;i++) {
            float alpha = (float(i) + 0.5) / 4.0;
            float angle = float(i) * 2.39996323 + dither * 6.2831853;
            float sampleRadius = baseRadius * sqrt(alpha);
            vec2 offsetUv = centerUv + vec2(cos(angle), sin(angle)) * sampleRadius * ViewSizeAndInverse.zw;
            if(any(lessThan(offsetUv, vec2(0.0))) || any(greaterThanEqual(offsetUv, vec2(1.0)))) continue;
            ivec2 pixel = ivec2(offsetUv * vec2(depthSize));
            float sampleDepth = texelFetch(Depth, pixel, 0).r;
            if(sampleDepth <= 1e-7) continue;
            vec2 uv = (vec2(pixel) + 0.5) / vec2(depthSize);
            float sDepth = max(sampleDepth, 1e-6);
            float pw = sDepth * projW.x + projW.y;
            float invW = 1.0 / (abs(pw) < 1e-6 ? 1e-6 : pw);
            vec3 samplePos = vec3((uv * 2.0 - 1.0) * projScale, sDepth * projDepth.x + projDepth.y) * invW;
            vec3 delta = samplePos - p;
            float distance = length(delta);
            float planeDist = dot(n, delta);
            float normalDot = planeDist / max(distance, 0.001);
            float occl = smoothstep(0.05, 0.15, planeDist) * max(normalDot - 0.25, 0.0) * (1.0 / (1.0 + distance * distance * 1.6)) * smoothstep(2.6, 0.20, distance);
            ao += occl * 1.35;
        }
    }
#endif
    float shafts=0.0;
#if _SULKAN_ENABLED_SUN_SHAFTS
    if(abs(WorldTimeWeatherDimension.w)<0.5 && CameraPositionHighAndFogType.w<0.5 && SunDirectionAndRainBrightness.y>0.02 && CloudOffsetAndGameTime.z>0.05) {
        vec3 ray=sulkanRay(texCoord);
        vec3 sun=normalize(SunDirectionAndRainBrightness.xyz);
        float reach=depth>1e-7?min(length(p),96.0):96.0;
        // Optimized 8-step volume march with spatial dither
        float stepLength=reach/8.0;
        vec3 origin=sulkanCloudOrigin();
        float dither = fract(sin(dot(texCoord * ViewSizeAndInverse.xy, vec2(12.9898, 78.233))) * 43758.5453);
        for(int i=0;i<8;i++) {
            float distance=(float(i)+dither)*stepLength;
            vec3 relative=sulkanCameraOffset()+ray*distance;
            vec3 world=origin+relative;
            float visibility=sulkanVolumeShadow(relative);
#if CLOUD_QUALITY > 0
            float entry=max((cloudBottom()-world.y)/sun.y,0.0);
            float exitDistance=max((cloudBottom()+4.0-world.y)/sun.y,0.0);
            float span=max(exitDistance-entry,0.0);
            float cloudDepth=0.0;
            for(int c=0;c<2;c++) cloudDepth+=cloudDensity(world+sun*(entry+(float(c)+0.5)*span*0.5))*span*0.5;
            visibility*=exp(-cloudDepth);
#endif
            float airDensity=exp(clamp((72.0-world.y)*0.018,-8.0,3.0));
            shafts+=visibility*airDensity*exp(-distance*0.012)*stepLength*0.006;
        }
        float forward=0.08+0.92*pow(max(dot(ray,sun),0.0),8.0);
        shafts*=smoothstep(0.05,0.65,CloudOffsetAndGameTime.z)*forward*(1.0-WorldTimeWeatherDimension.y)*smoothstep(0.02,0.15,sun.y);
    }
#endif
    lighting=vec4(clamp(1.0-ao*0.30*AMBIENT_OCCLUSION,0.30,1.0),shafts,0.0,1.0);
}

`

## shaders/atmosphere.fsh

`glsl
#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/ground-mist.glsl"
#include "shaders/surface-normal.glsl"
#include "shaders/surface-data.glsl"
#include "shaders/specular.glsl"
#include "shaders/held-light.glsl"
#include "shaders/include/native_shadows.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 hdr;
uniform sampler2D Scene;
uniform usampler2D Surface;
uniform sampler2D Weather;
uniform sampler2D Depth;
uniform sampler2D HandDepth;
#if CLOUD_QUALITY > 0
uniform sampler2D Clouds;
uniform sampler2D CloudDistance;
#endif
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS
uniform sampler2D Lighting;
#endif
#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
#include "shaders/water-resolve.glsl"
#endif
void main() {
    vec3 c=toLinear(texture(Scene,texCoord).rgb);
    float depth=texture(Depth,texCoord).r;
    float handDepth=texture(HandDepth,texCoord).r;
    if(handDepth>1e-7) {
        // Hand depth has its own FOV; bob and swing are already in the geometry.
        if(HandProjectionValid.x>0.5 && abs(WorldTimeWeatherDimension.w)<0.5 && CameraPositionHighAndFogType.w<0.5) {
            vec3 position=mat3(InverseView)*viewPosition(texCoord,handDepth,InverseHandProjection);
            vec3 normal=mat3(InverseView)*depthSurfaceNormal(HandDepth,texCoord,InverseHandProjection);
            if(dot(normal,normal)>0.5) {
                c+=sqrt(max(c,vec3(0)))*sulkanHeldLight(position,normal)*0.5;
                float specular=sulkanSunSpecular(normal,normalize(-position),0.55,0.035);
                if(specular>0.0) c+=portLightPalette()*specular*sulkanDirectShadow(position,normal)*smoothstep(0.05,0.65,CloudOffsetAndGameTime.z);
            }
        }
        hdr=vec4(c,1.0); return;
    }
    uvec2 surface=texture(Surface,texCoord).rg;
    bool nativeSurface=surfaceMatches(surface,depth);
    bool sky=depth<=1e-7;
    vec3 ray=sulkanRay(texCoord);
    vec3 viewSurface=sky?vec3(0):viewPosition(texCoord,depth);
    float distanceToScene=sky?60000.0:min(length(viewSurface),60000.0);
    bool overworld=abs(WorldTimeWeatherDimension.w)<0.5;
    bool air=CameraPositionHighAndFogType.w<0.5;
    // Depth-aware upsampling prevents half-resolution lighting/clouds leaking over silhouettes.
    vec2 size=ceil(ViewSizeAndInverse.xy*0.5), q=texCoord*size-0.5, f=fract(q);
    ivec2 origin=ivec2(floor(q));
    vec2 light=vec2(0.0); vec4 cloud=vec4(0.0); float total=0.0;
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS || CLOUD_QUALITY > 0
    for(int y=0;y<2;y++) for(int x=0;x<2;x++) {
        ivec2 pixel=clamp(origin+ivec2(x,y),ivec2(0),ivec2(size)-1);
        vec2 uv=(vec2(pixel)+0.5)/size;
        float d=texture(Depth,uv).r;
        float dist=d<=1e-7?60000.0:length(viewPosition(uv,d));
        float weight=(x==0?1.0-f.x:f.x)*(y==0?1.0-f.y:f.y);
        float separation=abs(dist-distanceToScene)/max(distanceToScene*0.02,0.3);
        weight*=1.0/(1.0+separation*separation);
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS
        light+=texelFetch(Lighting,pixel,0).rg*weight;
#else
        light+=vec2(1,0)*weight;
#endif
#if CLOUD_QUALITY > 0
        vec4 sampleCloud=texelFetch(Clouds,pixel,0);
        if(texture(CloudDistance,uv).r>distanceToScene) sampleCloud=vec4(0.0);
        cloud+=sampleCloud*weight;
#endif
        total+=weight;
    }
#endif
    if(total>1e-5) { light/=total; cloud/=total; } else { light=vec2(1.0,0.0); cloud=vec4(0.0); }
#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
    if(nativeSurface && surfaceReflective(surface) && air) {
        vec3 position=mat3(InverseView)*viewSurface;
        c=toLinear(resolveWaterReflection(texCoord,surface,position,pow(max(c,vec3(0)),vec3(1.0/2.2))));
    }
#endif
    if(!sky && !(nativeSurface && surfaceTransparent(surface))) c*=light.x;
    if(nativeSurface) {
        float boost = surfaceHdrBoost(surface);
        float luma = max(c.r, max(c.g, c.b));
        // 只有像素自身原本就亮的区域（灯芯）才吃满 HDR 倍增，灯具暗部铁框保持原样！
        c *= mix(1.0, boost, smoothstep(0.2, 0.85, luma));
    }
    // Native terrain is already lit. Depth matching rejects metadata behind entities.
    if(!sky && !nativeSurface) {
        // Entities and other non-terrain surfaces: reconstruct the depth normal once
        // for both the sun highlight and the held light.
        vec3 position=mat3(InverseView)*viewSurface;
        vec3 normal=normalize(mat3(InverseView)*depthSurfaceNormal(Depth,texCoord)+vec3(0,1e-8,0));
        if(overworld && air) {
            vec3 toEye=normalize(sulkanCameraOffset()-position);
            float specular=sulkanSunSpecular(normal,toEye,0.55,0.035);
            if(specular>0.0) c+=portLightPalette()*specular*sulkanDirectShadow(position,normal)*smoothstep(0.05,0.65,CloudOffsetAndGameTime.z);
        }
        c+=sqrt(max(c,vec3(0)))*sulkanHeldLight(position,normal)*0.5;
    }
    if(overworld && air) {
        vec3 skyColor=sulkanSky(ray);
        if(sky) c=skyColor+sulkanCelestials(ray);
        else {
            float distance=min(distanceToScene,1500.0);
            float skyAccess=smoothstep(0.05,0.65,CloudOffsetAndGameTime.z);
            if(nativeSurface) skyAccess=min(skyAccess,smoothstep(0.01,0.5,surfaceSky(surface)));
            float fog=sulkanGroundMist(ray,distance)*skyAccess;
            // Color the existing aerial perspective rather than adding another fog layer.
            float towardSun=max(dot(ray,SunDirectionAndRainBrightness.xyz),0.0);
            float horizon=1.0-smoothstep(0.0,0.5,abs(ray.y));
            vec3 distanceTint=mix(vec3(0.88,0.97,1.10),vec3(1.12,1.01,0.88),
                towardSun*towardSun*horizon);
            float distanceGrade=DISTANCE_COLOR*sulkanDay()*(1.0-WorldTimeWeatherDimension.y);
            // 加入强烈的阳光前向米氏散射（Mie Scattering），让空气充满温暖的丁达尔体积光感！
            float mie = pow(towardSun, 5.0) * (1.0 - WorldTimeWeatherDimension.y) * sulkanDay();
            vec3 mistColor = sulkanSky(normalize(vec3(ray.x, 0.25, ray.z))) * 0.70 + portLightPalette() * mie * 0.35;
            c=mix(c,mistColor*mix(vec3(1.0),distanceTint,distanceGrade*0.5),fog);
        }
        c=c*(1.0-cloud.a)+cloud.rgb;
        c+=portLightPalette()*light.y*SUN_SHAFTS*0.8;
    }
    // Weather is depth-tested against the world in its own transparent layer.
    // Unpremultiply before converting its display-space color to linear light.
    vec4 weather=texture(Weather,texCoord);
    float weatherAlpha=clamp(weather.a,0.0,1.0);
    vec3 weatherColor=toLinear(weather.rgb/max(weatherAlpha,1e-5));
    c=c*(1.0-weatherAlpha)+weatherColor*weatherAlpha;
    hdr=vec4(max(c,vec3(0.0)),1.0);
}

`

## shaders/bloom-seed.fsh

`glsl
#version 450
#include "shaders/common.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
void main() {
    vec2 px = 0.5 / vec2(textureSize(Source,0));
    vec3 c = (texture(Source,texCoord+px).rgb + texture(Source,texCoord-px).rgb + texture(Source,texCoord+vec2(px.x,-px.y)).rgb + texture(Source,texCoord+vec2(-px.x,px.y)).rgb)*0.25;
    float brightness = max(c.r, max(c.g, c.b));
    // 1. 提高起跳阈值，让普通白天景物（<0.70）绝对不泛白光
    float contribution = smoothstep(0.70, 1.60, brightness);
    vec3 bloomColor = c * contribution;
    // 2. 核心防核爆机制：Karis / Reinhard 软封顶，把输入给模糊器的最大能量温和限制在 2.5 以内
    float bloomLuma = max(bloomColor.r, max(bloomColor.g, bloomColor.b));
    bloomColor *= 1.0 / (1.0 + bloomLuma * 0.4);
    color = vec4(bloomColor, 1.0);
}

`

## shaders/blur-y.fsh

`glsl
#version 450
#include "shaders/common.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
void main() {
    vec2 d = 1.25 / vec2(textureSize(Source, 0));
    vec3 c = texture(Source, texCoord).rgb * 0.20;
    c += texture(Source, texCoord + vec2( d.x,  d.y)).rgb * 0.20;
    c += texture(Source, texCoord + vec2(-d.x,  d.y)).rgb * 0.20;
    c += texture(Source, texCoord + vec2( d.x, -d.y)).rgb * 0.20;
    c += texture(Source, texCoord + vec2(-d.x, -d.y)).rgb * 0.20;
    color = vec4(c, 1.0);
}

`

## shaders/final.fsh

`glsl
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

`

## shaders/core/sodium_terrain_shadow.fsh

`glsl
#version 460 core

#define SULKAN_GLOBALS_BINDING 2
#moj_import <sulkan:sodium_globals.glsl>
#moj_import <sulkan:terrain_material.glsl>

layout(binding = 0) uniform sampler2D u_LightTex;
layout(binding = 1) uniform sampler2D u_BlockTex;
layout(binding = 3) uniform isamplerBuffer u_SectionTimeInfo;
layout(location = 0) in vec2 v_TexCoord;
layout(location = 1) flat in uint v_Material;
layout(location = 2) in float v_Alpha;
layout(location = 0) out vec4 fragColor;

void main() {
#ifdef ALPHA_CUTOUT
	// Fast single-tap alpha lookup for shadow pass cutout test
	float alpha = textureLod(u_BlockTex, v_TexCoord, 0.0).a * v_Alpha;
	if (alpha < sulkanMaterialAlphaCutoff(v_Material)) discard;
#endif
	fragColor = vec4(0.0, 0.0, 0.0, 1.0);
}

`

## shaders/include/native_shadows.glsl

`glsl
// Native shadow ABI v1. Position and normal are camera-relative world axes.
#ifndef SULKAN_NATIVE_SHADOWS
#define SULKAN_NATIVE_SHADOWS
#ifndef SHADOW_QUALITY
#define SHADOW_QUALITY 2
#endif
#if SHADOW_QUALITY > 0
#define SULKAN_SHADOW_FILTER_TIER SHADOW_QUALITY
uniform sampler2D SulkanShadowMap0;
uniform sampler2D SulkanShadowMap1;
uniform sampler2D SulkanShadowMap2;
uniform sampler2D SulkanShadowMap3;
// Legacy slots: map 0 aliases the composited cascade 0, map 1 is unused.
uniform sampler2D SulkanEntityShadowMap0;
uniform sampler2D SulkanEntityShadowMap1;
layout(std140) uniform SulkanShadowData {
    mat4 ShadowViewProjection[4];
    vec4 CascadeParams[4];
    vec4 LightDirection;
    vec4 ShadowParams;
};
#include "shaders/include/directional_shadow.glsl"
float sulkanTerrainShadow(vec3 position, vec3 normal) {
    return mix(1.0, sulkanDirectionalVisibility(position, normal), ShadowParams.x);
}
// Direct light must reach zero behind an occluder; ambient belongs elsewhere.
float sulkanDirectShadow(vec3 position, vec3 normal) {
    return sulkanCastShadowVisibility(position,normal);
}
float sulkanGrassShadow(vec3 position, vec3 normal) {
    // Apply the grass allowance independently in each cascade. Keep the original
    // receiver position for cascade selection and entity shadows.
    float visibility=sulkanCastShadowVisibility(position,normal,true);
    // Terrain lighting already applies N.L. Do not shade the same face a second
    // time as its wind-deformed normal crosses the light's grazing threshold.
    return mix(1.0,mix(ShadowParams.z,1.0,visibility),ShadowParams.x);
}
// Both terrain lighting terms from one cast lookup. Returns sulkanTerrainShadow
// (or sulkanGrassShadow for grass) and writes the sulkanDirectShadow term to
// direct, so receivers never run the cascade filter twice per fragment.
float sulkanTerrainShadows(vec3 position, vec3 normal, bool grass, out float direct) {
    direct=sulkanCastShadowVisibility(position,normal,grass);
    if(grass) return mix(1.0,mix(ShadowParams.z,1.0,direct),ShadowParams.x);
    float normalLight=dot(normal,LightDirection.xyz);
    float visibility=ShadowParams.z;
    if(normalLight>0.0) {
        float faceVisibility=mix(ShadowParams.z,1.0,smoothstep(0.0,0.08,normalLight));
        visibility=min(faceVisibility,mix(ShadowParams.z,1.0,direct));
    }
    return mix(1.0,visibility,ShadowParams.x);
}
// Air samples have no receiver surface or normal bias. One bilinear comparison
// is sufficient inside the low-resolution volume integration; cascade 0 already
// contains entity casters.
float sulkanVolumeShadow(vec3 position) {
    int cascade=sulkanSelectCascade(length(position));
    int last=sulkanLastCascade();
    if(length(position)>=CascadeParams[last].z) return 1.0;
    vec3 coord=sulkanShadowCoord(cascade,position);
    if(any(lessThan(coord,vec3(0))) || any(greaterThan(coord,vec3(1)))) return 1.0;
    float visible=sulkanShadowBilinearVisibility(cascade,coord.xy,coord.xy,coord.z,vec2(0));
    float coverage=1.0-smoothstep(mix(CascadeParams[last].y,CascadeParams[last].z,0.88),CascadeParams[last].z,length(position));
    return mix(1.0,visible,coverage);
}

#else
float sulkanTerrainShadow(vec3 position, vec3 normal) { return 1.0; }
float sulkanDirectShadow(vec3 position, vec3 normal) { return 1.0; }
float sulkanGrassShadow(vec3 position, vec3 normal) { return 1.0; }
float sulkanVolumeShadow(vec3 position) { return 1.0; }
float sulkanTerrainShadows(vec3 position, vec3 normal, bool grass, out float direct) { direct=1.0; return 1.0; }
#endif
#endif

`

## shaders/include/directional_shadow.glsl

`glsl
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

// The 2x2 footprint whose lower-left texel is base, in textureGather order.
// Hardware gather picks its footprint with limited sub-texel precision, which
// can disagree with floor() and compare each depth against a neighbour's plane.
vec4 sulkanShadowGather(int cascade, ivec2 base) {
	return vec4(
		sulkanShadowTexelDepth(cascade, base + ivec2(0, 1)),
		sulkanShadowTexelDepth(cascade, base + ivec2(1, 1)),
		sulkanShadowTexelDepth(cascade, base + ivec2(1, 0)),
		sulkanShadowTexelDepth(cascade, base));
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
	vec2 base = floor(footprint);
	vec2 blend = footprint - base;
	vec4 depths = sulkanShadowGather(cascade, clamp(ivec2(base), ivec2(0), ivec2(size) - 2));
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
	float radius = SULKAN_SHADOW_FILTER_TIER < 4 ? 0.55 : 0.85;
	vec2 offset = texel * radius;
	float corners = sulkanShadowBilinearVisibility(cascade, uv + vec2(-offset.x, -offset.y), uv, compareDepth, depthGradient);
	corners += sulkanShadowBilinearVisibility(cascade, uv + vec2( offset.x, -offset.y), uv, compareDepth, depthGradient);
	corners += sulkanShadowBilinearVisibility(cascade, uv + vec2(-offset.x,  offset.y), uv, compareDepth, depthGradient);
	corners += sulkanShadowBilinearVisibility(cascade, uv + vec2( offset.x,  offset.y), uv, compareDepth, depthGradient);
	corners *= 0.25;
#if SULKAN_SHADOW_FILTER_TIER < 4
	return corners;
#else

	float center = sulkanShadowBilinearVisibility(cascade, uv, uv, compareDepth, depthGradient);
	return mix(center, corners, 0.65);
#endif
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
	vec2 depthGradient = sulkanReceiverDepthGradient(cascade, normal) * 0.5;
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
		float fadeStart = mix(CascadeParams[last].y, CascadeParams[last].z, 0.88);
		float coverage = 1.0 - smoothstep(fadeStart, CascadeParams[last].z, cameraDistance);
		return mix(1.0, currentVisibility, coverage);
	}

	float blendStart = mix(CascadeParams[current].y, CascadeParams[current].z, 0.90);
	float blend = smoothstep(blendStart, CascadeParams[current].z, cameraDistance);
	if (blend <= 0.0) return currentVisibility;
	float nextVisibility = sulkanCascadeSample(current + 1, position, normal, grassReceiver);
	return nextVisibility < 0.0 ? currentVisibility : mix(currentVisibility, nextVisibility, blend);
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

`

## shaders/include/terrain_material.glsl

`glsl
// Sodium's packed material ABI, shared by visible terrain and shadow casters.
float sulkanMaterialAlphaCutoff(uint material) {
    const float cutoff[4] = float[4](0.0, 0.1, 0.5, 1.0);
    return cutoff[(material >> 1u) & 3u];
}

vec4 sulkanSampleTerrainMaterial(sampler2D atlas, vec2 uv, uint material) {
    vec2 dx = dFdx(uv), dy = dFdy(uv);
    return (material & 1u) != 0u ? textureGrad(atlas, uv, dx, dy) : textureLod(atlas, uv, 0.0);
}

`

