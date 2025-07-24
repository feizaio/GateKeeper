import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../components/Login.vue'
import Layout from '../components/Layout.vue'
import ServerList from '../components/ServerList.vue'
import Dashboard from '../components/Dashboard.vue'
import UserManagement from '../components/UserManagement.vue'
import CategoryManagement from '../components/CategoryManagement.vue'
import AuditLogs from '../components/AuditLogs.vue'
import CredentialManagement from '../components/CredentialManagement.vue'

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
        path: 'dashboard',
        name: 'Dashboard',
        component: Dashboard,
        meta: { requiresAuth: true, requiresAdmin: true }
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
      },
      {
        path: 'system/audit-logs',
        name: 'AuditLogs',
        component: AuditLogs,
        meta: { requiresAuth: true, requiresAdmin: true }
      },
      {
        path: 'system/credentials',
        name: 'CredentialManagement',
        component: CredentialManagement,
        meta: { requiresAuth: true, requiresAdmin: true }
      },
      {
        path: 'system/service-manager',
        name: 'ServiceManager',
        component: () => import('../components/ServiceManager.vue'),
        meta: { requiresAuth: true }
      },
      {
        path: 'system/task-manager',
        name: 'TaskManager',
        component: () => import('../components/TaskManager.vue'),
        meta: { requiresAuth: true }
      },
      {
        path: 'system/task-detail/:id',
        name: 'TaskDetail',
        component: () => import('../components/TaskDetail.vue'),
        meta: { requiresAuth: true },
        props: true
      },
      {
        path: 'system/task-execution/:id',
        name: 'TaskExecution',
        component: () => import('../components/TaskExecution.vue'),
        meta: { requiresAuth: true },
        props: true
      },
      {
        path: 'system/task-views',
        name: 'TaskViewManagement',
        component: () => import('../components/TaskViewManagement.vue'),
        meta: { requiresAuth: true }
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
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const requiresAdmin = to.matched.some(record => record.meta.requiresAdmin)
  const isLoggedIn = !!localStorage.getItem('token')
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  const isAdmin = user.is_admin === true

  if (requiresAuth && !isLoggedIn) {
      next('/login')
  } else if (requiresAdmin && !isAdmin) {
      next('/')
  } else {
    next()
  }
})

export default router