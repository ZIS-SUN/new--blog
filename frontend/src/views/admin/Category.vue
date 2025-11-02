<template>
  <div class="admin-category-page">
    <div class="page-header">
      <h2 class="page-title">分类管理</h2>
      <el-button type="primary" @click="showDialog()">
        <el-icon><Plus /></el-icon>
        新建分类
      </el-button>
    </div>
    
    <div class="table-container harmony-card">
      <el-table :data="categories" style="width: 100%">
        <el-table-column prop="categoryId" label="ID" width="80" />
        <el-table-column prop="categoryName" label="分类名称" width="200" />
        <el-table-column prop="description" label="描述" min-width="200" />
        <el-table-column prop="articleCount" label="文章数" width="100" />
        <el-table-column label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button link type="primary" @click="showDialog(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row.categoryId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    
    <el-dialog
      v-model="dialogVisible"
      :title="editingCategory?.categoryId ? '编辑分类' : '新建分类'"
      width="500px"
    >
      <el-form :model="editingCategory" label-width="80px">
        <el-form-item label="分类名称">
          <el-input v-model="editingCategory.categoryName" placeholder="请输入分类名称" />
        </el-form-item>
        
        <el-form-item label="描述">
          <el-input
            v-model="editingCategory.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
          />
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
import { getCategoryList, createCategory, updateCategory, deleteCategory } from '@/api/category'

const categories = ref([])
const dialogVisible = ref(false)
const saving = ref(false)
const editingCategory = ref({})

const loadCategories = async () => {
  try {
    const res = await getCategoryList()
    categories.value = res.data || []
  } catch (error) {
    ElMessage.error('加载分类失败')
  }
}

const showDialog = (category = null) => {
  if (category) {
    editingCategory.value = { ...category }
  } else {
    editingCategory.value = { categoryName: '', description: '' }
  }
  dialogVisible.value = true
}

const handleSave = async () => {
  saving.value = true
  try {
    if (editingCategory.value.categoryId) {
      await updateCategory(editingCategory.value)
    } else {
      await createCategory(editingCategory.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadCategories()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除该分类吗？', '提示', { type: 'warning' })
    await deleteCategory(id)
    ElMessage.success('删除成功')
    loadCategories()
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
  loadCategories()
})
</script>

<style scoped lang="scss">
.admin-category-page {
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
  }
}
</style>

