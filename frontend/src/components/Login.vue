<template>
  <div class="login-container">
    <!-- 左侧木纹背景部分 -->
    <div class="left-side-container">
      <div class="left-side"></div>
    </div>
    
    <!-- 右侧登录表单部分 -->
    <div class="right-side">
      <!-- Logo部分 - 移动到右上角 -->
      <div class="logo-container">
        <img src="/img/logo.svg" alt="LOGO" class="logo">
      </div>
      
      <!-- 中央内容区域 -->
      <div class="center-content">
        <!-- 平台名称和提示文字 -->
        <div class="platform-info">
          <h2 class="platform-title">GateKeeper堡垒机</h2>
          <p class="platform-subtitle">请在下方登录你的账户</p>
        </div>
        
        <!-- 登录表单 -->
        <el-form :model="loginForm" :rules="rules" ref="loginForm" @submit.native.prevent class="login-form">
          <el-form-item prop="username">
            <div class="form-label">登录账号</div>
            <el-input 
              v-model="loginForm.username" 
              placeholder="username">
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <div class="form-label">密码</div>
            <el-input 
              v-model="loginForm.password" 
              type="password"
              placeholder="••••••••••••••"
              @keyup.enter.native="handleLogin">
            </el-input>
          </el-form-item>
          
          <!-- 记住我复选框 -->
          <el-form-item>
            <el-checkbox v-model="rememberMe">记住账号密码</el-checkbox>
          </el-form-item>
          
          <!-- 登录按钮 -->
          <el-button type="primary" 
                    :loading="loading"
                    class="login-button"
                    @click="handleLogin">
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      loading: false,
      isSubmitting: false,
      loginForm: {
        username: '',
        password: ''
      },
      rememberMe: false,
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    // 自动填充账号密码
    const savedUsername = localStorage.getItem('rememberedUsername');
    const savedPassword = localStorage.getItem('rememberedPassword');
    if (savedUsername) {
      this.loginForm.username = savedUsername;
      this.rememberMe = true;
    }
    if (savedPassword) {
      this.loginForm.password = savedPassword;
    }
  },
  methods: {
    async handleLogin() {
      // 防止重复提交
      if (this.loading || this.isSubmitting) {
        console.log('登录请求正在处理中，请勿重复提交');
        return;
      }
      
      // 表单验证
      this.$refs.loginForm.validate(async valid => {
        if (!valid) {
          return false;
        }
        
        this.loading = true;
        this.isSubmitting = true; // 标记开始提交
        
        // 记住账号密码逻辑
        if (this.rememberMe) {
          localStorage.setItem('rememberedUsername', this.loginForm.username);
          localStorage.setItem('rememberedPassword', this.loginForm.password);
        } else {
          localStorage.removeItem('rememberedUsername');
          localStorage.removeItem('rememberedPassword');
        }
        
        try {
          const response = await axios.post('/api/auth/login', this.loginForm);
          const token = response.data.token;
          
          // 正确存储token到localStorage
          localStorage.setItem('token', token);
          
          // 设置全局请求头的Authorization
          axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
          
          // 使用正确的mutation名称保存用户信息
          this.$store.commit('setUser', response.data);
          
          // 启动不活动计时器
          this.$store.dispatch('startInactivityTimer');
          
          this.$message.success('登录成功');
          
          // 立即导航到首页，不使用定时器
          this.$router.push('/');
          
        } catch (error) {
          console.error('登录失败:', error);
          let errorMessage = '登录失败';
          if (error.response) {
            errorMessage = error.response.data.error || '服务器错误';
          } else if (error.request) {
            errorMessage = '网络错误，请检查网络连接';
          } else {
            errorMessage = error.message || '未知错误';
          }
          this.$message.error(errorMessage);
        } finally {
          this.loading = false;
          this.isSubmitting = false;
        }
      });
    }
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  width: 100%;
  display: flex;
  background-color: #f5f7fa;
  overflow: hidden;
}

/* 左侧木纹背景容器 */
.left-side-container {
  width: 25%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0;
  perspective: 1500px;
  overflow: hidden;
  background-color: #212121;
  position: relative;
}

/* 左侧操作系统界面背景 */
.left-side {
  width: 100%;
  height: 100%;
  background-image: url(/img/os-interface.svg);
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
  position: relative;
  z-index: 10;
  transform: perspective(1500px) rotateY(8deg) translateZ(50px);
  transition: all 0.8s cubic-bezier(0.165, 0.84, 0.44, 1);
  transform-origin: left center;
}

.left-side:before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 50%, rgba(0,0,0,0.2) 100%);
  z-index: 2;
}

.left-side:hover {
  transform: perspective(1500px) rotateY(2deg) translateZ(70px);
  box-shadow: 0 35px 60px rgba(0, 0, 0, 0.6);
}

/* 右侧登录区域 */
.right-side {
  width: 75%;
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

/* Logo样式 - 放在右上角 */
.logo-container {
  position: absolute;
  top: 40px;
  right: 40px;
}

.logo {
  width: 50px;
  height: 50px;
}

/* 中央内容区域 */
.center-content {
  width: 400px;
  max-width: 90%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* 平台信息样式 */
.platform-info {
  width: 100%;
  margin-bottom: 25px;
  text-align: center;
}

.platform-title {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 10px;
  color: #333;
}

.platform-subtitle {
  font-size: 14px;
  color: #999;
}

/* 登录表单样式 */
.login-form {
  width: 100%;
}

.form-label {
  font-size: 14px;
  margin-bottom: 5px;
  color: #333;
}

.el-input {
  margin-bottom: 15px;
}

.el-input >>> .el-input__inner {
  border-radius: 4px;
  height: 42px;
  padding: 0 15px;
  border: 1px solid #dcdfe6;
}

.el-input >>> .el-input__inner:focus {
  border-color: #1e88e5;
}

/* 登录按钮样式 */
.login-button {
  width: 100%;
  height: 44px;
  margin-top: 5px;
  background-color: #1e88e5;
  border: none;
  font-size: 16px;
  border-radius: 4px;
}

.login-button:hover {
  background-color: #1976d2;
}

/* 响应式调整 */
@media screen and (max-width: 1200px) {
  .logo-container {
    top: 20px;
    right: 20px;
  }
}

@media screen and (max-width: 768px) {
  .login-container {
    flex-direction: column;
  }
  
  .left-side-container {
    width: 100%;
    height: 35vh;
    padding: 0;
    background-color: #212121;
  }
  
  .left-side {
    width: 100%;
    height: 100%;
    background-size: contain;
    transform: perspective(1500px) rotateX(8deg) translateZ(40px);
    transform-origin: center top;
  }
  
  .left-side:hover {
    transform: perspective(1500px) rotateX(3deg) translateZ(60px) translateY(-5px);
  }
  
  .right-side {
    width: 100%;
    padding: 60px 20px 40px;
  }

  .logo-container {
    top: 15px;
    right: 15px;
  }
  
  .center-content {
    width: 100%;
  }
}
</style>