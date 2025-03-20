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
          <!-- 添加注销按钮 -->
          <el-button type="text" class="logout-button" @click="handleLogout">
            <i class="el-icon-switch-button"></i>
            注销
          </el-button>
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
    },
    isLoggedIn() {
      return this.$store.state.user !== null;
    }
  },
  methods: {
    async handleLogout() {
      try {
        // 调用注销接口
        await axios.post('/api/auth/logout');
        // 清除本地存储的 token 和用户信息
        localStorage.removeItem('token');
        this.$store.commit('SET_USER', null);
        // 停止状态检查
        this.stopStatusCheck();
        // 重置状态
        this.clientConnected = false;
        this.checkingStatus = false;
        this.showClientDialog = false;
        // 跳转到登录页面
        this.$router.push('/login');
        this.$message.success('注销成功');
      } catch (error) {
        console.error('注销失败:', error);
        const errorMessage = error.response && error.response.data && error.response.data.error || error.message;
        this.$message.error('注销失败: ' + errorMessage);
      }
    },
    async checkClientStatus() {
      // 如果未登录，不执行检查
      if (!this.isLoggedIn) {
        return;
      }
      
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
      // 如果未登录，不启动检查
      if (!this.isLoggedIn) {
        return;
      }
      
      // 如果已经有定时器在运行，先清除它
      this.stopStatusCheck();
      
      // 更频繁地检查状态（每10秒一次）
      this.statusCheckInterval = setInterval(() => {
        this.checkClientStatus();
      }, 10000);
      
      // 立即执行一次检查
      this.checkClientStatus();
    },
    stopStatusCheck() {
      if (this.statusCheckInterval) {
        clearInterval(this.statusCheckInterval);
        this.statusCheckInterval = null;
      }
    }
  },
  watch: {
    // 监听登录状态变化
    isLoggedIn(newValue) {
      if (newValue) {
        this.startStatusCheck();
      } else {
        this.stopStatusCheck();
      }
    }
  },
  mounted() {
    // 只在登录状态下启动检查
    if (this.isLoggedIn) {
      this.startStatusCheck();
    }
  },
  beforeDestroy() {
    this.stopStatusCheck();
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

.logout-button {
  margin-left: auto;
  color: #F56C6C;
}
</style>