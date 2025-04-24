@echo off
setlocal enabledelayedexpansion

:: 1. 创建目标目录
if not exist C:\gatekeeper (
    mkdir C:\gatekeeper
)

:: 2. 复制堡垒机小助手.exe到目标目录
copy "gatekeeperclient.exe" "C:\gatekeeper" /y

:: 3. 创建并启动Windows服务
sc query gatekeeperclient >nul 2>&1
if %errorlevel% equ 0 (
    echo 服务 gatekeeperclient 已存在，正在删除...
    sc delete gatekeeperclient
    timeout /t 3 /nobreak
)

sc create gatekeeperclient binPath= "C:\gatekeeper\gatekeeperclient.exe" displayname= "Gatekeeper Client" start= auto

if %errorlevel% equ 0 (
    echo 服务创建成功，正在启动...
    sc start gatekeeperclient
) else (
    echo 服务创建失败，请检查权限。
)

pause