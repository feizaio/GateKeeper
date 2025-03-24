import Vue from 'vue'
import VueRouter from 'vue-router'
import UserManagement from '../components/UserManagement.vue'
import Login from '../components/Login.vue'
import Layout from '../components/Layout.vue'
import ServerList from '../components/ServerList.vue'
import CategoryManagement from '../components/CategoryManagement.vue'
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
        component: UserManagement,
        meta: { requiresAuth: true, requiresAdmin: true }
      },
      {
        path: 'system/categories',
        name: 'CategoryManagement',
        component: CategoryManagement,
        meta: { requiresAuth: true, requiresAdmin: true }
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
  const isAuthenticated = localStorage.getItem('token')
  const user = store.state.user
  const isAdmin = user && user.is_admin

  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!isAuthenticated) {
      next('/login')
    } else if (to.matched.some(record => record.meta.requiresAdmin) && !isAdmin) {
      next('/')
    } else {
      next()
    }
  } else {
    next()
  }
})


export default router