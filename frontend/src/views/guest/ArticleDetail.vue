<template>
  <div class="article-detail-page">
    <div class="harmony-container">
      <div v-if="loading" class="loading">
        <el-skeleton :rows="10" animated />
      </div>
      
      <div v-else-if="article" class="article-container">
        <article class="article-main harmony-card">
          <!-- 文章头部 -->
          <header class="article-header">
            <h1 class="article-title">{{ article.title }}</h1>
            
            <div class="article-meta">
              <span class="meta-item">
                <el-icon><Calendar /></el-icon>
                发布于 {{ formatDate(article.publishTime) }}
              </span>
              <span class="meta-item">
                <el-icon><View /></el-icon>
                阅读 {{ article.viewCount }}
              </span>
              <span class="meta-item">
                <el-icon><ChatDotRound /></el-icon>
                评论 {{ article.commentCount }}
              </span>
            </div>
          </header>
          
          <!-- 文章内容 -->
          <div class="article-content markdown-body" v-html="renderedContent"></div>
          
          <!-- 文章底部操作 -->
          <footer class="article-footer">
            <el-button type="primary" :icon="StarFilled" @click="handleLike">
              点赞 ({{ article.likeCount }})
            </el-button>
          </footer>
        </article>
        
        <!-- 评论区 -->
        <div class="comments-section harmony-card">
          <h3 class="section-title">评论 ({{ comments.length }})</h3>
          
          <!-- 发表评论 -->
          <div v-if="isLoggedIn" class="comment-form">
            <el-input
              v-model="commentContent"
              type="textarea"
              :rows="4"
              placeholder="写下你的评论..."
            />
            <el-button type="primary" @click="submitComment" :loading="submitting">
              发表评论
            </el-button>
          </div>
          <div v-else class="login-tip">
            <el-alert type="info" :closable="false">
              请先 <el-link type="primary" @click="$router.push('/auth/login')">登录</el-link> 后再发表评论
            </el-alert>
          </div>
          
          <!-- 评论列表 -->
          <div class="comment-list">
            <div v-for="comment in comments" :key="comment.commentId" class="comment-item">
              <div class="comment-avatar">
                <img src="https://via.placeholder.com/40" alt="用户头像">
              </div>
              <div class="comment-content">
                <div class="comment-author">用户{{ comment.userId }}</div>
                <div class="comment-text">{{ comment.content }}</div>
                <div class="comment-meta">
                  {{ formatDate(comment.createTime) }}
                </div>
              </div>
            </div>
            
            <el-empty v-if="!comments.length" description="暂无评论" />
          </div>
        </div>
      </div>
      
      <el-empty v-else description="文章不存在" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getArticleDetail, likeArticle } from '@/api/article'
import { ElMessage } from 'element-plus'
import { StarFilled } from '@element-plus/icons-vue'
import MarkdownIt from 'markdown-it'
import hljs from 'highlight.js'
import 'highlight.js/styles/github.css'
import request from '@/utils/request'

const route = useRoute()
const router = useRouter()

const md = new MarkdownIt({
  highlight: function (str, lang) {
    if (lang && hljs.getLanguage(lang)) {
      try {
        return hljs.highlight(str, { language: lang }).value
      } catch (__) {}
    }
    return ''
  }
})

const loading = ref(true)
const article = ref(null)
const comments = ref([])
const commentContent = ref('')
const submitting = ref(false)

const isLoggedIn = computed(() => !!localStorage.getItem('token'))

const renderedContent = computed(() => {
  if (!article.value || !article.value.content) return ''
  return md.render(article.value.content)
})

const loadArticle = async () => {
  loading.value = true
  try {
    const res = await getArticleDetail(route.params.id)
    article.value = res.data
    loadComments()
  } catch (error) {
    ElMessage.error('加载文章失败')
  } finally {
    loading.value = false
  }
}

const loadComments = async () => {
  try {
    const res = await request.get(`/comment/article/${route.params.id}`)
    comments.value = res.data.records || []
  } catch (error) {
    console.error('加载评论失败', error)
  }
}

const handleLike = async () => {
  try {
    await likeArticle(route.params.id)
    article.value.likeCount++
    ElMessage.success('点赞成功')
  } catch (error) {
    ElMessage.error('点赞失败')
  }
}

const submitComment = async () => {
  if (!commentContent.value.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  
  submitting.value = true
  try {
    await request.post('/comment/add', {
      articleId: route.params.id,
      content: commentContent.value
    })
    ElMessage.success('评论成功')
    commentContent.value = ''
    loadComments()
  } catch (error) {
    ElMessage.error('评论失败')
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
  loadArticle()
})
</script>

<style scoped lang="scss">
.article-detail-page {
  padding: 24px 0;
  
  .article-container {
    max-width: 900px;
    margin: 0 auto;
  }
  
  .article-main {
    padding: 40px;
    margin-bottom: 24px;
    
    .article-header {
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 1px solid #E5E5EA;
      
      .article-title {
        font-size: 32px;
        font-weight: 700;
        color: #1D1D1F;
        margin: 0 0 16px 0;
        line-height: 1.4;
      }
      
      .article-meta {
        display: flex;
        gap: 24px;
        
        .meta-item {
          display: flex;
          align-items: center;
          gap: 6px;
          color: #86868B;
          font-size: 14px;
        }
      }
    }
    
    .article-content {
      font-size: 16px;
      line-height: 1.8;
      color: #1D1D1F;
      
      :deep(h1), :deep(h2), :deep(h3) {
        margin-top: 24px;
        margin-bottom: 16px;
        font-weight: 600;
      }
      
      :deep(p) {
        margin-bottom: 16px;
      }
      
      :deep(code) {
        background: #F5F7FA;
        padding: 2px 6px;
        border-radius: 4px;
        font-family: 'Courier New', monospace;
      }
      
      :deep(pre) {
        background: #F5F7FA;
        padding: 16px;
        border-radius: 8px;
        overflow-x: auto;
        margin-bottom: 16px;
      }
      
      :deep(img) {
        max-width: 100%;
        border-radius: 8px;
      }
    }
    
    .article-footer {
      margin-top: 32px;
      padding-top: 24px;
      border-top: 1px solid #E5E5EA;
      text-align: center;
    }
  }
  
  .comments-section {
    padding: 32px;
    
    .section-title {
      font-size: 20px;
      font-weight: 600;
      margin: 0 0 24px 0;
    }
    
    .comment-form {
      margin-bottom: 32px;
      
      .el-textarea {
        margin-bottom: 12px;
      }
    }
    
    .login-tip {
      margin-bottom: 32px;
    }
    
    .comment-list {
      .comment-item {
        display: flex;
        gap: 12px;
        padding: 16px 0;
        border-bottom: 1px solid #E5E5EA;
        
        &:last-child {
          border-bottom: none;
        }
        
        .comment-avatar img {
          width: 40px;
          height: 40px;
          border-radius: 50%;
        }
        
        .comment-content {
          flex: 1;
          
          .comment-author {
            font-weight: 600;
            margin-bottom: 8px;
          }
          
          .comment-text {
            color: #1D1D1F;
            line-height: 1.6;
            margin-bottom: 8px;
          }
          
          .comment-meta {
            font-size: 12px;
            color: #86868B;
          }
        }
      }
    }
  }
}
</style>


