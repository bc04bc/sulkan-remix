# Sulkan 光影开发与深度定制指南

本目录（`D:\sulkan`）汇集了开发与定制 Minecraft 26.3 原生 Vulkan 光影所需的全部核心文件和参考资料。

---

## 目录结构说明

- **`shaderpack/`**：**主力开发工程**。包含优化后的着色器源码与 `sulkan.json`。所有的修改都在此目录下进行。
  - `sulkan.json`：渲染图定义文件（渲染流水线 Pass、材质映射表、GUI 设置滑动条定义）。
  - `shaders/`：GLSL 450 着色器源码文件（顶点着色器 `.vsh`，片元着色器 `.fsh`，公共包含文件 `.glsl`）。
- **`shaderpack_template_original/`**：Sulkan 官方原本未修改的 `Sulkan-Realistic` 纯净备份（供对照参考）。
- **`mod_core_shaders/`**：模组注入 Sodium 渲染的底层核心阴影着色器源码（方块阴影与实体阴影）。
- **`reference_api/`**：反编译提取的 Sulkan 核心类定义（`PackGraph`、`GraphRenderer`、`GpuCapabilities` 等），方便查阅底层如何解析与绑定。
- **`build_and_deploy.py`**：**一键构建与部署脚本**。

---

## 快速开发工作流（极简高效）

1. **修改代码**：
   在 `D:\sulkan\shaderpack\shaders\` 下编辑 GLSL 着色器，或编辑 `sulkan.json`。
2. **一键构建与部署**：
   在终端或命令行中直接运行：
   ```bash
   python D:\sulkan\build_and_deploy.py
   ```
   该脚本会自动完成：
   - 检查 `sulkan.json` 语法与选项合法性（防止非法档位报错）；
   - 自动打包并写回模组 JAR 包内部以及 `shaderpacks` 目录；
   - 自动清除旧的 Vulkan 管线二进制缓存（`pipeline-cache.bin`）。
3. **游戏内立即生效**：
   - 游戏不需要重启！进入游戏世界后按下 **`F3 + T`**（或在着色器设置页面点击 **`Reload`**），修改的着色器就会在 Vulkan 驱动中热编译并立即呈现在屏幕上。

---

## 关键着色器职责速查

| 文件路径 | 职责与效果 | 定制重点 |
| :--- | :--- | :--- |
| `shaders/palette.glsl` | 阳光、月光色温与水体色调 | 控制昼夜冷暖、中性自然日光 |
| `shaders/environment.glsl` | 天空渐变、太阳/月亮盘面与星空 | 绘制物理天穹、控制天光散射与太阳眩光 |
| `shaders/clouds.fsh` & `cloud-volume.glsl` | 3D 体积云光线步进算法 | 控制云朵密度、步进步长与性能开销 |
| `shaders/water-reflections.fsh` & `water-resolve.glsl` | 水面/冰面屏幕空间反射（SSR） | 掠射角菲涅尔反射、棋盘格加速光线追踪 |
| `shaders/lighting.fsh` | 接触阴影（AO）与太阳体积光（丁达尔效应） | 控制方块边缘暗部细节与光柱效果 |
| `shaders/tonemap.glsl` | 色调映射（Tonemapping）与色彩饱和度 | 控制画面对比度、高光保护、暗部细节 |
| `shaders/final.fsh` | 最终合成输出 Pass | 叠加泛光（Bloom）、自动曝光（Auto-exposure） |

---

## `sulkan.json` 规则与避坑指南

1. **选项默认值校验**：
   `options` 中定义的任何设置项，其 `"default"` 必须精确包含在 `"values"` 数组内，否则解析器会抛出 `IllegalArgumentException` 拒绝加载。
2. **材质分流（Materials）**：
   `materials` 中映射了每个方块对应的 Material ID：
   - 水：`1`
   - 草/花：`2 ~ 4`
   - 树叶：`5`
   - 金属（铁、金、铜、下界合金）：`6`
   - 石头/深板岩：`7`
   - 木板：`8`
   - 发光方块（萤石、岩浆、海晶灯）：`9 ~ 11`
   - 冰：`12 ~ 14`
   在着色器中可以通过 `surface.data` 读取并赋予不同的金属度、粗糙度与发光遮罩，这是实现类似 RTX Remix 质感的核心！
