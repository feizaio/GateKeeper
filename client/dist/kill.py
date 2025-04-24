from pywinauto import Application
import time

while True:
    try:
        # 连接到 MicroStation 进程（调整进程名）
        app = Application(backend="win32").connect(title="Bentley.Licensing.Service.exe", timeout=1)
        # 关闭窗口
        app.window(title="Bentley.Licensing.Service.exe").close()
        print("弹窗已关闭")
    except Exception:
        pass  # 如果窗口不存在，继续循环
    time.sleep(5)  # 每 5 秒检查一次