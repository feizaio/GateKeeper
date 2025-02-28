<template>
  <div class="layout">
    <el-container>
      <el-header height="50px">
        <div class="header-content">
          <div class="client-status">
            <el-tooltip :content="statusText" placement="bottom">
              <i :class="['client-icon', statusIcon]"></i>
            </el-tooltip>
          </div>
          <span class="header-title">堡垒机管理系统</span>
        </div>
      </el-header>
      
      <el-container>
        <el-aside width="200px">
          <div class="logo">堡垒机</div>
          <el-menu
            :default-active="$route.path"
            class="el-menu-vertical"
            router
          >
            <el-menu-item index="/">
              <i class="el-icon-monitor"></i>
              <span>服务器管理</span>
            </el-menu-item>
            

            <el-submenu index="2">
              <template slot="title">
                <i class="el-icon-setting"></i>
                <span>系统设置</span>
              </template>
              <el-menu-item index="/users">
                <i class="el-icon-user"></i>
                <span>用户管理</span>
              </el-menu-item>
            </el-submenu>
          </el-menu>
        </el-aside>
        
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
    </el-container>

    <!-- 客户端下载提示对话框 -->
    <el-dialog
      title="需要安装客户端"
      :visible.sync="showClientDialog"
      width="400px">
      <span>需要安装堡垒机客户端才能使用远程连接功能。</span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showClientDialog = false">取消</el-button>
        <el-button type="primary" @click="downloadClient">
          下载客户端
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'Layout',
  data() {
    return {
      clientConnected: false,
      checkingStatus: false,
      showClientDialog: false
    }
  },
  computed: {
    statusIcon() {
      if (this.checkingStatus) return 'el-icon-loading';
      return this.clientConnected ? 'el-icon-success' : 'el-icon-error';
    },
    statusText() {
      if (this.checkingStatus) return '正在检查客户端状态...';
      return this.clientConnected ? '客户端已连接' : '客户端未连接';
    }
  },
  methods: {
    async checkClientStatus() {
      try {
        this.checkingStatus = true;
        const response = await axios.get('/api/client/status');
        
        // 直接使用服务器返回的状态
        this.clientConnected = response.data.is_connected;
        
        // 只有在未连接时才显示下载对话框
        if (!this.clientConnected && !this.showClientDialog) {
          this.showClientDialog = true;
        }
        
        console.log('客户端状态:', {
          currentIp: response.data.current_ip,
          isConnected: response.data.is_connected,
          clients: response.data.clients
        });
        
      } catch (error) {
        console.error('检查客户端状态失败:', error);
        this.clientConnected = false;
      } finally {
        this.checkingStatus = false;
      }
    },
    downloadClient() {
      window.location.href = '/static/fortress_client.exe';
      this.showClientDialog = false;
    },
    startStatusCheck() {
      // 更频繁地检查状态（每10秒一次）
      this.statusCheckInterval = setInterval(() => {
        this.checkClientStatus();
      }, 10000);
      
      // 立即执行一次检查
      this.checkClientStatus();
    }
  },
  mounted() {
    this.startStatusCheck();
  },
  beforeDestroy() {
    if (this.statusCheckInterval) {
      clearInterval(this.statusCheckInterval);
    }
  }
}
</script>

<style scoped>
.layout {
  height: 100vh;
}

.el-aside {
  background-color: #304156;
  height: 100vh;
}

.el-menu {
  border-right: none;
  background-color: transparent;
}

.el-menu-item {
  color: #fff;
}

.el-menu-item:hover, .el-menu-item.is-active {
  background-color: #263445;
}

.el-submenu {
  color: #fff;
}

.el-submenu /deep/ .el-submenu__title {
  color: #fff;
}

.el-submenu /deep/ .el-submenu__title:hover {
  background-color: #263445;
}

.header-content {
  display: flex;
  align-items: center;
  height: 100%;
}

.client-status {
  margin-right: 20px;
}

.client-icon {
  font-size: 20px;
}

.client-icon.el-icon-success {
  color: #67C23A;
}

.client-icon.el-icon-error {
  color: #F56C6C;
}

.client-icon.el-icon-loading {
  color: #409EFF;
}

.header-title {
  color: #303133;
  font-size: 18px;
}
</style> 