import sys
from pathlib import Path
import logging
from waitress import serve

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("waitress.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger("waitress")
logger.info("正在启动Waitress服务器...")

# 将项目根目录添加到 sys.path
project_root = Path(__file__).parent.parent
sys.path.append(str(project_root))

# 导入Flask应用
# 首先尝试从hackend.app导入，与测试环境保持一致
try:
    from hackend.app import app
    logger.info("从hackend.app成功导入应用")
except ImportError:
    # 如果失败，尝试从backend.app导入
    try:
        from backend.app import app
        logger.info("从backend.app成功导入应用")
    except ImportError:
        # 最后尝试从backend模块创建应用
        logger.info("尝试从backend.__init__创建应用")
        from backend import create_app
        app = create_app()

if __name__ == '__main__':
    # 设置服务器参数
    host = '0.0.0.0'
    port = 5000
    threads = 4
    
    logger.info(f"Waitress服务器正在 {host}:{port} 上运行，线程数: {threads}")
    
    # 启动Waitress服务器
    serve(app, host=host, port=port, threads=threads) 