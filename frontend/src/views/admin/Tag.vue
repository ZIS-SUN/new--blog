<template>
  <div class="admin-tag-page">
    <div class="page-header">
      <h2 class="page-title">标签管理</h2>
      <el-button type="primary" @click="showDialog()">
        <el-icon><Plus /></el-icon>
        新建标签
      </el-button>
    </div>
    
    <div class="table-container harmony-card">
      <el-table :data="tags" style="width: 100%">
        <el-table-column prop="tagId" label="ID" width="80" />
        <el-table-column prop="tagName" label="标签名称" width="200" />
        <el-table-column prop="articleCount" label="文章数" width="100" />
        <el-table-column label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button link type="primary" @click="showDialog(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row.tagId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    
    <el-dialog
      v-model="dialogVisible"
      :title="editingTag?.tagId ? '编辑标签' : '新建标签'"
      width="400px"
    >
      <el-form :model="editingTag" label-width="80px">
        <el-form-item label="标签名称">
          <el-input v-model="editingTag.tagName" placeholder="请输入标签名称" />
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
import { getTagList, createTag, updateTag, deleteTag } from '@/api/tag'

const tags = ref([])
const dialogVisible = ref(false)
const saving = ref(false)
const editingTag = ref({})

const loadTags = async () => {
  try {
    const res = await getTagList()
    tags.value = res.data || []
  } catch (error) {
    ElMessage.error('加载标签失败')
  }
}

const showDialog = (tag = null) => {
  if (tag) {
    editingTag.value = { ...tag }
  } else {
    editingTag.value = { tagName: '' }
  }
  dialogVisible.value = true
}

const handleSave = async () => {
  saving.value = true
  try {
    if (editingTag.value.tagId) {
      await updateTag(editingTag.value)
    } else {
      await createTag(editingTag.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadTags()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除该标签吗？', '提示', { type: 'warning' })
    await deleteTag(id)
    ElMessage.success('删除成功')
    loadTags()
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
  loadTags()
})
</script>

<style scoped lang="scss">
.admin-tag-page {
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

