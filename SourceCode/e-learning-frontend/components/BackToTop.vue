<template>
  <Transition name="fade">
    <button
      v-show="showButton"
      @click="scrollToTop"
      class="fixed bottom-8 right-8 z-50 group"
      aria-label="Back to top"
    >
      <!-- Circular Progress -->
      <div class="relative">
        <!-- Background Circle -->
        <svg class="w-12 h-12 transform -rotate-90">
          <circle
            cx="24"
            cy="24"
            r="20"
            stroke-width="2"
            stroke="currentColor"
            fill="none"
            class="text-gray-300 dark:text-gray-600"
          />
          <!-- Progress Circle -->
          <circle
            cx="24"
            cy="24"
            r="20"
            stroke-width="2"
            stroke="currentColor"
            fill="none"
            :stroke-dasharray="circumference"
            :stroke-dashoffset="dashOffset"
            class="text-primary transition-all duration-300"
          />
        </svg>
        
        <!-- Button Content -->
        <div 
          class="absolute inset-0 flex items-center justify-center rounded-full transform transition-transform duration-300 group-hover:scale-110"
          :class="[
            'bg-white dark:bg-gray-800',
            'shadow-lg hover:shadow-xl'
          ]"
        >
          <Icon 
            icon="heroicons:arrow-up" 
            class="w-5 h-5 text-primary group-hover:text-primary-dark transition-colors duration-300"
          />
        </div>

        <!-- Percentage Text -->
        <div 
          class="absolute -top-8 left-1/2 -translate-x-1/2 px-2 py-1 text-xs font-semibold bg-primary text-white rounded-md opacity-0 group-hover:opacity-100 transition-opacity duration-300"
        >
          {{ scrollPercentage }}%
        </div>
      </div>
    </button>
  </Transition>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';

const showButton = ref(false);
const scrollPercentage = ref(0);
const scrollThreshold = 300; // Show button after scrolling 300px

// Circle progress calculations
const circumference = computed(() => 2 * Math.PI * 20); // 2πr where r=20
const dashOffset = computed(() => {
  return circumference.value - (scrollPercentage.value / 100) * circumference.value;
});

const checkScroll = () => {
  const scrollTop = window.scrollY;
  const docHeight = document.documentElement.scrollHeight - window.innerHeight;
  showButton.value = scrollTop > scrollThreshold;

  // Calculate scroll percentage
  if (docHeight > 0) {
    scrollPercentage.value = Math.round((scrollTop / docHeight) * 100);
  } else {
    scrollPercentage.value = 0;
  }
};

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth',
  });
};

// Lifecycle hooks
onMounted(() => {
  window.addEventListener('scroll', checkScroll);
  checkScroll(); // Initial check
});

onUnmounted(() => {
  window.removeEventListener('scroll', checkScroll);
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

circle {
  transition: stroke-dashoffset 0.3s ease;
}
</style>

