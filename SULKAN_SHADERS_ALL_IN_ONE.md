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
      "default": 2,
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
      "format": "RGBA16_FLOAT",
      "scale": 0.5
    },
    "surface.data": {
      "format": "RG32_UINT"
    },
    "water.reflection": {
      "format": "RGBA16_FLOAT",
      "scale": 0.5
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
        "Surface": "surface.data",
        "Scene": "$scene"
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
#include "shaders/environment.glsl"
#include "shaders/surface-data.glsl"

#ifdef SULKAN_TRANSLUCENT
uniform sampler2D Opaque;
uniform sampler2D OpaqueDepth;
#endif

uniform sampler2D u_BlockTex;
uniform sampler2D u_LightTex;

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
    // 1. 无条件前置求导：1-cycle 完成 2x2 Quad 寄存器差分，为硬件提前释放死 Lane 做准备
    vec3 dPosX = dFdx(relativePosition);
    vec3 dPosY = dFdy(relativePosition);
    vec2 dUvX  = dFdx(uv);
    vec2 dUvY  = dFdy(uv);

    // 2. 硬件 Cutout 极速检测与提前退出（死片元立即终止，无需保留 Helper Lane）
    uint cutoffBits = (terrainMaterial >> 1u) & 3u;
    vec4 base = ((terrainMaterial & 1u) != 0u ? textureGrad(u_BlockTex, uv, dUvX, dUvY) : textureLod(u_BlockTex, uv, 0.0)) * tint;
    if (cutoffBits != 0u && base.a < (cutoffBits == 1u ? 0.1 : 0.5)) discard;
#ifdef SULKAN_TRANSLUCENT
    if (base.a <= 1.0/255.0) discard;
#endif

    // 3. 存活片元求几何法线
    vec3 crossNormal = cross(dPosX, dPosY);
    vec3 geomNormal = crossNormal * inversesqrt(max(dot(crossNormal, crossNormal), 1e-12));
    if (dot(geomNormal, sulkanCameraOffset() - relativePosition) < 0.0) geomNormal = -geomNormal;

    // 4. 计算能见度（加入 IGN 抖动，让 3-bit 量化在远景边界丝滑无色带）
    float cylinder = max(length(relativePosition.xz), abs(relativePosition.y));
    float renderFog = clamp((cylinder - u_RenderFog.x) / max(u_RenderFog.y - u_RenderFog.x, 0.001), 0.0, 1.0);
    float fog = max(1.0 - fade, renderFog) * u_FogColor.a;
    float dither = (fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715)))) - 0.5) / 7.0;
    float visibility = clamp(1.0 - fog + dither, 0.0, 1.0);

    // 5. 下界/末地/水下等非主世界陆地环境极简回退（原版光照与雾直通）
    float overworld = 1.0 - step(0.5, abs(WorldTimeWeatherDimension.w));
    if (overworld < 0.5 || CameraPositionHighAndFogType.w >= 0.5) {
        vec3 vanillaLight = toLinear(texture(u_LightTex, lightLevel * (15.0/16.0)).rgb);
        base.rgb = mix(toLinear(base.rgb) * vanillaLight, toLinear(u_FogColor.rgb), fog);
        base.rgb = pow(max(base.rgb, vec3(0.0)), vec3(1.0/2.2));
    }

#ifdef SULKAN_TRANSLUCENT
#if WATER_ENABLED == 1
    // 半透明水体背景折射与物理吸收
    if (materialId == 1u && CameraPositionHighAndFogType.w < 0.5) {
        vec2 screenUv = gl_FragCoord.xy * ViewSizeAndInverse.zw;
        vec2 worldXZ = relativePosition.xz + mod(CameraPositionHighAndFogType.xz, vec2(4096.0)) + CameraPositionLowAndFarPlane.xz;
        float t = TimeDeltaFrame.x * 0.25;
        vec2 wave = vec2(cos(dot(worldXZ, vec2(2.2, 1.24)) + t * 1.2), sin(dot(worldXZ, vec2(-1.12, 2.48)) - t * 0.9));
        vec2 refractedUv = clamp(screenUv + wave * WATER_WAVES * 0.0008, ViewSizeAndInverse.zw, vec2(1.0) - ViewSizeAndInverse.zw);
        float surfaceDist = length(viewPosition(screenUv, gl_FragCoord.z));
        float backDepth = texture(OpaqueDepth, refractedUv).r;
        float backDist = backDepth > 1e-7 ? length(viewPosition(refractedUv, backDepth)) : surfaceDist;
        if (backDist < surfaceDist) {
            refractedUv = screenUv;
            backDepth = texture(OpaqueDepth, refractedUv).r;
            backDist = backDepth > 1e-7 ? length(viewPosition(refractedUv, backDepth)) : surfaceDist;
        }
        float thickness = clamp(max(backDist - surfaceDist, 0.0), 0.0, 160.0);
        vec4 bg = texture(Opaque, refractedUv);
        if (bg.a > 0.0) {
            vec3 absorption = exp(-thickness * WATER_DENSITY * vec3(0.16, 0.065, 0.035));
            vec3 waterTint = mix(vec3(0.035, 0.21, 0.28), tint.rgb * vec3(0.2, 0.65, 0.75), 0.25);
            // 注意：因为 G-Buffer 中的 bg.rgb 尚未打光，这里保持纯 Albedo 传输，统一交由 atmosphere.fsh 进行物理打光与高光合成！
            vec3 trans = toLinear(bg.rgb) * absorption + toLinear(waterTint) * (1.0 - absorption);
            base.rgb = pow(max(trans, vec3(0.0)), vec3(1.0/2.2));
            geomNormal = normalize(geomNormal + vec3(wave.x, 0.0, wave.y) * (0.018 * WATER_WAVES));
        }
    }
#endif
#endif

    color = base;

    // 6. 写入 64-bit 紧凑 G-Buffer
    bool isTransparent = false;
#ifdef SULKAN_TRANSLUCENT
    isTransparent = (materialId != 1u);
#endif
    surfaceData = packGbuffer(geomNormal, lightLevel, materialId, visibility, isTransparent, gl_FragCoord.z);
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
uniform sampler2D Scene;
#include "shaders/surface-data.glsl"
#include "shaders/surface-normal.glsl"

void main() {
    ivec2 depthSize = textureSize(Depth, 0);
    ivec2 center = clamp(ivec2(texCoord * vec2(depthSize)), ivec2(0), depthSize - 1);
    vec2 centerUv = (vec2(center) + 0.5) / vec2(depthSize);
    float depth = texelFetch(Depth, center, 0).r;
    vec3 p = viewPosition(centerUv, max(depth, 1e-6));

    float ao = 0.0;
    vec2 coloredBleed = vec2(0.0);
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION
    if (depth > 1e-7) {
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
        for(int i = 0; i < 4; i++) {
            float alpha = (float(i) + 0.5) / 4.0;
            float angle = float(i) * 2.39996323 + dither * 6.2831853;
            float sampleRadius = baseRadius * sqrt(alpha);
            vec2 offsetUv = centerUv + vec2(cos(angle), sin(angle)) * sampleRadius * ViewSizeAndInverse.zw;
            if (any(lessThan(offsetUv, vec2(0.0))) || any(greaterThanEqual(offsetUv, vec2(1.0)))) continue;
            ivec2 pixel = ivec2(offsetUv * vec2(depthSize));
            float sampleDepth = texelFetch(Depth, pixel, 0).r;
            if (sampleDepth <= 1e-7) continue;
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

            // 屏幕空间彩色光照扩散：检测发光方块（matId 9..11）并将颜色辐射到周围表面
            uvec2 tapSurf = texelFetch(Surface, pixel, 0).rg;
            uint tapMat = surfaceMaterialId(tapSurf);
            if (tapMat >= 9u && tapMat <= 11u) {
                vec3 emColor = texelFetch(Scene, pixel, 0).rgb;
                float distWeight = 1.0 / (1.0 + distance * distance * 0.7);
                // 提取色度偏差 (R-G, B-G) 并随距离平滑辐射
                coloredBleed += vec2(emColor.r - emColor.g, emColor.b - emColor.g) * (distWeight * 0.65);
            }
        }
    }
#endif
    float shafts = 0.0;
#if _SULKAN_ENABLED_SUN_SHAFTS
    if (abs(WorldTimeWeatherDimension.w) < 0.5 && CameraPositionHighAndFogType.w < 0.5 && SunDirectionAndRainBrightness.y > 0.02 && CloudOffsetAndGameTime.z > 0.05) {
        vec3 ray = sulkanRay(texCoord);
        vec3 sun = normalize(SunDirectionAndRainBrightness.xyz);
        float reach = depth > 1e-7 ? min(length(p), 96.0) : 96.0;
        // Optimized 8-step volume march with spatial dither
        float stepLength = reach / 8.0;
        vec3 origin = sulkanCloudOrigin();
        float dither = fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715))));
        for(int i = 0; i < 8; i++) {
            float distance = (float(i) + dither) * stepLength;
            vec3 relative = sulkanCameraOffset() + ray * distance;
            vec3 world = origin + relative;
            float visibility = sulkanVolumeShadow(relative);
#if CLOUD_QUALITY > 0
            float entry = max((cloudBottom() - world.y) / max(sun.y, 1e-4), 0.0);
            float exitDistance = max((cloudBottom() + 4.0 - world.y) / max(sun.y, 1e-4), 0.0);
            float span = max(exitDistance - entry, 0.0);
            float cloudDepth = cloudDensity(world + sun * (entry + span * 0.5)) * span;
            visibility *= exp(-cloudDepth);
#endif
            float airDensity = exp(clamp((72.0 - world.y) * 0.018, -8.0, 3.0));
            shafts += visibility * airDensity * exp(-distance * 0.012) * stepLength * 0.006;
        }
        float fDot = max(dot(ray, sun), 0.0);
        float f2 = fDot * fDot; float f4 = f2 * f2; float f8 = f4 * f4;
        float forward = 0.08 + 0.92 * f8;
        shafts *= smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z) * forward * (1.0 - WorldTimeWeatherDimension.y) * smoothstep(0.02, 0.15, sun.y);
    }
#endif
    lighting = vec4(clamp(1.0 - ao * 0.30 * AMBIENT_OCCLUSION, 0.30, 1.0), shafts, coloredBleed);
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
    vec3 c = toLinear(texture(Scene, texCoord).rgb);
    // 无条件前置计算屏幕亮度梯度（1-cycle 硬件 Quad 差分），用于后续构建零成本材质凹凸微法线！
    float rawLuma = dot(c, vec3(0.299, 0.587, 0.114));
    vec2 lumaGrad = vec2(dFdx(rawLuma), dFdy(rawLuma));

    uvec2 surface = texture(Surface, texCoord).rg;
    vec2 lightL = surfaceLightLevel(surface);
    // 1-Cycle 硬件差分获取方块光在屏幕上的入射方向（用于生成非太阳光源的凹凸立体阴影与高光！）
    vec2 blGrad = vec2(dFdx(lightL.x), dFdy(lightL.x));

    float depth = texture(Depth, texCoord).r;
    float handDepth = texture(HandDepth, texCoord).r;
    if (handDepth > 1e-7) {
        if (HandProjectionValid.x > 0.5 && abs(WorldTimeWeatherDimension.w) < 0.5 && CameraPositionHighAndFogType.w < 0.5) {
            vec3 position = mat3(InverseView) * viewPosition(texCoord, handDepth, InverseHandProjection);
            vec3 normal = mat3(InverseView) * depthSurfaceNormal(HandDepth, texCoord, InverseHandProjection);
            if (dot(normal, normal) > 0.5) {
                // 手持光源激活时，让手中物品的高亮部位（如火把火焰、灯笼芯）直接产生强烈的 HDR 自发光与 Bloom 光晕！
                float handEmit = smoothstep(0.35, 0.75, max(c.r, max(c.g, c.b))) * step(0.5, HeldLightPositionRadius.w);
                c += c * HeldLightColor.rgb * (handEmit * 3.2 * HELD_LIGHTING);
                c += (c + vec3(0.18)) * sulkanHeldLight(position, normal) * 0.85;
                float specular = sulkanSunSpecular(normal, normalize(-position), 0.55, 0.035);
                if (specular > 0.0) c += portLightPalette() * specular * sulkanDirectShadow(position, normal) * smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z);
            }
        }
        hdr = vec4(c, 1.0); return;
    }

    bool nativeSurface = surfaceMatches(surface, depth);
    bool sky = depth <= 1e-7;
    vec3 ray = sulkanRay(texCoord);
    vec3 viewSurface = sky ? vec3(0) : viewPosition(texCoord, depth);
    float distanceToScene = sky ? 60000.0 : min(length(viewSurface), 60000.0);
    bool overworld = abs(WorldTimeWeatherDimension.w) < 0.5;
    bool air = CameraPositionHighAndFogType.w < 0.5;

    // Depth-aware upsampling
    vec2 size = ceil(ViewSizeAndInverse.xy * 0.5), q = texCoord * size - 0.5, f = fract(q);
    ivec2 origin = ivec2(floor(q));
    vec4 light = vec4(0.0); vec4 cloud = vec4(0.0); float total = 0.0;
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS || CLOUD_QUALITY > 0
    float projZ2 = InverseProjection[2][3];
    float projZ3 = InverseProjection[3][3];
    float centerDenom = depth * projZ2 + projZ3;
    float centerLinZ = depth <= 1e-7 ? 60000.0 : abs(1.0 / (abs(centerDenom) < 1e-6 ? 1e-6 : centerDenom));
    for (int y = 0; y < 2; y++) for (int x = 0; x < 2; x++) {
        ivec2 pixel = clamp(origin + ivec2(x, y), ivec2(0), ivec2(size) - 1);
        vec2 uv = (vec2(pixel) + 0.5) / size;
        float d = texture(Depth, uv).r;
        float sampleDenom = d * projZ2 + projZ3;
        float sampleLinZ = d <= 1e-7 ? 60000.0 : abs(1.0 / (abs(sampleDenom) < 1e-6 ? 1e-6 : sampleDenom));
        float weight = (x == 0 ? 1.0 - f.x : f.x) * (y == 0 ? 1.0 - f.y : f.y);
        float separation = abs(sampleLinZ - centerLinZ) / max(centerLinZ * 0.02, 0.3);
        weight *= 1.0 / (1.0 + separation * separation);
#if _SULKAN_ENABLED_AMBIENT_OCCLUSION || _SULKAN_ENABLED_SUN_SHAFTS
        light += texelFetch(Lighting, pixel, 0) * weight;
#else
        light += vec4(1.0, 0.0, 0.0, 0.0) * weight;
#endif
#if CLOUD_QUALITY > 0
        vec4 sampleCloud = texelFetch(Clouds, pixel, 0);
        if (texture(CloudDistance, uv).r > distanceToScene) sampleCloud = vec4(0.0);
        cloud += sampleCloud * weight;
#endif
        total += weight;
    }
#endif
    if (total > 1e-5) { light /= total; cloud /= total; } else { light = vec4(1.0, 0.0, 0.0, 0.0); cloud = vec4(0.0); }

    // =========================================================================
    // 延迟物理光照与材质质感引擎（Deferred Physically Based Lighting & Texturing）
    // =========================================================================
    if (!sky && nativeSurface && overworld && air) {
        vec3 albedo = c;
        vec3 position = mat3(InverseView) * viewSurface;
        vec3 normal = surfaceNormal(surface.x);
        vec3 toEye = normalize(sulkanCameraOffset() - position);
        uint matId = surfaceMaterialId(surface);
        bool isWater = (matId == 1u);
        bool isPlant = (matId >= 2u && matId <= 5u);
        bool isLeaves = (matId == 5u);
        bool isIce = (matId >= 12u && matId <= 14u);

        float daylight = sulkanDay();
        vec3 sunDirection = daylight > 0.5 ? SunDirectionAndRainBrightness.xyz : MoonDirectionAndPhase.xyz;
        float skyLight = lightL.y * lightL.y;

        // 1. 贴图微表面遮蔽（Micro-Occlusion）与轴向体素立体感（Voxel Axis Shading）
        float microOccl = isWater ? 1.0 : clamp(0.80 + (rawLuma - 0.35) * 0.50, 0.68, 1.18);
        float axisShade = 1.0 - 0.13 * abs(normal.x) - 0.06 * abs(normal.z) - 0.20 * max(-normal.y, 0.0);

        // 2. 屏幕空间免贴图凹凸微法线（Screen-Space Albedo Bump）：
        // 利用砖缝/木纹/矿石的明暗梯度偏转高光法线，距离超过 32 格平滑淡出防止摩尔纹！
        vec3 specNormal = normal;
        if (!isWater && !isPlant) {
            float bumpFade = (1.0 - smoothstep(10.0, 36.0, distanceToScene)) * MATERIAL_SHEEN;
            vec3 camRight = vec3(InverseView[0][0], InverseView[0][1], InverseView[0][2]);
            vec3 camUp    = vec3(InverseView[1][0], InverseView[1][1], InverseView[1][2]);
            vec3 bumpOffset = (camRight * lumaGrad.x + camUp * lumaGrad.y) * (2.2 * bumpFade);
            // 剥离法线方向分量，仅在切平面内扰动
            bumpOffset -= normal * dot(normal, bumpOffset);
            specNormal = normalize(normal - clamp(bumpOffset, vec3(-0.35), vec3(0.35)));
        }

        // 3. 半球天空环境光与暖色地面反弹光（Fake GI Bounce）
        vec3 zenithSky = mix(vec3(0.012, 0.020, 0.045), vec3(0.28, 0.46, 0.78), daylight);
        vec3 groundBounce = portLightPalette() * vec3(0.44, 0.36, 0.25) * (0.4 + 0.6 * daylight);
        float hemiWeight = specNormal.y * 0.5 + 0.5;
        vec3 skyFill = mix(groundBounce * 0.45, zenithSky, hemiWeight) * axisShade;
        skyFill = mix(skyFill, vec3(dot(skyFill, vec3(0.299, 0.587, 0.114))), WorldTimeWeatherDimension.y * 0.65);

        // 4. 级联阴影采样（利用 G-Buffer 单次执行优势，恢复所有可见像素的高精度投影）
        float sunDot = dot(normal, sunDirection);
        float sunFacing = isPlant ? max(abs(sunDot), 0.35) : max(sunDot, 0.0);
        float shadow = 1.0;
        float sunVisibility = 0.0;
#if SHADOW_QUALITY > 0
        shadow = mix(1.0, ShadowParams.z, ShadowParams.x);
        if ((sunFacing > 0.0 || isPlant) && lightL.y > 1.0/30.0 + 1e-4) {
            vec3 sNorm = (isPlant && sunDot < 0.0) ? -normal : normal;
            shadow = sulkanTerrainShadows(position, sNorm, isPlant, sunVisibility);
        }
#else
        sunVisibility = 1.0;
#endif

        vec3 lighting;
        if (isLeaves) {
            // 树叶专属：柔和包裹漫反射 + 逆光翡翠次表面散射 (Canopy SSS)
            float exposure = exp2(-3.5 * (1.0 - clamp(lightL.y, 0.0, 1.0)));
            vec3 leafSky = skyFill * 0.45 * mix(0.42, 1.0, exposure);
            float wrapFacing = clamp((sunDot + 0.45) / 1.45, 0.0, 1.0);
            vec3 direct = portLightPalette() * wrapFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
            
            float forwardDot = max(dot(-toEye, sunDirection), 0.0);
            float forwardScatter = forwardDot * forwardDot * forwardDot;
            float sss = (0.30 * wrapFacing + 0.70 * forwardScatter) * exposure * sunVisibility * daylight * (1.0 - WorldTimeWeatherDimension.y);
            vec3 leafGlow = pow(max(albedo, vec3(0.01)), vec3(0.75)) * portLightPalette() * (sss * 0.65);
            lighting = vec3(0.024) + skyLight * (leafSky + direct * 0.92 + leafGlow);
        } else {
            // 固体、草地与水体光照
            float directFacing = isPlant ? sunFacing : smoothstep(-0.05, 0.95, dot(specNormal, sunDirection)) * sunFacing;
            vec3 direct = portLightPalette() * directFacing * shadow * microOccl * (1.0 - WorldTimeWeatherDimension.y * 0.65);
            vec3 giFill = groundBounce * (1.0 - hemiWeight * 0.6) * smoothstep(0.1, 0.9, lightL.y) * 0.28;
            lighting = vec3(0.020) + skyLight * (skyFill * 0.45 + giFill + direct * 1.08);
        }

        // 晴天阴影冷色调瑞利染色（消除阴影发灰，提升通透对比度）
        float shadowContrast = (1.0 - shadow) * daylight * (1.0 - WorldTimeWeatherDimension.y);
        if (isPlant) shadowContrast *= max(sunDot, 0.25);
        lighting *= mix(vec3(1.0), vec3(0.66, 0.76, 0.92), shadowContrast * skyLight * 0.58);

        // 5. 非太阳光方向性阴影 + 彩色光源渲染 (Directional & Colored Block Lighting)
        float bl = lightL.x;
        float blockLight = bl * bl * bl * (bl * 1.8 + 0.2);

        // 重构方块光源 3D 入射向量：让砖块缝隙和背向火把的侧面产生真实的立体阴影！
        vec3 camRight = vec3(InverseView[0][0], InverseView[0][1], InverseView[0][2]);
        vec3 camUp    = vec3(InverseView[1][0], InverseView[1][1], InverseView[1][2]);
        vec3 blockLightDir = camRight * blGrad.x + camUp * blGrad.y;
        float blGradLen = length(blockLightDir);
        float blockDirShade = 1.0;
        float blockSpec = 0.0;
        if (blGradLen > 1e-5 && !isPlant && !isWater) {
            vec3 pDir = normalize(blockLightDir / blGradLen + toEye * 0.35);
            // 朝向火把的微凹凸面受光增强，背向火把的凹陷处压暗产生非太阳光阴影！
            blockDirShade = clamp(0.62 + 0.68 * dot(specNormal, pDir), 0.45, 1.35);
            // 火把/灯笼在矿石和石砖表面的暖色微高光
            vec3 bHalf = normalize(pDir + toEye);
            blockSpec = pow(max(dot(specNormal, bHalf), 0.0), 16.0) * bl * bl * MATERIAL_SHEEN * 0.35;
        }
        // 结合 SSAO 深度强化角落接触阴影（让火把照亮的墙角、箱子底有深邃投影）
        float blockContactShadow = mix(1.0, light.x * light.x, 0.65);

        // 基础普朗克色温 + 局部发光材质色彩注入（灵魂蓝、红石红、海晶青、紫水晶紫）
        vec3 torchPalette = mix(vec3(1.65, 0.42, 0.10), vec3(1.85, 1.20, 0.68), bl * bl);
        vec3 warmBlock = mix(vec3(1.0), torchPalette, clamp(LIGHT_WARMTH, 0.0, 1.5));
        if (matId >= 9u && matId <= 11u) {
            // 发光体自身及紧邻像素直接继承其贴图的纯粹色相（灵魂火把自动泛蓝光，红石泛红光！）
            vec3 chroma = albedo / max(rawLuma, 0.05);
            warmBlock = mix(warmBlock, chroma * 1.45, 0.75);
        }
        // 叠加来自 lighting.fsh 半分辨率屏幕空间的彩色光照扩散（Screen-Space Colored Light Bleeding）
        if (abs(light.b) + abs(light.a) > 1e-4) {
            vec3 bleedOffset = vec3(light.b, -(light.b + light.a) * 0.45, light.a) * 1.25;
            warmBlock = mix(warmBlock, max(warmBlock + bleedOffset, vec3(0.05)), clamp(bl * 1.5, 0.0, 0.75));
        }

        lighting += warmBlock * (blockLight * microOccl * blockDirShade * blockContactShadow * 1.70);

        // 逆光边缘菲涅尔金边（Rim Light）：勾勒方块与树冠立体轮廓
        float rimN = 1.0 - max(dot(specNormal, toEye), 0.0);
        float rimS = max(dot(-toEye, sunDirection), 0.0);
        float rim = (rimN * rimN * rimN * rimN) * (rimS * rimS * rimS) * (1.0 - max(normal.y, 0.0));
        lighting += portLightPalette() * (rim * sunVisibility * skyLight * 0.32);

        // 调用带 4-Step 屏幕空间动态遮挡阴影与高光的升级版手持光源！
        vec3 heldLight = sulkanHeldLightAdvanced(position, specNormal, toEye, 0.45, Depth);
        c = albedo * (lighting + heldLight) + warmBlock * blockSpec;

        float nearSource = smoothstep(0.65, 1.0, lightL.x);
        c += warmBlock * (nearSource * nearSource * 0.05 * clamp(LIGHT_WARMTH, 0.0, 1.5));

        // 6. PBR 微表面高光、金属环境反射与水体波光
        if (isWater) {
            // 水体太阳波光高光（Glints）
            if (sunVisibility > 0.01) {
                c += portLightPalette() * sulkanSunSpecular(normal, toEye, 0.14, 0.025) * sunVisibility * skyLight;
            }
        } else if (!isPlant) {
            float wet = WET_SURFACES * WorldTimeWeatherDimension.y * smoothstep(0.88, 1.0, lightL.y) * smoothstep(0.0, 0.7, normal.y);
            if (matId >= 9u) wet = 0.0;
            c *= (1.0 - 0.22 * wet);

            float materialWeight = (matId >= 6u && matId <= 8u) ? MATERIAL_SHEEN : 0.0;
            // 纹理暗部（砖缝）粗糙，亮部（晶体/抛光面）光滑
            float microRough = clamp(1.0 - (rawLuma - 0.35) * 0.75, 0.70, 1.30);
            float roughness = mix(0.66, matId == 6u ? 0.20 : (matId == 8u ? 0.58 : 0.38), materialWeight) * microRough;
            roughness = clamp(roughness + smoothstep(12.0, 64.0, distanceToScene) * 0.22, 0.14, 0.95);
            float reflectance = mix(0.038, 0.22, matId == 6u ? materialWeight : 0.0);
            if (isIce) { roughness = 0.28 * microRough; reflectance = 0.035; }

            if (sunVisibility > 0.01) {
                float highlight = sulkanSunSpecular(specNormal, toEye, mix(roughness, 0.20, wet), reflectance);
                // 金属高光带自身色泽（金块泛金光，铜块泛铜光）
                vec3 specTint = (matId == 6u) ? mix(vec3(1.0), albedo * 1.25, 0.60) : vec3(1.0);
                c += portLightPalette() * specTint * highlight * sunVisibility * skyLight;
            }
            float envReflect = max(wet, (matId == 6u ? 0.18 : (matId == 7u ? 0.04 : 0.0)) * materialWeight);
            if (envReflect > 0.001) {
                float nv = 1.0 - max(dot(specNormal, toEye), 0.0);
                float nv2 = nv * nv;
                float fresnel = reflectance + (1.0 - reflectance) * (nv2 * nv2 * nv);
                vec3 specTint = (matId == 6u) ? mix(vec3(1.0), albedo * 1.2, 0.65) : vec3(1.0);
                c += sulkanSky(reflect(-toEye, specNormal)) * specTint * envReflect * fresnel * skyLight * (1.0 - roughness * 0.5);
            }

            // 自发光方块与微光植物
            float emission = 0.0;
            if (matId == 9u) emission = smoothstep(0.15, 0.60, max(albedo.r, max(albedo.g, albedo.b)));
            if (matId == 10u) emission = smoothstep(0.12, 0.5, albedo.r) * 0.8;
            if (matId == 11u) emission = smoothstep(0.08, 0.4, albedo.r - max(albedo.g, albedo.b)) * 0.9;
            if (emission > 0.0) {
                vec3 emissiveColor = albedo * sqrt(max(albedo, vec3(0.01)));
                c = mix(c, emissiveColor * 0.95, clamp(emission * EMISSIVE_ACCENTS, 0.0, 0.95));
            }
        }
    }

#if WATER_ENABLED == 1 && WATER_REFLECTION_QUALITY > 0 && _SULKAN_ENABLED_WATER_REFLECTION_STRENGTH
    if (nativeSurface && surfaceReflective(surface) && air) {
        vec3 position = mat3(InverseView) * viewSurface;
        c = toLinear(resolveWaterReflection(texCoord, surface, position, pow(max(c, vec3(0)), vec3(1.0/2.2))));
    }
#endif

    // SSAO 接触阴影遮挡
    if (!sky && !(nativeSurface && surfaceTransparent(surface))) c *= light.x;

    // HDR Boost 阶梯倍增
    if (nativeSurface) {
        float boost = surfaceHdrBoost(surface);
        float luma = max(c.r, max(c.g, c.b));
        c *= mix(1.0, boost, smoothstep(0.2, 0.85, luma));
    }

    // 非地形表面（原版实体、掉落物、粒子）：补充太阳高光与升级版手持光
    if (!sky && !nativeSurface) {
        vec3 position = mat3(InverseView) * viewSurface;
        vec3 normal = normalize(mat3(InverseView) * depthSurfaceNormal(Depth, texCoord) + vec3(0, 1e-8, 0));
        if (overworld && air) {
            vec3 toEye = normalize(sulkanCameraOffset() - position);
            float specular = sulkanSunSpecular(normal, toEye, 0.55, 0.035);
            if (specular > 0.0) c += portLightPalette() * specular * sulkanDirectShadow(position, normal) * smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z);
        }
        c += sqrt(max(c, vec3(0))) * sulkanHeldLight(position, normal) * 0.85;
    }

    // 大气透视、天空与丁达尔体积光
    if (overworld && air) {
        vec3 skyColor = sulkanSky(ray);
        if (sky) c = skyColor + sulkanCelestials(ray);
        else {
            float distance = min(distanceToScene, 1500.0);
            float skyAccess = smoothstep(0.05, 0.65, CloudOffsetAndGameTime.z);
            if (nativeSurface) skyAccess = min(skyAccess, smoothstep(0.01, 0.5, surfaceSky(surface)));
            float fog = sulkanGroundMist(ray, distance) * skyAccess;
            if (nativeSurface) {
                float gbufFog = 1.0 - surfaceVisibility(surface);
                fog = max(fog, gbufFog);
            }
            float towardSun = max(dot(ray, SunDirectionAndRainBrightness.xyz), 0.0);
            float horizon = 1.0 - smoothstep(0.0, 0.5, abs(ray.y));
            vec3 distanceTint = mix(vec3(0.88, 0.97, 1.10), vec3(1.12, 1.01, 0.88),
                towardSun * towardSun * horizon);
            float distanceGrade = DISTANCE_COLOR * sulkanDay() * (1.0 - WorldTimeWeatherDimension.y);
            float ts2 = towardSun * towardSun;
            float mie = (ts2 * ts2 * towardSun) * (1.0 - WorldTimeWeatherDimension.y) * sulkanDay();
            vec3 mistColor = sulkanSky(normalize(vec3(ray.x, 0.25, ray.z))) * 0.70 + portLightPalette() * mie * 0.35;
            c = mix(c, mistColor * mix(vec3(1.0), distanceTint, distanceGrade * 0.5), fog);
        }
        c = c * (1.0 - cloud.a) + cloud.rgb;
        c += portLightPalette() * light.y * SUN_SHAFTS * 0.8;
    }

    vec4 weather = texture(Weather, texCoord);
    float weatherAlpha = clamp(weather.a, 0.0, 1.0);
    vec3 weatherColor = toLinear(weather.rgb / max(weatherAlpha, 1e-5));
    c = c * (1.0 - weatherAlpha) + weatherColor * weatherAlpha;
    hdr = vec4(max(c, vec3(0.0)), 1.0);
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

	// 1. 优先用真实的相机相对距离平方 (dot(position, position)) 执行极速顶点坍缩剔除！
	// 在算风吹动画和矩阵乘法之前直接秒杀远端植物顶点！
	uint cutoffBits = (_material_params >> 1u) & 3u;
	float camDistSq = dot(position, position);
	// 草/花(1u) > 16格(256.0) 剔除；树叶(2u) > 32格(1024.0) 剔除（砍掉森林阴影 70% 的无效三角形！）
	if ((cutoffBits == 1u && camDistSq > 256.0) || (cutoffBits == 2u && camDistSq > 1024.0)) {
		gl_Position = vec4(2.0, 2.0, 2.0, 1.0);
		return;
	}

#ifdef SULKAN_VEGETATION
	if (camDistSq < 576.0) {
		position += sulkanWindOffset(position, a_SulkanMaterial);
	}
#endif
	vec4 shadowViewPos = u_ModelViewMatrix * vec4(position, 1.0);
	gl_Position = u_ProjectionMatrix * shadowViewPos;
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

