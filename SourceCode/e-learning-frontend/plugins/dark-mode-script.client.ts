// Plugin to prevent flash of unstyled content when using dark mode
export default defineNuxtPlugin(() => {
  if (process.client) {
    const applyTheme = () => {
      const savedTheme = localStorage.getItem('theme') || 'system';
      const systemDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;
      
      document.documentElement.classList.remove('dark', 'light');
      
      const shouldBeDark = 
        savedTheme === 'dark' || 
        (savedTheme === 'system' && systemDarkMode);

      if (shouldBeDark) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.add('light');
      }
    };

    applyTheme();
    
    document.body.classList.add('theme-loaded');

    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    mediaQuery.addEventListener('change', () => {
      applyTheme();
    });
  }
});



