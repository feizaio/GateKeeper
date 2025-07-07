import sys
import logging
from pathlib import Path

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("wsgi.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger("wsgi")
logger.info("初始化WSGI应用...")

# 将项目根目录添加到 sys.path
project_root = Path(__file__).parent.parent
sys.path.append(str(project_root))

# 尝试不同方式导入应用
try:
    from hackend.app import app as application
    logger.info("从hackend.app成功导入应用")
except ImportError:
    try:
        from backend.app import app as application
        logger.info("从backend.app成功导入应用")
    except ImportError:
        # 从backend创建应用
        logger.info("尝试从backend.__init__创建应用")
        from backend import create_app
        application = create_app()

if __name__ == '__main__':
    application.run() 