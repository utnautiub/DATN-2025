<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý bài kiểm tra</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tạo bài kiểm tra
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách bài kiểm tra</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tiêu đề</TableHead>
              <TableHead>Lớp học</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="quiz in quizzes" :key="quiz.id">
              <TableCell>{{ quiz.title }}</TableCell>
              <TableCell>{{ quiz.class_name }}</TableCell>
              <TableCell>{{ new Date(quiz.start_time).toLocaleString() }}</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="openEditDialog(quiz)" class="mr-2">
                  <Icon icon="heroicons:pencil" class="h-4 w-4" />
                </Button>
                <Button variant="destructive" size="sm" @click="deleteQuiz(quiz.id)">
                  <Icon icon="heroicons:trash" class="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create/Edit Quiz Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa bài kiểm tra' : 'Tạo bài kiểm tra' }}</DialogTitle>
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
            <Label>Thời gian bắt đầu</Label>
            <Input v-model="form.start_time" type="datetime-local" />
          </div>
          <div>
            <Label>Thời gian kết thúc</Label>
            <Input v-model="form.end_time" type="datetime-local" />
          </div>
          <div>
            <Label>Câu hỏi</Label>
            <Select v-model="form.questions" multiple>
              <SelectTrigger>
                <SelectValue placeholder="Chọn câu hỏi" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="question in questions" :key="question.id" :value="question.id">
                  {{ question.content }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveQuiz">{{ isEditing ? 'Cập nhật' : 'Tạo' }}</Button>
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

const quizzes = ref([])
const classes = ref([])
const questions = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  title: '',
  class_id: null,
  start_time: '',
  end_time: '',
  questions: []
})

const fetchQuizzes = async () => {
  try {
    const response = await $fetch('/api/quizzes')
    quizzes.value = response
  } catch (error) {
    console.error('Error fetching quizzes:', error)
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

const fetchQuestions = async () => {
  try {
    const response = await $fetch('/api/questions')
    questions.value = response
  } catch (error) {
    console.error('Error fetching questions:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.title = ''
  form.class_id = null
  form.start_time = ''
  form.end_time = ''
  form.questions = []
  dialogOpen.value = true
}

const openEditDialog = (quiz: any) => {
  isEditing.value = true
  form.id = quiz.id
  form.title = quiz.title
  form.class_id = quiz.class_id
  form.start_time = quiz.start_time
  form.end_time = quiz.end_time
  form.questions = quiz.questions
  dialogOpen.value = true
}

const saveQuiz = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/quizzes/${form.id}`, {
        method: 'PUT',
        body: form
      })
    } else {
      await $fetch('/api/quizzes', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchQuizzes()
    useToast().success('Bài kiểm tra đã được lưu!')
  } catch (error) {
    console.error('Error saving quiz:', error)
    useToast().error('Lỗi khi lưu bài kiểm tra.')
  }
}

const deleteQuiz = async (id: number) => {
  try {
    await $fetch(`/api/quizzes/${id}`, { method: 'DELETE' })
    fetchQuizzes()
    useToast().success('Bài kiểm tra đã được xóa!')
  } catch (error) {
    console.error('Error deleting quiz:', error)
    useToast().error('Lỗi khi xóa bài kiểm tra.')
  }
}

fetchQuizzes()
fetchClasses()
fetchQuestions()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
