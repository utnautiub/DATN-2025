<template>
  <div>
    <header :class="cn(
      'top-0 sm:top-4 z-50',
      !isDisableHeaderScroll && 'sticky'
    )">
      <!-- Phần header giữ nguyên -->
      <div :class="cn(
        'mx-auto flex justify-between gap-10 items-center transition-all duration-300 p-4 z-50',
        isScrolled
          ? 'bg-white/80 backdrop-blur-md md:p-6 dark:bg-zinc-900/80 xl:w-[90%] shadow  md:rounded-3xl'
          : 'bg-transparent w-full xl:w-[70%]'
      )">
        <!-- Logo -->
        <div class="flex items-center gap-2">
          <NuxtLink to="/" class="flex items-center" @click="scrollToTop">
            <Logo />
          </NuxtLink>
        </div>

        <!-- Navigation Links -->
        <div class="flex-1 items-center gap-3 justify-center hidden lg:flex">
          <HeaderLink v-for="link in navigationLinks" :key="link.name" :title="t(`navigation.${link.name}`)"
            :href="localePath(link.to)" :class="{ 'active': isCurrentRoute(link.to) }" />
        </div>

        <!-- Actions -->
        <div class="flex items-center justify-end gap-2 lg:min-w-[251px]">
          <LanguageSelector />
          <ThemeSwitcher />
          <NuxtLink :to="localePath('/login')" class="hidden lg:block">
            <Button>
              <Label class="text-white">{{ t('auth.login') }}</Label>
            </Button>
          </NuxtLink>
          <!-- Mobile Menu -->
          <Drawer v-model:open="mobileMenuOpen">
            <DrawerTrigger asChild>
              <Button variant="outline" size="icon"
                class="border size-10 rounded-xl p-2 hover:bg-neutral-100 dark:hover:bg-neutral-900 transition-colors duration-300 lg:hidden">
                <Icon icon="heroicons:bars-3-20-solid" class="h-6 w-6" />
              </Button>
            </DrawerTrigger>

            <DrawerContent class="min-h-[95%]">
              <DrawerHeader class="flex justify-between">
                <DrawerTitle class="flex items-center gap-2">
                  <NuxtLink to="/" class="flex items-center">
                    <Logo />
                  </NuxtLink>
                </DrawerTitle>
                <Button variant="outline" size="icon" class="size-8" @click="mobileMenuOpen = false">
                  <Icon icon="heroicons:x-mark-20-solid" class="h-6 w-6" />
                </Button>
              </DrawerHeader>

              <div class="p-4 flex flex-col gap-4">
                <NuxtLink v-for="link in navigationLinks" :key="link.name" :to="localePath(link.to)"
                  class="flex items-center gap-2 font-medium text-xl" :class="{ 'active': isCurrentRoute(link.to) }"
                  @click="mobileMenuOpen = false">
                  {{ t(`navigation.${link.name}`) }}
                </NuxtLink>
                <NuxtLink :to="localePath('/login')" class="sm:hidden" @click="mobileMenuOpen = false">
                  <Button>
                    <Label class="text-white">{{ t('auth.login') }}</Label>
                  </Button>
                </NuxtLink>
              </div>
            </DrawerContent>
          </Drawer>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <slot />

    <!-- Footer -->
    <footer class="bg-[#0a1f77] text-white py-5 mt-auto">
      <div class="container mx-auto px-4">
        <div class="flex flex-col sm:flex-row sm:justify-between items-center text-sm">
          <div>
            <Logo :isFooter="true" />
          </div>
          <div class="flex my-4 flex-col items-start gap-2">
            <span>Bản quyền thuộc về Trường Đại học Thủy Lợi</span>
            <span>Địa chỉ: 175 Tây Sơn, Đống Đa, Hà Nội</span>
            <span>Điện thoại: (024) 3852 2201</span>
          </div>
        </div>
      </div>
    </footer>

    <!-- Scroll to Top Button mới với hiển thị phần trăm -->
    <div v-if="showScrollToTop" 
         class="fixed bottom-10 right-8 md:right-10 z-[9999] flex items-center justify-center"
         @click="scrollToTop">
      <div class="relative size-12 cursor-pointer group">
        <!-- Circular progress - Chỉ hiển thị progress, không hiển thị nền -->
        <svg class="size-12 rotate-[-90deg]" viewBox="0 0 100 100">
          <!-- Ẩn circle nền -->
          <circle 
            class="opacity-0" 
            stroke-width="8" 
            stroke="currentColor" 
            fill="transparent" 
            r="42" 
            cx="50" 
            cy="50" />
          <!-- Circle progress hiển thị theo % cuộn -->
          <circle 
            class="text-primary transition-all duration-300" 
            stroke-width="8" 
            :stroke-dasharray="circumference" 
            :stroke-dashoffset="dashoffset" 
            stroke-linecap="round" 
            stroke="currentColor" 
            fill="transparent" 
            r="42" 
            cx="50" 
            cy="50" />
        </svg>
        
        <!-- Nút chỉ hiển thị mũi tên, không hiển thị phần trăm -->
        <div class="absolute top-0 left-0 size-full flex items-center justify-center bg-white dark:bg-zinc-900 rounded-full shadow-md transition-all duration-300 group-hover:shadow-lg group-hover:scale-105">
          <Icon icon="heroicons:arrow-up" class="h-5 w-5 text-primary group-hover:animate-bounce" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { cn } from '@/lib/utils';
import { Icon } from '@iconify/vue';
import { useI18n } from 'vue-i18n';
import { useLocalePath } from '#i18n';

const { t } = useI18n();
const localePath = useLocalePath();
const route = useRoute();

const navigationLinks = [
  { to: '/', name: 'home' },
  { to: '/history', name: 'history' },
];

const isCurrentRoute = (path: string) => {
  return route.path === localePath(path);
};

const isScrolled = ref(false);
const mobileMenuOpen = ref(false);
const showScrollToTop = ref(false);
const lastScrollY = ref(0);
const scrollPercentage = ref(0);

// Thêm biến cho vòng tròn hiển thị phần trăm
const circumference = 2 * Math.PI * 42;
const dashoffset = computed(() => {
  return circumference * (1 - scrollPercentage.value / 100);
});

const isDisableHeaderScroll = [''].includes(route.path);

const handleScroll = () => {
  const currentScrollY = window.scrollY;
  const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  const scrollThreshold = 60;

  if (isDisableHeaderScroll) {
    isScrolled.value = false;
    return;
  }

  if (currentScrollY <= scrollThreshold) {
    isScrolled.value = false;
  } else {
    isScrolled.value = true;
  }

  // Tính toán phần trăm cuộn trang
  scrollPercentage.value = scrollHeight > 0 ? (currentScrollY / scrollHeight) * 100 : 0;
  
  showScrollToTop.value = currentScrollY > 100;
  lastScrollY.value = currentScrollY;
};

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
};

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true });
  handleScroll();
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});
</script>

<style scoped>
/* Thêm các hiệu ứng và chuyển động nếu cần */
</style>