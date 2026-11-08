import ctypes, os, re, json

dll_path = r'C:\Users\bc04bc\Downloads\PCL 正式版 2.10.9\.minecraft\versions\26.3-Fabric 0.20.1\26.3-Fabric 0.20.1-natives\lwjgl\3.4.3-snapshot\x64\shaderc.dll'
lib = ctypes.CDLL(dll_path)

lib.shaderc_compiler_initialize.restype = ctypes.c_void_p
lib.shaderc_compile_options_initialize.restype = ctypes.c_void_p
lib.shaderc_compile_options_set_target_env.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int]
lib.shaderc_compile_options_set_auto_bind_uniforms.argtypes = [ctypes.c_void_p, ctypes.c_bool]
lib.shaderc_compile_options_set_auto_map_locations.argtypes = [ctypes.c_void_p, ctypes.c_bool]
lib.shaderc_compile_options_set_optimization_level.argtypes = [ctypes.c_void_p, ctypes.c_int]
lib.shaderc_compile_into_spv.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_size_t, ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_void_p]
lib.shaderc_compile_into_spv.restype = ctypes.c_void_p
lib.shaderc_result_get_compilation_status.argtypes = [ctypes.c_void_p]
lib.shaderc_result_get_compilation_status.restype = ctypes.c_int
lib.shaderc_result_get_error_message.argtypes = [ctypes.c_void_p]
lib.shaderc_result_get_error_message.restype = ctypes.c_char_p
lib.shaderc_result_release.argtypes = [ctypes.c_void_p]

compiler = lib.shaderc_compiler_initialize()
options = lib.shaderc_compile_options_initialize()
lib.shaderc_compile_options_set_target_env(options, 0, 4202496)
lib.shaderc_compile_options_set_auto_bind_uniforms(options, True)
lib.shaderc_compile_options_set_auto_map_locations(options, True)
lib.shaderc_compile_options_set_optimization_level(options, 0)

base_dir = r'd:\sulkan\shaderpack'

with open(os.path.join(base_dir, 'sulkan.json'), 'r', encoding='utf-8') as f:
    sulkan_data = json.load(f)

# Build default options header
opt_lines = ['#extension GL_EXT_demote_to_helper_invocation : enable\n']
for k, v in sulkan_data.get('options', {}).items():
    d = v.get('default')
    if isinstance(d, bool):
        opt_lines.append(f'#define {k} {1 if d else 0}\n')
        if d: opt_lines.append(f'#define _SULKAN_ENABLED_{k} 1\n')
    elif isinstance(d, (int, float)):
        opt_lines.append(f'#define {k} {d}\n')
        if d > 0: opt_lines.append(f'#define _SULKAN_ENABLED_{k} 1\n')
default_header = ''.join(opt_lines)

frame_decl = '''
layout(std140) uniform SulkanFrame {
mat4 Projection; mat4 View; mat4 InverseProjection; mat4 InverseView;
mat4 PreviousProjection; mat4 PreviousView;
vec4 CameraDeltaAndHistoryValid; vec4 TimeDeltaFrame; vec4 ViewSizeAndInverse;
vec4 WorldTimeWeatherDimension; vec4 SunDirectionAndRainBrightness; vec4 MoonDirectionAndPhase;
vec4 CameraPositionHighAndFogType; vec4 CameraPositionLowAndFarPlane;
vec4 FogColorAndStart; vec4 FogDistances; vec4 SkyColorAndStarBrightness;
vec4 CloudOffsetAndGameTime;
mat4 InverseHandProjection; vec4 HandProjectionValid;
vec4 HeldLightPositionRadius; vec4 HeldLightColor;
};
'''

def resolve_include(inc_raw, current_file):
    inc = inc_raw.replace('/', os.sep)
    if 'sulkan' + os.sep + 'frame.glsl' in inc or 'sulkan/frame.glsl' in inc_raw:
        return frame_decl
    if 'sulkan' + os.sep + 'shadows.glsl' in inc or 'sulkan/shadows.glsl' in inc_raw:
        inc_p = os.path.join(base_dir, 'shaders', 'include', 'native_shadows.glsl')
    elif 'sulkan' + os.sep + 'shadow-filter.glsl' in inc or 'sulkan/shadow-filter.glsl' in inc_raw:
        inc_p = os.path.join(base_dir, 'shaders', 'include', 'directional_shadow.glsl')
    elif inc.startswith('shaders' + os.sep):
        inc_p = os.path.join(base_dir, inc)
    elif inc.startswith('sulkan:'):
        # Mojang import format
        inc_p = os.path.join(base_dir, 'shaders', 'include', inc.split(':', 1)[1])
    else:
        inc_p = os.path.join(os.path.dirname(current_file), inc)
    if not os.path.exists(inc_p):
        inc_p2 = os.path.join(base_dir, 'shaders', inc)
        if os.path.exists(inc_p2): inc_p = inc_p2
        else:
            return f'// COULD NOT FIND INCLUDE {inc}\n'
    return expand(inc_p)

def expand(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    pattern = re.compile(r'#(?:include|moj_import)\s+["<]([^">]+)[">]')
    while True:
        m = pattern.search(content)
        if not m: break
        rep = resolve_include(m.group(1), path)
        content = content[:m.start()] + rep + content[m.end():]
    return content

tests = [
    ('terrain.vsh (solid)', 0, os.path.join(base_dir, 'shaders', 'terrain.vsh'), ''),
    ('terrain.fsh (solid)', 1, os.path.join(base_dir, 'shaders', 'terrain.fsh'), ''),
    ('terrain.fsh (cutout)', 1, os.path.join(base_dir, 'shaders', 'terrain.fsh'), '#define ALPHA_CUTOUT 1\n'),
    ('terrain.fsh (translucent)', 1, os.path.join(base_dir, 'shaders', 'terrain.fsh'), '#define SULKAN_TRANSLUCENT 1\n'),
    ('terrain.fsh (cutout+translucent / pipeline 7)', 1, os.path.join(base_dir, 'shaders', 'terrain.fsh'), '#define ALPHA_CUTOUT 1\n#define SULKAN_TRANSLUCENT 1\n'),
    ('sodium_terrain_shadow.vsh (solid)', 0, os.path.join(base_dir, 'shaders', 'core', 'sodium_terrain_shadow.vsh'), ''),
    ('sodium_terrain_shadow.fsh (cutout)', 1, os.path.join(base_dir, 'shaders', 'core', 'sodium_terrain_shadow.fsh'), '#define ALPHA_CUTOUT 1\n'),
    ('directional_shadow.glsl', 1, os.path.join(base_dir, 'shaders', 'include', 'directional_shadow.glsl'), ''),
    ('lighting.fsh', 1, os.path.join(base_dir, 'shaders', 'lighting.fsh'), ''),
    ('atmosphere.fsh', 1, os.path.join(base_dir, 'shaders', 'atmosphere.fsh'), ''),
    ('blur-y.fsh', 1, os.path.join(base_dir, 'shaders', 'blur-y.fsh'), ''),
    ('bloom-seed.fsh', 1, os.path.join(base_dir, 'shaders', 'bloom-seed.fsh'), ''),
    ('water-reflections.fsh', 1, os.path.join(base_dir, 'shaders', 'water-reflections.fsh'), ''),
    ('final.fsh', 1, os.path.join(base_dir, 'shaders', 'final.fsh'), '')
]

for stage_name, stage_kind, path, extra_defs in tests:
    expanded = expand(path)
    v_idx = expanded.find('\n')
    full_source = expanded[:v_idx+1] + default_header + extra_defs + expanded[v_idx+1:]
    
    source_bytes = full_source.encode('utf-8')
    res = lib.shaderc_compile_into_spv(compiler, source_bytes, len(source_bytes), stage_kind, path.encode('utf-8'), b'main', options)
    status = lib.shaderc_result_get_compilation_status(res)
    if status != 0:
        err_msg = lib.shaderc_result_get_error_message(res).decode('utf-8')
        print(f'FAILED: {stage_name}')
        print(err_msg)
    else:
        print(f'SUCCESS: {stage_name}')
    lib.shaderc_result_release(res)
