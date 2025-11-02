<template>
  <div class="announcement-detail-page">
    <div class="harmony-container">
      <div v-if="announcement" class="announcement-content harmony-card">
        <div class="announcement-header">
          <div class="tags">
            <el-tag v-if="announcement.isTop" type="warning" effect="dark">置顶</el-tag>
            <el-tag v-if="announcement.isEmergency" type="danger" effect="dark">紧急</el-tag>
          </div>
          <h1 class="title">{{ announcement.title }}</h1>
          <div class="meta">
            <span>发布时间：{{ formatDate(announcement.publishTime) }}</span>
          </div>
        </div>
        
        <div class="announcement-body" v-html="announcement.content"></div>
        
        <div class="announcement-footer">
          <el-button @click="$router.back()">返回</el-button>
        </div>
      </div>
      
      <el-empty v-else description="公告不存在" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getAnnouncementDetail } from '@/api/announcement'

const route = useRoute()
const announcement = ref(null)

const loadAnnouncement = async () => {
  try {
    const res = await getAnnouncementDetail(route.params.id)
    announcement.value = res.data
  } catch (error) {
    console.error('加载公告失败', error)
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

onMounted(() => {
  loadAnnouncement()
})
</script>

<style scoped lang="scss">
.announcement-detail-page {
  padding: 24px 0;
  
  .announcement-content {
    max-width: 900px;
    margin: 0 auto;
    padding: 40px;
    
    .announcement-header {
      padding-bottom: 24px;
      border-bottom: 1px solid #E5E5EA;
      margin-bottom: 32px;
      
      .tags {
        display: flex;
        gap: 8px;
        margin-bottom: 16px;
      }
      
      .title {
        font-size: 32px;
        font-weight: 700;
        margin: 0 0 16px 0;
        color: #1D1D1F;
      }
      
      .meta {
        color: #86868B;
        font-size: 14px;
      }
    }
    
    .announcement-body {
      font-size: 16px;
      line-height: 1.8;
      color: #1D1D1F;
      margin-bottom: 32px;
    }
    
    .announcement-footer {
      padding-top: 24px;
      border-top: 1px solid #E5E5EA;
    }
  }
}
</style>


