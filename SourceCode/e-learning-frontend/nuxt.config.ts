// https://nuxt.com/docs/api/configuration/nuxt-config
import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },

  devServer: {
    port: 4000
  },

  css: ['~/assets/css/no-flash.css', '~/assets/css/tailwind.css'],

  vite: {
    plugins: [
      tailwindcss(),
    ],
  },

  modules: [
    'shadcn-nuxt',
    '@nuxtjs/color-mode',
    '@vueuse/motion/nuxt',
    '@nuxtjs/i18n',
  ],
  colorMode: {
    classSuffix: ''
  },
  shadcn: {
    prefix: '',
    /**
     * Directory that the component lives in.
     * @default "./components/ui"
     */
    componentDir: './components/ui'
  },
  runtimeConfig: {
    public: {
      nuxtApiBaseUrl: process.env.NUXT_API_BASE_URL,
    },
  },
  i18n: {
    langDir: './locales',
    defaultLocale: 'vi',
    locales: [
      { code: 'vi', iso: 'vi-VN', file: 'vi.json', name: 'Tiếng Việt' },
      { code: 'en', iso: 'en-US', file: 'en.json', name: 'English' },
      { code: 'lo', iso: 'lo-LA', file: 'lo.json', name: 'ພາສາລາວ' }
    ],
    detectBrowserLanguage: {
      useCookie: true,
      cookieKey: 'i18n_redirected',
      redirectOn: 'root'
    },
    strategy: 'prefix_except_default'
  }
})

