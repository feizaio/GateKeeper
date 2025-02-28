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
    <el-menu-item index="/settings">
      <i class="el-icon-setting"></i>
      <span>系统设置</span>
    </el-menu-item>
  </el-menu>
</template>

<script>
export default {
  data() {
    return {
      activeIndex: this.$route.path, // 根据当前路由设置默认选中项
      isCollapse: false // 控制菜单是否折叠
    };
  },
  methods: {
    handleSelect(index) {
      this.$router.push(index); // 跳转到对应路由
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