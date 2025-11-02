<template>
  <div class="admin-message-page">
    <h2 class="page-title">留言管理</h2>
    
    <div class="table-container harmony-card">
      <el-table :data="messages" style="width: 100%">
        <el-table-column prop="messageId" label="ID" width="80" />
        <el-table-column prop="content" label="留言内容" min-width="200" show-overflow-tooltip />
        <el-table-column prop="userId" label="用户ID" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : row.status === 0 ? 'warning' : 'danger'">
              {{ row.status === 0 ? '待审' : row.status === 1 ? '已通过' : '已屏蔽' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="留言时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button v-if="row.status === 0" link type="success" @click="handleApprove(row.messageId)">
              通过
            </el-button>
            <el-button link type="danger" @click="handleDelete(row.messageId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminMessageList, approveMessage, deleteMessage } from '@/api/admin'

const messages = ref([])

const loadMessages = async () => {
  try {
    const res = await getAdminMessageList()
    messages.value = res.data.records || res.data || []
  } catch (error) {
    ElMessage.error('加载留言失败')
  }
}

const handleApprove = async (id) => {
  try {
    await approveMessage(id)
    ElMessage.success('审核通过')
    loadMessages()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除该留言吗？', '提示', { type: 'warning' })
    await deleteMessage(id)
    ElMessage.success('删除成功')
    loadMessages()
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
  loadMessages()
})
</script>

<style scoped lang="scss">
.admin-message-page {
  .page-title {
    font-size: 24px;
    font-weight: 600;
    margin: 0 0 24px 0;
  }
  
  .table-container {
    padding: 24px;
  }
}
</style>

