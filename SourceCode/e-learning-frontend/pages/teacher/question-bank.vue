<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Ngân hàng câu hỏi</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm câu hỏi
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách câu hỏi</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Nội dung</TableHead>
              <TableHead>Môn học</TableHead>
              <TableHead>Loại</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="question in questions" :key="question.id">
              <TableCell>{{ question.content }}</TableCell>
              <TableCell>{{ question.subject_name }}</TableCell>
              <TableCell>{{ question.type }}</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="openEditDialog(question)" class="mr-2">
                  <Icon icon="heroicons:pencil" class="h-4 w-4" />
                </Button>
                <Button variant="destructive" size="sm" @click="deleteQuestion(question.id)">
                  <Icon icon="heroicons:trash" class="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create/Edit Question Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa câu hỏi' : 'Thêm câu hỏi' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Nội dung câu hỏi</Label>
            <Textarea v-model="form.content" />
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
            <Label>Loại câu hỏi</Label>
            <Select v-model="form.type">
              <SelectTrigger>
                <SelectValue placeholder="Chọn loại" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="MultipleChoice">Trắc nghiệm</SelectItem>
                <SelectItem value="Essay">Tự luận</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveQuestion">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const questions = ref([])
const subjects = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  content: '',
  subject_id: null,
  type: ''
})

const fetchQuestions = async () => {
  try {
    const response = await $fetch('/api/questions')
    questions.value = response
  } catch (error) {
    console.error('Error fetching questions:', error)
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
  form.content = ''
  form.subject_id = null
  form.type = ''
  dialogOpen.value = true
}

const openEditDialog = (question: any) => {
  isEditing.value = true
  form.id = question.id
  form.content = question.content
  form.subject_id = question.subject_id
  form.type = question.type
  dialogOpen.value = true
}

const saveQuestion = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/questions/${form.id}`, {
        method: 'PUT',
        body: form
      })
    } else {
      await $fetch('/api/questions', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchQuestions()
    useToast().success('Câu hỏi đã được lưu!')
  } catch (error) {
    console.error('Error saving question:', error)
    useToast().error('Lỗi khi lưu câu hỏi.')
  }
}

const deleteQuestion = async (id: number) => {
  try {
    await $fetch(`/api/questions/${id}`, { method: 'DELETE' })
    fetchQuestions()
    useToast().success('Câu hỏi đã được xóa!')
  } catch (error) {
    console.error('Error deleting question:', error)
    useToast().error('Lỗi khi xóa câu hỏi.')
  }
}

fetchQuestions()
fetchSubjects()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
