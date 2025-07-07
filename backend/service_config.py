import win32serviceutil
import win32service
import win32event
import servicemanager
import socket
import sys
import os
import logging
from pathlib import Path

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("service.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger("service")

# 添加项目路径
project_root = Path(__file__).parent.parent
sys.path.append(str(project_root))

class AppService(win32serviceutil.ServiceFramework):
    _svc_name_ = "FlaskAppService"
    _svc_display_name_ = "Flask Application Service"
    _svc_description_ = "运行Flask WSGI应用程序的Windows服务"

    def __init__(self, args):
        win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        socket.setdefaulttimeout(60)
        self.is_running = True

    def SvcStop(self):
        self.is_running = False
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)

    def SvcDoRun(self):
        servicemanager.LogMsg(servicemanager.EVENTLOG_INFORMATION_TYPE,
                            servicemanager.PYS_SERVICE_STARTED,
                            (self._svc_name_, ''))
        self.main()

    def main(self):
        # 切换到应用程序目录
        os.chdir(str(project_root / "backend"))
        logger.info("切换到目录: %s", str(project_root / "backend"))
        
        # 导入waitress
        from waitress import serve
        
        # 尝试不同的方式导入或创建Flask应用
        try:
            from hackend.app import app
            logger.info("从hackend.app成功导入应用")
        except ImportError:
            try:
                from backend.app import app
                logger.info("从backend.app成功导入应用")
            except ImportError:
                # 从backend创建应用
                logger.info("尝试从backend.__init__创建应用")
                from backend import create_app
                app = create_app()
        
        # 启动服务器
        logger.info("启动Waitress服务器在 0.0.0.0:5000")
        serve(app, host='0.0.0.0', port=5000, threads=4)


if __name__ == '__main__':
    if len(sys.argv) == 1:
        servicemanager.Initialize()
        servicemanager.PrepareToHostSingle(AppService)
        servicemanager.StartServiceCtrlDispatcher()
    else:
        win32serviceutil.HandleCommandLine(AppService) 