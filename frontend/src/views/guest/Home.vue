<template>
  <div class="home-page">
    <div class="harmony-container">
      <div class="content-layout">
        <!-- 主要内容区域 -->
        <div class="main-content">
          <!-- 公告轮播 -->
          <div v-if="topAnnouncements.length" class="announcement-banner harmony-card">
            <el-carousel height="120px" :interval="5000">
              <el-carousel-item v-for="item in topAnnouncements" :key="item.announcementId">
                <div class="announcement-item" @click="goToAnnouncement(item.announcementId)">
                  <div class="announcement-header">
                    <el-tag v-if="item.isEmergency" type="danger" effect="dark">紧急</el-tag>
                    <el-tag v-else type="primary" effect="dark">公告</el-tag>
                    <span class="announcement-title">{{ item.title }}</span>
                  </div>
                  <p class="announcement-summary">{{ item.summary }}</p>
                </div>
              </el-carousel-item>
            </el-carousel>
          </div>
          
          <!-- 文章列表 -->
          <div class="article-list">
            <div
              v-for="article in articles"
              :key="article.articleId"
              class="article-card harmony-card"
              @click="goToArticle(article.articleId)"
            >
              <div v-if="article.coverImage" class="article-cover">
                <img :src="article.coverImage" :alt="article.title">
                <el-tag v-if="article.isTop" class="top-tag" type="danger">置顶</el-tag>
              </div>
              
              <div class="article-content">
                <h2 class="article-title">
                  <el-tag v-if="article.isTop && !article.coverImage" type="danger" size="small">置顶</el-tag>
                  {{ article.title }}
                </h2>
                
                <p class="article-summary">{{ article.summary }}</p>
                
                <div class="article-meta">
                  <span class="meta-item">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(article.publishTime) }}
                  </span>
                  <span class="meta-item">
                    <el-icon><View /></el-icon>
                    {{ article.viewCount }}
                  </span>
                  <span class="meta-item">
                    <el-icon><ChatDotRound /></el-icon>
                    {{ article.commentCount }}
                  </span>
                  <span class="meta-item">
                    <el-icon><StarFilled /></el-icon>
                    {{ article.likeCount }}
                  </span>
                </div>
              </div>
            </div>
            
            <!-- 加载中 -->
            <div v-if="loading" class="loading">
              <el-skeleton :rows="3" animated />
            </div>
            
            <!-- 空状态 -->
            <el-empty v-if="!loading && !articles.length" description="暂无文章" />
          </div>
          
          <!-- 分页 -->
          <div v-if="total > 0" class="pagination">
            <el-pagination
              v-model:current-page="currentPage"
              v-model:page-size="pageSize"
              :total="total"
              :page-sizes="[10, 20, 50]"
              layout="total, sizes, prev, pager, next, jumper"
              @current-change="handlePageChange"
              @size-change="handleSizeChange"
            />
          </div>
        </div>
        
        <!-- 侧边栏 -->
        <aside class="sidebar">
          <!-- 作者信息 -->
          <div class="sidebar-card harmony-card">
            <div class="author-info">
              <img src="https://via.placeholder.com/80" alt="作者头像" class="author-avatar">
              <h3 class="author-name">博主</h3>
              <p class="author-bio">热爱技术，热爱生活</p>
            </div>
          </div>
          
          <!-- 热门分类 -->
          <div class="sidebar-card harmony-card">
            <h3 class="sidebar-title">热门分类</h3>
            <div class="category-list">
              <div
                v-for="cat in categories"
                :key="cat.categoryId"
                class="category-item"
                @click="$router.push({ name: 'Category', query: { id: cat.categoryId } })"
              >
                <span>{{ cat.categoryName }}</span>
                <el-tag size="small">{{ cat.articleCount }}</el-tag>
              </div>
            </div>
          </div>
          
          <!-- 热门标签 -->
          <div class="sidebar-card harmony-card">
            <h3 class="sidebar-title">热门标签</h3>
            <div class="tag-cloud">
              <el-tag
                v-for="tag in tags"
                :key="tag.tagId"
                class="tag-item"
                @click="$router.push({ name: 'Tag', query: { id: tag.tagId } })"
              >
                {{ tag.tagName }}
              </el-tag>
            </div>
          </div>
        </aside>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getArticleList } from '@/api/article'
import { getTopAnnouncements } from '@/api/announcement'
import request from '@/utils/request'

const router = useRouter()

const loading = ref(false)
const articles = ref([])
const topAnnouncements = ref([])
const categories = ref([])
const tags = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

const loadArticles = async () => {
  loading.value = true
  try {
    const res = await getArticleList({
      current: currentPage.value,
      size: pageSize.value
    })
    articles.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载文章失败', error)
  } finally {
    loading.value = false
  }
}

const loadAnnouncements = async () => {
  try {
    const res = await getTopAnnouncements()
    topAnnouncements.value = res.data || []
  } catch (error) {
    console.error('加载公告失败', error)
  }
}

const loadCategories = async () => {
  try {
    const res = await request.get('/category/list')
    categories.value = res.data || []
  } catch (error) {
    console.error('加载分类失败', error)
  }
}

const loadTags = async () => {
  try {
    const res = await request.get('/tag/list')
    tags.value = (res.data || []).slice(0, 20)
  } catch (error) {
    console.error('加载标签失败', error)
  }
}

const handlePageChange = () => {
  loadArticles()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handleSizeChange = () => {
  currentPage.value = 1
  loadArticles()
}

const goToArticle = (id) => {
  router.push({ name: 'ArticleDetail', params: { id } })
}

const goToAnnouncement = (id) => {
  router.push({ name: 'AnnouncementDetail', params: { id } })
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  loadArticles()
  loadAnnouncements()
  loadCategories()
  loadTags()
})
</script>

<style scoped lang="scss">
.home-page {
  .content-layout {
    display: grid;
    grid-template-columns: 1fr 320px;
    gap: 24px;
  }
  
  .announcement-banner {
    margin-bottom: 24px;
    padding: 0;
    overflow: hidden;
    
    .announcement-item {
      padding: 24px;
      cursor: pointer;
      height: 120px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      
      .announcement-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 8px;
        
        .announcement-title {
          font-size: 18px;
          font-weight: 600;
          color: #1D1D1F;
        }
      }
      
      .announcement-summary {
        color: #86868B;
        font-size: 14px;
        line-height: 1.6;
        margin: 0;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  }
  
  .article-list {
    .article-card {
      margin-bottom: 20px;
      cursor: pointer;
      overflow: hidden;
      
      &:hover {
        .article-title {
          color: #007DFF;
        }
      }
      
      .article-cover {
        position: relative;
        width: 100%;
        height: 240px;
        overflow: hidden;
        
        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.3s;
        }
        
        &:hover img {
          transform: scale(1.05);
        }
        
        .top-tag {
          position: absolute;
          top: 12px;
          right: 12px;
        }
      }
      
      .article-content {
        padding: 24px;
        
        .article-title {
          font-size: 20px;
          font-weight: 600;
          color: #1D1D1F;
          margin: 0 0 12px 0;
          transition: color 0.3s;
          display: flex;
          align-items: center;
          gap: 8px;
        }
        
        .article-summary {
          color: #86868B;
          font-size: 14px;
          line-height: 1.8;
          margin: 0 0 16px 0;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          overflow: hidden;
        }
        
        .article-meta {
          display: flex;
          gap: 16px;
          
          .meta-item {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 13px;
            color: #86868B;
          }
        }
      }
    }
  }
  
  .pagination {
    display: flex;
    justify-content: center;
    margin-top: 32px;
  }
  
  .sidebar {
    .sidebar-card {
      padding: 20px;
      margin-bottom: 20px;
      
      .sidebar-title {
        font-size: 16px;
        font-weight: 600;
        color: #1D1D1F;
        margin: 0 0 16px 0;
        padding-bottom: 12px;
        border-bottom: 2px solid #007DFF;
      }
    }
    
    .author-info {
      text-align: center;
      
      .author-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        margin-bottom: 12px;
      }
      
      .author-name {
        font-size: 18px;
        font-weight: 600;
        margin: 0 0 8px 0;
      }
      
      .author-bio {
        font-size: 14px;
        color: #86868B;
        margin: 0;
      }
    }
    
    .category-list {
      .category-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 12px;
        margin-bottom: 8px;
        background: #F5F7FA;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s;
        
        &:hover {
          background: #E6F0FF;
          color: #007DFF;
        }
      }
    }
    
    .tag-cloud {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      
      .tag-item {
        cursor: pointer;
        transition: all 0.3s;
        
        &:hover {
          transform: scale(1.05);
        }
      }
    }
  }
}

@media (max-width: 768px) {
  .content-layout {
    grid-template-columns: 1fr !important;
  }
}
</style>


