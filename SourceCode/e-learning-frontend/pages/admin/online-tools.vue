<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Cấu hình công cụ học trực tuyến</h1>
    <Card>
      <CardHeader>
        <CardTitle>Tích hợp công cụ</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="space-y-4">
          <div>
            <Label>Zoom API Key</Label>
            <Input v-model="settings.zoom_api_key" placeholder="Nhập Zoom API Key" />
          </div>
          <div>
            <Label>Zoom API Secret</Label>
            <Input v-model="settings.zoom_api_secret" placeholder="Nhập Zoom API Secret" />
          </div>
          <div>
            <Label>Microsoft Teams Webhook</Label>
            <Input v-model="settings.teams_webhook" placeholder="Nhập Teams Webhook URL" />
          </div>
          <div>
            <Label>Google Meet API Key</Label>
            <Input v-model="settings.google_meet_api_key" placeholder="Nhập Google Meet API Key" />
          </div>
        </div>
      </CardContent>
      <CardFooter>
        <Button @click="saveSettings">Lưu cấu hình</Button>
      </CardFooter>
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
  zoom_api_key: '',
  zoom_api_secret: '',
  teams_webhook: '',
  google_meet_api_key: ''
})

const fetchSettings = async () => {
  try {
    const response = await $fetch('/api/online-tools')
    settings.value = response
  } catch (error) {
    console.error('Error fetching settings:', error)
  }
}

const saveSettings = async () => {
  try {
    await $fetch('/api/online-tools', {
      method: 'PUT',
      body: settings.value
    })
  } catch (error) {
    console.error('Error saving settings:', error)
  }
}

fetchSettings()
</script>
