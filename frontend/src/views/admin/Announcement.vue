<template>
  <div class="admin-announcement-page">
    <div class="page-header">
      <h2 class="page-title">公告管理</h2>
      <el-button type="primary" @click="showDialog()">
        <el-icon><Plus /></el-icon>
        新建公告
      </el-button>
    </div>
    
    <div class="table-container harmony-card">
      <el-table :data="announcements" style="width: 100%">
        <el-table-column prop="announcementId" label="ID" width="80" />
        <el-table-column prop="title" label="标题" min-width="200" />
        <el-table-column label="置顶" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.isTop" type="warning">是</el-tag>
            <span v-else>否</span>
          </template>
        </el-table-column>
        <el-table-column label="紧急" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.isEmergency" type="danger">是</el-tag>
            <span v-else>否</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '发布' : '隐藏' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="发布时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.publishTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button link type="primary" @click="showDialog(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row.announcementId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          :total="total"
          :page-size="pageSize"
          layout="total, prev, pager, next"
          @current-change="loadAnnouncements"
        />
      </div>
    </div>
    
    <el-dialog
      v-model="dialogVisible"
      :title="editingAnnouncement?.announcementId ? '编辑公告' : '新建公告'"
      width="700px"
    >
      <el-form :model="editingAnnouncement" label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="editingAnnouncement.title" placeholder="请输入公告标题" />
        </el-form-item>
        
        <el-form-item label="摘要">
          <el-input
            v-model="editingAnnouncement.summary"
            type="textarea"
            :rows="2"
            placeholder="请输入公告摘要"
          />
        </el-form-item>
        
        <el-form-item label="内容">
          <el-input
            v-model="editingAnnouncement.content"
            type="textarea"
            :rows="6"
            placeholder="请输入公告内容"
          />
        </el-form-item>
        
        <el-form-item label="置顶">
          <el-switch v-model="editingAnnouncement.isTop" :active-value="1" :inactive-value="0" />
        </el-form-item>
        
        <el-form-item label="紧急">
          <el-switch v-model="editingAnnouncement.isEmergency" :active-value="1" :inactive-value="0" />
        </el-form-item>
        
        <el-form-item label="状态">
          <el-radio-group v-model="editingAnnouncement.status">
            <el-radio :label="0">隐藏</el-radio>
            <el-radio :label="1">发布</el-radio>
          </el-radio-group>
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
import { getAdminAnnouncementList, createAnnouncement, updateAnnouncement, deleteAnnouncement } from '@/api/admin'

const announcements = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const saving = ref(false)
const editingAnnouncement = ref({})

const loadAnnouncements = async () => {
  try {
    const res = await getAdminAnnouncementList({
      current: currentPage.value, 
      size: pageSize.value
    })
    announcements.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    ElMessage.error('加载公告失败')
  }
}

const showDialog = (announcement = null) => {
  if (announcement) {
    editingAnnouncement.value = { ...announcement }
  } else {
    editingAnnouncement.value = {
      title: '',
      summary: '',
      content: '',
      isTop: 0,
      isEmergency: 0,
      status: 1
    }
  }
  dialogVisible.value = true
}

const handleSave = async () => {
  saving.value = true
  try {
    if (editingAnnouncement.value.announcementId) {
      await updateAnnouncement(editingAnnouncement.value)
    } else {
      await createAnnouncement(editingAnnouncement.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadAnnouncements()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除该公告吗？', '提示', { type: 'warning' })
    await deleteAnnouncement(id)
    ElMessage.success('删除成功')
    loadAnnouncements()
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
  loadAnnouncements()
})
</script>

<style scoped lang="scss">
.admin-announcement-page {
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

