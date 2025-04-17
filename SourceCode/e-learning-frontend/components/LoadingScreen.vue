<template>
  <div v-if="visible" class="loading-screen">
    <div class="loading-container">
      <div class="spinner"></div>
      <h2 class="mt-4 text-xl font-medium">E-Learning</h2>
    </div>
  </div>
</template>

<script lang="ts" setup>
const props = defineProps({
  visible: {
    type: Boolean,
    default: true
  }
});
</script>

<style scoped>
.loading-screen {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

:root .loading-screen {
  background-color: #ffffff;
  color: #000000;
}

:root.dark .loading-screen {
  background-color: #121212;
  color: #ffffff;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.spinner {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

:root .spinner {
  border: 4px solid #e0e0e0;
  border-left-color: #1a1a1a;
}

:root.dark .spinner {
  border: 4px solid #333333;
  border-left-color: #ffffff;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>


