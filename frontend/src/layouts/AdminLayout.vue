<template>
  <div class="admin-layout">
    <el-container>
      <!-- 侧边栏 -->
      <el-aside width="240px" class="sidebar">
        <div class="logo">
          <h2>博客后台</h2>
        </div>
        
        <el-menu
          :default-active="activeMenu"
          router
          background-color="#001529"
          text-color="#ffffff"
          active-text-color="#007DFF"
        >
          <el-menu-item index="/admin">
            <el-icon><Odometer /></el-icon>
            <span>仪表盘</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/article">
            <el-icon><Document /></el-icon>
            <span>文章管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/category">
            <el-icon><Folder /></el-icon>
            <span>分类管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/tag">
            <el-icon><PriceTag /></el-icon>
            <span>标签管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/announcement">
            <el-icon><Bell /></el-icon>
            <span>公告管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/comment">
            <el-icon><ChatDotRound /></el-icon>
            <span>评论管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/message">
            <el-icon><MessageBox /></el-icon>
            <span>留言管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/user">
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      
      <!-- 主体内容 -->
      <el-container>
        <el-header class="header">
          <div class="header-content">
            <div class="breadcrumb">
              <span>{{ currentPageTitle }}</span>
            </div>
            
            <div class="actions">
              <el-button text @click="$router.push('/')">
                <el-icon><HomeFilled /></el-icon>
                返回前台
              </el-button>
              
              <el-dropdown @command="handleCommand">
                <span class="user-dropdown">
                  管理员 <el-icon><ArrowDown /></el-icon>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </div>
        </el-header>
        
        <el-main class="main">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()

const activeMenu = computed(() => route.path)
const currentPageTitle = computed(() => route.meta.title || '')

const handleCommand = (command) => {
  if (command === 'logout') {
    handleLogout()
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  localStorage.removeItem('userRole')
  ElMessage.success('退出成功')
  router.push('/auth/login')
}
</script>

<style scoped lang="scss">
.admin-layout {
  height: 100vh;
  
  .el-container {
    height: 100%;
  }
  
  .sidebar {
    background: #001529;
    
    .logo {
      height: 64px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      
      h2 {
        color: white;
        font-size: 18px;
        margin: 0;
      }
    }
    
    .el-menu {
      border-right: none;
    }
  }
  
  .header {
    background: white;
    border-bottom: 1px solid #E5E5EA;
    
    .header-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 100%;
      
      .breadcrumb {
        font-size: 16px;
        font-weight: 600;
        color: #1D1D1F;
      }
      
      .actions {
        display: flex;
        align-items: center;
        gap: 16px;
        
        .user-dropdown {
          cursor: pointer;
          display: flex;
          align-items: center;
          gap: 4px;
        }
      }
    }
  }
  
  .main {
    background: #f5f7fa;
    padding: 24px;
  }
}
</style>


