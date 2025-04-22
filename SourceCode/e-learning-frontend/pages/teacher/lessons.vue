<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý bài giảng</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tạo bài giảng
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách bài giảng</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tiêu đề</TableHead>
              <TableHead>Lớp học</TableHead>
              <TableHead>Ngày tạo</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="lesson in lessons" :key="lesson.id">
              <TableCell>{{ lesson.title }}</TableCell>
              <TableCell>{{ lesson.class_name }}</TableCell>
              <TableCell>{{ new Date(lesson.created_at).toLocaleDateString() }}</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="openEditDialog(lesson)" class="mr-2">
                  <Icon icon="heroicons:pencil" class="h-4 w-4" />
                </Button>
                <Button variant="destructive" size="sm" @click="deleteLesson(lesson.id)">
                  <Icon icon="heroicons:trash" class="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create/Edit Lesson Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa bài giảng' : 'Tạo bài giảng' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tiêu đề</Label>
            <Input v-model="form.title" />
          </div>
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
            <Label>Nội dung</Label>
            <Textarea v-model="form.content" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveLesson">{{ isEditing ? 'Cập nhật' : 'Tạo' }}</Button>
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

const lessons = ref([])
const classes = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  title: '',
  class_id: null,
  content: ''
})

const fetchLessons = async () => {
  try {
    const response = await $fetch('/api/lessons')
    lessons.value = response
  } catch (error) {
    console.error('Error fetching lessons:', error)
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

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.title = ''
  form.class_id = null
  form.content = ''
  dialogOpen.value = true
}

const openEditDialog = (lesson: any) => {
  isEditing.value = true
  form.id = lesson.id
  form.title = lesson.title
  form.class_id = lesson.class_id
  form.content = lesson.content
  dialogOpen.value = true
}

const saveLesson = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/lessons/${form.id}`, {
        method: 'PUT',
        body: form
      })
    } else {
      await $fetch('/api/lessons', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchLessons()
    useToast().success('Bài giảng đã được lưu!')
  } catch (error) {
    console.error('Error saving lesson:', error)
    useToast().error('Lỗi khi lưu bài giảng.')
  }
}

const deleteLesson = async (id: number) => {
  try {
    await $fetch(`/api/lessons/${id}`, { method: 'DELETE' })
    fetchLessons()
    useToast().success('Bài giảng đã được xóa!')
  } catch (error) {
    console.error('Error deleting lesson:', error)
    useToast().error('Lỗi khi xóa bài giảng.')
  }
}

fetchLessons()
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
