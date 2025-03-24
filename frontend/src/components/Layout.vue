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
          
          <!-- 用户信息下拉菜单 -->
          <div class="user-dropdown">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-info">
                <i class="el-icon-user-solid"></i>
                <span>{{ currentUser.username }}</span>
                <i class="el-icon-caret-bottom"></i>
              </div>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="changePassword">
                  <i class="el-icon-key"></i>
                  <span>修改密码</span>
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <i class="el-icon-switch-button"></i>
                  <span>退出登录</span>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </el-header>
      
      <el-container>
        <el-aside width="180px">
          <el-menu
            :default-active="$route.path"
            class="el-menu-vertical"
            router>
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
              <el-menu-item index="/system/categories" v-if="isAdmin">
                <i class="el-icon-collection-tag"></i>
                <span>分类管理</span>
              </el-menu-item>
            </el-submenu>
          </el-menu>
        </el-aside>
        
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
    </el-container>

    <!-- 修改密码对话框 -->
    <el-dialog
      title="修改密码"
      :visible.sync="passwordDialogVisible"
      width="400px"
      :close-on-click-modal="false">
      <el-form
        :model="passwordForm"
        :rules="passwordRules"
        ref="passwordForm"
        label-width="100px">
        <el-form-item label="原密码" prop="oldPassword">
          <el-input
            v-model="passwordForm.oldPassword"
            type="password"
            show-password
            placeholder="请输入原密码">
          </el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            show-password
            placeholder="请输入新密码">
          </el-input>
        </el-form-item>
        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            show-password
            placeholder="请再次输入新密码">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="passwordDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitPasswordChange">确 定</el-button>
      </div>
    </el-dialog>

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
    // 密码确认验证函数
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入的密码不一致'));
      } else {
        callback();
      }
    };

    return {
      clientConnected: false,
      checkingStatus: false,
      showClientDialog: false,
      passwordDialogVisible: false,
      passwordForm: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      passwordRules: {
        oldPassword: [
          { required: true, message: '请输入原密码', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能小于6个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      }
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
    },
    isAdmin() {
      return this.$store.state.user && this.$store.state.user.is_admin;
    },
    currentUser() {
      return this.$store.state.user || { username: '' };
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
    },
    handleCommand(command) {
      switch (command) {
        case 'changePassword':
          this.showChangePasswordDialog();
          break;
        case 'logout':
          this.handleLogout();
          break;
      }
    },
    showChangePasswordDialog() {
      this.passwordDialogVisible = true;
      this.passwordForm = {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      };
    },
    async submitPasswordChange() {
      try {
        await this.$refs.passwordForm.validate();
        
        const response = await this.axios.post('/api/auth/change-password', {
          old_password: this.passwordForm.oldPassword,
          new_password: this.passwordForm.newPassword
        });

        if (response.data.success) {
          this.$message.success('密码修改成功');
          this.passwordDialogVisible = false;
        }
      } catch (error) {
        if (error.response) {
          this.$message.error(error.response.data.error || '密码修改失败');
        } else if (error.message) {
          // 表单验证错误
          this.$message.error(error.message);
        } else {
          this.$message.error('密码修改失败');
        }
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
  background-color: #f0f2f5;
}

.el-aside {
  background: linear-gradient(180deg, #F8FAFF 0%, #F0F5FF 100%);
  height: 100vh;
  box-shadow: 1px 0 8px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
  width: 180px !important;
}

.el-menu {
  border-right: none;
  background: transparent;
  padding-top: 12px;
  flex: 1;
  width: 180px;
}

.el-menu-item {
  height: 48px;
  line-height: 48px;
  color: #5B6B8B !important;
  margin: 4px 12px;
  padding: 0 16px !important;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.el-menu-item:hover {
  color: #4B7BE5 !important;
  background-color: rgba(75, 123, 229, 0.08) !important;
  transform: translateX(4px);
}

.el-menu-item.is-active {
  color: #4B7BE5 !important;
  background-color: rgba(75, 123, 229, 0.12) !important;
  font-weight: 500;
}

.el-submenu /deep/ .el-submenu__title {
  height: 48px;
  line-height: 48px;
  color: #5B6B8B !important;
  margin: 4px 12px;
  padding: 0 16px !important;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.el-submenu /deep/ .el-submenu__title:hover {
  color: #4B7BE5 !important;
  background-color: rgba(75, 123, 229, 0.08) !important;
  transform: translateX(4px);
}

.el-submenu.is-active /deep/ .el-submenu__title {
  color: #4B7BE5 !important;
}

.el-submenu /deep/ .el-menu {
  background-color: transparent !important;
  padding-left: 8px;
  margin: 0 8px;
  border-radius: 8px;
}

.el-menu-item i, .el-submenu /deep/ .el-submenu__title i {
  margin-right: 12px;
  width: 18px;
  font-size: 18px;
  color: inherit;
  transition: all 0.3s ease;
}

.header-content {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 0 24px;
  background: linear-gradient(90deg, #5B8FF9 0%, #4B7BE5 100%);
  position: relative;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.header-title {
  color: #fff;
  font-size: 18px;
  font-weight: 500;
  letter-spacing: 0.5px;
  opacity: 0.95;
  margin-left: 20px;
}

.user-dropdown {
  margin-left: auto;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 6px 16px;
  cursor: pointer;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  transition: all 0.3s ease;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.2);
}

.user-info i {
  color: #fff;
  font-size: 16px;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 6px 14px; /* 调整 */
  cursor: pointer;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); /* 调整 */
  gap: 6px; /* 新增 */
}

.el-dropdown-menu {
  min-width: 140px; /* 新增 */
  border-radius: 6px; /* 调整 */
  margin-top: 4px; /* 减少间距 */
}

.el-dropdown-menu__item {
  align-items: center; /* 新增 */
  padding: 8px 16px; /* 调整 */
  font-size: 13px; /* 可选：调小字号 */
}

.el-dropdown-menu__item i {
  margin-right: 8px; /* 调整 */
  width: 18px; /* 新增 */
  font-size: 16px; /* 调整 */
}

.el-dropdown-menu__item.is-divided {
  border-top: 1px solid #ebeef5;
  margin: 4px 0;
  padding-top: 8px; /* 调整 */
}

.el-header {
  padding: 0;
  height: 60px !important;
  box-shadow: 0 1px 4px rgba(0,21,41,0.08);
  z-index: 10;
  position: relative;
}

.el-main {
  padding: 20px;
  background-color: #F8FAFF;
}

.client-status {
  display: flex;
  align-items: center;
  margin-right: 24px;
  padding: 6px 12px;
  background: rgba(255,255,255,0.1);
  border-radius: 20px;
  backdrop-filter: blur(5px);
  transition: all 0.3s ease;
}

.client-status:hover {
  background: rgba(255,255,255,0.15);
}

.client-icon {
  font-size: 16px;
  color: rgba(255,255,255,0.85);
  transition: all 0.3s ease;
}

.client-icon.el-icon-success {
  color: #67C23A;
  text-shadow: 0 0 8px rgba(103, 194, 58, 0.3);
}

.client-icon.el-icon-error {
  color: #F56C6C;
  text-shadow: 0 0 8px rgba(245, 108, 108, 0.3);
}

.client-icon.el-icon-loading {
  color: #409EFF;
  text-shadow: 0 0 8px rgba(64, 158, 255, 0.3);
}
</style>