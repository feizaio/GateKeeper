@echo off
echo =====================================
echo 堡垒机客户端打包工具
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

REM 创建资源目录
if not exist "resources\xshell" mkdir "resources\xshell"
if not exist "resources\xftp" mkdir "resources\xftp"
if not exist "hooks" mkdir "hooks"

REM 安装依赖项
echo.
echo 正在安装所需依赖...
pip install -r requirements.txt
if %errorLevel% neq 0 (
    echo 安装依赖项失败
    pause
    exit /b 1
)

REM 确保setuptools安装完整
echo.
echo 确保setuptools安装完整...
pip install setuptools --upgrade
pip install importlib-metadata --upgrade
pip install packaging --upgrade

echo.
echo 请输入 Xshell 安装目录:
echo 例如: D:\NetSarang\Xshell 7
set /p XSHELL_PATH="> "

echo.
echo 请输入 Xftp 安装目录:
echo 例如: D:\NetSarang\Xftp 7
set /p XFTP_PATH="> "

echo.
echo 验证目录...

REM 验证目录
if not exist "%XSHELL_PATH%" (
    echo Xshell 目录不存在: %XSHELL_PATH%
    pause
    exit /b 1
)

if not exist "%XFTP_PATH%" (
    echo Xftp 目录不存在: %XFTP_PATH%
    pause
    exit /b 1
)

REM 创建钩子文件
echo.
echo 创建 PyInstaller 钩子文件...
python create_hooks.py
if %errorLevel% neq 0 (
    echo 创建钩子文件失败
    pause
    exit /b 1
)

REM 设置环境变量，供 spec 文件使用
setx XSHELL_PATH "%XSHELL_PATH%" /M
setx XFTP_PATH "%XFTP_PATH%" /M

echo.
echo 环境变量设置完成:
echo XSHELL_PATH = %XSHELL_PATH%
echo XFTP_PATH = %XFTP_PATH%

echo.
echo 执行资源准备和构建...
echo.

REM 执行 Python 脚本
python prepare_resources.py --xshell "%XSHELL_PATH%" --xftp "%XFTP_PATH%" --build

if %errorLevel% neq 0 (
    echo.
    echo 构建过程发生错误
    pause
    exit /b 1
)

echo.
echo =====================================
echo 构建过程完成!
echo 可执行文件位于 dist 目录下
echo =====================================
echo.

pause 