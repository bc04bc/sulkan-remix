# Sulkan Remix Shaderpack

> **Next-Generation Physical Lighting Pipeline for Minecraft on Vulkan**  
> 一款基于 **Sulkan** 原生 Vulkan 渲染管线深度定制与性能优化的现代化光影包，视觉风格与照明范式深度参考 **RTX Remix**。

> [!WARNING]
> **开发状态与兼容性说明 (WIP & Compatibility Notice)**  
> - **开发阶段**：本项目当前为**开发中版本 (Work In Progress)**，包含较多前沿实验性特性，尚存在一些亟待解决的视觉与渲染显示问题。  
> - **构建基线**：当前基于 **Minecraft 26.3** + Fabric + Sodium + Sulkan 0.6.0 环境构建。由于测试环境限制，**无法保证其在不同软件（驱动、系统）与硬件平台上的完全兼容性**。  
> - **实测性能参考**：在入门级独立显卡 **AMD Radeon RX 560** 测试平台上，实测可以 **1080p 分辨率以 60 FPS+** 稳定流畅运行。

---

## 📖 项目简介 (Overview)

本项目旨在基于 Minecraft 原生底层 Vulkan 渲染引擎（Sulkan），构建一套具备现代路径追踪质感的高保真物理渲染（PBR）管线。在艺术与视觉风格上深度汲取并参考了 **NVIDIA RTX Remix** 的照明设计理念（高动态范围 HDR、胶片级色调映射、精准物理接触遮挡与微表面质感）。

同时，本项目针对着色器与渲染管线进行了**全方位深度性能优化**（包括解析微表面遮挡、快速泊松步进环境光遮蔽、几何重绘率 Overdraw 抑制与轻量化泛光算法），在兼顾卓越视觉品质的同时实现极高的能效比，确保在各种硬件环境下均能保持流畅稳定的实时高帧率。

---

## ✨ 核心特性 (Key Features)

### 1. 物理级照明与解析微遮挡 (Analytical Micro-Occlusion)
- 彻底摒弃依赖 GPU 导数阻塞的昂贵多重采样，重构为基于解析贴图的微表面法线遮挡函数。
- 在极低开销下呈现更加深邃自然的方块表面细节层次与微凹凸立体感。

### 2. 高稳定性级联方向阴影 (Stable Cascaded Shadows)
- 引入解析斜率深度偏置（Analytical Slope-Scale Bias）与切向法线外推算法。
- 彻底根除传统光影中常见的自阴影粉刺（Shadow Acne）、斜向梳状/瀑布状莫尔伪影及边缘锯齿闪烁。

### 3. 高性能屏幕空间环境光遮蔽 (Fast SSAO & Contact Shadows)
- 采用 4 步进低开销泊松圆盘（Poisson Disk）采样架构与近距离自适应平滑滤波。
- 在平滑几何体表面提供纯净无噪点、无自遮挡抖动的坚实质感接触阴影。

### 4. 轻量化 Kawase 泛光与胶片级色调映射 (Filmic Tonemapping & Bloom)
- 合并单通道对角线 Kawase 滤波核，以极小的显存带宽开销实现电影级柔和高光光晕。
- 采用优化曲线拟合的高动态范围（HDR）胶片色调映射，保留丰富暗部细节的同时防止高光过曝溢出。

### 5. 管线级深度性能优化 (Pipeline Performance Optimization)
- 精细控制透明几何体着色分支，优化 Early-Z 早期深度测试并最小化 Alpha Cutout 的纹理丢弃损耗。
- 在丛林、樱花林、繁花草地等重度 Overdraw 场景下仍能保持极具弹性的高帧率输出。

---

## 📁 项目结构 (Project Structure)

```text
├── shaderpack/                      # 主开发工程：GLSL 450 着色器源码与 sulkan.json 渲染管线配置
│   ├── sulkan.json                  # 渲染图定义与 GUI 选项配置
│   └── shaders/                     # 顶点 (vsh)、片元 (fsh) 及公共包含 (glsl) 着色器
├── build_and_deploy.py              # 一键校验、自动打包、双模组路径部署与 Vulkan 缓存清理工具
├── test_compile.py                  # 基于 LWJGL shaderc 的离线 SPIR-V 编译校验工具
├── DEVELOPMENT_GUIDE.md             # 详细的开发架构与管线调试指南
└── SULKAN_SHADERS_ALL_IN_ONE.md     # 着色器全量代码合辑快照
```

---

## 🚀 快速构建与部署 (Build & Deploy)

### 前置要求
- Python 3.8+
- 安装了 Fabric + Sodium + Sulkan 的 Minecraft 26.3 客户端

### 一键部署
在项目根目录下运行：
```bash
python build_and_deploy.py
```

构建脚本将自动执行：
1. **完整性校验**：自动校验 `sulkan.json` 配置项与选项合法性；
2. **打包封装**：自动生成 `Sulkan-RTX-Remix.zip`；
3. **光影部署**：将光影包同步注册至游戏 `shaderpacks` 目录；
4. **清理缓存**：自动清理旧的 Vulkan 二进制管线缓存（`pipeline-cache.bin`），避免旧缓存冲突。

### 游戏内热重载
无需重启游戏，进入世界后按下快捷键 **`F3 + T`** 即可触发 Vulkan 驱动即时热编译并生效。

---

## 📜 开源协议 (License)
本项目着色器实现采用 MIT 许可证。
