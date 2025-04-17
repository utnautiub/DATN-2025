
export default defineNuxtPlugin(nuxtApp => {
  console.log('i18n and theme plugin initialized');
  if (process.client) {
    const savedTheme = localStorage.getItem('theme') || 'light';
    if (savedTheme === 'dark' || 
        (savedTheme === null && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    const savedLanguage = localStorage.getItem('language') || 'vi';
    document.documentElement.setAttribute('lang', savedLanguage);
  }
});

