<template>
  <div class="about-page">
    <div class="harmony-container">
      <div class="about-content harmony-card">
        <div class="profile-section">
          <img src="https://via.placeholder.com/120" alt="头像" class="avatar">
          <h1 class="name">博主</h1>
          <p class="bio">热爱技术，热爱生活</p>
        </div>
        
        <div class="info-section">
          <h2 class="section-title">关于我</h2>
          <p class="section-content">
            这是一个基于Spring Boot和Vue 3开发的个人博客系统，
            采用鸿蒙设计语言，提供文章发布、评论互动、数据统计等功能。
          </p>
        </div>
        
        <div class="skills-section">
          <h2 class="section-title">技能标签</h2>
          <div class="skills">
            <el-tag v-for="skill in skills" :key="skill" size="large">{{ skill }}</el-tag>
          </div>
        </div>
        
        <div class="contact-section">
          <h2 class="section-title">联系方式</h2>
          <div class="contacts">
            <div class="contact-item">
              <el-icon><Message /></el-icon>
              <span>邮箱：author@blog.com</span>
            </div>
            <div class="contact-item">
              <el-icon><Link /></el-icon>
              <span>GitHub：github.com/username</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const skills = ref([
  'Java', 'Spring Boot', 'Vue', 'MySQL', 
  '前端开发', '后端开发', '全栈开发'
])
</script>

<style scoped lang="scss">
.about-page {
  padding: 24px 0;
  
  .about-content {
    max-width: 800px;
    margin: 0 auto;
    padding: 40px;
    
    .profile-section {
      text-align: center;
      padding-bottom: 32px;
      border-bottom: 1px solid #E5E5EA;
      margin-bottom: 32px;
      
      .avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        margin-bottom: 16px;
      }
      
      .name {
        font-size: 28px;
        font-weight: 700;
        margin: 0 0 8px 0;
      }
      
      .bio {
        color: #86868B;
        font-size: 16px;
        margin: 0;
      }
    }
    
    .info-section,
    .skills-section,
    .contact-section {
      margin-bottom: 32px;
      
      .section-title {
        font-size: 20px;
        font-weight: 600;
        margin: 0 0 16px 0;
        color: #1D1D1F;
      }
      
      .section-content {
        line-height: 1.8;
        color: #1D1D1F;
      }
    }
    
    .skills {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
    }
    
    .contacts {
      .contact-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px 0;
        color: #1D1D1F;
      }
    }
  }
}
</style>


