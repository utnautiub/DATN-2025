<template>
  <DropdownMenu>
    <DropdownMenuTrigger asChild>
      <Button
        variant="outline"
        size="icon"
        class="border size-10 rounded-xl p-2 hover:bg-neutral-100 dark:hover:bg-neutral-900"
      >
        <Icon
          v-if="currentTheme === 'light'"
          icon="lucide:sun"
          class="h-8 w-8"
        />
        <Icon
          v-else-if="currentTheme === 'dark'"
          icon="lucide:moon"
          class="h-8 w-8"
        />
        <Icon
          v-else
          icon="lucide:laptop"
          class="h-8 w-8"
        />
        <span class="sr-only">Toggle theme</span>
      </Button>
    </DropdownMenuTrigger>
    <DropdownMenuContent align="end">
      <DropdownMenuItem @click="setTheme('light')">
        <Icon icon="lucide:sun" class="mr-2 h-4 w-4" />
        <span>Light</span>
      </DropdownMenuItem>
      <DropdownMenuItem @click="setTheme('dark')">
        <Icon icon="lucide:moon" class="mr-2 h-4 w-4" />
        <span>Dark</span>
      </DropdownMenuItem>
      <DropdownMenuItem @click="setTheme('system')">
        <Icon icon="lucide:laptop" class="mr-2 h-4 w-4" />
        <span>System</span>
      </DropdownMenuItem>
    </DropdownMenuContent>
  </DropdownMenu>
</template>

<script setup lang="ts">
import { useTheme } from '~/composables/useTheme';
import { Icon } from '@iconify/vue';

const { setTheme, currentTheme } = useTheme();
</script>


