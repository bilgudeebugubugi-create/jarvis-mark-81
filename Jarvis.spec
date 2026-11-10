# -*- mode: python ; coding: utf-8 -*-

from pathlib import Path


ROOT = Path(SPECPATH).resolve()
datas = []
hiddenimports = ["actions", "plugins"]


def add_tree(source: Path, destination: str) -> None:
    if not source.is_dir():
        return
    for path in source.rglob("*"):
        if path.is_file():
            relative_parent = path.relative_to(source).parent
            target = Path(destination) / relative_parent
            datas.append((str(path), str(target)))


def add_file(source: Path, destination: str) -> None:
    if source.is_file():
        datas.append((str(source), destination))


for package in ("actions", "plugins"):
    package_dir = ROOT / package
    for module in sorted(package_dir.glob("*.py")):
        add_file(module, package)
        if module.stem != "__init__" and not module.stem.startswith("_"):
            hiddenimports.append(f"{package}.{module.stem}")

add_file(ROOT / "core" / "prompt.txt", "core")
add_file(ROOT / "core" / "face_model.obj", "core")
add_file(ROOT / "data" / "public_apis.json", "data")
add_file(ROOT / "config" / "jarvis.ico", "config")
add_tree(ROOT / "apps", "apps")
add_tree(ROOT / "dashboard" / "static", "dashboard/static")

a = Analysis(
    [str(ROOT / "main.py")],
    pathex=[str(ROOT)],
    binaries=[],
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="Jarvis",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    contents_directory=".",
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name="Jarvis",
)
