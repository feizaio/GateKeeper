#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys

# 创建钩子目录
HOOK_DIR = "hooks"
if not os.path.exists(HOOK_DIR):
    os.makedirs(HOOK_DIR)

def write_file(filename, content):
    """写入文件，明确指定UTF-8编码"""
    with open(os.path.join(HOOK_DIR, filename), 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"已创建文件: {filename}")

# 创建 comtypes 钩子
comtypes_hook = '''
"""
自定义 comtypes 钩子文件，确保所有必需的 comtypes 模块都包含在打包中
"""

from PyInstaller.utils.hooks import collect_submodules

# 收集所有 comtypes 子模块
hiddenimports = collect_submodules('comtypes')

# 额外添加可能被忽略的 comtypes 子模块
additional_modules = [
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
]

for module in additional_modules:
    if module not in hiddenimports:
        hiddenimports.append(module)
'''

# 创建 pkg_resources 钩子
pkg_resources_hook = '''
"""
确保 pkg_resources 及其所有子模块被正确包含
"""
from PyInstaller.utils.hooks import collect_submodules, collect_data_files

# 收集 pkg_resources 所有子模块
hiddenimports = collect_submodules('pkg_resources')

# 添加其他必要的子模块
additional_modules = [
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
]

for module in additional_modules:
    if module not in hiddenimports:
        hiddenimports.append(module)

# 收集数据文件
datas = collect_data_files('pkg_resources')
'''

# 创建运行时钩子
runtime_hook = '''
"""
PyInstaller runtime hook to fix pkg_resources issues
"""

import os
import sys
import importlib

# 确保 pkg_resources 可用
def ensure_pkg_resources():
    try:
        # 尝试导入 pkg_resources
        import pkg_resources
        print("pkg_resources 导入成功")
        
        # 检查是否有 extern 模块
        if not hasattr(pkg_resources, 'extern'):
            pkg_resources.extern = type('ExternModule', (), {})
            print("extern 模块创建成功")
        
        # 检查 extern.packaging
        if not hasattr(pkg_resources.extern, 'packaging'):
            import packaging
            pkg_resources.extern.packaging = packaging
            print("extern.packaging 设置成功")
            
        # 检查其他必要的模块
        required_modules = [
            'version', 
            'specifiers', 
            'requirements', 
            'markers'
        ]
        
        for module_name in required_modules:
            if not hasattr(pkg_resources.extern.packaging, module_name):
                try:
                    mod = importlib.import_module(f'packaging.{module_name}')
                    setattr(pkg_resources.extern.packaging, module_name, mod)
                    print(f"extern.packaging.{module_name} 设置成功")
                except:
                    print(f"无法导入 packaging.{module_name}")
                    
        print("pkg_resources 设置完成")
        
    except Exception as e:
        print(f"pkg_resources 初始化失败: {e}")
        
# 在应用程序启动时调用
ensure_pkg_resources()
'''

# 写入文件
write_file("hook-comtypes.py", comtypes_hook)
write_file("hook-pkg_resources.py", pkg_resources_hook)
write_file("pyi_rth_pkg_resources.py", runtime_hook)

print("所有钩子文件创建成功!") 