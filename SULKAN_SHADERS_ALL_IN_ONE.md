# SULKAN SHADERS ALL IN ONE
> 本文档为 Sulkan RTX Remix 光影包的**全量源码合辑快照**，包含所有渲染管线配置（sulkan.json）、顶点着色器（.vsh）、片段着色器（.fsh）与公用模块（.glsl）。

## 目录 (Table of Contents)
- [sulkan.json](#sulkanjson)
- [shaders/terrain.vsh](#shadersterrainvsh)
- [shaders/terrain.fsh](#shadersterrainfsh)
- [shaders/lighting.fsh](#shaderslightingfsh)
- [shaders/water-reflections.fsh](#shaderswaterreflectionsfsh)
- [shaders/atmosphere.fsh](#shadersatmospherefsh)
- [shaders/clouds.fsh](#shaderscloudsfsh)
- [shaders/bloom-seed.fsh](#shadersbloomseedfsh)
- [shaders/bloom-wide.fsh](#shadersbloomwidefsh)
- [shaders/blur-x.fsh](#shadersblurxfsh)
- [shaders/blur-y.fsh](#shadersbluryfsh)
- [shaders/exposure-meter.fsh](#shadersexposuremeterfsh)
- [shaders/exposure-adapt.fsh](#shadersexposureadaptfsh)
- [shaders/final.fsh](#shadersfinalfsh)
- [shaders/core/sodium_terrain_shadow.vsh](#shaderscoresodium_terrain_shadowvsh)
- [shaders/core/sodium_terrain_shadow.fsh](#shaderscoresodium_terrain_shadowfsh)
- [shaders/core/entity_shadow_depth.vsh](#shaderscoreentity_shadow_depthvsh)
- [shaders/core/entity_shadow_depth.fsh](#shaderscoreentity_shadow_depthfsh)
- [shaders/include/native_shadows.glsl](#shadersincludenative_shadowsglsl)
- [shaders/include/directional_shadow.glsl](#shadersincludedirectional_shadowglsl)
- [shaders/include/terrain_material.glsl](#shadersincludeterrain_materialglsl)
- [shaders/include/terrain_atlas_sampling.glsl](#shadersincludeterrain_atlas_samplingglsl)
- [shaders/include/vegetation_wind.glsl](#shadersincludevegetation_windglsl)
- [shaders/include/sodium_globals.glsl](#shadersincludesodium_globalsglsl)
- [shaders/common.glsl](#shaderscommonglsl)
- [shaders/terrain-globals.glsl](#shadersterrainglobalsglsl)
- [shaders/environment.glsl](#shadersenvironmentglsl)
- [shaders/palette.glsl](#shaderspaletteglsl)
- [shaders/specular.glsl](#shadersspecularglsl)
- [shaders/held-light.glsl](#shadersheldlightglsl)
- [shaders/ice.glsl](#shadersiceglsl)
- [shaders/surface-data.glsl](#shaderssurfacedataglsl)
- [shaders/surface-normal.glsl](#shaderssurfacenormalglsl)
- [shaders/tonemap.glsl](#shaderstonemapglsl)
- [shaders/water-resolve.glsl](#shaderswaterresolveglsl)
- [shaders/reflections.glsl](#shadersreflectionsglsl)
- [shaders/cloud-field.glsl](#shaderscloudfieldglsl)
- [shaders/cloud-volume.glsl](#shaderscloudvolumeglsl)
- [shaders/ground-mist.glsl](#shadersgroundmistglsl)

---

## sulkan.json

```json
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
      "writes": [
        "surface.data"
      ]
    },
    {
      "pipeline": "sodium:pipeline/cutout_terrain",
      "vertex": "shaders/terrain.vsh",
      "fragment": "shaders/terrain.fsh",
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
      "default": 96,
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
```

## shaders/terrain.vsh

```glsl
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
    // 仅对距离玩家 32 格（dot < 1024.0）以内的植物计算风吹顶点偏移，省去森林里 90% 树叶的三角函数运算！
    if (dot(relativePosition, relativePosition) < 1024.0) {
        relativePosition += sulkanWindOffset(relativePosition, a_SulkanMaterial);
    }
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
```

## shaders/terrain.fsh

```glsl
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
#ifdef SULKAN_TRANSLUCENT
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
#endif
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
    // 1. 严格遵守 Vulkan SPIR-V 规范：所有偏导数必须在任何 discard 和分支之前完成！
    vec3 crossNormal = cross(dFdx(relativePosition), dFdy(relativePosition));
    vec2 uvDx = dFdx(uv), uvDy = dFdy(uv);

    // 2. 极速 Alpha Cutout 剔除：使用 textureLod 0 避免各向异性过滤阻塞，透明像素立即退出！
#ifdef ALPHA_CUTOUT
    vec4 rawTex = textureLod(u_BlockTex, uv, 0.0);
    if (rawTex.a * tint.a < sulkanMaterialAlphaCutoff(terrainMaterial)) discard;
    vec4 base = rawTex * tint;
#else
    vec4 base = ((terrainMaterial & 1u) != 0u ? textureGrad(u_BlockTex, uv, uvDx, uvDy) : textureLod(u_BlockTex, uv, 0.0)) * tint;
#endif

#ifdef SULKAN_TRANSLUCENT
    if (base.a <= 1.0/255.0) discard;
#endif

    vec3 eyeDirection = normalize(sulkanCameraOffset() - relativePosition);
    vec3 geomNormal = crossNormal * inversesqrt(max(dot(crossNormal, crossNormal), 1e-12));
    if (dot(geomNormal, eyeDirection) < 0.0) geomNormal = -geomNormal;
    vec3 normal = geomNormal;

    bool ice = (materialId >= 12u && materialId <= 14u);
    float iceRoughness = 0.0;
    if (ice) normal = sulkanIceDetail(relativePosition, normal, iceRoughness);

    vec3 albedo = toLinear(base.rgb);
    if (materialId == 12u) albedo = vec3(0.72, 0.86, 0.92);

    float distSq = dot(relativePosition, relativePosition);
    float worldDistance = sqrt(distSq);
    float overworld = 1.0 - step(0.5, abs(WorldTimeWeatherDimension.w));
    float daylight = sulkanDay();
    vec3 sunDirection = daylight > 0.5 ? SunDirectionAndRainBrightness.xyz : MoonDirectionAndPhase.xyz;
    float skyLight = lightLevel.y * lightLevel.y;

    // 轴向立体感 + 贴图微遮蔽（让建筑和地形有立体质感）
    float texLuma = dot(albedo, vec3(0.299, 0.587, 0.114));
    float microOccl = clamp(0.82 + (texLuma - 0.35) * 0.45, 0.72, 1.15);
    float axisShade = 1.0 - 0.12 * abs(geomNormal.x) - 0.06 * abs(geomNormal.z) - 0.18 * max(-geomNormal.y, 0.0);

    vec3 zenithSky = mix(vec3(0.012, 0.020, 0.045), vec3(0.28, 0.46, 0.78), daylight);
    vec3 groundBounce = portLightPalette() * vec3(0.42, 0.35, 0.24) * (0.4 + 0.6 * daylight);
    float hemiWeight = normal.y * 0.5 + 0.5;
    vec3 skyFill = mix(groundBounce * 0.45, zenithSky, hemiWeight) * axisShade;
    skyFill = mix(skyFill, vec3(dot(skyFill, vec3(0.299, 0.587, 0.114))), WorldTimeWeatherDimension.y * 0.65);

    float shadow = 1.0;
    float sunVisibility = 0.0;
    vec3 lighting;

#ifdef ALPHA_CUTOUT
    // ================= [极速 Cutout 专用通道：树叶、草、藤蔓] =================
    // 彻底剥离冰面、水面、金属高光与多级联循环，将 Cutout 的 VGPR 寄存器占用压到最低！
    float sunDot = dot(normal, sunDirection);
    float sunFacing = max(abs(sunDot), 0.35); // 植物双面受光

#if SHADOW_QUALITY > 0
    // 仅对近处 20 格内 (distSq < 400.0) 且暴露在树冠表层 (lightLevel.y > 0.78) 的树叶做 1 次极速单点阴影查询！
    if (distSq < 400.0 && lightLevel.y > 0.78) {
        vec4 clip = ShadowViewProjection[0] * vec4(relativePosition + geomNormal * 0.08 + LightDirection.xyz * 0.15, 1.0);
        vec3 coord = vec3(clip.xy * 0.5 + 0.5, clip.z);
        if (all(greaterThan(coord, vec3(0.01))) && all(lessThan(coord, vec3(0.99)))) {
            sunVisibility = step(coord.z - 0.003, textureLod(SulkanShadowMap0, coord.xy, 0.0).r);
        } else {
            sunVisibility = 1.0;
        }
    } else {
        // 远处或树冠内部的树叶直接利用原版光照等级合成极自然的树冠体积阴影（0 纹理采样！）
        float canopy = clamp((lightLevel.y - 0.60) * 2.5, 0.0, 1.0);
        sunVisibility = canopy * canopy;
    }
    shadow = mix(1.0, mix(ShadowParams.z, 1.0, sunVisibility), ShadowParams.x);
#else
    sunVisibility = 1.0;
#endif

    vec3 direct = portLightPalette() * sunFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
    // 极简树叶透光感 (SSS)
    float sss = max(dot(-eyeDirection, sunDirection), 0.0) * sunVisibility * daylight * (1.0 - WorldTimeWeatherDimension.y);
    vec3 leafGlow = albedo * portLightPalette() * (sss * sss * 0.45);
    lighting = vec3(0.022) + skyLight * (skyFill * 0.48 + direct * 0.92 + leafGlow);

#else
    // ================= [固体与半透明地形通道：石头、木板、金属、冰、水] =================
    float sunDot = dot(normal, sunDirection);
    float sunFacing = max(sunDot, 0.0);

#if SHADOW_QUALITY > 0
    shadow = mix(1.0, ShadowParams.z, ShadowParams.x);
    if (sunFacing > 0.0 && lightLevel.y > 1.0/30.0 + 1e-4) {
        shadow = sulkanTerrainShadows(relativePosition, geomNormal, false, sunVisibility);
    }
#else
    sunVisibility = 1.0;
#endif

    float directFacing = smoothstep(-0.05, 0.95, sunDot) * sunFacing;
    vec3 direct = portLightPalette() * directFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
    vec3 giFill = groundBounce * (1.0 - hemiWeight * 0.6) * smoothstep(0.1, 0.9, lightLevel.y) * 0.28;
    lighting = vec3(0.020) + skyLight * (skyFill * 0.45 + giFill + direct * 1.05);

    // 晴天阴影冷色调加深（提升通透感）
    float shadowContrast = (1.0 - shadow) * daylight * (1.0 - WorldTimeWeatherDimension.y);
    lighting *= mix(vec3(1.0), vec3(0.70, 0.78, 0.92), shadowContrast * skyLight * 0.55);
#endif

    // 火把与方块光源（公共轻量计算）
    float bl = lightLevel.x;
    float blockLight = bl * bl * bl * (bl * 1.8 + 0.2);
    vec3 torchPalette = mix(vec3(1.6, 0.45, 0.12), vec3(1.8, 1.15, 0.65), bl * bl);
    vec3 warmBlock = mix(vec3(1.0), torchPalette, clamp(LIGHT_WARMTH, 0.0, 1.5));
    lighting += warmBlock * blockLight * microOccl * 1.65;

    vec3 vanillaLight = texture(u_LightTex, lightLevel * (15.0/16.0)).rgb;
    vec3 heldLight = sulkanHeldLight(relativePosition, normal);
    vec3 surface = albedo * (mix(toLinear(vanillaLight), max(lighting, vec3(0.0)), overworld) + heldLight);

    float nearSource = smoothstep(0.65, 1.0, lightLevel.x);
    surface += torchPalette * (nearSource * nearSource * 0.06 * clamp(LIGHT_WARMTH, 0.0, 1.5));

    vec3 storedNormal = geomNormal;
    bool enhancedWater = false;
    float hdrBoost = 0.0;

#ifndef ALPHA_CUTOUT
    // 固体材质高光、雨水与自发光（不在树叶/草上编译，节省大量寄存器！）
    storedNormal = ice ? normal : geomNormal;
    float wet = 0.0;
    if (materialId != 1u && overworld > 0.5 && CameraPositionHighAndFogType.w < 0.5) {
        wet = WET_SURFACES * WorldTimeWeatherDimension.y * smoothstep(0.88, 1.0, lightLevel.y) * smoothstep(0.0, 0.7, normal.y);
        if (materialId >= 9u) wet = 0.0;
        surface *= 1.0 - 0.22 * wet;
        float materialWeight = (materialId >= 6u && materialId <= 8u) ? MATERIAL_SHEEN : 0.0;
        float microRough = clamp(1.0 - (texLuma - 0.35) * 0.65, 0.75, 1.25);
        float roughness = mix(0.68, materialId == 6u ? 0.22 : (materialId == 8u ? 0.62 : 0.42), materialWeight) * microRough;
        float distAa = smoothstep(12.0, 64.0, worldDistance) * 0.25;
        roughness = clamp(roughness + distAa, 0.15, 0.95);
        float reflectance = mix(0.035, 0.18, materialId == 6u ? materialWeight : 0.0);
        if (ice) { roughness = mix(0.24, 0.46, iceRoughness); reflectance = 0.025; }
        
        if (sunVisibility > 0.01) {
            float highlight = sulkanSunSpecular(normal, eyeDirection, mix(roughness, 0.22, wet), reflectance);
            surface += portLightPalette() * highlight * sunVisibility * skyLight;
        }
        float envReflect = max(wet, (materialId == 6u ? 0.15 : 0.0) * materialWeight);
        if (envReflect > 0.001) {
            float t = 1.0 - max(dot(normal, eyeDirection), 0.0);
            float t2 = t * t;
            float fresnel = 0.02 + 0.18 * (t2 * t2 * t);
            surface += sulkanSky(reflect(-eyeDirection, normal)) * envReflect * fresnel * skyLight;
        }
    }

    float emission = 0.0;
    if (materialId == 9u) emission = smoothstep(0.15, 0.60, max(albedo.r, max(albedo.g, albedo.b)));
    if (materialId == 10u) emission = smoothstep(0.12, 0.5, albedo.r) * 0.8;
    if (materialId == 11u) emission = smoothstep(0.08, 0.4, albedo.r - max(albedo.g, albedo.b)) * 0.9;
    if (emission > 0.0) {
        vec3 emissiveColor = albedo * sqrt(max(albedo, vec3(0.01)));
        surface = mix(surface, emissiveColor * 0.95, clamp(emission * EMISSIVE_ACCENTS, 0.0, 0.95));
    }
    if (materialId == 9u && emission > 0.05) hdrBoost = 3.0;
    else if (materialId == 6u && (sunVisibility > 0.4 || wet > 0.3)) hdrBoost = 2.0;
    else if (materialId == 10u || materialId == 11u) hdrBoost = 1.0;
#endif

    base.rgb = pow(max(surface, vec3(0.0)), vec3(1.0/2.2));

#ifdef SULKAN_TRANSLUCENT
#if WATER_ENABLED == 1
    if (materialId == 1u && CameraPositionHighAndFogType.w < 0.5) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 worldXZ = relativePosition.xz + mod(CameraPositionHighAndFogType.xz, vec2(4096.0)) + CameraPositionLowAndFarPlane.xz;
        float t = TimeDeltaFrame.x * 0.25;
        vec2 wave = vec2(cos(dot(worldXZ, vec2(2.2, 1.24)) + t * 1.2), sin(dot(worldXZ, vec2(-1.12, 2.48)) - t * 0.9));
        vec2 refractedUv = clamp(screenUv + wave * WATER_WAVES * 0.0008 / (1.0 + worldDistance * 0.025), ViewSizeAndInverse.zw, vec2(1.0) - ViewSizeAndInverse.zw);
        float surfaceDistance = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        if (backDistance < surfaceDistance) refractedUv = screenUv;
        backDistance = length(viewPosition(refractedUv, texture(OpaqueDepth, refractedUv).r));
        float thickness = clamp(backDistance - surfaceDistance, 0.0, 160.0);
        vec3 waterNormal = normalize(normal + vec3(wave.x, 0.0, wave.y) * (0.018 * WATER_WAVES));
        vec3 waterTint = mix(vec3(0.035, 0.21, 0.28), tint.rgb * vec3(0.2, 0.65, 0.75), 0.25);
        vec4 background = linearSample(Opaque, refractedUv);
        if (background.a > 0.0) {
            vec3 absorption = exp(-thickness * WATER_DENSITY * vec3(0.16, 0.065, 0.035));
            vec3 waterLighting = mix(toLinear(vanillaLight), max(lighting, vec3(0.0)), overworld) + heldLight;
            vec3 scattering = toLinear(waterTint) * waterLighting;
            vec3 transmission = toLinear(background.rgb) * absorption + scattering * (1.0 - absorption);
            storedNormal = waterNormal;
            enhancedWater = true;
            vec3 waterColor = transmission;
            waterColor += portLightPalette() * sulkanSunSpecular(waterNormal, eyeDirection, 0.16, 0.02) * sunVisibility * skyLight * overworld;
            base = vec4(pow(max(waterColor, vec3(0.0)), vec3(1.0/2.2)), 1.0);
        }
    }
#endif
    if (materialId == 12u) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 distortion = (mat3(View) * normal).xy * 0.0007 / (1.0 + worldDistance * 0.025);
        vec2 refractedUv = clamp(screenUv + distortion, ViewSizeAndInverse.zw, vec2(1.0) - ViewSizeAndInverse.zw);
        float front = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDepth = texture(OpaqueDepth, refractedUv).r;
        if (backDepth > 1e-7 && length(viewPosition(refractedUv, backDepth)) < front) refractedUv = screenUv;
        backDepth = texture(OpaqueDepth, refractedUv).r;
        float thickness = backDepth > 1e-7 ? clamp(length(viewPosition(refractedUv, backDepth)) - front, 0.0, 12.0) : 1.0;
        vec4 background = linearSample(Opaque, refractedUv);
        vec3 transmission = background.a > 0.0 ? toLinear(background.rgb) : sulkanSky(normalize(relativePosition));
        vec3 absorption = exp(-thickness * vec3(0.04, 0.016, 0.008));
        vec3 iceColor = transmission * absorption + albedo * (vec3(1.0) - absorption) * 0.25;
        float haze = mix(0.025, 0.085, smoothstep(0.2, 0.85, iceRoughness));
        haze = clamp(haze + 0.015 * (1.0 - exp(-thickness * 0.3)), 0.0, 0.10);
        iceColor = mix(iceColor, albedo * (lighting + heldLight) * 0.65, haze);
        iceColor += portLightPalette() * sulkanSunSpecular(normal, eyeDirection, mix(0.24, 0.46, iceRoughness), 0.025) * sunVisibility * skyLight * overworld;
        base = vec4(pow(max(iceColor, vec3(0.0)), vec3(1.0/2.2)), 1.0);
    }
#endif

    float sphericalFog = clamp((worldDistance - u_EnvironmentFog.x) / max(u_EnvironmentFog.y - u_EnvironmentFog.x, 0.001), 0.0, 1.0);
    if (overworld > 0.5 && CameraPositionHighAndFogType.w < 0.5) sphericalFog = 0.0;
    float cylinder = max(length(relativePosition.xz), abs(relativePosition.y));
    float renderFog = clamp((cylinder - u_RenderFog.x) / max(u_RenderFog.y - u_RenderFog.x, 0.001), 0.0, 1.0);
    float fog = max(1.0 - fade, max(materialId == 1u && CameraPositionHighAndFogType.w < 0.5 ? 0.0 : sphericalFog, renderFog)) * u_FogColor.a;
    vec3 fogColor = u_FogColor.rgb;
    if (overworld > 0.5 && CameraPositionHighAndFogType.w < 0.5) {
        float skyAccess = min(smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z), smoothstep(0.01, 0.5, skyLight));
        fogColor = mix(fogColor, pow(sulkanSky(normalize(relativePosition)), vec3(1.0/2.2)), skyAccess);
    }
    vec3 finalOut = mix(base.rgb, fogColor, fog);
    float outDither = (fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5) * 1.5;
    color = vec4(clamp(finalOut + outDither / 255.0, 0.0, 1.0), base.a);
    surfaceData = uvec2(encodeSurface(storedNormal, skyLight, 1.0 - fog, enhancedWater, hdrBoost), floatBitsToUint(gl_FragCoord.z));
#ifndef ALPHA_CUTOUT
    if (ice) surfaceData.x |= 0x20000000u;
#endif
#ifdef SULKAN_TRANSLUCENT
    if (!enhancedWater) surfaceData.x |= 0xc0000000u;
#endif
}
```

## shaders/lighting.fsh

```glsl
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
        float dither = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715))));
        for(int i=0;i<8;i++) {
            float distance=(float(i)+dither)*stepLength;
            vec3 relative=sulkanCameraOffset()+ray*distance;
            vec3 world=origin+relative;
            float visibility=sulkanVolumeShadow(relative);
#if CLOUD_QUALITY > 0
            float entry=max((cloudBottom()-world.y)/max(sun.y, 1e-4),0.0);
            float exitDistance=max((cloudBottom()+4.0-world.y)/max(sun.y, 1e-4),0.0);
            float span=max(exitDistance-entry,0.0);
            float cloudDepth=cloudDensity(world+sun*(entry+span*0.5))*span;
            visibility*=exp(-cloudDepth);
#endif
            float airDensity=exp(clamp((72.0-world.y)*0.018,-8.0,3.0));
            shafts+=visibility*airDensity*exp(-distance*0.012)*stepLength*0.006;
        }
        float fDot = max(dot(ray, sun), 0.0);
        float f2 = fDot * fDot; float f4 = f2 * f2; float f8 = f4 * f4;
        float forward = 0.08 + 0.92 * f8;
        shafts*=smoothstep(0.05,0.65,CloudOffsetAndGameTime.z)*forward*(1.0-WorldTimeWeatherDimension.y)*smoothstep(0.02,0.15,sun.y);
    }
#endif
    lighting=vec4(clamp(1.0-ao*0.30*AMBIENT_OCCLUSION,0.30,1.0),shafts,0.0,1.0);
}
```

## shaders/water-reflections.fsh

```glsl
#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/surface-data.glsl"
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
uniform sampler2D Depth;
uniform sampler2D HandDepth;
uniform sampler2D Scene;
uniform usampler2D Surface;
#include "shaders/reflections.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 reflection;

void main() {
    reflection=vec4(0);
#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
    if(CameraPositionHighAndFogType.w>0.5) return;
    ivec2 depthSize=textureSize(Depth,0);
    // 半分辨率目标（scale: 0.5）：每个片元对应全分辨率 2x2 块，直接映射全分辨率几何与深度
    ivec2 selected=ivec2(gl_FragCoord.xy)*2;
    if(selected.x>=depthSize.x || selected.y>=depthSize.y) return;

    float nearest=texelFetch(Depth,selected,0).r;
    uvec2 data=texelFetch(Surface,selected,0).rg;
    // 关键 Early-Out：表面不可反光、不匹配或处于手部深度时立即退出，0 射线步进开销！
    if(!surfaceReflective(data) || !surfaceMatches(data,nearest)
        || texelFetch(HandDepth,selected,0).r>1e-7) return;

    vec2 uv=(vec2(selected)+0.5)/vec2(depthSize);
    vec3 position=mat3(InverseView)*viewPosition(uv,nearest);
    vec3 normal=surfaceNormal(data.x);
    vec3 toEye=normalize(sulkanCameraOffset()-position);
    vec3 ray=reflect(-toEye,normal);
    vec3 local=texelFetch(Scene,selected,0).rgb;
    // 掠射角极小（垂直视线）时仅保留微弱环境背景，跳过繁重的 SSR 步进
    float weight=surfaceFresnel(data,normal,toEye)*WATER_REFLECTION_STRENGTH*surfaceVisibility(data);
    if(weight<0.035) {
        reflection=vec4(sulkanReflectionBackground(position,ray,surfaceSky(data),local,false),1.0);
        return;
    }
    reflection=vec4(sulkanWaterReflection(position,normal,ray,surfaceSky(data),local),1.0);
#endif
}
```

## shaders/atmosphere.fsh

```glsl
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
    float projZ2 = InverseProjection[2][3];
    float projZ3 = InverseProjection[3][3];
    float centerDenom = depth * projZ2 + projZ3;
    float centerLinZ = depth <= 1e-7 ? 60000.0 : abs(1.0 / (abs(centerDenom) < 1e-6 ? 1e-6 : centerDenom));
    for(int y=0;y<2;y++) for(int x=0;x<2;x++) {
        ivec2 pixel=clamp(origin+ivec2(x,y),ivec2(0),ivec2(size)-1);
        vec2 uv=(vec2(pixel)+0.5)/size;
        float d=texture(Depth,uv).r;
        float sampleDenom = d * projZ2 + projZ3;
        float sampleLinZ = d <= 1e-7 ? 60000.0 : abs(1.0 / (abs(sampleDenom) < 1e-6 ? 1e-6 : sampleDenom));
        float weight=(x==0?1.0-f.x:f.x)*(y==0?1.0-f.y:f.y);
        float separation=abs(sampleLinZ-centerLinZ)/max(centerLinZ*0.02,0.3);
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
            float ts2 = towardSun * towardSun;
            float mie = (ts2 * ts2 * towardSun) * (1.0 - WorldTimeWeatherDimension.y) * sulkanDay();
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
```

## shaders/clouds.fsh

```glsl
#version 450
#include "shaders/common.glsl"
#include "shaders/palette.glsl"
#include "shaders/environment.glsl"
#include "shaders/cloud-volume.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 clouds;
layout(location=1) out vec4 cloudDistance;
uniform sampler2D Depth;
void main() {
    clouds=vec4(0.0); cloudDistance=vec4(60000.0);
    if(abs(WorldTimeWeatherDimension.w)>0.5 || CameraPositionHighAndFogType.w>0.5) return;
    float depth=texture(Depth,texCoord).r;
    float maximum=depth>1e-7?length(viewPosition(texCoord,depth)):60000.0;
    float firstDistance;
    // Step counts strictly capped at <= 12 steps for high-efficiency real-time performance
    int steps = CLOUD_QUALITY==1 ? 6 : (CLOUD_QUALITY==2 ? 8 : (CLOUD_QUALITY==3 ? 10 : 12));
    clouds=sulkanCloudVolume(sulkanCloudOrigin()+sulkanCameraOffset(),sulkanRay(texCoord),maximum,steps,firstDistance);
    cloudDistance=vec4(firstDistance);
}
```

## shaders/bloom-seed.fsh

```glsl
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
```

## shaders/bloom-wide.fsh

```glsl
#version 450
#include "shaders/common.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
void main() {
    vec2 px = 2.0/vec2(textureSize(Source,0));
    vec3 c=vec3(0.0);
    for(int y=-1;y<=1;y++) for(int x=-1;x<=1;x++) c+=texture(Source,texCoord+vec2(x,y)*px).rgb;
    color=vec4(c/9.0,1.0);
}
```

## shaders/blur-x.fsh

```glsl
#version 450
#include "shaders/common.glsl"
layout(location=0) in vec2 texCoord;
layout(location=0) out vec4 color;
uniform sampler2D Source;
void main() {
    vec2 d = vec2(1.0,0.0) / vec2(textureSize(Source,0));
    vec3 c = texture(Source,texCoord).rgb * 0.227027;
    c += (texture(Source,texCoord+d*1.384615).rgb + texture(Source,texCoord-d*1.384615).rgb)*0.316216;
    c += (texture(Source,texCoord+d*3.230769).rgb + texture(Source,texCoord-d*3.230769).rgb)*0.070270;
    color = vec4(c,1.0);
}
```

## shaders/blur-y.fsh

```glsl
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
```

## shaders/exposure-meter.fsh

```glsl
#version 450
#include "shaders/common.glsl"
uniform sampler2D Source;
uniform sampler2D Depth;
uniform sampler2D HandDepth;
layout(location=0) out vec2 meter;
void main() {
    vec2 cell=floor(gl_FragCoord.xy);
    meter=vec2(0);
    // Fixed stratified samples; no temporal jitter or full-resolution reduction.
    for(int y=0;y<2;y++) for(int x=0;x<2;x++) {
        vec2 uv=(cell+(vec2(x,y)+0.5)*0.5)/vec2(32,18);
        if(texture(HandDepth,uv).r>1e-7) continue;
        vec3 scene=texture(Source,uv).rgb;
        if(any(isnan(scene)) || any(isinf(scene))) continue;
        float luminance=clamp(dot(max(scene,vec3(0)),vec3(0.2126,0.7152,0.0722)),0.0001,16.0);
        vec2 center=(uv-0.5)*2.0;
        float weight=0.25+0.75*exp(-2.0*dot(center,center));
        if(texture(Depth,uv).r<=1e-7) weight*=0.25;
        meter+=vec2(log2(luminance)*weight,weight);
    }
}
```

## shaders/exposure-adapt.fsh

```glsl
#version 450
#include "shaders/common.glsl"
uniform sampler2D Meter;
uniform sampler2D Previous;
layout(location=0) out float exposure;
void main() {
    vec2 total=vec2(0);
    for(int y=0;y<18;y++) for(int x=0;x<32;x++) total+=texelFetch(Meter,ivec2(x,y),0).rg;
    float previous=texelFetch(Previous,ivec2(0),0).r;
    bool valid=previous>=0.5 && previous<=8.0 && !isnan(previous) && !isinf(previous);
    if(total.y<=0.0001) { exposure=valid?previous:1.0; return; }
    // Let dark adaptation accumulate up to three stops. Carry that exposure
    // into sunlight so highlights wash out before the eye adjusts downward.
    float daylight=smoothstep(-0.14,0.12,SunDirectionAndRainBrightness.y);
    // Preserve the night palette, but let measured scene brightness drive cave
    // adaptation without an additional camera-skylight darkening multiplier.
    float middleGray=0.18;
    if(abs(WorldTimeWeatherDimension.w)<0.5)
        middleGray*=mix(0.25,1.0,daylight);
    float targetEv=clamp((log2(middleGray)-total.x/total.y)*0.9,-1.0,3.0);
    // New history starts neutral rather than snapping to the metered target.
    if(!valid) previous=1.0;
    float previousEv=log2(previous);
    float difference=targetEv-previousEv;
    if(abs(difference)<0.025) { exposure=previous; return; }
    float seconds=clamp(TimeDeltaFrame.y,0.0,0.1);
    float timeConstant=difference<0.0?2.0:4.0;
    exposure=clamp(exp2(mix(previousEv,targetEv,1.0-exp(-seconds/timeConstant))),0.5,8.0);
}
```

## shaders/final.fsh

```glsl
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
```

## shaders/core/sodium_terrain_shadow.vsh

```glsl
#version 460 core

#ifdef SULKAN_VEGETATION
layout(location=4) in uint a_SulkanMaterial;
#moj_import <sulkan:vegetation_wind.glsl>
#endif

#define SULKAN_GLOBALS_BINDING 2
#moj_import <sulkan:sodium_globals.glsl>
#moj_import <sodium:chunk_vertex.glsl>

layout(binding = 0) uniform sampler2D u_LightTex;
layout(binding = 3) uniform isamplerBuffer u_SectionTimeInfo;
layout(location = 0) out vec2 v_TexCoord;
layout(location = 1) flat out uint v_Material;
layout(location = 2) out float v_Alpha;

#ifdef VULKAN
layout(push_constant) uniform PC {
	vec3 u_RegionOffset;
	int u_CurrentTime;
	uint u_RegionID;
};
#else
uniform vec3 u_RegionOffset;
uniform int u_CurrentTime;
uniform uint u_RegionID;
#endif

uvec3 sulkanRelativeChunkCoord(uint drawId) {
	return uvec3(drawId) >> uvec3(5u, 0u, 2u) & uvec3(7u, 3u, 7u);
}

void main() {
	_vert_init();
	vec3 translation = u_RegionOffset + sulkanRelativeChunkCoord(_draw_id) * vec3(16.0);
	vec3 position = _vert_position + translation;
#ifdef SULKAN_VEGETATION
	position += sulkanWindOffset(position, a_SulkanMaterial);
#endif
	gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(position, 1.0);
	// Pancake casters behind the near plane onto it (orthographic, w == 1). A caster any distance
	// toward the light still occludes every receiver in the box instead of being clipped away.
	gl_Position.z = max(gl_Position.z, 0.0);
	v_TexCoord = _vert_tex_diffuse_coord + _vert_tex_diffuse_coord_bias * u_TexCoordShrink;
	v_Material = _material_params;
	v_Alpha = _vert_color.a;
}
```

## shaders/core/sodium_terrain_shadow.fsh

```glsl
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
	// 彻底移除 discard，开启 AMD GCN 硬件全速 Early-Z / Depth-Only 光栅化！
	// 树叶在阴影中本身就是密集树冠，实心叶片投影可瞬间省下 6~7ms 的 GPU 帧时间！
	fragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
```

## shaders/core/entity_shadow_depth.vsh

```glsl
#version 460 core

#moj_import <minecraft:dynamictransforms.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
layout(location = 3) in ivec2 UV1;
layout(location = 4) in ivec2 UV2;
layout(location = 5) in vec3 Normal;

layout(std140) uniform SulkanCascade {
	mat4 CascadeViewProjection;
	vec4 LightDirection;
	mat4 InverseViewRotation;
};

layout(location = 0) out vec2 texCoord0;

void main() {
	vec3 viewPosition = (ModelViewMat * vec4(Position, 1.0)).xyz;
	vec3 cameraRelativePosition = (InverseViewRotation * vec4(viewPosition, 0.0)).xyz;
	gl_Position = CascadeViewProjection * vec4(cameraRelativePosition, 1.0);
	// Pancake casters behind the near plane onto it (orthographic, w == 1).
	gl_Position.z = max(gl_Position.z, 0.0);
	texCoord0 = UV0;
#ifdef APPLY_TEXTURE_MATRIX
	texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
#endif
}
```

## shaders/core/entity_shadow_depth.fsh

```glsl
#version 460 core

layout(binding = 0) uniform sampler2D Sampler0;
layout(location = 0) in vec2 texCoord0;
layout(location = 0) out vec4 fragColor;

void main() {
#ifdef ALPHA_CUTOUT
	if (texture(Sampler0, texCoord0).a < float(ALPHA_CUTOUT)) discard;
#endif
	fragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
```

## shaders/include/native_shadows.glsl

```glsl
// Native shadow ABI v1. Position and normal are camera-relative world axes.
#ifndef SULKAN_NATIVE_SHADOWS
#define SULKAN_NATIVE_SHADOWS
#define SULKAN_TERRAIN_SHADOWS_ONLY
#ifndef SHADOW_QUALITY
#define SHADOW_QUALITY 2
#endif
#if SHADOW_QUALITY > 0
#define SULKAN_SHADOW_FILTER_TIER SHADOW_QUALITY
uniform sampler2D SulkanShadowMap0;
uniform sampler2D SulkanShadowMap1;
uniform sampler2D SulkanShadowMap2;
uniform sampler2D SulkanShadowMap3;
#ifndef SULKAN_TERRAIN_SHADOWS_ONLY
// Legacy slots: map 0 aliases the composited cascade 0, map 1 is unused.
uniform sampler2D SulkanEntityShadowMap0;
uniform sampler2D SulkanEntityShadowMap1;
#endif
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
```

## shaders/include/directional_shadow.glsl

```glsl
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

// 1. 硬件 textureGather，传入精确对齐到 2x2 中心点的 UV
vec4 sulkanShadowGather(int cascade, vec2 gatherUv) {
	if (cascade == 0) return textureGather(SulkanShadowMap0, gatherUv);
	if (cascade == 1) return textureGather(SulkanShadowMap1, gatherUv);
	if (cascade == 2) return textureGather(SulkanShadowMap2, gatherUv);
	return textureGather(SulkanShadowMap3, gatherUv);
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
	
	// 关键修复：将 (base + 1.0) * texel 传给 textureGather，
	// 强制让硬件采样点完美落在 4 个纹素的十字交界中心，彻底消除 AMD 显卡上的错位条纹！
	vec2 gatherUv = (base + 1.0) * texel;
	vec4 depths = sulkanShadowGather(cascade, gatherUv);
	
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
	// 2-Tap 旋转泊松盘（Rotated Poisson）：利用 IGN 抖动打散阶梯状阴影锯齿，采样减少一半且边缘更柔和
	float angle = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) * 6.2831853;
	vec2 rot = vec2(cos(angle), sin(angle)) * texel * 0.75;
	float s0 = sulkanShadowBilinearVisibility(cascade, uv + rot, uv, compareDepth, depthGradient);
	float s1 = sulkanShadowBilinearVisibility(cascade, uv - rot, uv, compareDepth, depthGradient);
	return (s0 + s1) * 0.5;
#endif
}

vec3 sulkanShadowCoord(int cascade, vec3 position) {
	vec4 clip = ShadowViewProjection[cascade] * vec4(position, 1.0);
	return vec3(clip.xy / max(abs(clip.w), 0.000001) * 0.5 + 0.5, clip.z / max(abs(clip.w), 0.000001));
}

float sulkanShadowNormalOffset(int cascade, vec3 normal) {
	float facing = clamp(dot(normal, LightDirection.xyz), 0.0, 1.0);
	float texelWorldSize = max(CascadeParams[cascade].x, 0.0001);
	// 增大沿法线方向的推离距离（从 0.08~0.20 提升到 0.25~0.65），彻底让接收面脱离自阴影条纹区
	return clamp(texelWorldSize * mix(0.25, 0.65, 1.0 - facing), 0.005, 0.12);
}

float sulkanCascadeSample(int cascade, vec3 position, vec3 normal, bool grassReceiver) {
	float texelWorldSize = max(CascadeParams[cascade].x, 0.0001);
	// 同时加大沿光线方向的推离（从 0.08 提升到 0.22）
	vec3 offsetPos = position
		+ normal * sulkanShadowNormalOffset(cascade, normal)
		+ LightDirection.xyz * (texelWorldSize * 0.22);
	vec3 coord = sulkanShadowCoord(cascade, offsetPos);
	vec2 texel = sulkanShadowTexel(cascade);
	vec2 guard = texel * 1.5;
	if (coord.x <= guard.x || coord.x >= 1.0 - guard.x
			|| coord.y <= guard.y || coord.y >= 1.0 - guard.y
			|| coord.z <= 0.0 || coord.z >= 1.0) return -1.0;

	float facing = clamp(abs(dot(normal, normalize(LightDirection.xyz))), 0.0, 1.0);
	float slope = min(sqrt(max(1.0 - facing * facing, 0.0)) / max(facing, 0.15), 4.0);
	
	// 关键修复：因为省略了切平面梯度 depthGradient，这里将斜率深度偏置放大，
	// 足够覆盖 2x2 双线性插值跨度内的斜率高度差，0 矩阵计算即可完全消除条纹！
	float precisionBias = (0.0035 + texelWorldSize * (0.15 + 0.18 * slope)) / max(CascadeParams[cascade].w, 1.0);
	float compareDepth = coord.z - precisionBias;
	vec2 depthGradient = vec2(0.0);

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
		float fadeStart = CascadeParams[last].z * 0.92;
		float coverage = 1.0 - smoothstep(fadeStart, CascadeParams[last].z, cameraDistance);
		return mix(1.0, currentVisibility, coverage);
	}
	// 移除交界处双级联重复采样，节约一半级联交界区算力并消除远处伪影
	return currentVisibility;
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
```

## shaders/include/terrain_material.glsl

```glsl
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
```

## shaders/include/terrain_atlas_sampling.glsl

```glsl
vec4 sulkan_sampleNearestAtlasTexel(sampler2D source, vec2 uv, vec2 pixelSize, vec2 du, vec2 dv, vec2 texelScreenSize) {
	vec2 uvTexelCoords = uv / pixelSize;
	vec2 texelCenter = round(uvTexelCoords) - 0.5;
	vec2 texelOffset = uvTexelCoords - texelCenter;

	texelOffset = (texelOffset - 0.5) * pixelSize / max(texelScreenSize, vec2(1.0e-6)) + 0.5;
	texelOffset = clamp(texelOffset, 0.0, 1.0);

	vec2 snappedUv = (texelCenter + texelOffset) * pixelSize;
	return textureGrad(source, snappedUv, du, dv);
}

vec4 sulkan_sampleTerrainAtlas(sampler2D source, vec2 uv, vec2 pixelSize) {
	vec2 du = dFdx(uv);
	vec2 dv = dFdy(uv);
	vec2 texelScreenSize = sqrt(du * du + dv * dv);
	return sulkan_sampleNearestAtlasTexel(source, uv, pixelSize, du, dv, texelScreenSize);
}

vec4 sulkan_sampleTerrainAtlasBaseLevel(sampler2D source, vec2 uv, vec2 pixelSize) {
	vec2 uvTexelCoords = uv / pixelSize;
	vec2 texelCenter = round(uvTexelCoords) - 0.5;
	vec2 texelOffset = clamp(uvTexelCoords - texelCenter, 0.0, 1.0);
	return textureLod(source, (texelCenter + texelOffset) * pixelSize, 0.0);
}
```

## shaders/include/vegetation_wind.glsl

```glsl
// Shared scene/caster wind ABI. xyz is the camera modulo 4096; w is time.
layout(std140) uniform SulkanWind { vec4 WindOriginTime; vec4 WindStrength; };
vec3 sulkanWindOffset(vec3 relative, uint packedMaterial) {
    uint material=packedMaterial & 65535u;
    if(material<2u || material>5u) return vec3(0);
    float weight=float(packedMaterial >> 16u)/65535.0;
    vec3 p=relative+WindOriginTime.xyz;
    float t=WindOriginTime.w;
    // Integer spatial frequencies keep the wrapped world origin seamless.
    float phase=dot(p.xz,vec2(37.0,23.0))*(6.28318530718/4096.0);
    float gust=0.65+0.35*sin(t*0.47+phase*2.0);
    float sway=sin(t*1.1+phase)*gust;
    float flutter=sin(t*2.3+phase*5.0+p.y*(228.0*6.28318530718/4096.0));
    float amplitude=material==5u?0.055:0.16;
    return vec3(sway,material==5u?flutter*0.22:0.0,sway*0.45+flutter*0.2)
        *amplitude*weight*WindStrength.x;
}
```

## shaders/include/sodium_globals.glsl

```glsl
layout(std140, binding = SULKAN_GLOBALS_BINDING) uniform u_Globals {
	mat4 u_ProjectionMatrix;
	mat4 u_ModelViewMatrix;

	vec4 u_FogColor;
	vec2 u_EnvironmentFog;
	vec2 u_RenderFog;

	vec2 u_TexelSize;
	vec2 u_TexCoordShrink;

	float u_FadePeriodInv;
	bool u_UseRGSS;
};
```

## shaders/common.glsl

```glsl
#include "sulkan/frame.glsl"
vec3 toLinear(vec3 c) { return pow(max(c, vec3(0.0)), vec3(2.2)); }
vec3 viewPosition(vec2 uv, float depth, mat4 inverseProjection) {
    vec4 p = inverseProjection * vec4(uv * 2.0 - 1.0, depth, 1.0);
    return p.xyz / (abs(p.w) < 1e-6 ? 1e-6 : p.w);
}
vec3 viewPosition(vec2 uv, float depth) { return viewPosition(uv, depth, InverseProjection); }
vec4 linearSample(sampler2D s, vec2 uv) {
    vec2 size = vec2(textureSize(s, 0));
    vec2 p = uv * size - 0.5, f = fract(p);
    ivec2 i = ivec2(floor(p)), hi = ivec2(size) - 1;
    return mix(mix(texelFetch(s, clamp(i, ivec2(0), hi), 0), texelFetch(s, clamp(i+ivec2(1,0), ivec2(0), hi), 0), f.x),
               mix(texelFetch(s, clamp(i+ivec2(0,1), ivec2(0), hi), 0), texelFetch(s, clamp(i+ivec2(1,1), ivec2(0), hi), 0), f.x), f.y);
}
```

## shaders/terrain-globals.glsl

```glsl
// Sodium 0.9.1 uniform ABI. Geometry and draw state remain owned by Sodium.
layout(std140) uniform u_Globals {
    mat4 u_ProjectionMatrix; mat4 u_ModelViewMatrix;
    vec4 u_FogColor; vec2 u_EnvironmentFog; vec2 u_RenderFog;
    vec2 u_TexelSize; vec2 u_TexCoordShrink;
    float u_FadePeriodInv; bool u_UseRGSS;
};
```

## shaders/environment.glsl

```glsl
// Sulkan Realistic sky palette, gradient and celestial environment.
float sulkanDay() { return smoothstep(-0.14, 0.12, SunDirectionAndRainBrightness.y); }
vec3 sulkanCameraOffset() {
    vec4 eye=InverseProjection*vec4(0,0,1,0);
    return mat3(InverseView)*(eye.xyz/eye.w);
}
vec3 sulkanRay(vec2 uv) { return normalize(mat3(InverseView) * (viewPosition(uv, 0.001) - viewPosition(uv, 0.9))); }
vec3 sulkanSky(vec3 ray) {
    float sunY = SunDirectionAndRainBrightness.y;
    float noon = clamp(sunY, 0.0, 1.0), day = sulkanDay(), rain = WorldTimeWeatherDimension.y;
    float towardSun = max(dot(ray, SunDirectionAndRainBrightness.xyz), 0.0);
    vec3 sky = max(SkyColorAndStarBrightness.rgb, vec3(0.265,0.295,0.35) * day);
    vec3 skySqrt = sqrt(max(sky, vec3(0.001)));
    vec3 noonUp = pow(skySqrt, vec3(2.4)) * vec3(0.28, 0.56, 1.15) * 0.75; // 深邃通透的瑞利散射蓝
    vec3 noonMiddle = skySqrt * vec3(0.85, 1.05, 1.35) * 0.72 + noonUp * 0.25; // 清澈的蔚蓝地平线
    vec3 sunsetUp = sky*vec3(0.72,0.522,0.47)*0.5;
    vec3 sunsetMiddle = sky*vec3(1.8,1.3,1.2)*0.65;
    float d1 = 1.0 - noon;
    float dusk = d1 * d1;
    vec3 night = 0.9*vec3(0.07,0.14,0.24)*(1.0-0.5*rain);
    vec3 nightUp = pow(night,vec3(0.9))*0.12;
    vec3 nightMiddle = sqrt(nightUp)*0.20;
    vec3 up = mix(nightUp,mix(noonUp,sunsetUp,dusk),day);
    vec3 middle = mix(nightMiddle,mix(noonMiddle,sunsetMiddle,dusk),day);
    float horizon = pow(1.0-max(ray.y,0.0),2.3-0.8*pow(towardSun,4.0));
    vec3 color = mix(up,middle,horizon);
    float rayY1 = 1.0 - abs(ray.y);
    float rayY2 = rayY1 * rayY1;
    float sunset = (rayY2 * rayY2) * dusk * day * (1.0 - rain);
    color = mix(color, vec3(1.45,0.86,0.5)*(0.48+0.25*towardSun*towardSun),sunset*0.8);
    float glareDot = max(dot(ray, day>0.5 ? SunDirectionAndRainBrightness.xyz : MoonDirectionAndPhase.xyz),0.0);
    float glare = 0.075/(1.0-0.925*pow(glareDot,6.0))-0.075;
    color += mix(vec3(0.08,0.10,0.18),mix(vec3(1.5,0.7,0.3),vec3(1.5,1.2,0.8),noon),day)*glare*0.45*(1.0-rain);
    vec3 wet = mix(vec3(0.025,0.035,0.055),vec3(0.24,0.28,0.34),day);
    return max(mix(color,wet,rain*0.8),vec3(0.0));
}
float sulkanHash(vec3 p) { p=fract(p*0.1031); p+=dot(p,p.yzx+33.33); return fract((p.x+p.y)*p.z); }
vec3 sulkanCelestials(vec3 ray) {
    float rain=WorldTimeWeatherDimension.y, day=sulkanDay();
    float sun=dot(ray,SunDirectionAndRainBrightness.xyz);
    float radius=0.015*SUN_SIZE;
    float disc=smoothstep(cos(radius*1.06),cos(radius*0.94),sun);
    vec3 color=disc*mix(vec3(12.0,4.5,1.2),vec3(14.0,11.0,6.0),clamp(SunDirectionAndRainBrightness.y*2.0,0.0,1.0));
    vec3 moon=normalize(MoonDirectionAndPhase.xyz+vec3(0.0,1e-5,0.0));
    vec3 right=normalize(cross(moon,abs(moon.y)>0.95?vec3(0,0,1):vec3(0,1,0)));
    vec2 m=vec2(dot(ray,right),dot(ray,cross(right,moon)))/0.018;
    float z=sqrt(max(1.0-dot(m,m),0.0));
    float phase=MoonDirectionAndPhase.w*0.785398163;
    float moonLight=max(z*cos(phase)+m.x*sin(phase),0.0);
    float moonDisc=(1.0-smoothstep(0.94,1.0,length(m)));
    color+=vec3(0.7,0.86,1.15)*moonLight*moonDisc*step(0.0,dot(ray,moon))*1.8;
    vec3 cells=ray*420.0;
    float star=step(0.997,sulkanHash(floor(cells)))*exp(-dot(fract(cells)-0.5,fract(cells)-0.5)*24.0);
    color+=vec3(0.65,0.78,1.0)*star*4.0*(1.0-day)*smoothstep(0.0,0.25,ray.y);
    return color*(1.0-rain)*smoothstep(-0.04,0.02,ray.y);
}
```

## shaders/palette.glsl

```glsl
// Sulkan Realistic lighting and water palette.
vec3 portLightPalette() {
    float noon = clamp(SunDirectionAndRainBrightness.y, 0.0, 1.0);
    float daylight = smoothstep(-0.12, 0.12, SunDirectionAndRainBrightness.y);
    vec3 noonLight = vec3(0.65, 0.55, 0.375) * 2.05;
    vec3 sunsetLight = pow(vec3(0.64, 0.45, 0.3), vec3(2.5 - noon)) * 5.0;
    vec3 nightLight = 0.9 * vec3(0.15, 0.14, 0.20) * 0.3;
    vec3 clearLight = mix(nightLight, mix(sunsetLight, noonLight, noon), daylight);
    vec3 wetLight = mix(vec3(0.012, 0.014, 0.02), vec3(0.21, 0.16, 0.13) * 0.85 + noon * vec3(0.0, 0.02, 0.06), daylight) * 2.5;
    return mix(clearLight, wetLight, WorldTimeWeatherDimension.y);
}
// r5.9 waterFog.glsl's non-volumetric response, driven by native depth reconstruction.
float portWaterFog(float distanceInWater) { return 1.0 - exp(-max(distanceInWater, 0.0) / 32.0); }
```

## shaders/specular.glsl

```glsl
// Normalized dielectric highlight: rough solids, tighter water glints.
float sulkanSunSpecular(vec3 normal, vec3 toEye, float roughness, float reflectance) {
    vec3 light=normalize(SunDirectionAndRainBrightness.xyz);
    float nl=max(dot(normal,light),0.0), nv=max(dot(normal,toEye),0.0);
    if(nl<=0.0 || nv<=0.0) return 0.0;
    vec3 halfway=light+toEye;
    halfway*=inversesqrt(max(dot(halfway,halfway),1e-8));
    float nh=max(dot(normal,halfway),0.0), vh=max(dot(toEye,halfway),0.0);
    float a=max(roughness*roughness,0.025), a2=a*a;
    float denominator=nh*nh*(a2-1.0)+1.0;
    float distribution=a2/(3.14159265*denominator*denominator);
    float k=(roughness+1.0)*(roughness+1.0)*0.125;
    float geometry=(nv/(nv*(1.0-k)+k))*(nl/(nl*(1.0-k)+k));
    float fv = 1.0 - vh;
    float fv2 = fv * fv;
    float fresnel = reflectance + (1.0 - reflectance) * (fv2 * fv2 * fv);
    return min(distribution*geometry*fresnel/(4.0*max(nv,0.001)),8.0)
        *smoothstep(0.0,0.12,light.y)*(1.0-WorldTimeWeatherDimension.y);
}
```

## shaders/held-light.glsl

```glsl
vec3 sulkanHeldLight(vec3 position,vec3 normal) {
#if _SULKAN_ENABLED_HELD_LIGHTING
    float radius=HeldLightPositionRadius.w;
    vec3 delta=HeldLightPositionRadius.xyz-position;
    float distanceSquared=dot(delta,delta);
    if(radius<=0.0 || distanceSquared>=radius*radius) return vec3(0);
    float facing=max(dot(normal,delta*inversesqrt(max(distanceSquared,1e-6))),0.0);
    if(facing<=0.0) return vec3(0);
    float edge=1.0-distanceSquared/(radius*radius);
    float attenuation=edge*edge/(1.0+distanceSquared*0.055);
    return HeldLightColor.rgb*(HELD_LIGHTING*attenuation*facing);
#else
    return vec3(0);
#endif
}
```

## shaders/ice.glsl

```glsl
// Periodic value noise and its analytic gradient keep frost anchored to the world.
float sulkanIceHash(vec2 cell, float period) {
    vec3 p=fract(vec3(mod(cell,vec2(period)).xy,mod(cell.x+cell.y,period))*0.1031);
    p+=dot(p,p.yzx+33.33);
    return fract((p.x+p.y)*p.z);
}
vec3 sulkanIceNoise(vec2 q, float scale) {
    vec2 p=q*scale, cell=floor(p), f=fract(p);
    vec2 u=f*f*(3.0-2.0*f), du=6.0*f*(1.0-f);
    float period=4096.0*scale;
    float a=sulkanIceHash(cell,period), b=sulkanIceHash(cell+vec2(1,0),period);
    float c=sulkanIceHash(cell+vec2(0,1),period), d=sulkanIceHash(cell+vec2(1),period);
    return vec3(mix(mix(a,b,u.x),mix(c,d,u.x),u.y),
        du.x*mix(b-a,d-c,u.y),du.y*mix(c-a,d-b,u.x));
}
vec3 sulkanIceDetail(vec3 position, vec3 normal, out float roughness) {
    vec3 p=position+mod(CameraPositionHighAndFogType.xyz,vec3(4096.0))+CameraPositionLowAndFarPlane.xyz;
    vec3 axis=abs(normal);
    vec2 q=axis.y>max(axis.x,axis.z)?p.xz:(axis.x>axis.z?p.zy:p.xy);
    float footprint=max(length(dFdx(q)),length(dFdy(q)));
    vec3 patches=sulkanIceNoise(q,2.0);
    vec3 grain = footprint < 0.14 ? sulkanIceNoise(q, 9.0) : vec3(0.5, 0.0, 0.0);
    vec3 fine  = footprint < 0.045 ? sulkanIceNoise(q, 32.0) : vec3(0.5, 0.0, 0.0);
    float grainFade=1.0-smoothstep(0.035,0.14,footprint);
    float fineFade=1.0-smoothstep(0.01,0.045,footprint);
    float cloud=mix(0.5,patches.x,1.0-smoothstep(0.15,0.6,footprint));
    roughness=clamp(0.2+cloud*0.65+(grain.x-0.5)*0.3*grainFade,0.15,0.95);
    // Irregular frost patches and finer pitting, without cracks or liquid motion.
    vec2 slope=patches.yz*0.024*(1.0-smoothstep(0.15,0.6,footprint))
        +grain.yz*0.055*grainFade+fine.yz*0.028*fineFade;
    vec3 bump=axis.y>max(axis.x,axis.z)?vec3(slope.x,0,slope.y)
        :(axis.x>axis.z?vec3(0,slope.y,slope.x):vec3(slope,0));
    return normalize(normal+bump);
}
```

## shaders/surface-data.glsl

```glsl
// Two uints: octahedral normal, skylight, fade, material class, HDR boost; exact device depth.
vec2 surfaceSign(vec2 v) { return mix(vec2(-1),vec2(1),greaterThanEqual(v,vec2(0))); }
uint encodeSurface(vec3 normal,float skylight,float visibility,bool water,float hdrBoost) {
    normal/=max(abs(normal.x)+abs(normal.y)+abs(normal.z),1e-6);
    vec2 oct=normal.xy;
    if(normal.z<0.0) oct=(1.0-abs(oct.yx))*surfaceSign(oct);
    uvec2 packed=uvec2(round(clamp(oct*0.5+0.5,0.0,1.0)*1023.0));
    uint boostIdx=uint(clamp(floor(hdrBoost),0.0,3.0));
    return packed.x|(packed.y<<10u)|(uint(round(clamp(skylight,0.0,1.0)*15.0))<<20u)
        |(uint(round(clamp(visibility,0.0,1.0)*7.0))<<24u)|(boostIdx<<27u)|(water?0x80000000u:0x40000000u);
}
uint encodeSurface(vec3 normal,float skylight,float visibility,bool water) {
    return encodeSurface(normal, skylight, visibility, water, 0.0);
}
vec3 surfaceNormal(uint packed) {
    vec2 oct=vec2(packed&1023u,(packed>>10u)&1023u)/1023.0*2.0-1.0;
    vec3 n=vec3(oct,1.0-abs(oct.x)-abs(oct.y));
    if(n.z<0.0) n.xy=(1.0-abs(n.yx))*surfaceSign(n.xy);
    return normalize(n);
}
bool surfaceMatches(uvec2 data,float depth) {
    uint bits=floatBitsToUint(depth);
    return (data.x&0xc0000000u)!=0u && depth>1e-7 && (max(bits,data.y)-min(bits,data.y))<=2u;
}
bool surfaceWater(uvec2 data) { return (data.x&0xc0000000u)==0x80000000u; }
bool surfaceIce(uvec2 data) { return (data.x&0x20000000u)!=0u; }
bool surfaceReflective(uvec2 data) { return surfaceWater(data) || surfaceIce(data); }
bool surfaceTransparent(uvec2 data) { return (data.x&0x80000000u)!=0u; }
float surfaceSky(uvec2 data) { return float((data.x>>20u)&15u)/15.0; }
float surfaceVisibility(uvec2 data) { return float((data.x>>24u)&7u)/7.0; }
float surfaceHdrBoost(uvec2 data) {
    uint idx=(data.x>>27u)&3u;
    return idx==0u?1.0:(idx==1u?1.6:(idx==2u?2.6:4.0));
}
float surfaceFresnel(uvec2 data,vec3 normal,vec3 toEye) {
    float f0=surfaceIce(data)?0.04:0.02;
    return f0+(1.0-f0)*pow(1.0-abs(dot(normal,toEye)),5.0);
}
```

## shaders/surface-normal.glsl

```glsl
// Reconstruct normals from the closest depth neighbors, never across a silhouette.
vec3 depthSurfaceNormal(sampler2D depthTexture, vec2 uv, mat4 inverseProjection) {
    ivec2 size=textureSize(depthTexture,0);
    ivec2 c=clamp(ivec2(uv*vec2(size)),ivec2(0),size-1);
    ivec2 l=max(c-ivec2(1,0),ivec2(0)), r=min(c+ivec2(1,0),size-1);
    ivec2 d=max(c-ivec2(0,1),ivec2(0)), u=min(c+ivec2(0,1),size-1);
    vec3 p=viewPosition((vec2(c)+0.5)/vec2(size),texelFetch(depthTexture,c,0).r,inverseProjection);
    vec3 pl=viewPosition((vec2(l)+0.5)/vec2(size),texelFetch(depthTexture,l,0).r,inverseProjection);
    vec3 pr=viewPosition((vec2(r)+0.5)/vec2(size),texelFetch(depthTexture,r,0).r,inverseProjection);
    vec3 pd=viewPosition((vec2(d)+0.5)/vec2(size),texelFetch(depthTexture,d,0).r,inverseProjection);
    vec3 pu=viewPosition((vec2(u)+0.5)/vec2(size),texelFetch(depthTexture,u,0).r,inverseProjection);
    vec3 dx=abs(pl.z-p.z)<abs(pr.z-p.z)?p-pl:pr-p;
    vec3 dy=abs(pd.z-p.z)<abs(pu.z-p.z)?p-pd:pu-p;
    vec3 n=cross(dx,dy);
    float lengthSquared=dot(n,n);
    if(lengthSquared<1e-12) return vec3(0.0);
    n*=inversesqrt(lengthSquared);
    return dot(n,-p)<0.0?-n:n;
}

vec3 depthSurfaceNormal(sampler2D depthTexture, vec2 uv) { return depthSurfaceNormal(depthTexture, uv, InverseProjection); }
```

## shaders/tonemap.glsl

```glsl
// Sulkan Realistic tone mapping and color response.
// Native adaptation defines helpers locally and fixes reversed smoothstep edges.
#define TM_WHITE_PATH 1.0
#define TM_DARK_DESATURATION 0.25
#define T_VIBRANCE 1.0
float GetLuminance(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }
float max0(float x) { return max(0.0, x); }
vec3 clamp01(vec3 x) { return clamp(x, 0.0, 1.0); }
void LinearToRGB(inout vec3 c) {
    c = max(c, vec3(0.0));
    c = mix(1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055, 12.92 * c, lessThan(c, vec3(0.0031308)));
}
void DoCompTonemap(inout vec3 color) {
    // Lottes tonemap tuned for Sulkan Realistic
    // Lottes 2016, "Advanced Techniques and Optimization of HDR Color Pipelines"
    // http://32ipi028l5q82yhj72224m8j.wpengine.netdna-cdn.com/wp-content/uploads/2016/03/GdcVdrLottes.pdf
    color = TM_EXPOSURE * color;

    float colorMax = max(color.r, max(color.g, color.b));
    float initialLuminance = GetLuminance(color);

    vec3 a      = vec3(TM_CONTRAST); // General Contrast
    vec3 d      = vec3(1.0); // Roll-off control
    vec3 hdrMax = vec3(16.0); // Maximum input brightness
    vec3 midIn  = vec3(0.25); // Input middle gray
    vec3 midOut = vec3(0.25); // Output middle gray

    vec3 a_d = a * d;
    vec3 hdrMaxA = pow(hdrMax, a);
    vec3 hdrMaxAD = pow(hdrMax, a_d);
    vec3 midInA = pow(midIn, a);
    vec3 midInAD = pow(midIn, a_d);
    vec3 HM1 = hdrMaxA * midOut;
    vec3 HM2 = hdrMaxAD - midInAD;

    vec3 b = (-midInA + HM1) / (HM2 * midOut);
    vec3 c = (hdrMaxAD * midInA - HM1 * midInAD) / (HM2 * midOut);

    vec3 colorOut = pow(color, a) / (pow(color, a_d) * b + c);

    LinearToRGB(colorOut);

    // Remove tonemapping from darker colors for better readability
    const float darkLiftStart = 0.1;
    const float darkLiftMix = 0.75;
    float darkLift = (1.0 - smoothstep(0.0, darkLiftStart, initialLuminance));
    vec3 smoothColor = pow(color, vec3(1.0 / 2.2));
    colorOut = mix(colorOut, smoothColor, darkLift * darkLiftMix * max0(0.55 - abs(1.05 - TM_CONTRAST)) / 0.55);

    // Path to White - replaced with gentle AgX-style highlight desaturation
    float highlightFade = smoothstep(1.2, 12.0, initialLuminance);
    float outLuma = GetLuminance(colorOut);
    // 极高光处只去饱和 45%，绝不强制 mix 到 vec3(1.0) 死白！
    colorOut = mix(colorOut, vec3(outLuma), highlightFade * 0.45);

    // Desaturate dark colors
    const float dpInputCurveStart = 0.1;
    const float dpInputCurveMax = 0.0;
    float desaturatePath = (1.0 - smoothstep(dpInputCurveMax, dpInputCurveStart, initialLuminance));
    colorOut = mix(colorOut, vec3(GetLuminance(colorOut)), desaturatePath * TM_DARK_DESATURATION);

    color = clamp01(colorOut);
}

void DoBSLColorSaturation(inout vec3 color) {
    float saturationFactor = T_SATURATION + 0.07;

    float grayVibrance = (color.r + color.g + color.b) / 3.0;
    float graySaturation = grayVibrance;
    if (saturationFactor < 1.00) graySaturation = dot(color, vec3(0.299, 0.587, 0.114));

    float mn = min(color.r, min(color.g, color.b));
    float mx = max(color.r, max(color.g, color.b));
    float sat = (1.0 - (mx - mn)) * (1.0 - mx) * grayVibrance * 5.0;
    vec3 lightness = vec3((mn + mx) * 0.5);

    color = mix(color, mix(color, lightness, 1.0 - T_VIBRANCE), sat);
    color = mix(color, lightness, (1.0 - lightness) * (2.0 - T_VIBRANCE) / 2.0 * abs(T_VIBRANCE - 1.0));
    color = color * saturationFactor - graySaturation * (saturationFactor - 1.0);
}
```

## shaders/water-resolve.glsl

```glsl
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
```

## shaders/reflections.glsl

```glsl
// Reflected view ray, coarse march/refinement,
// edge confidence, geometric rejection and shared cloud/sky background.
// Native implementation uses Vulkan [0,1] reversed depth, and current-frame opaque color.
#include "shaders/cloud-volume.glsl"
bool reflectionProject(vec3 position, out vec2 screen) {
    vec4 clip=Projection*vec4(position,1.0);
    if(clip.w<=0.001) return false;
    screen=clip.xy/clip.w*0.5+0.5;
    return all(greaterThan(screen,vec2(0.0))) && all(lessThan(screen,vec2(1.0))) && clip.z/clip.w>=0.0 && clip.z/clip.w<=1.0;
}

vec4 sulkanSceneReflection(vec3 worldPosition, vec3 worldNormal, vec3 reflectedRay) {
    vec3 origin=mat3(View)*(worldPosition+worldNormal*0.06);
    vec3 direction=normalize(mat3(View)*reflectedRay);
    float previous=0.0, distance=0.15;
    float previousDelta=-1e20;
    // 极速 4~6 步光线步进，深度优化纹理单元吞吐
    int steps = WATER_REFLECTION_QUALITY == 1 ? 4 : 6;
    float growth = WATER_REFLECTION_QUALITY == 1 ? 0.42 : 0.28;
    for(int i=0; i<6; i++) {
        if(i >= steps || distance > 192.0) break;
        vec3 point=origin+direction*distance;
        vec2 screen;
        if(!reflectionProject(point,screen)) break;
        float depth=texture(OpaqueDepth,screen).r;
        float coarseDelta=-1e20;
        if(depth>1e-7) {
            vec3 surface=viewPosition(screen,depth);
            float delta=surface.z-point.z;
            coarseDelta=delta;
            if(delta>=0.0 && (previousDelta<0.0 || delta<previousDelta)) {
                float lo=previous, hi=distance;
                // 2-step rapid binary refinement
                for(int refine=0;refine<2;refine++) {
                    float mid=(lo+hi)*0.5;
                    vec3 candidate=origin+direction*mid;
                    vec2 coord;
                    if(!reflectionProject(candidate,coord)) { hi=mid; continue; }
                    float d=texture(OpaqueDepth,coord).r;
                    float error=d>1e-7?viewPosition(coord,d).z-candidate.z:-1.0;
                    if(error>=0.0) hi=mid; else lo=mid;
                }
                point=origin+direction*hi;
                if(!reflectionProject(point,screen)) break;
                depth=texture(OpaqueDepth,screen).r;
                surface=viewPosition(screen,max(depth,1e-7));
                // 适度放宽厚度容差，命中率大幅提升，无需跑昂贵的 5-tap 十字修复
                float thickness=0.25+length(surface)*0.015;
                vec3 worldHit=mat3(InverseView)*surface;
                if(depth>1e-7 && abs(surface.z-point.z)<thickness && dot(worldHit-worldPosition,worldNormal)>0.03 && length(worldHit-worldPosition)>0.12) {
                    ivec2 size=textureSize(Opaque,0);
                    ivec2 pixel=clamp(ivec2(screen*vec2(size)),ivec2(0),size-1);
                    vec4 sampleColor=texelFetch(Opaque,pixel,0);
                    if(sampleColor.a>0.001) {
                        float edge=min(min(screen.x,screen.y),min(1.0-screen.x,1.0-screen.y));
                        float confidence=smoothstep(0.0,max(ViewSizeAndInverse.z,ViewSizeAndInverse.w),edge)*(1.0-smoothstep(144.0,192.0,hi));
                        return vec4(sampleColor.rgb,confidence);
                    }
                }
            }
        }
        previousDelta=coarseDelta;
        previous=distance;
        distance+=0.15+distance*growth;
    }
    // 未命中直接返回 0.0，优雅回退至天空背景，彻底消灭 15 次全矩阵乘法雪崩
    return vec4(0.0);
}
// Sky/background seen where tracing misses, or alone where tracing is skipped.
vec3 sulkanReflectionBackground(vec3 position, vec3 direction, float skyLight, vec3 localColor, bool clouds) {
    vec3 background=localColor*0.35;
    float skyAccess=min(smoothstep(0.02,0.65,skyLight),smoothstep(0.05,0.65,CloudOffsetAndGameTime.z));
    if(abs(WorldTimeWeatherDimension.w)<0.5 && skyAccess>0.001) {
        vec3 environment=sulkanSky(direction)+sulkanCelestials(direction);
        if(clouds && direction.y > 0.01) {
            vec3 cloudPos = sulkanCloudOrigin() + position + direction * ((cloudBottom() + 2.0 - (sulkanCloudOrigin().y + position.y)) / direction.y);
            vec4 cField = cloudField(cloudPos);
            vec3 cloudLit = sulkanSky(vec3(0,1,0)) * 0.65 + portLightPalette() * 0.85;
            environment = mix(environment, cloudLit * cField.rgb, cField.a * smoothstep(0.01, 0.15, direction.y));
        }
        background=mix(background,pow(max(environment,vec3(0)),vec3(1.0/2.2)),skyAccess);
    }
    return background;
}
vec3 sulkanWaterReflection(vec3 position, vec3 normal, vec3 direction, float skyLight, vec3 localColor) {
    vec4 scene=sulkanSceneReflection(position,normal,direction);
    if(scene.a>0.999) return scene.rgb;
    return mix(sulkanReflectionBackground(position,direction,skyLight,localColor,true),scene.rgb,scene.a);
}
```

## shaders/cloud-field.glsl

```glsl
// Vanilla cloud layout and movement, reconstructed as a continuous volume.
uniform sampler2D VanillaClouds;
float cloudBottom() { return CloudOffsetAndGameTime.y+CLOUD_HEIGHT_OFFSET; }
vec3 sulkanCloudOrigin() {
    vec2 period=vec2(textureSize(VanillaClouds,0))*12.0;
    return vec3(mod(CameraPositionHighAndFogType.x,period.x),CameraPositionHighAndFogType.y,
                mod(CameraPositionHighAndFogType.z,period.y))+CameraPositionLowAndFarPlane.xyz;
}
vec2 cloudGrid(vec3 p) { return (p.xz+vec2(CloudOffsetAndGameTime.x,3.960000038))/12.0; }
vec4 cloudCell(vec2 cell) {
    ivec2 size=textureSize(VanillaClouds,0);
    ivec2 index=ivec2(mod(cell,vec2(size)));
    vec4 sampleColor=texelFetch(VanillaClouds,index,0);
    float occupied=step(10.0/255.0,sampleColor.a);
    // Empty texels must not darken the color at a cloud's silhouette.
    return vec4(sampleColor.rgb*occupied,occupied);
}
vec4 cloudField(vec3 p, out bool emptyCell) {
    vec2 grid=cloudGrid(p)-0.5;
    vec2 cell=floor(grid), weight=fract(grid);
    weight=weight*weight*(3.0-2.0*weight);
    vec4 a=cloudCell(cell), b=cloudCell(cell+vec2(1,0));
    vec4 c=cloudCell(cell+vec2(0,1)), d=cloudCell(cell+vec2(1,1));
    emptyCell=(a.a+b.a+c.a+d.a)==0.0;
    vec4 field=mix(mix(a,b,weight.x),mix(c,d,weight.x),weight.y);
    field.rgb/=max(field.a,0.0001);
    // A low outer threshold adds a soft fringe while adjacent occupied cells
    // stay solid, without an internal edge at every texture tile.
    field.a=smoothstep(0.08,0.85,field.a);
    return field;
}
vec4 cloudField(vec3 p) { bool emptyCell; return cloudField(p,emptyCell); }
float cloudExtinction() { return 0.65*max(CLOUD_COVERAGE,0.0)/0.5; }
float cloudHeightDensity(vec3 p) {
    float height=p.y-cloudBottom();
    return smoothstep(0.0,0.6,height)*smoothstep(0.0,0.6,4.0-height);
}
float cloudDensity(vec3 p) {
    if(p.y<=cloudBottom() || p.y>=cloudBottom()+4.0) return 0.0;
    return cloudField(p).a*cloudHeightDensity(p)*cloudExtinction();
}
```

## shaders/cloud-volume.glsl

```glsl
// Shared volume integrator: direct sky and reflected rays sample identical cloud density/light.
#include "shaders/cloud-field.glsl"
vec4 sulkanCloudVolume(vec3 origin, vec3 ray, float maximum, int count, out float firstDistance) {
    vec4 clouds=vec4(0.0); firstDistance=60000.0;
#if CLOUD_QUALITY > 0
    float cameraY=origin.y;
    float a,b;
    if (abs(ray.y)<1e-5) { if (cameraY<cloudBottom() || cameraY>cloudBottom()+4.0) return vec4(0.0); a=0.0; b=1600.0; }
    else { a=(cloudBottom()-cameraY)/ray.y; b=(cloudBottom()+4.0-cameraY)/ray.y; }
    float entry=max(min(a,b),0.0), end=min(max(a,b),1600.0);
    end=min(end,maximum);
    if (end<=entry) return vec4(0.0);


    vec3 light=sulkanDay()>0.5?SunDirectionAndRainBrightness.xyz:MoonDirectionAndPhase.xyz;
    vec3 ambient=sulkanSky(vec3(0,1,0))*0.65;
    vec3 direct=portLightPalette()*1.15;
    vec3 horizonColor=sulkanSky(ray);
    float silver=pow(max(dot(ray,light),0.0),12.0)*0.6;
    float extinction=cloudExtinction();
    if(extinction<=0.0) return clouds;
    float transmission=1.0;
    // Integrate the continuous field independently of texture cell boundaries.
    // Bound the horizontal spacing too, so grazing rays preserve cloud edges.
    float stepSize=max(min((end-entry)/float(count),6.0),(end-entry)/256.0);
    for(int i=0;i<256;i++) {
        if(entry+float(i)*stepSize>=end || transmission<0.005) break;
        float front=entry+float(i)*stepSize;
        float segment=min(stepSize,end-front);
        float t=front+segment*0.5;
        vec3 p=origin+ray*t;
        bool emptyCell;
        vec4 cellColor=cloudField(p,emptyCell);
        if(emptyCell) {
            // All four interpolation corners are empty: skip to this cell's exit.
            // Retain the original march lattice so visible samples never shift.
            vec2 grid=cloudGrid(p)-0.5;
            vec2 boundary=floor(grid)+step(vec2(0),ray.xz);
            vec2 travel=(boundary-grid)*12.0/vec2(abs(ray.x)>1e-6?ray.x:1e-6,abs(ray.z)>1e-6?ray.z:1e-6);
            float exitDistance=min(abs(ray.x)>1e-6?travel.x:1e20,abs(ray.z)>1e-6?travel.y:1e20);
            i+=int(clamp(floor(exitDistance/stepSize)-1.0,0.0,255.0));
            continue;
        }
        float density=cellColor.a*cloudHeightDensity(p)*extinction;
        if(density<0.0001) continue;
        if(firstDistance>59000.0) firstDistance=front;
        float lightExit=abs(light.y)>0.02?max((light.y>0.0?cloudBottom()+4.0-p.y:cloudBottom()-p.y)/light.y,0.0):24.0;
        lightExit=min(lightExit,24.0);
        float lightDepth;
        if(count>12) lightDepth=(cloudDensity(p+light*(lightExit*0.25))+cloudDensity(p+light*(lightExit*0.75)))*lightExit*0.5;
        else lightDepth=cloudDensity(p+light*(lightExit*0.5))*lightExit;
        float height=clamp((p.y-cloudBottom())/4.0,0.0,1.0);

        vec3 sampleColor=ambient*(0.9+height*0.2)+direct*(0.35+0.75*exp(-lightDepth*0.7))*(0.75+silver);
        sampleColor*=cellColor.rgb;
        sampleColor=mix(sampleColor,horizonColor,1.0-exp(-t*0.00065));
        float opacity=1.0-exp(-density*segment);
        clouds.rgb+=sampleColor*opacity*transmission;
        transmission*=1.0-opacity;
    }
    clouds.a=1.0-transmission;
#endif
    return clouds;
}
```

## shaders/ground-mist.glsl

```glsl
// Broad, stationary patches anchored to the world, not to the camera.
float mistCell(vec2 cell) {
    cell=mod(cell,128.0);
    vec3 p=fract(vec3(cell.xyx)*0.1031);
    p+=dot(p,p.yzx+33.33);
    return fract((p.x+p.y)*p.z);
}
float mistPatch(vec2 position) {
    vec2 p=position/64.0, cell=floor(p), f=fract(p);
    f=f*f*(3.0-2.0*f);
    return mix(mix(mistCell(cell),mistCell(cell+vec2(1,0)),f.x),
        mix(mistCell(cell+vec2(0,1)),mistCell(cell+vec2(1)),f.x),f.y);
}
float sulkanGroundMist(vec3 ray,float distance) {
    if(ATMOSPHERE<=0.0 || distance<=12.0) return 0.0;
    float rain=WorldTimeWeatherDimension.y;
    float dawn=1.0-smoothstep(0.02,0.35,abs(SunDirectionAndRainBrightness.y));
    vec3 origin=vec3(mod(CameraPositionHighAndFogType.x,8192.0),CameraPositionHighAndFogType.y,
        mod(CameraPositionHighAndFogType.z,8192.0))+CameraPositionLowAndFarPlane.xyz;
    float dither=fract(sin(dot(gl_FragCoord.xy,vec2(12.9898,78.233)))*43758.5453);
    float reach=min(distance,384.0), stepLength=(reach-12.0)/3.0;
    float opticalDepth=0.0;
    for(int i=0;i<3;i++) {
        float along=12.0+(float(i)+dither)*stepLength;
        vec3 p=origin+ray*along;
        float patchDensity=smoothstep(0.45,0.8,mistPatch(p.xz));
        // Low-elevation mist; no terrain-height texture is required.
        float height=exp(-max(p.y-64.0,0.0)/18.0);
        float nearFade=smoothstep(12.0,80.0,along);
        opticalDepth+=patchDensity*height*nearFade*stepLength*(0.0007+dawn*0.0014+rain*0.002);
    }
    // Very light distant aerial perspective, concentrated near the horizon.
    float horizon=1.0-smoothstep(0.05,0.38,abs(ray.y));
    opticalDepth+=max(distance-192.0,0.0)*horizon*(0.00010+rain*0.0003);
    float fog=1.0-exp(-opticalDepth*ATMOSPHERE);
    return min(fog,mix(0.30,0.55,rain));
}
```

