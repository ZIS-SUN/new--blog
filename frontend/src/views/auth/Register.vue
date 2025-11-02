<template>
  <div class="register-page">
    <div class="register-container">
      <!-- 左侧装饰区域 -->
      <div class="register-decoration">
        <div class="decoration-content">
          <div class="logo-area">
            <div class="logo-icon">
              <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
                <path d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64z m0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372 372 166.6 372 372-166.6 372-372 372z" fill="currentColor"/>
                <path d="M512 140c-205.4 0-372 166.6-372 372s166.6 372 372 372 372-166.6 372-372-166.6-372-372-372z m193.4 225.7l-210.6 292a31.8 31.8 0 0 1-51.7 0L318.5 484.9c-3.8-5.3 0-12.7 6.5-12.7h46.9c10.3 0 19.9 5 25.9 13.3l71.2 98.8 157.2-218c6-8.4 15.7-13.3 25.9-13.3H699c6.5 0 10.3 7.4 6.4 12.7z" fill="currentColor"/>
              </svg>
            </div>
            <h1>加入我们</h1>
            <p>创建账号开始您的创作之旅</p>
          </div>
          
          <div class="feature-list">
            <div class="feature-item">
              <div class="feature-icon">📝</div>
              <div class="feature-text">
                <h3>自由创作</h3>
                <p>分享您的精彩内容</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">💬</div>
              <div class="feature-text">
                <h3>互动交流</h3>
                <p>与读者深度沟通</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">🌟</div>
              <div class="feature-text">
                <h3>成长记录</h3>
                <p>记录您的成长历程</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 右侧注册表单 -->
      <div class="register-form-wrapper">
        <div class="form-content">
          <div class="form-header">
            <h2>创建账号</h2>
            <p>填写信息以创建您的账号</p>
          </div>
          
          <el-form :model="form" :rules="rules" ref="formRef" class="register-form">
            <el-form-item prop="username">
              <div class="input-label">用户名</div>
              <el-input
                v-model="form.username"
                placeholder="请输入用户名"
                size="large"
                clearable
              >
                <template #prefix>
                  <el-icon><User /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="email">
              <div class="input-label">邮箱</div>
              <el-input
                v-model="form.email"
                placeholder="请输入邮箱"
                size="large"
                clearable
              >
                <template #prefix>
                  <el-icon><Message /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="nickname">
              <div class="input-label">昵称（可选）</div>
              <el-input
                v-model="form.nickname"
                placeholder="请输入昵称"
                size="large"
                clearable
              >
                <template #prefix>
                  <el-icon><Avatar /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="password">
              <div class="input-label">密码</div>
              <el-input
                v-model="form.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                show-password
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item prop="confirmPassword">
              <div class="input-label">确认密码</div>
              <el-input
                v-model="form.confirmPassword"
                type="password"
                placeholder="请再次输入密码"
                size="large"
                show-password
                @keyup.enter="handleRegister"
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                size="large"
                class="register-button"
                :loading="loading"
                @click="handleRegister"
              >
                <span v-if="!loading">注册</span>
                <span v-else>注册中...</span>
              </el-button>
            </el-form-item>
          </el-form>
          
          <div class="form-footer">
            <span class="footer-text">已有账号？</span>
            <el-link type="primary" :underline="false" @click="$router.push('/auth/login')">
              立即登录
            </el-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '@/api/auth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const formRef = ref()
const loading = ref(false)

const form = ref({
  username: '',
  email: '',
  nickname: '',
  password: '',
  confirmPassword: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== form.value.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度3-20位', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      await register(form.value)
      ElMessage.success('注册成功，请登录')
      router.push('/auth/login')
    } catch (error) {
      ElMessage.error(error.message || '注册失败')
    } finally {
      loading.value = false
    }
  })
}
</script>

<style scoped lang="scss">
.register-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  padding: 20px;
  position: relative;
  overflow: hidden;
  
  // 背景装饰
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -50%;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
    animation: float 20s infinite ease-in-out;
  }
  
  &::after {
    content: '';
    position: absolute;
    bottom: -50%;
    left: -50%;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.05) 0%, transparent 70%);
    animation: float 25s infinite ease-in-out reverse;
  }
}

.register-container {
  width: 100%;
  max-width: 1000px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  display: flex;
  overflow: hidden;
  position: relative;
  z-index: 1;
  animation: slideUp 0.6s ease-out;
}

.register-decoration {
  flex: 1;
  background: linear-gradient(135deg, #f5576c 0%, #d63447 100%);
  padding: 60px 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
    animation: rotate 30s linear infinite;
  }
  
  .decoration-content {
    position: relative;
    z-index: 1;
    color: white;
  }
  
  .logo-area {
    text-align: center;
    margin-bottom: 60px;
    
    .logo-icon {
      width: 80px;
      height: 80px;
      margin: 0 auto 24px;
      background: rgba(255, 255, 255, 0.2);
      backdrop-filter: blur(10px);
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      animation: pulse 2s ease-in-out infinite;
      
      svg {
        width: 50px;
        height: 50px;
        color: white;
      }
    }
    
    h1 {
      font-size: 32px;
      font-weight: 600;
      margin: 0 0 12px 0;
      letter-spacing: 1px;
    }
    
    p {
      font-size: 16px;
      opacity: 0.9;
      margin: 0;
    }
  }
  
  .feature-list {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }
  
  .feature-item {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    padding: 20px;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 16px;
    transition: all 0.3s ease;
    
    &:hover {
      background: rgba(255, 255, 255, 0.15);
      transform: translateX(8px);
    }
    
    .feature-icon {
      font-size: 32px;
      flex-shrink: 0;
    }
    
    .feature-text {
      h3 {
        font-size: 18px;
        font-weight: 600;
        margin: 0 0 4px 0;
      }
      
      p {
        font-size: 14px;
        opacity: 0.9;
        margin: 0;
      }
    }
  }
}

.register-form-wrapper {
  flex: 1;
  padding: 60px 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  overflow-y: auto;
}

.form-content {
  width: 100%;
  max-width: 400px;
}

.form-header {
  margin-bottom: 32px;
  
  h2 {
    font-size: 28px;
    font-weight: 600;
    color: #1D1D1F;
    margin: 0 0 8px 0;
  }
  
  p {
    font-size: 14px;
    color: #86868B;
    margin: 0;
  }
}

.register-form {
  :deep(.el-form-item) {
    margin-bottom: 20px;
  }
  
  .input-label {
    font-size: 14px;
    font-weight: 500;
    color: #1D1D1F;
    margin-bottom: 8px;
  }
  
  :deep(.el-input) {
    .el-input__wrapper {
      border-radius: 12px;
      padding: 12px 16px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
      transition: all 0.3s ease;
      
      &:hover {
        box-shadow: 0 4px 12px rgba(245, 87, 108, 0.15);
      }
      
      &.is-focus {
        box-shadow: 0 4px 16px rgba(245, 87, 108, 0.25);
      }
    }
  }
  
  .register-button {
    width: 100%;
    height: 48px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(135deg, #f5576c 0%, #d63447 100%);
    border: none;
    box-shadow: 0 4px 16px rgba(245, 87, 108, 0.3);
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(245, 87, 108, 0.4);
    }
    
    &:active {
      transform: translateY(0);
    }
  }
}

.form-footer {
  text-align: center;
  margin-top: 24px;
  
  .footer-text {
    color: #86868B;
    font-size: 14px;
    margin-right: 8px;
  }
  
  :deep(.el-link) {
    font-size: 14px;
    font-weight: 600;
  }
}

// 响应式设计
@media (max-width: 768px) {
  .register-decoration {
    display: none;
  }
  
  .register-form-wrapper {
    padding: 40px 30px;
  }
}

// 动画
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) translateX(0);
  }
  50% {
    transform: translateY(-20px) translateX(20px);
  }
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}
</style>


