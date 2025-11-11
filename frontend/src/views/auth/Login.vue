<template>
  <div class="login-page">
    <!-- 背景装饰元素 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>

    <div class="login-container">
      <!-- 左侧装饰区域 -->
      <div class="login-decoration">
        <div class="decoration-content">
          <div class="logo-area">
            <div class="logo-icon">
              <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
                <path d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64z m0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372 372 166.6 372 372-166.6 372-372 372z" fill="currentColor"/>
                <path d="M512 140c-205.4 0-372 166.6-372 372s166.6 372 372 372 372-166.6 372-372-166.6-372-372-372z m193.4 225.7l-210.6 292a31.8 31.8 0 0 1-51.7 0L318.5 484.9c-3.8-5.3 0-12.7 6.5-12.7h46.9c10.3 0 19.9 5 25.9 13.3l71.2 98.8 157.2-218c6-8.4 15.7-13.3 25.9-13.3H699c6.5 0 10.3 7.4 6.4 12.7z" fill="currentColor"/>
              </svg>
            </div>
            <h1>欢迎回来</h1>
            <p>登录以继续您的精彩旅程</p>
          </div>

          <div class="feature-list">
            <div class="feature-item" v-for="(feature, index) in features" :key="index">
              <div class="feature-icon">{{ feature.icon }}</div>
              <div class="feature-text">
                <h3>{{ feature.title }}</h3>
                <p>{{ feature.desc }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧登录表单 -->
      <div class="login-form-wrapper">
        <div class="form-content">
          <div class="form-header">
            <h2>账号登录</h2>
            <p>使用您的账号登录系统</p>
          </div>

          <el-form :model="form" :rules="rules" ref="formRef" class="login-form">
            <el-form-item prop="username">
              <div class="input-wrapper">
                <div class="input-label">
                  <el-icon class="label-icon"><User /></el-icon>
                  <span>用户名</span>
                </div>
                <el-input
                  v-model="form.username"
                  placeholder="请输入用户名"
                  size="large"
                  clearable
                  @focus="activeInput = 'username'"
                  @blur="activeInput = ''"
                >
                  <template #prefix>
                    <el-icon><User /></el-icon>
                  </template>
                </el-input>
              </div>
            </el-form-item>

            <el-form-item prop="password">
              <div class="input-wrapper">
                <div class="input-label">
                  <el-icon class="label-icon"><Lock /></el-icon>
                  <span>密码</span>
                </div>
                <el-input
                  v-model="form.password"
                  type="password"
                  placeholder="请输入密码（至少6位）"
                  size="large"
                  show-password
                  @keyup.enter="handleLogin"
                  @focus="activeInput = 'password'"
                  @blur="activeInput = ''"
                >
                  <template #prefix>
                    <el-icon><Lock /></el-icon>
                  </template>
                </el-input>
              </div>
            </el-form-item>

            <div class="form-options">
              <el-checkbox v-model="rememberMe" label="记住我" />
              <el-link type="primary" :underline="false" class="forgot-link">
                忘记密码？
              </el-link>
            </div>

            <el-form-item class="submit-item">
              <el-button
                type="primary"
                size="large"
                class="login-button"
                :loading="loading"
                @click="handleLogin"
              >
                <template v-if="!loading">
                  <span>立即登录</span>
                  <el-icon class="button-icon"><Right /></el-icon>
                </template>
                <span v-else>登录中...</span>
              </el-button>
            </el-form-item>

            <div class="divider">
              <span class="divider-text">其他登录方式</span>
            </div>

            <div class="social-login">
              <el-tooltip content="微信登录" placement="top">
                <div class="social-item wechat">
                  <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
                    <path d="M690.1 377.4c5.9 0 11.8 0.2 17.6 0.5-24.4-128.7-158.3-227.1-319.9-227.1C209 150.8 64 271.4 64 420.2c0 81.1 43.5 154.1 111.9 203.6 9.5 6.9 10.9 21.1 3.2 29.8l-29.8 33.3c-6.8 7.6-18.9 8.8-27.1 2.7-0.4-0.3-0.8-0.5-1.2-0.8C46.7 641.2 0 532.1 0 420.2c0-184.4 178.7-334.2 399.1-334.2 204.6 0 373.2 131.9 393.9 298.4z" fill="currentColor"/>
                  </svg>
                </div>
              </el-tooltip>

              <el-tooltip content="QQ登录" placement="top">
                <div class="social-item qq">
                  <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
                    <path d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64z" fill="currentColor"/>
                  </svg>
                </div>
              </el-tooltip>

              <el-tooltip content="GitHub登录" placement="top">
                <div class="social-item github">
                  <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
                    <path d="M512 42.666667A464.64 464.64 0 0 0 42.666667 502.186667 460.373333 460.373333 0 0 0 363.52 938.666667c23.466667 4.266667 32-9.813333 32-22.186667v-78.08c-130.56 27.733333-158.293333-61.44-158.293333-61.44a122.026667 122.026667 0 0 0-52.053334-67.413333c-42.666667-28.16 3.413333-27.733333 3.413334-27.733334a98.56 98.56 0 0 1 71.68 47.36 101.12 101.12 0 0 0 136.533333 37.973334 99.413333 99.413333 0 0 1 29.866667-61.44c-104.106667-11.52-213.333333-50.773333-213.333334-226.986667a177.066667 177.066667 0 0 1 47.36-124.16 161.28 161.28 0 0 1 4.693334-121.173333s39.68-12.373333 128 46.933333a455.68 455.68 0 0 1 234.666666 0c89.6-59.306667 128-46.933333 128-46.933333a161.28 161.28 0 0 1 4.693334 121.173333A177.066667 177.066667 0 0 1 810.666667 477.866667c0 176.64-110.08 215.466667-213.333334 226.986666a106.666667 106.666667 0 0 1 32 85.333334v125.866666c0 14.933333 8.533333 26.88 32 22.186667A460.8 460.8 0 0 0 981.333333 502.186667 464.64 464.64 0 0 0 512 42.666667" fill="currentColor"/>
                  </svg>
                </div>
              </el-tooltip>
            </div>
          </el-form>

          <div class="form-footer">
            <span class="footer-text">还没有账号？</span>
            <el-link type="primary" :underline="false" @click="$router.push('/auth/register')" class="register-link">
              立即注册
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
import { login } from '@/api/auth'
import { ElMessage } from 'element-plus'
import { User, Lock, Right } from '@element-plus/icons-vue'

const router = useRouter()
const formRef = ref()
const loading = ref(false)
const rememberMe = ref(false)
const activeInput = ref('')

const form = ref({
  username: '',
  password: ''
})

const features = [
  {
    icon: '✨',
    title: '现代化设计',
    desc: '基于鸿蒙设计语言'
  },
  {
    icon: '🚀',
    title: '极速体验',
    desc: '流畅的用户体验'
  },
  {
    icon: '🔒',
    title: '安全可靠',
    desc: '保护您的隐私安全'
  }
]

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度为3-20个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return

    loading.value = true
    try {
      const res = await login(form.value)

      localStorage.setItem('token', res.data.token)
      localStorage.setItem('user', JSON.stringify(res.data.user))
      localStorage.setItem('userRole', res.data.user.role.toString())

      if (rememberMe.value) {
        localStorage.setItem('rememberMe', 'true')
        localStorage.setItem('savedUsername', form.value.username)
      } else {
        localStorage.removeItem('rememberMe')
        localStorage.removeItem('savedUsername')
      }

      ElMessage.success({
        message: '登录成功，欢迎回来！',
        type: 'success',
        duration: 2000
      })

      // 管理员跳转后台，普通用户跳转首页
      setTimeout(() => {
        if (res.data.user.role === 1) {
          router.push('/admin')
        } else {
          router.push('/')
        }
      }, 500)
    } catch (error) {
      ElMessage.error({
        message: error.message || '登录失败，请检查用户名和密码',
        type: 'error',
        duration: 3000
      })
    } finally {
      loading.value = false
    }
  })
}

// 页面加载时检查是否记住密码
if (localStorage.getItem('rememberMe')) {
  rememberMe.value = true
  form.value.username = localStorage.getItem('savedUsername') || ''
}
</script>

<style scoped lang="scss">
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
  position: relative;
  overflow: hidden;
}

.bg-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;

  .circle {
    position: absolute;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, rgba(255, 255, 255, 0.05) 50%, transparent 70%);
    animation: float 20s infinite ease-in-out;

    &.circle-1 {
      width: 600px;
      height: 600px;
      top: -10%;
      right: -10%;
      animation-delay: 0s;
    }

    &.circle-2 {
      width: 400px;
      height: 400px;
      bottom: -5%;
      left: -5%;
      animation-delay: 7s;
    }

    &.circle-3 {
      width: 300px;
      height: 300px;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      animation-delay: 3s;
    }
  }
}

.login-container {
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

.login-decoration {
  flex: 1;
  background: linear-gradient(135deg, #007DFF 0%, #0051D5 100%);
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

.login-form-wrapper {
  flex: 1;
  padding: 60px 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
}

.form-content {
  width: 100%;
  max-width: 400px;
}

.form-header {
  margin-bottom: 40px;
  
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

.login-form {
  :deep(.el-form-item) {
    margin-bottom: 28px;
  }

  .input-wrapper {
    .input-label {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 14px;
      font-weight: 600;
      color: #1D1D1F;
      margin-bottom: 10px;

      .label-icon {
        font-size: 16px;
        color: #007DFF;
      }
    }
  }

  :deep(.el-input) {
    .el-input__wrapper {
      border-radius: 14px;
      padding: 14px 16px;
      background: #F5F5F7;
      border: 2px solid transparent;
      box-shadow: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

      &:hover {
        background: #EBEBED;
        border-color: rgba(0, 125, 255, 0.2);
      }

      &.is-focus {
        background: white;
        border-color: #007DFF;
        box-shadow: 0 0 0 4px rgba(0, 125, 255, 0.1);
      }

      .el-input__prefix {
        color: #86868B;
      }

      .el-input__inner {
        font-size: 15px;
        color: #1D1D1F;

        &::placeholder {
          color: #86868B;
        }
      }
    }
  }

  .form-options {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: -8px 0 24px 0;

    :deep(.el-checkbox) {
      .el-checkbox__label {
        font-size: 14px;
        color: #515154;
      }
    }

    .forgot-link {
      font-size: 14px;
      font-weight: 500;
      transition: all 0.2s ease;

      &:hover {
        transform: translateX(2px);
      }
    }
  }

  .submit-item {
    margin-bottom: 24px;
  }

  .login-button {
    width: 100%;
    height: 52px;
    border-radius: 14px;
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(135deg, #007DFF 0%, #0051D5 100%);
    border: none;
    box-shadow: 0 8px 24px rgba(0, 125, 255, 0.3);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;

    .button-icon {
      font-size: 18px;
      transition: transform 0.3s ease;
    }

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 12px 32px rgba(0, 125, 255, 0.4);

      .button-icon {
        transform: translateX(4px);
      }
    }

    &:active {
      transform: translateY(0);
      box-shadow: 0 4px 16px rgba(0, 125, 255, 0.3);
    }
  }

  .divider {
    position: relative;
    text-align: center;
    margin: 32px 0;

    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 50%;
      width: 100%;
      height: 1px;
      background: linear-gradient(to right, transparent, #E5E5E7, transparent);
    }

    .divider-text {
      position: relative;
      display: inline-block;
      padding: 0 16px;
      background: white;
      font-size: 13px;
      color: #86868B;
      z-index: 1;
    }
  }

  .social-login {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 20px;
    margin-bottom: 24px;

    .social-item {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      background: #F5F5F7;

      svg {
        width: 24px;
        height: 24px;
      }

      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
      }

      &:active {
        transform: translateY(-2px);
      }

      &.wechat {
        &:hover {
          background: #07C160;
          color: white;
          box-shadow: 0 8px 20px rgba(7, 193, 96, 0.3);
        }
      }

      &.qq {
        &:hover {
          background: #12B7F5;
          color: white;
          box-shadow: 0 8px 20px rgba(18, 183, 245, 0.3);
        }
      }

      &.github {
        &:hover {
          background: #24292E;
          color: white;
          box-shadow: 0 8px 20px rgba(36, 41, 46, 0.3);
        }
      }
    }
  }
}

.form-footer {
  text-align: center;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid #E5E5E7;

  .footer-text {
    color: #86868B;
    font-size: 14px;
    margin-right: 8px;
  }

  .register-link {
    font-size: 14px;
    font-weight: 600;
    transition: all 0.2s ease;

    &:hover {
      transform: translateX(2px);
    }
  }
}

// 响应式设计
@media (max-width: 968px) {
  .login-container {
    max-width: 480px;
  }

  .login-decoration {
    display: none;
  }

  .login-form-wrapper {
    padding: 50px 40px;
  }
}

@media (max-width: 480px) {
  .login-page {
    padding: 16px;
  }

  .login-container {
    border-radius: 20px;
  }

  .login-form-wrapper {
    padding: 40px 24px;
  }

  .form-header {
    margin-bottom: 32px;

    h2 {
      font-size: 24px;
    }
  }

  .social-login {
    gap: 16px;

    .social-item {
      width: 44px;
      height: 44px;

      svg {
        width: 20px;
        height: 20px;
      }
    }
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
    transform: translate(0, 0);
  }
  25% {
    transform: translate(20px, -20px);
  }
  50% {
    transform: translate(-20px, 20px);
  }
  75% {
    transform: translate(20px, 10px);
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
    opacity: 1;
  }
  50% {
    transform: scale(1.05);
    opacity: 0.8;
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>


