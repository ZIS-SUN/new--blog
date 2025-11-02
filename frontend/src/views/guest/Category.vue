<template>
  <div class="category-page">
    <div class="harmony-container">
      <h1 class="page-title">分类浏览</h1>
      
      <div class="category-grid">
        <div
          v-for="category in categories"
          :key="category.categoryId"
          class="category-card harmony-card"
          @click="viewCategory(category.categoryId)"
        >
          <div class="category-icon">
            <el-icon size="40"><Folder /></el-icon>
          </div>
          <h3 class="category-name">{{ category.categoryName }}</h3>
          <p class="category-desc">{{ category.description }}</p>
          <div class="category-count">{{ category.articleCount }} 篇文章</div>
        </div>
      </div>
      
      <el-empty v-if="!categories.length" description="暂无分类" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const categories = ref([])

const loadCategories = async () => {
  try {
    const res = await request.get('/category/list')
    categories.value = res.data || []
  } catch (error) {
    console.error('加载分类失败', error)
  }
}

const viewCategory = (id) => {
  router.push({ name: 'Home', query: { categoryId: id } })
}

onMounted(() => {
  loadCategories()
})
</script>

<style scoped lang="scss">
.category-page {
  padding: 24px 0;
  
  .page-title {
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
    color: #1D1D1F;
  }
  
  .category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
    
    .category-card {
      padding: 32px 24px;
      text-align: center;
      cursor: pointer;
      
      .category-icon {
        color: #007DFF;
        margin-bottom: 16px;
      }
      
      .category-name {
        font-size: 20px;
        font-weight: 600;
        margin: 0 0 8px 0;
        color: #1D1D1F;
      }
      
      .category-desc {
        color: #86868B;
        font-size: 14px;
        margin: 0 0 16px 0;
      }
      
      .category-count {
        color: #007DFF;
        font-weight: 500;
      }
    }
  }
}
</style>


