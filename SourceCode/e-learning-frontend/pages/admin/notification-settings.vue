<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Thiết lập thông báo</h1>
    <Card>
      <CardHeader>
        <CardTitle>Cài đặt thông báo cá nhân</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <Label>Nhận thông báo qua email</Label>
            <Switch v-model="settings.email_notifications" @update:modelValue="saveSettings" />
          </div>
          <div class="flex items-center justify-between">
            <Label>Nhận thông báo qua ứng dụng</Label>
            <Switch v-model="settings.push_notifications" @update:modelValue="saveSettings" />
          </div>
          <div>
            <Label>Loại thông báo</Label>
            <div class="space-y-2">
              <div v-for="type in notificationTypes" :key="type.value" class="flex items-center">
                <Checkbox v-model="settings.notification_types" :value="type.value" @update:modelValue="saveSettings" />
                <Label class="ml-2">{{ type.label }}</Label>
              </div>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useLanguage } from '~/composables/useLanguage';

// Set the layout for this page
definePageMeta({
  layout: 'admin',
});

// Get translations
const { t } = useLanguage();

// Check if user is logged in and is admin
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'admin') {
    // Redirect to login if not logged in as admin
    navigateTo('/login');
  }
});

const settings = ref({
  email_notifications: false,
  push_notifications: false,
  notification_types: []
})

const notificationTypes = [
  { value: 'system', label: 'Hệ thống' },
  { value: 'course', label: 'Khóa học' },
  { value: 'exam', label: 'Kỳ thi' }
]

const fetchSettings = async () => {
  try {
    const response = await $fetch('/api/notification-settings')
    settings.value = response
  } catch (error) {
    console.error('Error fetching settings:', error)
  }
}

const saveSettings = async () => {
  try {
    await $fetch('/api/notification-settings', {
      method: 'PUT',
      body: settings.value
    })
  } catch (error) {
    console.error('Error saving settings:', error)
  }
}

fetchSettings()
</script>
