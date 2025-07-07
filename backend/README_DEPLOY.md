# Windows服务器上的WSGI部署指南

本文档将指导您如何在Windows服务器上使用WSGI部署Flask应用程序。

## 准备工作

1. 确保Windows服务器上已安装Python 3.8或更高版本
2. 安装所需依赖项

```bash
pip install -r backend/requirements_wsgi.txt
```

## 部署选项

### 选项1：使用Waitress直接运行

这是最简单的部署方式，适合测试或小规模部署。

```bash
python backend/run_waitress.py
```

### 选项2：作为Windows服务运行

这种方式可以确保应用程序在系统启动时自动运行，并在后台稳定运行。

#### 安装服务

```bash
python backend/service_config.py install
```

#### 启动服务

```bash
python backend/service_config.py start
```

#### 停止服务

```bash
python backend/service_config.py stop
```

#### 删除服务

```bash
python backend/service_config.py remove
```

## 配置说明

### 端口配置

默认情况下，应用程序在端口5000上运行。如果需要更改端口，请修改以下文件中的端口配置：

- `backend/run_waitress.py` 
- `backend/service_config.py`

### 线程配置

Waitress默认使用4个线程。如果需要调整线程数，请修改以上两个文件中的 `threads` 参数。

## 日志

当使用Waitress运行时，日志将写入 `waitress.log` 文件。

## 故障排除

1. **服务无法启动**：检查Windows事件查看器中的错误日志
2. **无法访问应用程序**：确认防火墙设置允许指定端口通过
3. **权限问题**：确保用于运行服务的用户具有适当的权限

## 生产环境注意事项

1. 确保已禁用DEBUG模式
2. 考虑使用Nginx作为反向代理，处理静态文件并提供额外的安全层
3. 定期备份数据库
4. 设置适当的日志轮转策略
5. 确保使用HTTPS加密连接 