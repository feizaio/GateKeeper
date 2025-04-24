#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import shutil
import logging
import argparse
import subprocess

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def get_app_path():
    """获取应用程序运行时路径"""
    return os.path.dirname(os.path.abspath(__file__))

def create_resource_dirs():
    """创建资源目录"""
    app_path = get_app_path()
    xshell_path = os.path.join(app_path, 'resources', 'xshell')
    xftp_path = os.path.join(app_path, 'resources', 'xftp')
    hooks_path = os.path.join(app_path, 'hooks')
    
    # 创建目录
    os.makedirs(xshell_path, exist_ok=True)
    os.makedirs(xftp_path, exist_ok=True)
    os.makedirs(hooks_path, exist_ok=True)
    
    return xshell_path, xftp_path, hooks_path

def ensure_comtypes_hook(hooks_path):
    """确保 comtypes 钩子文件存在"""
    hook_file = os.path.join(hooks_path, 'hook-comtypes.py')
    
    if not os.path.exists(hook_file):
        with open(hook_file, 'w') as f:
            f.write("""
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
""")
        logging.info(f"创建 comtypes 钩子文件: {hook_file}")

def copy_resources(source_xshell, source_xftp):
    """复制 Xshell 和 Xftp 资源到应用程序目录"""
    xshell_dest, xftp_dest, hooks_path = create_resource_dirs()
    
    # 清空目标目录，确保干净拷贝
    logging.info("清空目标目录以确保干净拷贝")
    shutil.rmtree(xshell_dest, ignore_errors=True)
    shutil.rmtree(xftp_dest, ignore_errors=True)
    
    # 重新创建目录
    os.makedirs(xshell_dest, exist_ok=True)
    os.makedirs(xftp_dest, exist_ok=True)
    
    # 确保 comtypes 钩子存在
    ensure_comtypes_hook(hooks_path)
    
    # 验证源目录
    if not os.path.exists(source_xshell):
        raise Exception(f"Xshell 源目录不存在: {source_xshell}")
    
    if not os.path.exists(source_xftp):
        raise Exception(f"Xftp 源目录不存在: {source_xftp}")
    
    # 复制 Xshell
    logging.info(f"正在复制 Xshell 从 {source_xshell} 到 {xshell_dest}")
    
    # 首先尝试找到 Xshell.exe
    xshell_exe = None
    for root, dirs, files in os.walk(source_xshell):
        for file in files:
            if file.lower() == 'xshell.exe':
                xshell_exe = os.path.join(root, file)
                break
        if xshell_exe:
            break
    
    if xshell_exe:
        logging.info(f"找到 Xshell.exe: {xshell_exe}")
        
        # 确定实际的 Xshell 程序目录
        xshell_program_dir = os.path.dirname(xshell_exe)
        logging.info(f"Xshell 程序目录: {xshell_program_dir}")
        
        # 复制整个程序目录
        logging.info(f"复制整个程序目录: {xshell_program_dir} -> {xshell_dest}")
        
        # 直接复制整个目录结构
        copy_dir_structure(xshell_program_dir, xshell_dest)
        
        # 设置环境变量，供 spec 文件使用
        os.environ['XSHELL_PATH'] = xshell_program_dir
    else:
        # 未找到 Xshell.exe，尝试复制整个目录
        logging.warning(f"未找到 Xshell.exe，尝试复制整个目录: {source_xshell}")
        copy_dir_structure(source_xshell, xshell_dest)
        os.environ['XSHELL_PATH'] = source_xshell
    
    # 复制 Xftp
    logging.info(f"正在复制 Xftp 从 {source_xftp} 到 {xftp_dest}")
    
    # 首先尝试找到 Xftp.exe
    xftp_exe = None
    for root, dirs, files in os.walk(source_xftp):
        for file in files:
            if file.lower() == 'xftp.exe':
                xftp_exe = os.path.join(root, file)
                break
        if xftp_exe:
            break
    
    if xftp_exe:
        logging.info(f"找到 Xftp.exe: {xftp_exe}")
        
        # 确定实际的 Xftp 程序目录
        xftp_program_dir = os.path.dirname(xftp_exe)
        logging.info(f"Xftp 程序目录: {xftp_program_dir}")
        
        # 复制整个程序目录
        logging.info(f"复制整个程序目录: {xftp_program_dir} -> {xftp_dest}")
        
        # 直接复制整个目录结构
        copy_dir_structure(xftp_program_dir, xftp_dest)
        
        # 设置环境变量，供 spec 文件使用
        os.environ['XFTP_PATH'] = xftp_program_dir
    else:
        # 未找到 Xftp.exe，尝试复制整个目录
        logging.warning(f"未找到 Xftp.exe，尝试复制整个目录: {source_xftp}")
        copy_dir_structure(source_xftp, xftp_dest)
        os.environ['XFTP_PATH'] = source_xftp
    
    logging.info("资源复制完成")
    
    # 验证复制结果
    verify_xshell(xshell_dest)
    verify_xftp(xftp_dest)

def copy_dir_structure(src, dst):
    """复制整个目录结构，包括所有子目录和文件"""
    try:
        # 如果源是目录，创建目标目录并遍历
        if os.path.isdir(src):
            if not os.path.exists(dst):
                os.makedirs(dst)
            
            for item in os.listdir(src):
                s = os.path.join(src, item)
                d = os.path.join(dst, item)
                
                if os.path.isdir(s):
                    # 复制子目录
                    copy_dir_structure(s, d)
                else:
                    # 复制文件
                    shutil.copy2(s, d)
        else:
            # 如果源是文件，直接复制
            shutil.copy2(src, dst)
    except Exception as e:
        logging.error(f"复制目录结构时出错: {e}")

def verify_xshell(path):
    """验证 Xshell 文件是否存在"""
    xshell_exe = None
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.lower() == 'xshell.exe':
                xshell_exe = os.path.join(root, file)
                break
        if xshell_exe:
            break
    
    if xshell_exe:
        logging.info(f"Xshell.exe 已找到: {xshell_exe}")
    else:
        logging.warning("警告: Xshell.exe 未找到，请检查源目录结构")

def verify_xftp(path):
    """验证 Xftp 文件是否存在"""
    xftp_exe = None
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.lower() == 'xftp.exe':
                xftp_exe = os.path.join(root, file)
                break
        if xftp_exe:
            break
    
    if xftp_exe:
        logging.info(f"Xftp.exe 已找到: {xftp_exe}")
    else:
        logging.warning("警告: Xftp.exe 未找到，请检查源目录结构")

def build_executable():
    """使用 PyInstaller 构建可执行文件"""
    try:
        logging.info("开始构建可执行文件...")
        spec_file = os.path.join(get_app_path(), 'bundle_fortress.spec')
        
        if not os.path.exists(spec_file):
            logging.error(f"构建规范文件不存在: {spec_file}")
            return False
        
        # 安装必要的依赖
        logging.info("确保所有依赖已安装...")
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'comtypes'])
        
        # 打印当前环境变量
        logging.info(f"打包时使用的环境变量:")
        logging.info(f"XSHELL_PATH = {os.environ.get('XSHELL_PATH', '未设置')}")
        logging.info(f"XFTP_PATH = {os.environ.get('XFTP_PATH', '未设置')}")
        
        # 执行 PyInstaller 命令
        cmd = [sys.executable, '-m', 'PyInstaller', '--clean', spec_file]
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate()
        
        # 输出构建日志
        logging.info("PyInstaller 输出:")
        for line in stdout.splitlines():
            logging.info(line)
        
        if process.returncode != 0:
            logging.error(f"构建失败: {stderr}")
            for line in stderr.splitlines():
                logging.error(line)
            return False
        
        logging.info("构建成功完成")
        logging.info(f"输出目录: {os.path.join(get_app_path(), 'dist')}")
        return True
    
    except Exception as e:
        logging.error(f"构建过程中发生错误: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='准备资源并构建客户端')
    parser.add_argument('--xshell', required=True, help='Xshell 程序目录路径')
    parser.add_argument('--xftp', required=True, help='Xftp 程序目录路径')
    parser.add_argument('--build', action='store_true', help='构建可执行文件')
    
    args = parser.parse_args()
    
    try:
        # 复制资源
        copy_resources(args.xshell, args.xftp)
        
        # 构建可执行文件
        if args.build:
            build_executable()
        
    except Exception as e:
        logging.error(f"错误: {e}")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main()) 