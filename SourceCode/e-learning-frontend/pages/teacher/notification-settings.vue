<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Thiết lập thông báo</h1>
      <Button variant="outline" @click="resetSettings">
        <Icon icon="heroicons:arrow-path" class="mr-2 h-5 w-5" />
        Đặt lại
      </Button>
    </div>
    <Card class="border border-border shadow-sm">
      <CardHeader>
        <CardTitle class="text-lg">Cài đặt thông báo cá nhân</CardTitle>
        <CardDescription>Quản lý cách bạn nhận thông báo từ hệ thống.</CardDescription>
      </CardHeader>
      <CardContent class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <Label class="font-medium">Thông báo qua email</Label>
            <p class="text-sm text-muted-foreground">Nhận thông báo qua email đã đăng ký.</p>
          </div>
          <Switch v-model="settings.email_notifications" @update:modelValue="saveSettings" />
        </div>
        <div class="flex items-center justify-between">
          <div>
            <Label class="font-medium">Thông báo qua ứng dụng</Label>
            <p class="text-sm text-muted-foreground">Nhận thông báo đẩy trên thiết bị.</p>
          </div>
          <Switch v-model="settings.push_notifications" @update:modelValue="saveSettings" />
        </div>
        <div>
          <Label class="font-medium">Loại thông báo</Label>
          <p class="text-sm text-muted-foreground">Chọn các loại thông báo bạn muốn nhận.</p>
          <div class="mt-2 space-y-2">
            <div v-for="type in notificationTypes" :key="type.value" class="flex items-center">
              <Checkbox v-model="settings.notification_types" :value="type.value" @update:modelValue="saveSettings" />
              <Label class="ml-2">{{ type.label }}</Label>
            </div>
          </div>
        </div>
      </CardContent>
      <CardFooter>
        <Button @click="saveSettings">Lưu cài đặt</Button>
      </CardFooter>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref } from 'vue'

definePageMeta({
  layout: 'teacher',
});

// Check if user is logged in and is teacher
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'teacher') {
    // Redirect to login if not logged in as teacher
    navigateTo('/teacher/login');
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
  { value: 'assignment', label: 'Bài tập' },
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
    useToast().success('Cài đặt thông báo đã được lưu!')
  } catch (error) {
    console.error('Error saving settings:', error)
    useToast().error('Lỗi khi lưu cài đặt.')
  }
}

const resetSettings = () => {
  settings.value = {
    email_notifications: false,
    push_notifications: false,
    notification_types: []
  }
  saveSettings()
}

fetchSettings()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
