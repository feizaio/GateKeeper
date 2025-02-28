import Vue from 'vue'
import VueRouter from 'vue-router'
import UserManagement from '../components/UserManagement.vue'
import Login from '../components/Login.vue'
import Layout from '../components/Layout.vue'
import ServerList from '../components/ServerList.vue'
import store from '../store'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/',
    component: Layout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',  // 默认路由指向服务器列表
        name: 'Home',
        component: ServerList
      },
      {
        path: 'users',
        name: 'UserManagement',
        component: UserManagement
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  if (!token && to.path !== '/login') {
    next('/login');  // 如果没有 token 且目标路径不是登录页面，则跳转到登录页面
  } else {
    next();  // 放行
  }
});


export default router