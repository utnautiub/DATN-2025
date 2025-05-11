<template>
  <div class="w-full md:px-10" ref="containerRef">
    <div class="max-w-7xl mx-auto py-10 px-4 md:px-8 lg:px-10">
      <h2 class="text-2xl md:text-5xl font-bold text-black dark:text-white mb-6">
        Giới thiệu về Trường Đại học Thủy Lợi
      </h2>
      <p class="text-sm md:text-base text-neutral-700 dark:text-neutral-300 italic mb-8 max-w-3xl">
        Thành lập năm 1959, Trường Đại học Thủy Lợi là cơ sở đào tạo hàng đầu Việt Nam trong lĩnh vực thủy lợi, thủy
        điện, và quản lý tài nguyên nước.
        Qua hơn 65 năm phát triển, nhà trường không ngừng đổi mới, cung cấp môi trường học tập hiện đại và chất lượng
        cao, đáp ứng nhu cầu xã hội.
        <br> Dưới đây là hành trình và những cột mốc nổi bật của Đại học Thủy Lợi.
      </p>
    </div>

    <div ref="timelineRef" class="relative max-w-7xl mx-auto pb-20">
      <div v-for="(item, index) in data" :key="index" class="flex justify-start pt-10 pb-20 md:pb-10 md:pt-10 md:gap-10 timeline-item"
        :data-index="index" ref="timelineItemRefs">
        <div
          class="sticky flex flex-col md:flex-row z-40 items-center top-[70px] lg:top-[120px] self-start max-w-xs lg:max-w-sm md:w-full timeline-year-container"
          :data-year-index="index">
          <div
            class="h-10 absolute left-3 md:left-3 w-10 rounded-full bg-white dark:bg-black flex items-center justify-center timeline-dot">
            <div class="h-5 w-5 rounded-full timeline-indicator"
              :class="{ 'active-indicator': index <= activeItemIndex }"></div>
          </div>
          <!-- Hiển thị năm ở phiên bản mobile trong khung đỏ, nằm ngang và ở dưới -->
          <div class="md:hidden absolute -left-12 top-0 flex justify-center rotate-90 origin-top-right">
            <h3 class="text-lg font-bold timeline-year-mobile-box bg-white dark:bg-black px-2 py-1 rounded border-2"
              :class="{ 'active-year-box': index <= activeItemIndex }">
              {{ item.title }}
            </h3>
          </div>
          <h3 class="hidden md:block text-xl md:pl-20 md:text-5xl font-bold timeline-year"
            :class="{ 'active-year': index <= activeItemIndex, 'fixed-year': index === activeFixedYear }">
            {{ item.title }}
          </h3>
        </div>

        <div class="relative pl-20 pr-4 md:pl-4 w-full timeline-content"
          :class="{ 'active-content': index <= activeItemIndex }">
          <!-- Ẩn tiêu đề năm ở đây vì đã hiển thị ở trên -->
          <!-- <h3 class="md:hidden block text-2xl mb-4 text-left font-bold timeline-year-mobile"
            :class="{ 'active-year': index <= activeItemIndex, 'fixed-year': index === activeFixedYear }">
            {{ item.title }}
          </h3> -->
          <div class="timeline-card">
            <component :is="item.content" />
          </div>
        </div>
      </div>

      <div :style="{ height: `${height}px` }"
        class="absolute md:left-[30px] left-[25px] top-0 overflow-hidden w-[4px] bg-[linear-gradient(to_bottom,var(--tw-gradient-stops))] from-transparent from-[0%] via-muted via-[50%] to-transparent to-[99%] [mask-image:linear-gradient(to_bottom,transparent_0%,black_10%,black_90%,transparent_100%)]">
        <div ref="lightBeamRef" :style="{
            height: Math.min(scrollDistance, height) + 'px',
            opacity: Math.min(scrollProgress * 10, 1)
          }"
          class="absolute inset-x-0 top-0 w-full bg-gradient-to-b from-blue-600 via-blue-400 to-primary from-[0%] via-[50%] rounded-full light-beam">
          <div class="absolute top-0 left-0 w-full h-16 animate-pulse-fast light-pulse"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed, nextTick, watch as vueWatch } from 'vue'
import { useScroll } from '@vueuse/core'

interface TimelineEntry {
  title: string
  content: any
}

const props = defineProps<{
  data: TimelineEntry[]
}>()

const containerRef = ref<HTMLElement | null>(null)
const timelineRef = ref<HTMLElement | null>(null)
const timelineItemRefs = ref<HTMLElement[]>([])
const height = ref(0)
const scrollProgress = ref(0)
const scrollDistance = ref(0)
const lightBeamRef = ref<HTMLElement | null>(null)
const activeItemIndex = ref(-1)
const activeFixedYear = ref(-1)
const visibleItems = ref<Set<number>>(new Set())

onMounted(async () => {
  if (!timelineRef.value) return

  await nextTick()

  const updateHeight = () => {
    if (timelineRef.value) {
      height.value = timelineRef.value.getBoundingClientRect().height
    }
  }

  updateHeight()
  const resizeObserver = new ResizeObserver(updateHeight)
  resizeObserver.observe(timelineRef.value)
  
  // Initialize Intersection Observer for each timeline item with earlier activation
  const timelineItems = document.querySelectorAll('.timeline-item')
  const itemObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const index = parseInt(entry.target.getAttribute('data-index') || '-1')
        if (index !== -1) {
          // Nếu element đang hiện ra trong viewport
          if (entry.isIntersecting) {
            visibleItems.value.add(index)
          } else {
            // Nếu element đã biến mất khỏi viewport
            visibleItems.value.delete(index)
          }
          
          // Tìm index cao nhất trong tập hợp các mục đang hiển thị
          if (visibleItems.value.size > 0) {
            activeItemIndex.value = Math.max(...Array.from(visibleItems.value))
          } else {
            activeItemIndex.value = -1
          }
        }
      })
    },
    { 
      rootMargin: '-10% 0px -50% 0px',
      threshold: 0.2
    }
  )
  
  // Observer for fixed year elements
  const yearObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const index = parseInt(entry.target.getAttribute('data-year-index') || '-1')
        if (index !== -1) {
          if (entry.isIntersecting && 
              entry.boundingClientRect.top <= 50 && 
              entry.boundingClientRect.bottom >= 50) {
            activeFixedYear.value = index
          } else if (activeFixedYear.value === index && !entry.isIntersecting) {
            // Reset active fixed year when the current active one is no longer in view
            activeFixedYear.value = -1
          }
        }
      })
    },
    { 
      rootMargin: '-40px 0px -60% 0px',
      threshold: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
    }
  )
  
  timelineItems.forEach(item => {
    itemObserver.observe(item)
  })
  
  document.querySelectorAll('.timeline-year-container').forEach(year => {
    yearObserver.observe(year)
  })

  onUnmounted(() => {
    if (timelineRef.value) resizeObserver.unobserve(timelineRef.value)
    itemObserver.disconnect()
    yearObserver.disconnect()
  })
})

// Scroll handler for light beam effect
const { y: scrollY } = useScroll(window)

vueWatch(scrollY, () => {
  if (!containerRef.value || !timelineRef.value) return

  const container = containerRef.value
  const containerRect = container.getBoundingClientRect()
  const timelineRect = timelineRef.value.getBoundingClientRect()
  
  // Calculate scroll progress (0 to 1)
  const start = containerRect.top + window.scrollY
  const visibleHeight = window.innerHeight
  const totalScrollDistance = timelineRect.height
  
  // When timeline starts to enter viewport
  if (containerRect.top <= visibleHeight && containerRect.bottom >= 0) {
    // Calculate how far we've scrolled into the timeline
    scrollDistance.value = Math.max(0, window.scrollY - start + visibleHeight * 0.5)
    scrollProgress.value = Math.min(scrollDistance.value / totalScrollDistance, 1)
    
    // Animate light beam pulse effect
    if (lightBeamRef.value) {
      const pulseElement = lightBeamRef.value.querySelector('.light-pulse')
      if (pulseElement) {
        const pulseTop = Math.min(scrollDistance.value - 8, height.value - 16)
          ; (pulseElement as HTMLElement).style.top = `${pulseTop}px`
      }
    }
  }
})
</script>

<style scoped>
.timeline-indicator {
  transition: background-color 0.5s ease-out, border-color 0.5s ease-out, transform 0.5s ease-out;
  background-color: var(--muted);
  border: 1px solid var(--border);
}

.active-indicator {
  background-color: var(--primary);
  border-color: var(--primary);
  transform: scale(1.5);
  box-shadow: 0 10px 15px -3px rgba(var(--primary-rgb), 0.3);
}

.timeline-year {
  font-size: 2.5rem;
  transition: color 0.5s ease-out;
  color: var(--muted-foreground);
}

.timeline-year-mobile {
  font-size: 1.5rem;
  border-bottom: 2px solid var(--muted);
  padding-bottom: 0.5rem;
  margin-bottom: 1rem;
  transition: color 0.5s ease-out;
  color: var(--muted-foreground);
}

/* Style mới cho khung hiển thị năm trên mobile */
.timeline-year-mobile-box {
  color: var(--muted-foreground);
  border-color: var(--muted);
  transition: all 0.3s ease;
  z-index: 50;
  display: inline-block;
  transform-origin: center;
  white-space: nowrap;
  position: relative;
  bottom: 34px;
  right: -100px;
}

.active-year-box {
  color: white;
  background-color: var(--primary) !important;
  border-color: var(--primary);
  box-shadow: 0 4px 8px rgba(var(--primary-rgb), 0.5);
}

.active-year {
  color: var(--primary);
  font-weight: 700;
}

/* .fixed-year {
  color: var(--primary);
  font-weight: 700;
  position: relative;
} */

/* .fixed-year::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 20px;
  width: 60%;
  height: 3px;
  background-color: var(--primary);
  border-radius: 3px;
  animation: scale-in 0.3s ease-out forwards;
  transform-origin: left;
} */

.timeline-year-mobile.fixed-year::after {
  left: 0;
  width: 100px;
  bottom: -2px;
}

.light-beam {
  box-shadow: 0 0 10px var(--primary), 0 0 20px var(--primary);
  transition: height 0.3s ease-out;
}

.light-pulse {
  background: linear-gradient(to bottom, 
              rgba(59, 130, 246, 0) 0%,
              rgba(59, 130, 246, 0.8) 50%,
              rgba(59, 130, 246, 0) 100%);
  box-shadow: 0 0 15px rgba(59, 130, 246, 0.8);
  border-radius: 4px;
  transition: top 0.3s ease-out;
}

@keyframes pulse-fast {
  0% {
    opacity: 0.4;
  }

  50% {
    opacity: 1;
  }

  100% {
    opacity: 0.4;
  }
}

@keyframes scale-in {
  0% {
    transform: scaleX(0);
  }

  100% {
    transform: scaleX(1);
  }
}

.animate-pulse-fast {
  animation: pulse-fast 1.5s infinite;
}

.timeline-content {
  opacity: 0.6;
  transform: translateY(20px);
  transition: opacity 0.5s ease-out, transform 0.5s ease-out;
}

.active-content {
  opacity: 1;
  transform: translateY(0);
}

.timeline-item {
  transition: opacity 0.5s ease-out;
}

.timeline-card {
  padding: 1.5rem;
  border-radius: 0.5rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.active-content .timeline-card {
  background-color: rgba(var(--primary-rgb), 0.05);
  border-left: 4px solid var(--primary);
}

@media (max-width: 768px) {
  .timeline-dot {
    left: 7px;
  }
}
</style>