# Sulkan Remix Shaderpack

[![License: GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Minecraft](https://img.shields.io/badge/Minecraft-26.3-brightgreen.svg)](https://www.minecraft.net/)
[![API: Vulkan](https://img.shields.io/badge/Vulkan-1.2%20%7C%201.3-red.svg)](https://www.vulkan.org/)
[![Sodium Powered](https://img.shields.io/badge/Sodium-0.9.2-blueviolet.svg)](https://github.com/CaffeineMC/sodium-fabric)
[![Sulkan](https://img.shields.io/badge/Sulkan-0.6.0-orange.svg)](https://github.com/mravatin/sulkan)

> **Next-Generation Physical Lighting Pipeline for Minecraft on Vulkan**  
> An advanced physically based deferred shaderpack customized for Minecraft's native Vulkan renderer (**Sulkan**), referencing the visual paradigm and lighting aesthetics of **NVIDIA RTX Remix**.

[English](#english) | [中文说明](#chinese)

---

<a name="english"></a>
## English Documentation

> [!WARNING]
> ### ⚠️ Work In Progress (WIP) & Compatibility Disclaimer
> - **Active Development**: This shaderpack is currently in active development. Several visual artifacts and display quirks are known and actively being refined.
> - **Build Target**: Built and tailored for **Minecraft 26.3** + **Fabric** + **Sodium 0.9.2** + **Sulkan 0.6.0**. Due to hardware and environmental testing constraints, **seamless cross-platform compatibility cannot be guaranteed** across all operating systems, GPU architectures, and proprietary driver versions.
> - **Benchmark Reference**: Thoroughly profiled and benchmarked on an entry-level **AMD Radeon RX 560 (Polaris 21, 4GB)**; comfortably sustains **1080p @ 60 FPS+** during gameplay in survival worlds.

---

### 📖 Overview

The **Sulkan Remix** project aims to bring the filmic, physically coherent lighting atmosphere reminiscent of **NVIDIA RTX Remix** into Minecraft via native modern Vulkan graphics pipelines.

By transitioning from forward-rendered heavy geometry passes to a custom **64-bit G-Buffer Deferred Architecture**, lighting and heavy post-processing are decoupled from terrain geometry density. Complex phenomena—such as 2K cascaded sun/moon shadows, screen-space raymarched contact shadows for held torches, directional blocklight normal shading, and half-resolution chromatic GI bleeding—are calculated once per visible screen pixel with low register pressure.

---

### ✨ Core Features & Technical Architecture

#### 1. 64-bit Compact Deferred G-Buffer (`surface.data`)
- **Octahedral Normal Encoding**: Compresses geometric surface normals into 16 bits (8-bit X, 8-bit Y) with zero trigonometric operations and high precision.
- **Monotonic 24-bit Depth Matching**: Bit-shifts IEEE-754 depth (`gl_FragCoord.z`) into signed integer space with a $\pm 1$ ULP tolerance comparison against hardware `$depth`, eliminating sparkle noise on entity/terrain boundaries.
- **Packed Light & Material IDs**: Integrates torch blocklight, skylight, 4-bit material IDs (water, plants, foliage, metals, stones, emissives, ice), and fade flags into an ultra-fast `uvec2` color attachment.
- **Minimalist `terrain.fsh`**: Main pass execution time is cut by over 75%, executing Quad derivatives unconditionally before early `discard` without complex lighting loops.

#### 2. Deferred Atmospheric Physical Lighting (`atmosphere.fsh`)
- **Screen-Space Micro-Relief Bump Normals**: Reconstructs analytical micro-surface surface normals from albedo luminance gradients on bricks, ores, and wood planks.
- **Canopy Wrap Scattering (SSS)**: Renders lush jade-like translucent subsurface scattering on leaves under direct sunlight and wrap-around illumination.
- **Physical Planck Warmth**: Simulates natural blackbody radiation color temperatures for block lights, transitioning from glowing orange embers to soft yellow highlights.
- **Backlight Fresnel Rim Lighting**: Outlines block silhouettes and tree canopies under grazing sun angles.

#### 3. 2K Cascaded Directional Shadows (`SHADOW_QUALITY: 2`)
- **Quadrupled Shadow Texel Density**: Default Tier 2 cascaded shadow maps provide **2048×2048 resolution** across 4 cascades (up to 128 texels per block in the closest cascade).
- **Camera-Distance World Culling**: Custom early vertex collapse in [`sodium_terrain_shadow.vsh`](file:///d:/sulkan/shaderpack/shaders/core/sodium_terrain_shadow.vsh) discards distant grass (>16 blocks) and foliage (>32 blocks) before matrix multiplications, cutting shadow pass overhead significantly.
- **Analytical Slope-Bias**: Eliminates shadow acne and moiré banding across all sun elevation angles.

#### 4. Held-Light Raymarched Contact Shadows & Specular (`held-light.glsl`)
- **4-Step Screen-Space Raymarching**: Casts depth rays from visible surfaces toward the player's held light position, creating dynamic, moving contact shadows behind pillars, corner walls, and fences.
- **Dynamic PBR Specular**: Adds Blinn-Phong/GGX specular glints to wet rocks, metals, and water surfaces when holding torches or lanterns.
- **First-Person Hand Bloom Boost**: Detects bright flame pixels on held torches and lanterns, boosting them into HDR space to cast ambient bloom halos.

#### 5. Screen-Space Colored GI Bleeding (`lighting.fsh`)
- **Half-Resolution Chromatic Bleeding**: Upgrades `lighting.half` to `RGBA16_FLOAT`. Detects nearby emissive blocks (soul torches, sea lanterns, redstone, crying obsidian, glowstone) during 4-tap spiral sampling and radiates their pure hue across adjacent walls and floors.

#### 6. High-Performance Post-Processing (`final.fsh`)
- **Reversed-Karis Filtering**: Replaces scalar square roots with reciprocal Karis weighting for sub-pixel anti-aliasing and sharpening, effectively suppressing high-frequency fireflies and shimmering.
- **Filmic Tonemapping & Bloom**: High-speed Kawase bloom with filmic curve mapping to preserve shadow details while preventing specular blow-out.

---

### 📁 Project Structure

```text
d:/sulkan/
├── shaderpack/                      # Active shaderpack source code
│   ├── sulkan.json                  # Render graph passes, resources, and option declarations
│   └── shaders/                     # GLSL 450 fragment, vertex, and library modules
│       ├── atmosphere.fsh           # Main deferred physical lighting pass
│       ├── terrain.fsh              # Minimal 64-bit G-Buffer generation pass
│       ├── lighting.fsh             # Half-res SSAO, sun shafts & chromatic GI pass
│       ├── held-light.glsl          # Screen-space contact shadows & held-light optics
│       ├── surface-data.glsl        # 64-bit G-Buffer pack/unpack & depth matching
│       └── core/                    # Sodium shadow caster core shaders
├── build_and_deploy.py              # Automated 1-click build, dual-directory pack deployment tool
├── test_compile.py                  # Offline SPIR-V compiler validation via LWJGL shaderc
├── LICENSE                          # GNU General Public License v3.0 (GPL-3.0)
├── DEVELOPMENT_GUIDE.md             # Developer architecture and debug guidelines
└── SULKAN_SHADERS_ALL_IN_ONE.md     # Aggregated snapshot of all shader code
```

---

### 🚀 Build & Installation

#### Requirements
- **Minecraft**: 26.3 (Fabric Loader)
- **Required Mods**: [Sodium](https://modrinth.com/mod/sodium) 0.9.2+, [Sulkan](https://github.com/mravatin/sulkan) 0.6.0+
- **Environment**: Python 3.8+ (for build script)

#### 1-Click Build & Deploy
Run the automated deployment script in the project root:
```bash
python build_and_deploy.py
```
This script will:
1. Validate `sulkan.json` syntax and pass configuration.
2. Package `Sulkan-RTX-Remix.zip` into your `.minecraft/shaderpacks` directory.
3. Invalidate old Vulkan pipeline caches (`pipeline-cache.bin`).
4. Update `sulkan-shaders.json` to select the shaderpack automatically.

#### In-Game Reload
While in-game, press **`F3 + T`** to trigger an instant live SPIR-V pipeline reload.

---

### 📜 Credits & License

- **Repository License**: Distributed under the **[GNU General Public License v3.0 (GPL-3.0)](LICENSE)**.
- **Upstream Credits**:
  - **[Sulkan](https://github.com/mravatin/sulkan)** by *mravatin* & Sulkan Contributors (licensed under GPL-3.0). Core loader shadow shaders in `shaders/core/` and helper includes in `shaders/include/` originate from Sulkan.
  - **[Sodium](https://github.com/CaffeineMC/sodium-fabric)** by *CaffeineMC* (licensed under LGPL-3.0). Vertex ABI layout and chunk mesh definitions.
  - **Upstream Visual References**: Aesthetics and lighting models reference **NVIDIA RTX Remix**, with tone reproduction references documented in [`PORT.md`](file:///d:/sulkan/shaderpack/PORT.md).

---

<a name="chinese"></a>
## 中文说明 (Chinese Documentation)

> [!WARNING]
> ### ⚠️ 开发状态与兼容性说明 (WIP & Compatibility Notice)
> - **开发中版本**：本项目当前处于积极开发与实验阶段，仍存在部分亟待解决的视觉与渲染显示问题。
> - **构建基线**：当前基于 **Minecraft 26.3** + **Fabric** + **Sodium 0.9.2** + **Sulkan 0.6.0** 环境构建。由于测试环境限制，**无法保证其在不同软件（驱动、系统）与硬件平台上的完全兼容性**。
> - **实测性能参考**：在入门级硬件 **AMD Radeon RX 560 (Polaris 21, 4GB)** 测试平台上，实测可在 **1080p 分辨率下保持 60 FPS+** 稳定流畅运行。

---

### 📖 项目简介

**Sulkan Remix** 旨在基于 Minecraft 原生底层 Vulkan 渲染引擎（**Sulkan**），打造一套具备 **NVIDIA RTX Remix** 物理质感的高保真渲染管线。

通过将传统的前向渲染重构成**全新的 64-bit G-Buffer 延迟渲染架构**，把复杂光影计算解耦到全屏后处理单次执行中，在入门级显卡上兼具极高帧率与电影级画质：
1. **64-bit 延迟 G-Buffer 架构**：八面体压缩法线、单调 24-bit 整数深度比对（$\pm 1$ ULP 容差消除噪点）、4-bit 材质分类；
2. **极简地形阶段**：`terrain.fsh` 缩减至不到 30 行，前置 Quad 导数，去除所有阴影循环；
3. **延迟物理大气光照**：免贴图屏幕空间微表面凹凸微法线、树冠翡翠次表面散射（Canopy SSS）、普朗克黑体辐射暖色温、逆光边缘菲涅尔金边；
4. **2K 级联阴影与顶点剔除**：默认 2048×2048 级联阴影贴图，在 `sodium_terrain_shadow.vsh` 中按相机距离提早秒杀远景植物；
5. **手持光源 4-Step 屏幕空间动态接触阴影**：在墙角、石柱背后投射随玩家移动的动态硬朗阴影，附带 PBR 动态高光与第一人称手部自发光 Bloom 辉光；
6. **屏幕空间半分辨率彩色漫反射溢出**：灵魂火把幽蓝冷光、海晶灯青光、红石火把深红光实时浸染周围墙壁与地面；
7. **后处理加速**：Reversed-Karis 权重消除高频闪烁，标量化亮度加速抗锯齿。

---

### 🚀 构建与部署

在项目根目录下运行：
```bash
python build_and_deploy.py
```
进入游戏后，按下 **`F3 + T`** 即可即时热重载 Vulkan 着色器管线并查看效果。

---

### 📜 开源协议与致谢

- **开源协议**：本项目基于 **[GNU General Public License v3.0 (GPL-3.0)](LICENSE)** 协议开源。
- **上游致谢**：
  - **[Sulkan](https://github.com/mravatin/sulkan)** (GPL-3.0) by *mravatin* 及贡献者：提供核心 Vulkan 渲染管线与阴影中间层着色器。
  - **[Sodium](https://github.com/CaffeineMC/sodium-fabric)** (LGPL-3.0) by *CaffeineMC*：提供高性能区块几何网格与顶点 ABI。
  - **视觉参考**：参考了 **NVIDIA RTX Remix** 的物理照明风格范式与相关色调映射研究。
