<template>
  <div class="archive-page">
    <div class="harmony-container">
      <h1 class="page-title">文章归档</h1>
      
      <div class="archive-content harmony-card">
        <el-timeline>
          <el-timeline-item
            v-for="item in archives"
            :key="item.date"
            :timestamp="item.date"
            placement="top"
          >
            <el-card>
              <h4>{{ item.month }}</h4>
              <div
                v-for="article in item.articles"
                :key="article.articleId"
                class="article-item"
                @click="$router.push({ name: 'ArticleDetail', params: { id: article.articleId } })"
              >
                <span class="article-title">{{ article.title }}</span>
                <span class="article-date">{{ formatDate(article.publishTime) }}</span>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
        
        <el-empty v-if="!archives.length" description="暂无归档" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getArticleList } from '@/api/article'

const archives = ref([])

const loadArchives = async () => {
  try {
    const res = await getArticleList({ current: 1, size: 100 })
    const articles = res.data.records || []
    
    // 按月份分组
    const grouped = {}
    articles.forEach(article => {
      const date = new Date(article.publishTime)
      const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`
      if (!grouped[key]) {
        grouped[key] = {
          date: key,
          month: `${date.getFullYear()}年${date.getMonth() + 1}月`,
          articles: []
        }
      }
      grouped[key].articles.push(article)
    })
    
    archives.value = Object.values(grouped).sort((a, b) => b.date.localeCompare(a.date))
  } catch (error) {
    console.error('加载归档失败', error)
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  loadArchives()
})
</script>

<style scoped lang="scss">
.archive-page {
  padding: 24px 0;
  
  .page-title {
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
    color: #1D1D1F;
  }
  
  .archive-content {
    max-width: 900px;
    margin: 0 auto;
    padding: 40px;
    
    .article-item {
      display: flex;
      justify-content: space-between;
      padding: 12px 0;
      border-bottom: 1px solid #E5E5EA;
      cursor: pointer;
      transition: all 0.3s;
      
      &:hover {
        color: #007DFF;
        padding-left: 8px;
      }
      
      &:last-child {
        border-bottom: none;
      }
      
      .article-title {
        flex: 1;
      }
      
      .article-date {
        color: #86868B;
        font-size: 14px;
      }
    }
  }
}
</style>


