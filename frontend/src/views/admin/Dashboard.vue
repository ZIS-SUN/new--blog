<template>
  <div class="dashboard-page">
    <h2 class="page-title">仪表盘</h2>
    
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <div class="stat-card harmony-card">
          <div class="stat-icon" style="background: #E6F0FF; color: #007DFF;">
            <el-icon size="32"><Document /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.articleCount || 0 }}</div>
            <div class="stat-label">文章总数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :span="6">
        <div class="stat-card harmony-card">
          <div class="stat-icon" style="background: #FFE6E6; color: #FF4D4F;">
            <el-icon size="32"><User /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.userCount || 0 }}</div>
            <div class="stat-label">用户总数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :span="6">
        <div class="stat-card harmony-card">
          <div class="stat-icon" style="background: #FFF7E6; color: #FAAD14;">
            <el-icon size="32"><ChatDotRound /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.commentCount || 0 }}</div>
            <div class="stat-label">评论总数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :span="6">
        <div class="stat-card harmony-card">
          <div class="stat-icon" style="background: #E6FFFB; color: #13C2C2;">
            <el-icon size="32"><Bell /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.announcementCount || 0 }}</div>
            <div class="stat-label">公告总数</div>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <!-- 图表区域 -->
    <el-row :gutter="20" class="charts-row">
      <el-col :span="24">
        <div class="chart-card harmony-card">
          <h3>欢迎使用个人博客管理系统</h3>
          <p>系统采用 Spring Boot + Vue 3 + 鸿蒙设计语言开发</p>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getDashboardStatistics } from '@/api/admin'

const statistics = ref({
  articleCount: 0,
  userCount: 0,
  commentCount: 0,
  announcementCount: 0
})

const loadStatistics = async () => {
  try {
    const res = await getDashboardStatistics()
    statistics.value = res.data || {}
  } catch (error) {
    console.error('加载统计数据失败', error)
  }
}

onMounted(() => {
  loadStatistics()
})
</script>

<style scoped lang="scss">
.dashboard-page {
  .page-title {
    font-size: 24px;
    font-weight: 600;
    margin: 0 0 24px 0;
    color: #1D1D1F;
  }
  
  .stats-row {
    margin-bottom: 20px;
    
    .stat-card {
      padding: 24px;
      display: flex;
      align-items: center;
      gap: 16px;
      
      .stat-icon {
        width: 64px;
        height: 64px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      
      .stat-info {
        flex: 1;
        
        .stat-value {
          font-size: 32px;
          font-weight: 700;
          color: #1D1D1F;
          margin-bottom: 4px;
        }
        
        .stat-label {
          font-size: 14px;
          color: #86868B;
        }
      }
    }
  }
  
  .charts-row {
    .chart-card {
      padding: 32px;
      text-align: center;
      
      h3 {
        font-size: 20px;
        margin: 0 0 16px 0;
      }
      
      p {
        color: #86868B;
        margin: 0;
      }
    }
  }
}
</style>

