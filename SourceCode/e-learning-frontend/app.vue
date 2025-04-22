<template>
  <LoadingScreen :visible="!mounted" />
  <div :class="{ 'opacity-0': !mounted, 'opacity-100': mounted }" class="transition-opacity duration-300">
    <ClientOnly>
      <NuxtLayout :name="layout">
        <NuxtPage />
      </NuxtLayout>
    </ClientOnly>
  </div>
  <Toaster />
</template>

<script setup>
const { t } = useLanguage();
const route = useRoute();
const layout = computed(() => {
  return route.meta.layout || 'default';
});

const mounted = ref(false);

onMounted(async () => {
  await nextTick();
  setTimeout(() => {
    mounted.value = true;
  }, 500);
});

useHead({
  titleTemplate: (titleChunk) => {
    return titleChunk ? `${titleChunk} | ${t('common.appName')}` : t('common.appName');
  },
});
</script>
