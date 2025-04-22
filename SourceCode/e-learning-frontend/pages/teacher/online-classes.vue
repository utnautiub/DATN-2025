<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Lớp học trực tuyến</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tạo lớp trực tuyến
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách lớp học trực tuyến</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Lớp học</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Công cụ</TableHead>
              <TableHead>Trạng thái</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="onlineClass in onlineClasses" :key="onlineClass.id">
              <TableCell>{{ onlineClass.class_name }}</TableCell>
              <TableCell>{{ new Date(onlineClass.start_time).toLocaleString() }}</TableCell>
              <TableCell>{{ onlineClass.tool }}</TableCell>
              <TableCell>
                <Badge :variant="onlineClass.status === 'Active' ? 'success' : 'secondary'">
                  {{ onlineClass.status }}
                </Badge>
              </TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="joinClass(onlineClass.link)">
                  <Icon icon="heroicons:video-camera" class="h-4 w-4" />
                  Tham gia
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create Online Class Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Tạo lớp học trực tuyến</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Lớp học</Label>
            <Select v-model="form.class_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn lớp" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="classItem in classes" :key="classItem.id" :value="classItem.id">
                  {{ classItem.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Thời gian bắt đầu</Label>
            <Input v-model="form.start_time" type="datetime-local" />
          </div>
          <div>
            <Label>Công cụ</Label>
            <Select v-model="form.tool">
              <SelectTrigger>
                <SelectValue placeholder="Chọn công cụ" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="Zoom">Zoom</SelectItem>
                <SelectItem value="Microsoft Teams">Microsoft Teams</SelectItem>
                <SelectItem value="Google Meet">Google Meet</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="createOnlineClass">Tạo</Button>
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

const onlineClasses = ref([])
const classes = ref([])
const dialogOpen = ref(false)
const form = reactive({
  class_id: null,
  start_time: '',
  tool: ''
})

const fetchOnlineClasses = async () => {
  try {
    const response = await $fetch('/api/online-classes')
    onlineClasses.value = response
  } catch (error) {
    console.error('Error fetching online classes:', error)
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

const createOnlineClass = async () => {
  try {
    await $fetch('/api/online-classes', {
      method: 'POST',
      body: form
    })
    dialogOpen.value = false
    fetchOnlineClasses()
    useToast().success('Lớp học trực tuyến đã được tạo!')
  } catch (error) {
    console.error('Error creating online class:', error)
    useToast().error('Lỗi khi tạo lớp học trực tuyến.')
  }
}

const joinClass = (link: string) => {
  window.open(link, '_blank')
}

fetchOnlineClasses()
fetchClasses()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
