import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    component: () => import('@/layouts/GuestLayout.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('@/views/guest/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: '/article/:id',
        name: 'ArticleDetail',
        component: () => import('@/views/guest/ArticleDetail.vue'),
        meta: { title: '文章详情' }
      },
      {
        path: '/category',
        name: 'Category',
        component: () => import('@/views/guest/Category.vue'),
        meta: { title: '分类浏览' }
      },
      {
        path: '/tag',
        name: 'Tag',
        component: () => import('@/views/guest/Tag.vue'),
        meta: { title: '标签浏览' }
      },
      {
        path: '/archive',
        name: 'Archive',
        component: () => import('@/views/guest/Archive.vue'),
        meta: { title: '归档' }
      },
      {
        path: '/search',
        name: 'Search',
        component: () => import('@/views/guest/Search.vue'),
        meta: { title: '搜索' }
      },
      {
        path: '/announcement',
        name: 'Announcement',
        component: () => import('@/views/guest/Announcement.vue'),
        meta: { title: '公告中心' }
      },
      {
        path: '/announcement/:id',
        name: 'AnnouncementDetail',
        component: () => import('@/views/guest/AnnouncementDetail.vue'),
        meta: { title: '公告详情' }
      },
      {
        path: '/about',
        name: 'About',
        component: () => import('@/views/guest/About.vue'),
        meta: { title: '关于我' }
      },
      {
        path: '/message',
        name: 'Message',
        component: () => import('@/views/guest/Message.vue'),
        meta: { title: '留言板' }
      }
    ]
  },
  {
    path: '/auth',
    component: () => import('@/layouts/AuthLayout.vue'),
    children: [
      {
        path: 'login',
        name: 'Login',
        component: () => import('@/views/auth/Login.vue'),
        meta: { title: '登录' }
      },
      {
        path: 'register',
        name: 'Register',
        component: () => import('@/views/auth/Register.vue'),
        meta: { title: '注册' }
      }
    ]
  },
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requiresAuth: true, requiresAdmin: true },
    children: [
      {
        path: '',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { title: '仪表盘' }
      },
      {
        path: 'article',
        name: 'AdminArticle',
        component: () => import('@/views/admin/Article.vue'),
        meta: { title: '文章管理' }
      },
      {
        path: 'category',
        name: 'AdminCategory',
        component: () => import('@/views/admin/Category.vue'),
        meta: { title: '分类管理' }
      },
      {
        path: 'tag',
        name: 'AdminTag',
        component: () => import('@/views/admin/Tag.vue'),
        meta: { title: '标签管理' }
      },
      {
        path: 'announcement',
        name: 'AdminAnnouncement',
        component: () => import('@/views/admin/Announcement.vue'),
        meta: { title: '公告管理' }
      },
      {
        path: 'comment',
        name: 'AdminComment',
        component: () => import('@/views/admin/Comment.vue'),
        meta: { title: '评论管理' }
      },
      {
        path: 'message',
        name: 'AdminMessage',
        component: () => import('@/views/admin/AdminMessage.vue'),
        meta: { title: '留言管理' }
      },
      {
        path: 'user',
        name: 'AdminUser',
        component: () => import('@/views/admin/User.vue'),
        meta: { title: '用户管理' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - 个人博客` : '个人博客'
  
  const token = localStorage.getItem('token')
  const userRole = localStorage.getItem('userRole')
  
  if (to.meta.requiresAuth && !token) {
    next('/auth/login')
  } else if (to.meta.requiresAdmin && userRole != '1') {
    next('/')
  } else {
    next()
  }
})

export default router


