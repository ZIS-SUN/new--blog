<template>
  <div class="auth-layout">
    <div class="auth-container harmony-card">
      <router-view />
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped lang="scss">
.auth-layout {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #007DFF 0%, #0062CC 100%);
  
  .auth-container {
    width: 100%;
    max-width: 450px;
    margin: 20px;
    padding: 40px;
  }
}
</style>


