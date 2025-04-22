<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý thông báo</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Gửi thông báo
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tiêu đề</TableHead>
          <TableHead>Nội dung</TableHead>
          <TableHead>Ngày gửi</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="notification in notifications" :key="notification.id">
          <TableCell>{{ notification.title }}</TableCell>
          <TableCell>{{ notification.content }}</TableCell>
          <TableCell>{{ new Date(notification.sent_at).toLocaleDateString() }}</TableCell>
          <TableCell>
            <Button variant="destructive" size="sm" @click="deleteNotification(notification.id)">
              <Icon icon="heroicons:trash" class="h-4 w-4" />
            </Button>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>

    <!-- Create Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Gửi thông báo mới</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tiêu đề</Label>
            <Input v-model="form.title" />
          </div>
          <div>
            <Label>Nội dung</Label>
            <Textarea v-model="form.content" />
          </div>
          <div>
            <Label>Đối tượng nhận</Label>
            <Select v-model="form.recipient">
              <SelectTrigger>
                <SelectValue placeholder="Chọn đối tượng" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="All">Tất cả</SelectItem>
                <SelectItem value="Students">Học sinh</SelectItem>
                <SelectItem value="Teachers">Giáo viên</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="sendNotification">Gửi</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref, reactive } from 'vue'
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

const notifications = ref([])
const dialogOpen = ref(false)
const form = reactive({
  title: '',
  content: '',
  recipient: ''
})

const fetchNotifications = async () => {
  try {
    const response = await $fetch('/api/notifications')
    notifications.value = response
  } catch (error) {
    console.error('Error fetching notifications:', error)
  }
}

const openCreateDialog = () => {
  form.title = ''
  form.content = ''
  form.recipient = ''
  dialogOpen.value = true
}

const sendNotification = async () => {
  try {
    await $fetch('/api/notifications', {
      method: 'POST',
      body: form
    })
    dialogOpen.value = false
    fetchNotifications()
  } catch (error) {
    console.error('Error sending notification:', error)
  }
}

const deleteNotification = async (id: number) => {
  try {
    await $fetch(`/api/notifications/${id}`, { method: 'DELETE' })
    fetchNotifications()
  } catch (error) {
    console.error('Error deleting notification:', error)
  }
}

fetchNotifications()
</script>
