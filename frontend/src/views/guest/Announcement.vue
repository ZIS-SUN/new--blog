<template>
  <div class="announcement-page">
    <div class="harmony-container">
      <h1 class="page-title">公告中心</h1>
      
      <div class="announcement-list">
        <div
          v-for="item in announcements"
          :key="item.announcementId"
          class="announcement-card harmony-card"
          @click="$router.push({ name: 'AnnouncementDetail', params: { id: item.announcementId } })"
        >
          <div class="announcement-header">
            <div class="tags">
              <el-tag v-if="item.isTop" type="warning" effect="dark">置顶</el-tag>
              <el-tag v-if="item.isEmergency" type="danger" effect="dark">紧急</el-tag>
            </div>
            <span class="date">{{ formatDate(item.publishTime) }}</span>
          </div>
          
          <h3 class="announcement-title">{{ item.title }}</h3>
          <p class="announcement-summary">{{ item.summary }}</p>
        </div>
      </div>
      
      <el-empty v-if="!announcements.length" description="暂无公告" />
      
      <div v-if="total > 0" class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          :total="total"
          :page-size="pageSize"
          layout="total, prev, pager, next"
          @current-change="loadAnnouncements"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAnnouncementList } from '@/api/announcement'

const announcements = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

const loadAnnouncements = async () => {
  try {
    const res = await getAnnouncementList({
      current: currentPage.value,
      size: pageSize.value
    })
    announcements.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载公告失败', error)
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  loadAnnouncements()
})
</script>

<style scoped lang="scss">
.announcement-page {
  padding: 24px 0;
  
  .page-title {
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
    color: #1D1D1F;
  }
  
  .announcement-list {
    max-width: 900px;
    margin: 0 auto;
    
    .announcement-card {
      padding: 24px;
      margin-bottom: 16px;
      cursor: pointer;
      
      &:hover .announcement-title {
        color: #007DFF;
      }
      
      .announcement-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
        
        .tags {
          display: flex;
          gap: 8px;
        }
        
        .date {
          color: #86868B;
          font-size: 14px;
        }
      }
      
      .announcement-title {
        font-size: 20px;
        font-weight: 600;
        margin: 0 0 12px 0;
        transition: color 0.3s;
      }
      
      .announcement-summary {
        color: #86868B;
        margin: 0;
        line-height: 1.6;
      }
    }
  }
  
  .pagination {
    display: flex;
    justify-content: center;
    margin-top: 32px;
  }
}
</style>


