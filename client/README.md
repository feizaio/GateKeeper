# 堡垒机客户端集成工具

## 概述

此工具将 Xshell 和 Xftp 集成到堡垒机客户端中，使用户无需单独安装这些工具即可通过堡垒机客户端进行 SSH 和 SFTP 连接。

## 功能特点

- 内置 Xshell 和 Xftp，无需单独安装
- 自动处理 SSH 和 SFTP 连接
- 系统托盘图标，便于操作
- 自动配置防火墙规则

## 使用方法

### 打包构建

1. 确保您的系统中已安装 Xshell 和 Xftp
2. 以管理员身份运行 `bundle.bat`
3. 按照提示输入 Xshell 和 Xftp 的安装目录
4. 等待打包和构建完成

### 使用集成客户端

1. 运行 `dist` 目录下的 `堡垒机客户端.exe`
2. 客户端将自动连接到堡垒机服务器
3. 通过堡垒机界面选择需要连接的服务器，点击连接

## 开发环境需求

- Python 3.8 或更高版本
- PyInstaller (`pip install pyinstaller`)
- 以下 Python 包:
  ```
  pystray
  pillow
  requests
  pywin32
  pywinauto
  ```

## 文件说明

- `fort.py` - 主程序代码
- `bundle_fortress.spec` - PyInstaller 打包配置
- `prepare_resources.py` - 资源准备脚本
- `bundle.bat` - 一键打包脚本

## 注意事项

1. 打包过程需要管理员权限
2. 请确保提供正确的 Xshell 和 Xftp 安装路径
3. 集成后的客户端需要以管理员身份运行才能正常使用

## 排障指南

### 常见问题

1. **无法启动集成的 Xshell**
   - 检查日志文件 (`%APPDATA%\fortress_client.log`)
   - 确认 Xshell.exe 在资源目录中的正确位置

2. **无法启动集成的 Xftp**
   - 检查日志文件 (`%APPDATA%\fortress_client.log`)
   - 确认 Xftp.exe 在资源目录中的正确位置

3. **打包过程失败**
   - 确保 PyInstaller 已正确安装
   - 检查源目录是否有访问权限问题 