@echo off
echo =====================================
echo 堡垒机客户端重新打包工具（无窗口版）
echo =====================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员身份运行此脚本!
    echo 右键点击此脚本，选择"以管理员身份运行"。
    pause
    exit /b 1
)

REM 设置变量
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM 确保依赖项已安装
echo.
echo 正在检查依赖项...
pip list | findstr pyinstaller >nul
if %errorLevel% neq 0 (
    echo 安装 PyInstaller...
    pip install pyinstaller
)

echo.
echo 正在重新打包堡垒机客户端（无窗口版）...

REM 使用已修改的spec文件重新打包
python -m PyInstaller --clean bundle_fortress.spec

if %errorLevel% neq 0 (
    echo.
    echo 构建过程发生错误
    pause
    exit /b 1
)

echo.
echo =====================================
echo 构建过程完成!
echo 无窗口版可执行文件位于 dist 目录下
echo =====================================
echo.

pause 