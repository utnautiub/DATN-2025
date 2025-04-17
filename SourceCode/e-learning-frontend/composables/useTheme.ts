import { ref, watch, onMounted } from 'vue';

// Define available themes
const themes = {
  light: {
    name: 'Light',
    colorScheme: 'light',
    primary: 'blue',
    icon: 'ph:sun-fill'
  },
  dark: {
    name: 'Dark',
    colorScheme: 'dark',
    primary: 'blue',
    icon: 'ph:moon-fill'
  },
  system: {
    name: 'System',
    colorScheme: 'system',
    primary: 'blue',
    icon: 'ph:desktop-fill'
  }
};

type ThemeKey = keyof typeof themes;

const currentTheme = ref<ThemeKey>('system');

// Function to get system theme
const getSystemTheme = (): 'light' | 'dark' => {
  if (process.client) {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }
  return 'light';
};

// Function to update theme classes
const updateThemeClasses = (colorScheme: 'light' | 'dark') => {
  if (process.client) {
    document.documentElement.classList.remove('dark', 'light');
    document.documentElement.classList.add(colorScheme);
    document.documentElement.setAttribute('data-theme', colorScheme);
  }
};

// Function to apply theme
const applyTheme = (theme: ThemeKey) => {
  if (process.client) {
    const effectiveTheme = theme === 'system' ? getSystemTheme() : theme;
    updateThemeClasses(effectiveTheme);
  }
};

export function useTheme() {
  // Initialize theme
  onMounted(() => {
    if (process.client) {
      const savedTheme = localStorage.getItem('theme') as ThemeKey || 'system';
      if (themes[savedTheme]) {
        currentTheme.value = savedTheme;
        applyTheme(savedTheme);
      }

      // Watch for system theme changes
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
      mediaQuery.addEventListener('change', () => {
        if (currentTheme.value === 'system') {
          applyTheme('system');
        }
      });
    }
  });

  // Watch for theme changes
  watch(currentTheme, (newTheme) => {
    if (process.client) {
      localStorage.setItem('theme', newTheme);
      applyTheme(newTheme);
    }
  });

  // Function to change the theme
  const setTheme = (theme: ThemeKey) => {
    if (themes[theme]) {
      currentTheme.value = theme;
    }
  };

  // Toggle between light and dark
  const toggleDarkMode = () => {
    const themeOrder: ThemeKey[] = ['light', 'dark', 'system'];
    const currentIndex = themeOrder.indexOf(currentTheme.value);
    const nextIndex = (currentIndex + 1) % themeOrder.length;
    currentTheme.value = themeOrder[nextIndex];
  };

  // Get all available themes
  const getThemes = () => {
    return Object.entries(themes).map(([key, details]) => ({
      key,
      ...details
    }));
  };

  // Check if current theme is dark
  const isDark = () => {
    if (currentTheme.value === 'system') {
      return getSystemTheme() === 'dark';
    }
    return currentTheme.value === 'dark';
  };

  return {
    currentTheme,
    setTheme,
    toggleDarkMode,
    getThemes,
    isDark
  };
}

