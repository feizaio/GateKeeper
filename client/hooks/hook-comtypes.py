
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
