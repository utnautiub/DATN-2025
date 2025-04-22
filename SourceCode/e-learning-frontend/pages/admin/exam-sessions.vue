<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý ca thi</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm ca thi
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Kỳ thi</TableHead>
          <TableHead>Thời gian</TableHead>
          <TableHead>Phòng thi</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="session in sessions" :key="session.id">
          <TableCell>{{ session.exam_name }}</TableCell>
          <TableCell>{{ session.start_time }} - {{ session.end_time }}</TableCell>
          <TableCell>{{ session.classroom_name }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(session)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteSession(session.id)">
              <Icon icon="heroicons:trash" class="h-4 w-4" />
            </Button>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>

    <!-- Create/Edit Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa ca thi' : 'Thêm ca thi' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Kỳ thi</Label>
            <Select v-model="form.exam_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn kỳ thi" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="exam in exams" :key="exam.id" :value="exam.id">
                  {{ exam.title }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Thời gian bắt đầu</Label>
            <Input v-model="form.start_time" type="datetime-local" />
          </div>
          <div>
            <Label>Thời gian kết thúc</Label>
            <Input v-model="form.end_time" type="datetime-local" />
          </div>
          <div>
            <Label>Phòng thi</Label>
            <Select v-model="form.classroom_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn phòng thi" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="classroom in classrooms" :key="classroom.id" :value="classroom.id">
                  {{ classroom.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveSession">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const sessions = ref([])
const exams = ref([])
const classrooms = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  exam_id: null,
  start_time: '',
  end_time: '',
  classroom_id: null
})

const fetchSessions = async () => {
  try {
    const response = await $fetch('/api/exam-sessions')
    sessions.value = response
  } catch (error) {
    console.error('Error fetching sessions:', error)
  }
}

const fetchExams = async () => {
  try {
    const response = await $fetch('/api/exams')
    exams.value = response
  } catch (error) {
    console.error('Error fetching exams:', error)
  }
}

const fetchClassrooms = async () => {
  try {
    const response = await $fetch('/api/classrooms')
    classrooms.value = response
  } catch (error) {
    console.error('Error fetching classrooms:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.exam_id = null
  form.start_time = ''
  form.end_time = ''
  form.classroom_id = null
  dialogOpen.value = true
}

const openEditDialog = (session: any) => {
  isEditing.value = true
  form.id = session.id
  form.exam_id = session.exam_id
  form.start_time = session.start_time
  form.end_time = session.end_time
  form.classroom_id = session.classroom_id
  dialogOpen.value = true
}

const saveSession = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/exam-sessions/${form.id}`, {
        method: 'PUT',
        body: { exam_id: form.exam_id, start_time: form.start_time, end_time: form.end_time, classroom_id: form.classroom_id }
      })
    } else {
      await $fetch('/api/exam-sessions', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchSessions()
  } catch (error) {
    console.error('Error saving session:', error)
  }
}

const deleteSession = async (id: number) => {
  try {
    await $fetch(`/api/exam-sessions/${id}`, { method: 'DELETE' })
    fetchSessions()
  } catch (error) {
    console.error('Error deleting session:', error)
  }
}

fetchSessions()
fetchExams()
fetchClassrooms()
</script>