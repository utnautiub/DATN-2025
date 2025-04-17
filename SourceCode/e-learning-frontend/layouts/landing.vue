<template>
  <div>
    <header :class="cn(
      'top-8 sm:top-4 z-50',
      !isDisableHeaderScroll && 'sticky'
    )">
      <div :class="cn(
        'mx-auto flex justify-between gap-10 items-center transition-all duration-300 p-4 z-50',
        isScrolled
          ? 'bg-white/80 backdrop-blur-md md:p-6 dark:bg-zinc-900/80 xl:w-[90%] shadow  md:rounded-3xl'
          : 'bg-transparent w-full xl:w-[70%]'
      )">
        <!-- Logo -->
        <div class="flex items-center gap-2">
          <NuxtLink to="/" class="flex items-center"  @click="scrollToTop">
            <Logo />
          </NuxtLink>
        </div>

        <!-- Navigation Links -->
        <div class="flex-1 items-center gap-3 justify-center hidden sm:flex">
          <HeaderLink v-for="link in navigationLinks" :key="link.name" :title="t(`navigation.${link.name}`)"
            :href="localePath(link.to)" :class="{ 'active': isCurrentRoute(link.to) }" />
        </div>

        <!-- Actions -->
        <div class="flex items-center justify-end gap-2 min-w-[251px]">
          <LanguageSelector />
          <ThemeSwitcher />
          <NuxtLink to="/login">
            <Button>
              <Label class="text-white">Đăng nhập</Label>
            </Button>
          </NuxtLink>
          <!-- Mobile Menu -->
          <Drawer v-model:open="mobileMenuOpen">
            <DrawerTrigger asChild>
              <Button variant="outline" size="icon"
                class="border size-10 rounded-xl p-2 hover:bg-neutral-100 dark:hover:bg-neutral-900 transition-colors duration-300 sm:hidden">
                <Icon icon="heroicons:bars-3-20-solid" class="h-6 w-6" />
              </Button>
            </DrawerTrigger>

            <DrawerContent class="min-h-dvh">
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

              <div class="px-6 flex flex-col gap-4">
                <NuxtLink v-for="link in navigationLinks" :key="link.name" :to="localePath(link.to)"
                  class="flex items-center gap-2 font-medium text-xl" :class="{ 'active': isCurrentRoute(link.to) }"
                  @click="mobileMenuOpen = false">
                  {{ t(`navigation.${link.name}`) }}
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
          <div >
            <Logo :isFooter="true"/>
          </div>
          <div class="flex my-4 flex-col items-start gap-2">
            <span>Bản quyền thuộc về Trường Đại học Thủy Lợi</span>
            <span>Địa chỉ: 175 Tây Sơn, Đống Đa, Hà Nội</span>
            <span>Điện thoại: (024) 3852 2201</span>
          </div>
        </div>
      </div>
    </footer>

    <!-- Scroll to Top Button -->
    <Button v-if="showScrollToTop" variant="outline" size="icon"
      class="size-10 !bg-zinc-900/80 backdrop-blur-md rounded-xl p-2 hover:scale-110 duration-300 fixed bottom-10 right-8 md:right-10 z-[9999]"
      @click="scrollToTop">
      <Icon icon="heroicons:arrow-up" class="text-white h-5 w-5" />
    </Button>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { cn } from '@/lib/utils';
import { Icon } from '@iconify/vue';
import { useI18n } from 'vue-i18n';
import { useLocalePath } from '#i18n';

const { t } = useI18n();
const localePath = useLocalePath();
const route = useRoute();

const navigationLinks = [
  { to: '/', name: 'home' },
  { to: '/courses', name: 'courses' },
  { to: '/history', name: 'history' },
  { to: '/about', name: 'about' }
];

const isCurrentRoute = (path: string) => {
  return route.path === localePath(path);
};

const isScrolled = ref(false);
const mobileMenuOpen = ref(false);
const showScrollToTop = ref(false);
const lastScrollY = ref(0);

const isDisableHeaderScroll = [''].includes(route.path);

const handleScroll = () => {
  const currentScrollY = window.scrollY;
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

<style scoped></style>
