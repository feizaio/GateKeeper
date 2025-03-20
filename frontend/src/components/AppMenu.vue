<template>
  <el-menu
    :default-active="activeIndex"
    class="el-menu-vertical"
    @select="handleSelect"
    :collapse="isCollapse"
  >
    <el-menu-item index="/servers">
      <i class="el-icon-monitor"></i>
      <span>服务器管理</span>
    </el-menu-item>
    <el-menu-item index="/users">
      <i class="el-icon-user"></i>
      <span>用户管理</span>
    </el-menu-item>
    <!-- 添加注销按钮 -->
    <el-menu-item index="logout" @click="handleLogout">
      <i class="el-icon-switch-button"></i>
      <span>注销</span>
    </el-menu-item>
  </el-menu>
</template>
<script>
import axios from 'axios';

export default {
  data() {
    return {
      activeIndex: this.$route.path, // 根据当前路由设置默认选中项
      isCollapse: false // 控制菜单是否折叠
    };
  },
  methods: {
    handleSelect(index) {
      if (index === 'logout') {
        this.handleLogout();
      } else {
        this.$router.push(index); // 跳转到对应路由
      }
    },
    async handleLogout() {
      try {
        // 调用注销接口
        await axios.post('/api/auth/logout');
        // 清除本地存储的 token 和用户信息
        localStorage.removeItem('token');
        this.$store.commit('SET_USER', null);
        // 跳转到登录页面
        this.$router.push('/login');
        this.$message.success('注销成功');
      } catch (error) {
        console.error('注销失败:', error);
        const errorMessage = error.response && error.response.data && error.response.data.error || error.message;
        this.$message.error('注销失败: ' + errorMessage);
      }
    }
  }
};
</script>

<style scoped>
.el-menu-vertical {
  height: 100vh; /* 使菜单占满整个视口高度 */
  border-right: none; /* 移除默认边框 */
}
</style>