@echo off
echo =====================================
echo 堡垒机客户端 - 全套安装工具
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

echo.
echo 此脚本将执行以下操作:
echo 1. 打包堡垒机服务组件
echo 2. 安装服务组件到系统服务
echo 3. 打包通知组件
echo 4. 创建启动脚本
echo.
echo 是否继续？(Y/N)
set /p continue_choice="选择: "

if /i not "%continue_choice%"=="Y" (
    echo 已取消安装
    pause
    exit /b 0
)

echo.
echo =====================================
echo 第1步: 打包服务组件...
echo =====================================
echo.

call build_service.bat

if %errorLevel% neq 0 (
    echo 服务组件打包失败
    pause
    exit /b 1
)

echo.
echo =====================================
echo 第2步: 安装服务...
echo =====================================
echo.

echo 是否要安装堡垒机客户端服务？(Y/N)
set /p install_service="选择: "

if /i "%install_service%"=="Y" (
    echo.
    echo 正在安装服务...
    
    REM 先尝试停止和移除现有服务
    net stop FortressService >nul 2>&1
    sc delete FortressService >nul 2>&1
    
    REM 等待服务完全停止
    timeout /t 2 >nul
    
    REM 安装新服务
    dist\FortressService.exe --startup=auto install
    
    if %errorLevel% neq 0 (
        echo 服务安装失败
        pause
        exit /b 1
    )
    
    echo.
    echo 服务已安装，是否立即启动服务？(Y/N)
    set /p start_service="选择: "
    
    if /i "%start_service%"=="Y" (
        echo 正在启动服务...
        net start FortressService
        
        if %errorLevel% neq 0 (
            echo 服务启动失败
            pause
            exit /b 1
        )
        
        echo 服务已成功启动
    ) else (
        echo 服务已安装但未启动，您可以稍后通过服务管理器启动它
    )
) else (
    echo 已跳过服务安装
)

echo.
echo =====================================
echo 第3步: 打包通知组件...
echo =====================================
echo.

call build_notifier.bat

if %errorLevel% neq 0 (
    echo 通知组件打包失败
    pause
    exit /b 1
)

echo.
echo =====================================
echo 第4步: 创建启动配置...
echo =====================================
echo.

REM 创建开机自启配置
echo 是否要将堡垒机通知组件设置为开机自启？(Y/N)
set /p autostart="选择: "

if /i "%autostart%"=="Y" (
    echo 正在创建开机自启配置...
    
    REM 创建快捷方式到启动文件夹
    echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
    echo sLinkFile = oWS.SpecialFolders("Startup") ^& "\FortressNotifier.lnk" >> CreateShortcut.vbs
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
    echo oLink.TargetPath = "%SCRIPT_DIR%dist\FortressNotifier.exe" >> CreateShortcut.vbs
    echo oLink.WorkingDirectory = "%SCRIPT_DIR%dist" >> CreateShortcut.vbs
    echo oLink.Description = "堡垒机通知组件" >> CreateShortcut.vbs
    echo oLink.IconLocation = "%SCRIPT_DIR%fortress.ico" >> CreateShortcut.vbs
    echo oLink.Save >> CreateShortcut.vbs
    
    cscript //nologo CreateShortcut.vbs
    del CreateShortcut.vbs
    
    echo 已设置开机自启
)

echo.
echo =====================================
echo 安装完成!
echo.
echo 服务组件已安装到系统服务中，可以通过服务管理器管理
echo 通知组件位于dist目录，可以通过"启动堡垒机客户端.bat"启动
echo.
echo 请注意：
echo 1. 服务组件负责与堡垒机服务器通信
echo 2. 通知组件负责响应连接请求并启动Xshell/Xftp/RDP
echo 3. 两个组件必须同时运行，才能正常使用堡垒机功能
echo =====================================
echo.

pause 