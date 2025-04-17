import { useI18n } from 'vue-i18n';
import { useNuxtApp } from 'nuxt/app';
import { computed } from 'vue';

export function useLanguage() {
  const { locale, t } = useI18n();
  const { $i18n } = useNuxtApp();

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

  const currentLanguage = computed(() => locale.value);

  const setLanguage = async (lang: keyof typeof languages) => {
    await $i18n.setLocale(lang);
    if (process.client) {
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

