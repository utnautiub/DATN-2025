<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import { cn } from '@/lib/utils';

const props = defineProps<{
  title: string
  href: string
}>();

const route = useRoute();
const isActive = computed(() => props.href === route.path);
</script>

<template>
  <div :class="cn(
    'flex items-center gap-2 px-3 py-2 rounded-full',
    isActive
      ? 'dark:bg-white dark:text-black bg-zinc-900 text-white'
      : 'dark:hover:bg-zinc-800 hover:bg-zinc-100'
  )">
    <NuxtLink :to="href">{{ title }}</NuxtLink>
  </div>
</template>