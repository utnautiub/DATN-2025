<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý kỳ thi</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm kỳ thi
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên kỳ thi</TableHead>
          <TableHead>Môn học</TableHead>
          <TableHead>Ngày thi</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="exam in exams" :key="exam.id">
          <TableCell>{{ exam.title }}</TableCell>
          <TableCell>{{ exam.subject_name }}</TableCell>
          <TableCell>{{ new Date(exam.exam_date).toLocaleDateString() }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(exam)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteExam(exam.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa kỳ thi' : 'Thêm kỳ thi' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên kỳ thi</Label>
            <Input v-model="form.title" />
          </div>
          <div>
            <Label>Môn học</Label>
            <Select v-model="form.subject_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn môn học" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="subject in subjects" :key="subject.id" :value="subject.id">
                  {{ subject.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Ngày thi</Label>
            <Input v-model="form.exam_date" type="date" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveExam">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const exams = ref([])
const subjects = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  title: '',
  subject_id: null,
  exam_date: ''
})

const fetchExams = async () => {
  try {
    const response = await $fetch('/api/exams')
    exams.value = response
  } catch (error) {
    console.error('Error fetching exams:', error)
  }
}

const fetchSubjects = async () => {
  try {
    const response = await $fetch('/api/subjects')
    subjects.value = response
  } catch (error) {
    console.error('Error fetching subjects:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.title = ''
  form.subject_id = null
  form.exam_date = ''
  dialogOpen.value = true
}

const openEditDialog = (exam: any) => {
  isEditing.value = true
  form.id = exam.id
  form.title = exam.title
  form.subject_id = exam.subject_id
  form.exam_date = exam.exam_date
  dialogOpen.value = true
}

const saveExam = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/exams/${form.id}`, {
        method: 'PUT',
        body: { title: form.title, subject_id: form.subject_id, exam_date: form.exam_date }
      })
    } else {
      await $fetch('/api/exams', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchExams()
  } catch (error) {
    console.error('Error saving exam:', error)
  }
}

const deleteExam = async (id: number) => {
  try {
    await $fetch(`/api/exams/${id}`, { method: 'DELETE' })
    fetchExams()
  } catch (error) {
    console.error('Error deleting exam:', error)
  }
}

fetchExams()
fetchSubjects()
</script>
