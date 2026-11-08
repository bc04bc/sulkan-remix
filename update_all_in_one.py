# Sulkan All-In-One Codebase Aggregator Tool
# Usage: python update_all_in_one.py
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SRC_DIR = os.path.join(SCRIPT_DIR, 'shaderpack')
OUT_FILE = os.path.join(SCRIPT_DIR, 'SULKAN_SHADERS_ALL_IN_ONE.md')

# Logical ordering of files
PRIORITY_ORDER = [
    # 1. Config
    'sulkan.json',
    # 2. Main Terrain Geometry
    'shaders/terrain.vsh',
    'shaders/terrain.fsh',
    # 3. Post-Processing & Lighting Passes
    'shaders/lighting.fsh',
    'shaders/water-reflections.fsh',
    'shaders/atmosphere.fsh',
    'shaders/clouds.fsh',
    'shaders/bloom-seed.fsh',
    'shaders/bloom-wide.fsh',
    'shaders/blur-x.fsh',
    'shaders/blur-y.fsh',
    'shaders/exposure-meter.fsh',
    'shaders/exposure-adapt.fsh',
    'shaders/final.fsh',
    # 4. Core Shadow Passes
    'shaders/core/sodium_terrain_shadow.vsh',
    'shaders/core/sodium_terrain_shadow.fsh',
    'shaders/core/entity_shadow_depth.vsh',
    'shaders/core/entity_shadow_depth.fsh',
    # 5. Core Includes
    'shaders/include/native_shadows.glsl',
    'shaders/include/directional_shadow.glsl',
    'shaders/include/terrain_material.glsl',
    'shaders/include/terrain_atlas_sampling.glsl',
    'shaders/include/vegetation_wind.glsl',
    'shaders/include/sodium_globals.glsl',
    # 6. Library & Modules
    'shaders/common.glsl',
    'shaders/terrain-globals.glsl',
    'shaders/environment.glsl',
    'shaders/palette.glsl',
    'shaders/specular.glsl',
    'shaders/held-light.glsl',
    'shaders/ice.glsl',
    'shaders/surface-data.glsl',
    'shaders/surface-normal.glsl',
    'shaders/tonemap.glsl',
    'shaders/water-resolve.glsl',
    'shaders/reflections.glsl',
    'shaders/cloud-field.glsl',
    'shaders/cloud-volume.glsl',
    'shaders/ground-mist.glsl',
]

def get_all_code_files(base_dir):
    res = []
    for root, dirs, files in os.walk(base_dir):
        for f in files:
            if f.endswith(('.json', '.glsl', '.vsh', '.fsh')):
                rel = os.path.relpath(os.path.join(root, f), base_dir).replace('\\', '/')
                res.append(rel)
    
    # Sort by PRIORITY_ORDER, remaining alphabetically
    order_map = {name: i for i, name in enumerate(PRIORITY_ORDER)}
    res.sort(key=lambda x: (order_map.get(x, 999), x))
    return res

def main():
    print('=== Sulkan All-In-One Codebase Aggregator ===')
    files = get_all_code_files(SRC_DIR)
    print(f'Found {len(files)} shader and config files in {SRC_DIR}')

    lines = [
        '# SULKAN SHADERS ALL IN ONE\n',
        '> 本文档为 Sulkan RTX Remix 光影包的**全量源码合辑快照**，包含所有渲染管线配置（sulkan.json）、顶点着色器（.vsh）、片段着色器（.fsh）与公用模块（.glsl）。\n\n',
        '## 目录 (Table of Contents)\n'
    ]

    for f in files:
        anchor = f.replace('/', '').replace('.', '').replace('-', '').lower()
        lines.append(f'- [{f}](#{anchor})\n')
    lines.append('\n---\n\n')

    total_code_lines = 0
    for f in files:
        full_path = os.path.join(SRC_DIR, f.replace('/', os.sep))
        with open(full_path, 'r', encoding='utf-8') as src_file:
            content = src_file.read()
        
        c_lines = content.count('\n') + 1
        total_code_lines += c_lines
        
        lang = 'json' if f.endswith('.json') else 'glsl'
        lines.append(f'## {f}\n\n')
        lines.append(f'```{lang}\n')
        lines.append(content)
        if not content.endswith('\n'):
            lines.append('\n')
        lines.append('```\n\n')

    out_content = ''.join(lines)
    with open(OUT_FILE, 'w', encoding='utf-8') as out_f:
        out_f.write(out_content)

    print(f'Successfully updated: {OUT_FILE}')
    print(f'Total files: {len(files)}, Total lines: {len(lines)}, Output size: {len(out_content.encode("utf-8"))} bytes')

if __name__ == '__main__':
    main()
