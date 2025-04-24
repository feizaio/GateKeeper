# -*- mode: python ; coding: utf-8 -*-
import os
import sys
import shutil

# 指定 Xshell 和 Xftp 资源路径（假设资源放在resources目录下）
# 这里需要您提供实际的 Xshell 和 Xftp 文件夹路径
XSHELL_RESOURCE_PATH = os.path.abspath("./resources/xshell")
XFTP_RESOURCE_PATH = os.path.abspath("./resources/xftp")

# 确保钩子目录存在
HOOK_DIR = os.path.abspath("./hooks")
if not os.path.exists(HOOK_DIR):
    os.makedirs(HOOK_DIR)

# 运行时钩子路径
RUNTIME_HOOK_PATH = os.path.join(HOOK_DIR, "pyi_rth_pkg_resources.py")

# 收集 Xshell 和 Xftp 资源
xshell_datas = []  # 初始化为空列表
xftp_datas = []   # 初始化为空列表

# 指定 Xshell 和 Xftp 安装目录（从环境变量中获取，如果存在）
xshell_install_path = os.environ.get('XSHELL_PATH', "D:\\xshell\\Xshell")
xftp_install_path = os.environ.get('XFTP_PATH', "D:\\xshell\\Xftp7")

# 打印当前使用的路径
print(f"使用 Xshell 路径: {xshell_install_path}")
print(f"使用 Xftp 路径: {xftp_install_path}")

# 收集函数
def collect_directory(source_dir, dest_base):
    """收集整个目录及其子目录到 datas 列表，保持目录结构"""
    collected_data = []
    
    if not os.path.exists(source_dir):
        print(f"警告: 源目录不存在 {source_dir}")
        return collected_data
    
    print(f"收集目录: {source_dir} -> {dest_base}")
    
    # 直接将整个目录作为资源收集
    collected_data.append((source_dir, dest_base))
    
    return collected_data

# 收集 Xshell 目录
xshell_datas = collect_directory(xshell_install_path, 'resources/xshell')

# 收集 Xftp 目录
xftp_datas = collect_directory(xftp_install_path, 'resources/xftp')

# 合并所有资源
all_datas = [('fortress.ico', '.')] + xshell_datas + xftp_datas

# 添加所有隐藏导入
hidden_imports = [
    'win32com.client',
    'win32crypt',
    'pywinauto',
    'comtypes.stream',
    'comtypes.persist',
    'comtypes.client',
    'comtypes.automation',
    'comtypes._comobject',
    'comtypes._meta',
    'comtypes._safearray',
    'comtypes.typeinfo',
    'comtypes.hresult',
    'comtypes.errorinfo',
    'comtypes.server',
    'pywinauto.controls',
    'pywinauto.findwindows',
    'pywinauto.uia_defines',
    'pywinauto.windows',
    'pywinauto.keyboard',
    'pywinauto.mouse',
    'win32gui',
    'win32con',
    'win32api',
    'win32cred',
    # pkg_resources 相关模块
    'pkg_resources',
    'pkg_resources.extern',
    'pkg_resources.extern.packaging',
    'pkg_resources.extern.packaging.version',
    'pkg_resources.extern.packaging.specifiers',
    'pkg_resources.extern.packaging.requirements',
    'pkg_resources._vendor',
    'pkg_resources._vendor.packaging',
    'packaging',
    'packaging.version',
    'packaging.specifiers',
    'packaging.requirements',
    'packaging.markers',
    'importlib_metadata',
    'setuptools',
]

# 自定义运行时钩子
runtime_hooks = [
    RUNTIME_HOOK_PATH  # 添加我们的自定义运行时钩子
]

a = Analysis(
    ['fort.py'],
    pathex=[],
    binaries=[],
    datas=all_datas,
    hiddenimports=hidden_imports,
    hookspath=[HOOK_DIR],
    hooksconfig={},
    runtime_hooks=runtime_hooks,
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='堡垒机客户端',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,  # 改为False以隐藏控制台窗口
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='fortress.ico',
) 