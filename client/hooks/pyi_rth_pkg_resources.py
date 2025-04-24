
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
