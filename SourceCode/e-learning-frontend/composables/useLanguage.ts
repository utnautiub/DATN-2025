import { useI18n } from 'vue-i18n';
import { useNuxtApp } from 'nuxt/app';
import { computed, onMounted } from 'vue';
import { useCookie } from 'nuxt/app';

export function useLanguage() {
  const { locale, t } = useI18n();
  const { $i18n } = useNuxtApp();
  const localeCookie = useCookie('i18n_redirected');

  const languages = {
    en: {
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸'
    },
    vi: {
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳'
    },
    lo: {
      name: 'Lao',
      nativeName: 'ພາສາລາວ',
      flag: '🇱🇦'
    }
  };

  // Khởi tạo ngôn ngữ từ localStorage hoặc cookie nếu có
  onMounted(() => {
    if (process.client) {
      const savedLang = localStorage.getItem('language') || localeCookie.value || 'vi';
      if (savedLang && locale.value !== savedLang) {
        setLanguage(savedLang as keyof typeof languages);
      }
    }
  });

  const currentLanguage = computed(() => locale.value);

  const setLanguage = async (lang: keyof typeof languages) => {
    await $i18n.setLocale(lang);
    
    if (process.client) {
      // Lưu ngôn ngữ vào localStorage và cookie
      localStorage.setItem('language', lang);
      localeCookie.value = lang;
      document.documentElement.setAttribute('lang', lang);
    }
  };

  const getLanguages = () => {
    return Object.entries(languages).map(([code, details]) => ({
      code,
      ...details
    }));
  };

  return {
    currentLanguage,
    setLanguage,
    t,
    getLanguages
  };
}

