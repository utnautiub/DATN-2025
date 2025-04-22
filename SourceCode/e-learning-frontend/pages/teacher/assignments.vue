<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý bài tập</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tạo bài tập
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách bài tập</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tiêu đề</TableHead>
              <TableHead>Lớp học</TableHead>
              <TableHead>Hạn nộp</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="assignment in assignments" :key="assignment.id">
              <TableCell>{{ assignment.title }}</TableCell>
              <TableCell>{{ assignment.class_name }}</TableCell>
              <TableCell>{{ new Date(assignment.due_date).toLocaleString() }}</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="openEditDialog(assignment)" class="mr-2">
                  <Icon icon="heroicons:pencil" class="h-4 w-4" />
                </Button>
                <Button variant="destructive" size="sm" @click="deleteAssignment(assignment.id)">
                  <Icon icon="heroicons:trash" class="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create/Edit Assignment Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa bài tập' : 'Tạo bài tập' }}</DialogTitle>
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
            <Label>Mô tả</Label>
            <Textarea v-model="form.description" />
          </div>
          <div>
            <Label>Hạn nộp</Label>
            <Input v-model="form.due_date" type="datetime-local" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveAssignment">{{ isEditing ? 'Cập nhật' : 'Tạo' }}</Button>
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

const assignments = ref([])
const classes = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  title: '',
  class_id: null,
  description: '',
  due_date: ''
})

const fetchAssignments = async () => {
  try {
    const response = await $fetch('/api/assignments')
    assignments.value = response
  } catch (error) {
    console.error('Error fetching assignments:', error)
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
  form.description = ''
  form.due_date = ''
  dialogOpen.value = true
}

const openEditDialog = (assignment: any) => {
  isEditing.value = true
  form.id = assignment.id
  form.title = assignment.title
  form.class_id = assignment.class_id
  form.description = assignment.description
  form.due_date = assignment.due_date
  dialogOpen.value = true
}

const saveAssignment = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/assignments/${form.id}`, {
        method: 'PUT',
        body: form
      })
    } else {
      await $fetch('/api/assignments', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchAssignments()
    useToast().success('Bài tập đã được lưu!')
  } catch (error) {
    console.error('Error saving assignment:', error)
    useToast().error('Lỗi khi lưu bài tập.')
  }
}

const deleteAssignment = async (id: number) => {
  try {
    await $fetch(`/api/assignments/${id}`, { method: 'DELETE' })
    fetchAssignments()
    useToast().success('Bài tập đã được xóa!')
  } catch (error) {
    console.error('Error deleting assignment:', error)
    useToast().error('Lỗi khi xóa bài tập.')
  }
}

fetchAssignments()
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
