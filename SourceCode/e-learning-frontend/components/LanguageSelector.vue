<template>
  <DropdownMenu>
    <DropdownMenuTrigger asChild>
      <Button
        variant="outline"
        size="icon"
        class="border size-10 rounded-xl p-2 hover:bg-neutral-100 dark:hover:bg-neutral-900"
      >
        <span>{{ currentFlag }}</span>
      </Button>
    </DropdownMenuTrigger>
    <DropdownMenuContent align="end">
      <DropdownMenuItem 
        v-for="lang in languages" 
        :key="lang.code"
        @click="setLanguage(lang.code)"
        :class="{ 'bg-accent': currentLanguage === lang.code }"
      >
        <span class="mr-2">{{ lang.flag }}</span>
        <span>{{ lang.nativeName }}</span>
        <Check
          v-if="currentLanguage === lang.code"
          class="ml-auto h-4 w-4"
        />
      </DropdownMenuItem>
    </DropdownMenuContent>
  </DropdownMenu>
</template>

<script lang="ts" setup>
import { Check } from 'lucide-vue-next';
import { computed } from 'vue';
import { useLanguage } from '~/composables/useLanguage';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Button } from '@/components/ui/button';

const { currentLanguage, setLanguage, getLanguages, t } = useLanguage();
const languages = getLanguages();

const currentFlag = computed(() => {
  const currentLang = languages.find(lang => lang.code === currentLanguage.value);
  return currentLang?.flag || '🌐';
});
</script>






