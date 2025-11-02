<template>
  <div class="tag-page">
    <div class="harmony-container">
      <h1 class="page-title">标签浏览</h1>
      
      <div class="tag-cloud">
        <el-tag
          v-for="tag in tags"
          :key="tag.tagId"
          class="tag-item"
          size="large"
          @click="viewTag(tag.tagId)"
        >
          {{ tag.tagName }} ({{ tag.articleCount }})
        </el-tag>
      </div>
      
      <el-empty v-if="!tags.length" description="暂无标签" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const tags = ref([])

const loadTags = async () => {
  try {
    const res = await request.get('/tag/list')
    tags.value = res.data || []
  } catch (error) {
    console.error('加载标签失败', error)
  }
}

const viewTag = (id) => {
  router.push({ name: 'Home', query: { tagId: id } })
}

onMounted(() => {
  loadTags()
})
</script>

<style scoped lang="scss">
.tag-page {
  padding: 24px 0;
  
  .page-title {
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
    color: #1D1D1F;
  }
  
  .tag-cloud {
    max-width: 900px;
    margin: 0 auto;
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    justify-content: center;
    
    .tag-item {
      cursor: pointer;
      padding: 12px 24px;
      font-size: 16px;
      transition: all 0.3s;
      
      &:hover {
        transform: scale(1.1);
      }
    }
  }
}
</style>


