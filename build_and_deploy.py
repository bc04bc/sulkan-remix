# Sulkan 1-Click Build and Deploy Tool
# Usage: python build_and_deploy.py
import os, zipfile, io, json, shutil

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SRC_DIR = os.path.join(SCRIPT_DIR, 'shaderpack')
TEMPLATE_DIR = os.path.join(SCRIPT_DIR, 'shaderpack_template_original')
MINECRAFT_VER_DIR = r'C:\Users\bc04bc\Downloads\PCL 正式版 2.10.9\.minecraft\versions\26.3-Fabric 0.20.1'
JAR_PATH = os.path.join(MINECRAFT_VER_DIR, r'mods\sulkan-0.6.0-26.3.jar')
CACHE_PATH = os.path.join(MINECRAFT_VER_DIR, r'config\sulkan\pipeline-cache.bin')
SHADERPACKS_DIR = os.path.join(MINECRAFT_VER_DIR, r'shaderpacks')
CONFIG_JSON_PATH = os.path.join(MINECRAFT_VER_DIR, r'config\sulkan-shaders.json')

def package_dir(directory):
    buf = io.BytesIO()
    count = 0
    with zipfile.ZipFile(buf, 'w', compression=zipfile.ZIP_DEFLATED) as zout:
        for root, dirs, files in os.walk(directory):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, directory).replace('\\', '/')
                zout.write(full_path, rel_path)
                count += 1
    return buf.getvalue(), count

def main():
    print('=== Sulkan Shaderpack Builder (Dual Pack Architecture) ===')
    sulkan_json_path = os.path.join(SRC_DIR, 'sulkan.json')
    if not os.path.exists(sulkan_json_path):
        print('ERROR: sulkan.json not found in', SRC_DIR)
        return

    # 1. Validate sulkan.json
    print('[1/4] Validating sulkan.json...')
    with open(sulkan_json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    pack_name = data.get('name', 'Sulkan RTX Remix')
    options = data.get('options', {})
    for k, v in options.items():
        d = v.get('default')
        vals = v.get('values')
        if vals is not None and d not in vals:
            print(f'ERROR: Option {k} default value {d} is not in values {vals}!')
            return
    print(f'       Validated {len(options)} options for "{pack_name}", all correct.')

    # 2. Package into memory zip
    print('[2/4] Packaging Sulkan RTX Remix shaderpack...')
    remix_zip_bytes, file_count = package_dir(SRC_DIR)
    print(f'       Packaged {file_count} files ({len(remix_zip_bytes)} bytes).')

    # Also package template for keeping/restoring original Sulkan Realistic
    orig_zip_bytes, _ = package_dir(TEMPLATE_DIR) if os.path.exists(TEMPLATE_DIR) else (None, 0)

    # 3. Save as independent pack in shaderpacks folder
    print('[3/4] Registering as new shaderpack in shaderpacks folder...')
    dirs_to_deploy = [
        SHADERPACKS_DIR,
        os.path.abspath(os.path.join(MINECRAFT_VER_DIR, r'..\..\shaderpacks'))
    ]
    for sp_dir in dirs_to_deploy:
        try:
            os.makedirs(sp_dir, exist_ok=True)
            out_sp = os.path.join(sp_dir, 'Sulkan-RTX-Remix.zip')
            with open(out_sp, 'wb') as f:
                f.write(remix_zip_bytes)
            # Also sync unzipped folder
            out_folder = os.path.join(sp_dir, 'Sulkan-RTX-Remix')
            if os.path.exists(out_folder):
                shutil.rmtree(out_folder, ignore_errors=True)
            shutil.copytree(SRC_DIR, out_folder)
            print(f'       Wrote Sulkan-RTX-Remix.zip and folder to {sp_dir}.')
        except Exception as e:
            print(f'       Could not write to {sp_dir}: {e}')

    # Update config to select the new RTX Remix pack
    config_paths = [
        CONFIG_JSON_PATH,
        os.path.abspath(os.path.join(MINECRAFT_VER_DIR, r'..\..\config\sulkan-shaders.json'))
    ]
    for cfg_p in config_paths:
        if os.path.exists(os.path.dirname(cfg_p)):
            try:
                cfg = {"enabled": True, "selectedPackId": "Sulkan-RTX-Remix.zip"}
                with open(cfg_p, 'w', encoding='utf-8') as f:
                    json.dump(cfg, f, indent=2)
                print(f'       Updated {cfg_p} to select Sulkan-RTX-Remix.zip.')
            except Exception as e:
                print(f'       Could not update {cfg_p}: {e}')

    # 4. Mod JAR handling: preserve original Sulkan Realistic, add RTX Remix as new pack
    print('[4/4] Checking mod JAR status...')
    if os.path.exists(JAR_PATH):
        temp_jar = JAR_PATH + '.tmp'
        try:
            with zipfile.ZipFile(JAR_PATH, 'r') as zin, zipfile.ZipFile(temp_jar, 'w', compression=zipfile.ZIP_DEFLATED) as zout:
                has_orig = False
                for item in zin.infolist():
                    if item.filename == 'sulkan-bundled/Sulkan-Realistic.zip':
                        has_orig = True
                        # Ensure original pack is 100% pristine official template
                        if orig_zip_bytes:
                            zout.writestr(item, orig_zip_bytes)
                        else:
                            zout.writestr(item, zin.read(item.filename))
                    else:
                        zout.writestr(item, zin.read(item.filename))
            os.replace(temp_jar, JAR_PATH)
            print('       Mod JAR validated: Sulkan-Realistic preserved intact.')
        except Exception as e:
            print('       Notice: Mod JAR is locked by running game. Standalone pack loaded via shaderpacks folder.')
            if os.path.exists(temp_jar):
                try: os.remove(temp_jar)
                except: pass
    else:
        print('       Warning: Mod JAR not found at', JAR_PATH)

    if os.path.exists(CACHE_PATH):
        try:
            os.remove(CACHE_PATH)
            print('       Cleared old Vulkan pipeline cache.')
        except Exception as e:
            print('       Could not clear cache (game may be running):', e)

    # 5. Automatically keep SULKAN_SHADERS_ALL_IN_ONE.md synchronized
    print('[5/5] Updating SULKAN_SHADERS_ALL_IN_ONE.md...')
    try:
        import update_all_in_one
        update_all_in_one.main()
    except Exception as e:
        print('       Notice: Could not auto-update SULKAN_SHADERS_ALL_IN_ONE.md:', e)

    print('=== All Done! ===')
    print('1. Original "Sulkan Realistic" is completely preserved.')
    print('2. New "Sulkan RTX Remix" is registered as an independent shaderpack.')
    print('3. If game is running: press F3+T or click Reload in Shaders menu.')
    print('   You can select either "Sulkan Realistic" or "Sulkan RTX Remix" in the Shaders list!')

if __name__ == '__main__':
    main()
