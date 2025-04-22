import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useScroll } from '@vueuse/core'

export function useScrollAnimation(containerRef: Ref<HTMLElement | null>) {
  const scrollProgress = ref(0)

  onMounted(() => {
    if (!containerRef.value) return

    const { y: scrollY } = useScroll(containerRef)

    const updateProgress = () => {
      if (!containerRef.value) return

      const rect = containerRef.value.getBoundingClientRect()
      const viewportHeight = window.innerHeight
      const startOffset = viewportHeight * (-1.2)
      const endOffset = viewportHeight * 0.8

      const progress = (rect.top - startOffset) / (startOffset - endOffset)
      scrollProgress.value = Math.max(0, Math.min(1, progress))
    }

    watch(scrollY, updateProgress)
    updateProgress()
  })

  return {
    scrollProgress
  }
}
