<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý thông báo</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Gửi thông báo
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Lịch sử thông báo</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tiêu đề</TableHead>
              <TableHead>Nội dung</TableHead>
              <TableHead>Đối tượng</TableHead>
              <TableHead>Ngày gửi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="notification in notifications" :key="notification.id">
              <TableCell>{{ notification.title }}</TableCell>
              <TableCell>{{ notification.content }}</TableCell>
              <TableCell>{{ notification.recipient }}</TableCell>
              <TableCell>{{ new Date(notification.sent_at).toLocaleDateString() }}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create Notification Dialog -->
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
                <SelectItem value="All">Tất cả học viên</SelectItem>
                <SelectItem v-for="classItem in classes" :key="classItem.id" :value="classItem.id">
                  {{ classItem.name }}
                </SelectItem>
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

const notifications = ref([])
const classes = ref([])
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

const fetchClasses = async () => {
  try {
    const response = await $fetch('/api/classes?role=teacher')
    classes.value = response
  } catch (error) {
    console.error('Error fetching classes:', error)
  }
}

const sendNotification = async () => {
  try {
    await $fetch('/api/notifications', {
      method: 'POST',
      body: form
    })
    dialogOpen.value = false
    fetchNotifications()
    useToast().success('Thông báo đã được gửi!')
  } catch (error) {
    console.error('Error sending notification:', error)
    useToast().error('Lỗi khi gửi thông báo.')
  }
}

fetchNotifications()
fetchClasses()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
