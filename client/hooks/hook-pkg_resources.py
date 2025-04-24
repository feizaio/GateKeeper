
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
