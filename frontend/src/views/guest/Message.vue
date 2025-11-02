<template>
  <div class="message-page">
    <div class="harmony-container">
      <h1 class="page-title">留言板</h1>
      
      <div class="message-container harmony-card">
        <!-- 发表留言 -->
        <div v-if="isLoggedIn" class="message-form">
          <el-input
            v-model="messageContent"
            type="textarea"
            :rows="4"
            placeholder="写下你的留言..."
          />
          <el-button type="primary" @click="submitMessage" :loading="submitting">
            发表留言
          </el-button>
        </div>
        <div v-else class="login-tip">
          <el-alert type="info" :closable="false">
            请先 <el-link type="primary" @click="$router.push('/auth/login')">登录</el-link> 后再发表留言
          </el-alert>
        </div>
        
        <!-- 留言列表 -->
        <div class="message-list">
          <div v-for="message in messages" :key="message.messageId" class="message-item">
            <div class="message-avatar">
              <img src="https://via.placeholder.com/50" alt="用户头像">
            </div>
            <div class="message-content">
              <div class="message-author">用户{{ message.userId }}</div>
              <div class="message-text">{{ message.content }}</div>
              <div class="message-time">{{ formatDate(message.createTime) }}</div>
            </div>
          </div>
          
          <el-empty v-if="!messages.length" description="暂无留言" />
        </div>
        
        <!-- 分页 -->
        <div v-if="total > 0" class="pagination">
          <el-pagination
            v-model:current-page="currentPage"
            :total="total"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            @current-change="loadMessages"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const messageContent = ref('')
const messages = ref([])
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const submitting = ref(false)

const isLoggedIn = computed(() => !!localStorage.getItem('token'))

const loadMessages = async () => {
  try {
    const res = await request.get('/message/list', {
      params: {
        current: currentPage.value,
        size: pageSize.value
      }
    })
    messages.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载留言失败', error)
  }
}

const submitMessage = async () => {
  if (!messageContent.value.trim()) {
    ElMessage.warning('请输入留言内容')
    return
  }
  
  submitting.value = true
  try {
    await request.post('/message/add', {
      content: messageContent.value
    })
    ElMessage.success('留言成功')
    messageContent.value = ''
    currentPage.value = 1
    loadMessages()
  } catch (error) {
    ElMessage.error('留言失败')
  } finally {
    submitting.value = false
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

onMounted(() => {
  loadMessages()
})
</script>

<style scoped lang="scss">
.message-page {
  padding: 24px 0;
  
  .page-title {
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
    color: #1D1D1F;
  }
  
  .message-container {
    max-width: 900px;
    margin: 0 auto;
    padding: 32px;
    
    .message-form {
      margin-bottom: 32px;
      
      .el-textarea {
        margin-bottom: 12px;
      }
    }
    
    .login-tip {
      margin-bottom: 32px;
    }
    
    .message-list {
      .message-item {
        display: flex;
        gap: 16px;
        padding: 20px 0;
        border-bottom: 1px solid #E5E5EA;
        
        &:last-child {
          border-bottom: none;
        }
        
        .message-avatar img {
          width: 50px;
          height: 50px;
          border-radius: 50%;
        }
        
        .message-content {
          flex: 1;
          
          .message-author {
            font-weight: 600;
            margin-bottom: 8px;
          }
          
          .message-text {
            color: #1D1D1F;
            line-height: 1.6;
            margin-bottom: 8px;
          }
          
          .message-time {
            font-size: 12px;
            color: #86868B;
          }
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


