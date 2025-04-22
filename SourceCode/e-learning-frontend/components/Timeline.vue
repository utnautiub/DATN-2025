<template>
  <div class="w-full md:px-10" ref="containerRef">
    <div class="max-w-7xl mx-auto py-20 px-4 md:px-8 lg:px-10">
      <h2 class="text-lg md:text-4xl mb-4 text-black dark:text-white max-w-4xl font-bold">
        Giới thiệu về Trường Đại học Thủy Lợi
      </h2>
      <p class="text-neutral-700 dark:text-neutral-300 text-sm md:text-base max-w-3xl italic">
        Thành lập năm 1959, Trường Đại học Thủy Lợi là cơ sở đào tạo hàng đầu Việt Nam trong lĩnh vực thủy lợi, thủy
        điện, và quản lý tài nguyên nước.
        Qua hơn 65 năm phát triển, nhà trường không ngừng đổi mới, cung cấp môi trường học tập hiện đại và chất lượng
        cao, đáp ứng nhu cầu xã hội.
        <br> Dưới đây là hành trình và những cột mốc nổi bật của Đại học Thủy Lợi.
      </p>
    </div>

    <div ref="timelineRef" class="relative max-w-7xl mx-auto pb-20">
      <div v-for="(item, index) in data" :key="index" class="flex justify-start pt-10 md:pt-40 md:gap-10">
        <div
          class="sticky flex flex-col md:flex-row z-40 items-center top-40 self-start max-w-xs lg:max-w-sm md:w-full">
          <div
            class="h-10 absolute left-3 md:left-3 w-10 rounded-full bg-white dark:bg-black flex items-center justify-center">
            <div
              class="h-4 w-4 rounded-full bg-neutral-200 dark:bg-neutral-800 border border-neutral-300 dark:border-neutral-700 p-2" />
          </div>
          <h3 class="hidden md:block text-xl md:pl-20 md:text-5xl font-bold text-neutral-500 dark:text-neutral-500">
            {{ item.title }}
          </h3>
        </div>

        <div class="relative pl-20 pr-4 md:pl-4 w-full">
          <h3 class="md:hidden block text-2xl mb-4 text-left font-bold text-neutral-500 dark:text-neutral-500">
            {{ item.title }}
          </h3>
          <component :is="item.content" />
        </div>
      </div>

      <div :style="{ height: `${height}px` }"
        class="absolute md:left-8 left-8 top-0 overflow-hidden w-[2px] bg-[linear-gradient(to_bottom,var(--tw-gradient-stops))] from-transparent from-[0%] via-neutral-200 dark:via-neutral-700 to-transparent to-[99%] [mask-image:linear-gradient(to_bottom,transparent_0%,black_10%,black_90%,transparent_100%)]">
        <div :style="{
          height: `${scrollProgress * height}px`,
          opacity: Math.min(scrollProgress * 10, 1)
        }"
          class="absolute inset-x-0 top-0 w-[2px] bg-gradient-to-t from-purple-500 via-blue-500 to-transparent from-[0%] via-[10%] rounded-full" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
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
const height = ref(0)
const scrollProgress = ref(0)

onMounted(() => {
  if (!timelineRef.value) return

  const updateHeight = () => {
    if (timelineRef.value) {
      height.value = timelineRef.value.getBoundingClientRect().height
    }
  }

  updateHeight()
  const resizeObserver = new ResizeObserver(updateHeight)
  resizeObserver.observe(timelineRef.value)

  onUnmounted(() => {
    if (timelineRef.value) resizeObserver.unobserve(timelineRef.value)
  })
})

const { y: scrollY } = useScroll(containerRef)
watch(scrollY, () => {
  if (!containerRef.value) return

  const container = containerRef.value
  const rect = container.getBoundingClientRect()
  const start = window.innerHeight * 0.2
  const end = window.innerHeight * 0.8

  const progress = (rect.top - start) / (start - end)
  scrollProgress.value = Math.max(0, Math.min(1, progress))
})
</script>
