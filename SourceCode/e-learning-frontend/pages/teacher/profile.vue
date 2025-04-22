<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Hồ sơ cá nhân</h1>
    <Card>
      <CardHeader>
        <CardTitle>Thông tin cá nhân</CardTitle>
      </CardHeader>
      <CardContent class="space-y-4">
        <div>
          <Label>Họ tên</Label>
          <Input v-model="profile.full_name" />
        </div>
        <div>
          <Label>Email</Label>
          <Input v-model="profile.email" disabled />
        </div>
        <div>
          <Label>Số điện thoại</Label>
          <Input v-model="profile.phone" />
        </div>
      </CardContent>
      <CardFooter>
        <Button @click="saveProfile">Lưu thông tin</Button>
      </CardFooter>
    </Card>
    <Card>
      <CardHeader>
        <CardTitle>Đổi mật khẩu</CardTitle>
      </CardHeader>
      <CardContent class="space-y-4">
        <div>
          <Label>Mật khẩu hiện tại</Label>
          <Input v-model="password.current" type="password" />
        </div>
        <div>
          <Label>Mật khẩu mới</Label>
          <Input v-model="password.new" type="password" />
        </div>
        <div>
          <Label>Xác nhận mật khẩu mới</Label>
          <Input v-model="password.confirm" type="password" />
        </div>
      </CardContent>
      <CardFooter>
        <Button @click="changePassword">Đổi mật khẩu</Button>
      </CardFooter>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

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

const profile = ref({
  full_name: '',
  email: '',
  phone: ''
})

const password = reactive({
  current: '',
  new: '',
  confirm: ''
})

const fetchProfile = async () => {
  try {
    const response = await $fetch('/api/profile')
    profile.value = response
  } catch (error) {
    console.error('Error fetching profile:', error)
    useToast().error('Lỗi khi tải thông tin hồ sơ.')
  }
}

const saveProfile = async () => {
  try {
    await $fetch('/api/profile', {
      method: 'PUT',
      body: profile.value
    })
    useToast().success('Thông tin hồ sơ đã được cập nhật!')
  } catch (error) {
    console.error('Error saving profile:', error)
    useToast().error('Lỗi khi cập nhật hồ sơ.')
  }
}

const changePassword = async () => {
  if (password.new !== password.confirm) {
    useToast().error('Mật khẩu xác nhận không khớp!')
    return
  }
  try {
    await $fetch('/api/profile/password', {
      method: 'PUT',
      body: { current: password.current, new: password.new }
    })
    password.current = ''
    password.new = ''
    password.confirm = ''
    useToast().success('Mật khẩu đã được thay đổi!')
  } catch (error) {
    console.error('Error changing password:', error)
    useToast().error('Lỗi khi đổi mật khẩu.')
  }
}

fetchProfile()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
