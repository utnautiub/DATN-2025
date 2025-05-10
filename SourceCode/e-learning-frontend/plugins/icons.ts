import { defineNuxtPlugin } from 'nuxt/app'
import { Icon } from '@iconify/vue'

export default defineNuxtPlugin((nuxtApp) => {
  // Đăng ký @iconify/vue
  nuxtApp.vueApp.component('Icon', Icon)
}) 