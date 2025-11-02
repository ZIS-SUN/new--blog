<template>
  <div class="admin-article-page">
    <div class="page-header">
      <h2 class="page-title">文章管理</h2>
      <el-button type="primary" @click="showDialog()">
        <el-icon><Plus /></el-icon>
        新建文章
      </el-button>
    </div>
    
    <!-- 文章列表 -->
    <div class="table-container harmony-card">
      <el-table :data="articles" style="width: 100%">
        <el-table-column prop="articleId" label="ID" width="80" />
        <el-table-column prop="title" label="标题" min-width="200" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '已发布' : '草稿' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="置顶" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.isTop" type="danger">是</el-tag>
            <span v-else>否</span>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="阅读" width="80" />
        <el-table-column prop="likeCount" label="点赞" width="80" />
        <el-table-column label="发布时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.publishTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="showDialog(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row.articleId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          layout="total, sizes, prev, pager, next"
          @current-change="loadArticles"
          @size-change="loadArticles"
        />
      </div>
    </div>
    
    <!-- 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="editingArticle?.articleId ? '编辑文章' : '新建文章'"
      width="800px"
    >
      <el-form :model="editingArticle" label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="editingArticle.title" placeholder="请输入文章标题" />
        </el-form-item>
        
        <el-form-item label="摘要">
          <el-input
            v-model="editingArticle.summary"
            type="textarea"
            :rows="3"
            placeholder="请输入文章摘要"
          />
        </el-form-item>
        
        <el-form-item label="内容">
          <el-input
            v-model="editingArticle.content"
            type="textarea"
            :rows="10"
            placeholder="请输入Markdown格式的文章内容"
          />
        </el-form-item>
        
        <el-form-item label="分类">
          <el-select v-model="editingArticle.categoryId" placeholder="请选择分类">
            <el-option
              v-for="cat in categories"
              :key="cat.categoryId"
              :label="cat.categoryName"
              :value="cat.categoryId"
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="状态">
          <el-radio-group v-model="editingArticle.status">
            <el-radio :label="0">草稿</el-radio>
            <el-radio :label="1">发布</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="置顶">
          <el-switch v-model="editingArticle.isTop" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminArticleList, createArticle, updateArticle, deleteArticle } from '@/api/admin'
import { getCategoryList } from '@/api/category'

const articles = ref([])
const categories = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const saving = ref(false)
const editingArticle = ref({})

const loadArticles = async () => {
  try {
    const res = await getAdminArticleList({
      current: currentPage.value, 
      size: pageSize.value
    })
    articles.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    ElMessage.error('加载文章失败')
  }
}

const loadCategories = async () => {
  try {
    const res = await getCategoryList()
    categories.value = res.data || []
  } catch (error) {
    console.error('加载分类失败', error)
  }
}

const showDialog = (article = null) => {
  if (article) {
    editingArticle.value = { ...article }
  } else {
    const userId = JSON.parse(localStorage.getItem('user')).userId
    editingArticle.value = {
      title: '',
      summary: '',
      content: '',
      categoryId: null,
      status: 0,
      isTop: 0,
      userId: userId
    }
  }
  dialogVisible.value = true
}

const handleSave = async () => {
  saving.value = true
  try {
    if (editingArticle.value.articleId) {
      await updateArticle(editingArticle.value)
    } else {
      await createArticle(editingArticle.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadArticles()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除该文章吗？', '提示', {
      type: 'warning'
    })
    await deleteArticle(id)
    ElMessage.success('删除成功')
    loadArticles()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

onMounted(() => {
  loadArticles()
  loadCategories()
})
</script>

<style scoped lang="scss">
.admin-article-page {
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    
    .page-title {
      font-size: 24px;
      font-weight: 600;
      margin: 0;
    }
  }
  
  .table-container {
    padding: 24px;
    
    .pagination {
      display: flex;
      justify-content: center;
      margin-top: 24px;
    }
  }
}
</style>

