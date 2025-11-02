<template>
  <div class="search-page">
    <div class="harmony-container">
      <div class="search-header">
        <h1 class="page-title">搜索文章</h1>
        <el-input
          v-model="keyword"
          placeholder="输入关键词搜索..."
          size="large"
          clearable
          @keyup.enter="handleSearch"
        >
          <template #append>
            <el-button :icon="Search" @click="handleSearch" />
          </template>
        </el-input>
      </div>
      
      <div v-if="searched" class="search-result">
        <p class="result-info">
          找到 <strong>{{ total }}</strong> 篇相关文章
        </p>
        
        <div class="article-list">
          <div
            v-for="article in articles"
            :key="article.articleId"
            class="article-card harmony-card"
            @click="$router.push({ name: 'ArticleDetail', params: { id: article.articleId } })"
          >
            <h3 class="article-title">{{ article.title }}</h3>
            <p class="article-summary">{{ article.summary }}</p>
            <div class="article-meta">
              <span>{{ formatDate(article.publishTime) }}</span>
              <span>阅读 {{ article.viewCount }}</span>
            </div>
          </div>
        </div>
        
        <el-empty v-if="!articles.length" description="未找到相关文章" />
        
        <div v-if="total > 0" class="pagination">
          <el-pagination
            v-model:current-page="currentPage"
            :total="total"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            @current-change="handleSearch"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { searchArticles } from '@/api/article'
import { Search } from '@element-plus/icons-vue'

const route = useRoute()

const keyword = ref('')
const articles = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const searched = ref(false)

const handleSearch = async () => {
  if (!keyword.value.trim()) return
  
  try {
    const res = await searchArticles({
      keyword: keyword.value,
      current: currentPage.value,
      size: pageSize.value
    })
    articles.value = res.data.records || []
    total.value = res.data.total || 0
    searched.value = true
  } catch (error) {
    console.error('搜索失败', error)
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  if (route.query.keyword) {
    keyword.value = route.query.keyword
    handleSearch()
  }
})
</script>

<style scoped lang="scss">
.search-page {
  padding: 24px 0;
  
  .search-header {
    max-width: 700px;
    margin: 0 auto 40px;
    
    .page-title {
      font-size: 28px;
      font-weight: 700;
      text-align: center;
      margin-bottom: 24px;
      color: #1D1D1F;
    }
  }
  
  .search-result {
    max-width: 900px;
    margin: 0 auto;
    
    .result-info {
      color: #86868B;
      margin-bottom: 24px;
      
      strong {
        color: #007DFF;
      }
    }
    
    .article-list {
      .article-card {
        padding: 24px;
        margin-bottom: 16px;
        cursor: pointer;
        
        &:hover .article-title {
          color: #007DFF;
        }
        
        .article-title {
          font-size: 20px;
          font-weight: 600;
          margin: 0 0 12px 0;
          transition: color 0.3s;
        }
        
        .article-summary {
          color: #86868B;
          margin: 0 0 12px 0;
          line-height: 1.6;
        }
        
        .article-meta {
          display: flex;
          gap: 16px;
          font-size: 14px;
          color: #86868B;
        }
      }
    }
    
    .pagination {
      display: flex;
      justify-content: center;
      margin-top: 32px;
    }
  }
}
</style>


