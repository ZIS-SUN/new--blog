<template>
  <div class="guest-layout">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="harmony-container header-content">
        <div class="logo" @click="$router.push('/')">
          <h1>个人博客</h1>
        </div>
        
        <nav class="nav-menu">
          <router-link to="/" class="nav-item">首页</router-link>
          <router-link to="/category" class="nav-item">分类</router-link>
          <router-link to="/tag" class="nav-item">标签</router-link>
          <router-link to="/archive" class="nav-item">归档</router-link>
          <router-link to="/announcement" class="nav-item">公告</router-link>
          <router-link to="/message" class="nav-item">留言板</router-link>
          <router-link to="/about" class="nav-item">关于我</router-link>
        </nav>
        
        <div class="user-actions">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索文章..."
            class="search-input"
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
          <div v-if="isLoggedIn" class="user-info">
            <el-dropdown @command="handleCommand">
              <span class="user-name">
                {{ userName }} <el-icon><ArrowDown /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item v-if="isAdmin" command="admin">
                    后台管理
                  </el-dropdown-item>
                  <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
          <div v-else class="auth-buttons">
            <el-button type="primary" @click="$router.push('/auth/login')">登录</el-button>
            <el-button @click="$router.push('/auth/register')">注册</el-button>
          </div>
        </div>
      </div>
    </header>
    
    <!-- 主体内容 -->
    <main class="main-content">
      <router-view />
    </main>
    
    <!-- 底部 -->
    <footer class="footer">
      <div class="harmony-container">
        <p>&copy; 2025 个人博客系统. All rights reserved.</p>
        <p>基于 Spring Boot + Vue 3 + 鸿蒙设计语言</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()
const searchKeyword = ref('')

const isLoggedIn = computed(() => !!localStorage.getItem('token'))
const userName = computed(() => {
  const user = localStorage.getItem('user')
  return user ? JSON.parse(user).nickname || JSON.parse(user).username : ''
})
const isAdmin = computed(() => localStorage.getItem('userRole') === '1')

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    router.push({ name: 'Search', query: { keyword: searchKeyword.value } })
  }
}

const handleCommand = (command) => {
  if (command === 'admin') {
    router.push('/admin')
  } else if (command === 'logout') {
    handleLogout()
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  localStorage.removeItem('userRole')
  ElMessage.success('退出成功')
  router.push('/')
}
</script>

<style scoped lang="scss">
.guest-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  position: sticky;
  top: 0;
  z-index: 100;
  
  .header-content {
    display: flex;
    align-items: center;
    height: 64px;
    gap: 40px;
  }
  
  .logo {
    cursor: pointer;
    
    h1 {
      font-size: 20px;
      font-weight: 600;
      color: #007DFF;
      margin: 0;
    }
  }
  
  .nav-menu {
    flex: 1;
    display: flex;
    gap: 24px;
    
    .nav-item {
      text-decoration: none;
      color: #1D1D1F;
      font-size: 15px;
      font-weight: 500;
      padding: 8px 12px;
      border-radius: 8px;
      transition: all 0.3s;
      
      &:hover, &.router-link-active {
        color: #007DFF;
        background: #E6F0FF;
      }
    }
  }
  
  .user-actions {
    display: flex;
    align-items: center;
    gap: 16px;
    
    .search-input {
      width: 200px;
    }
    
    .user-name {
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 14px;
      color: #1D1D1F;
    }
    
    .auth-buttons {
      display: flex;
      gap: 8px;
    }
  }
}

.main-content {
  flex: 1;
  padding: 24px 0;
}

.footer {
  background: white;
  border-top: 1px solid #E5E5EA;
  padding: 24px 0;
  text-align: center;
  
  p {
    margin: 4px 0;
    color: #86868B;
    font-size: 14px;
  }
}
</style>


