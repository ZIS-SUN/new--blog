<template>
  <div class="admin-comment-page">
    <h2 class="page-title">评论管理</h2>
    
    <div class="table-container harmony-card">
      <el-table :data="comments" style="width: 100%">
        <el-table-column prop="commentId" label="ID" width="80" />
        <el-table-column prop="content" label="评论内容" min-width="200" show-overflow-tooltip />
        <el-table-column prop="userId" label="用户ID" width="100" />
        <el-table-column prop="articleId" label="文章ID" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : row.status === 0 ? 'warning' : 'danger'">
              {{ row.status === 0 ? '待审' : row.status === 1 ? '已通过' : '已屏蔽' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="评论时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button v-if="row.status === 0" link type="success" @click="handleApprove(row.commentId)">
              通过
            </el-button>
            <el-button link type="danger" @click="handleDelete(row.commentId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminCommentList, approveComment, deleteComment } from '@/api/admin'

const comments = ref([])

const loadComments = async () => {
  try {
    const res = await getAdminCommentList()
    comments.value = res.data.records || res.data || []
  } catch (error) {
    ElMessage.error('加载评论失败')
  }
}

const handleApprove = async (id) => {
  try {
    await approveComment(id)
    ElMessage.success('审核通过')
    loadComments()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除该评论吗？', '提示', { type: 'warning' })
    await deleteComment(id)
    ElMessage.success('删除成功')
    loadComments()
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
  loadComments()
})
</script>

<style scoped lang="scss">
.admin-comment-page {
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

