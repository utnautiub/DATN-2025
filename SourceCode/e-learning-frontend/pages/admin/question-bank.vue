<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý ngân hàng câu hỏi</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm câu hỏi
      </Button>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="flex justify-center items-center h-64">
      <div class="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-primary"></div>
    </div>

    <!-- Error or Empty State -->
    <div v-else-if="error" class="text-center text-red-500">
      {{ error }}
    </div>
    <div v-else-if="questions.length === 0" class="text-center text-muted-foreground">
      Chưa có câu hỏi nào. Hãy thêm câu hỏi mới để bắt đầu!
    </div>

    <!-- Table -->
    <Table v-else>
      <TableHeader>
        <TableRow>
          <TableHead>Nội dung câu hỏi</TableHead>
          <TableHead>Môn học</TableHead>
          <TableHead>Loại câu hỏi</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="question in questions" :key="question.id">
          <TableCell>{{ question.content }}</TableCell>
          <TableCell>{{ question.subject_name }}</TableCell>
          <TableCell>{{ question.type === 'MultipleChoice' ? 'Trắc nghiệm' : 'Tự luận' }}</TableCell>
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

    <!-- Create/Edit Dialog -->
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
import { ref, reactive, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import { navigateTo } from '#app'

// Set the layout for this page
definePageMeta({
  layout: 'admin', // Đổi thành layout teacher
})

// State variables
const questions = ref([])
const subjects = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const isLoading = ref(true)
const error = ref(null)

const form = reactive({
  id: null,
  content: '',
  subject_id: null,
  type: ''
})

// Dữ liệu mẫu
const demoQuestions = [
  {
    id: 1,
    content: "Giải phương trình: 2x + 3 = 7",
    subject_id: 1,
    subject_name: "Toán",
    type: "MultipleChoice"
  },
  {
    id: 2,
    content: "Phân tích bài thơ Tràng giang của Xuân Diệu",
    subject_id: 2,
    subject_name: "Văn",
    type: "Essay"
  },
  {
    id: 3,
    content: "Công thức hóa học của nước là gì?",
    subject_id: 3,
    subject_name: "Hóa",
    type: "MultipleChoice"
  }
]

const demoSubjects = [
  { id: 1, name: "Toán" },
  { id: 2, name: "Văn" },
  { id: 3, name: "Hóa" }
]

// Check if user is logged in and is teacher
onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'admin') {
    navigateTo('/admin/login')
  } else {
    fetchQuestions()
    fetchSubjects()
  }
})

const fetchQuestions = async () => {
  try {
    isLoading.value = true
    // Sử dụng dữ liệu mẫu
    questions.value = demoQuestions
    console.log('Questions loaded:', questions.value)
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/questions')
    // questions.value = response
  } catch (err) {
    console.error('Error fetching questions:', err)
    error.value = 'Không thể tải danh sách câu hỏi. Vui lòng thử lại sau.'
    toast.error(error.value)
  } finally {
    isLoading.value = false
  }
}

const fetchSubjects = async () => {
  try {
    // Sử dụng dữ liệu mẫu
    subjects.value = demoSubjects
    console.log('Subjects loaded:', subjects.value)
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/subjects')
    // subjects.value = response
  } catch (error) {
    console.error('Error fetching subjects:', error)
    toast.error('Lỗi khi tải danh sách môn học.')
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

const openEditDialog = (question) => {
  isEditing.value = true
  form.id = question.id
  form.content = question.content
  form.subject_id = question.subject_id
  form.type = question.type
  dialogOpen.value = true
}

const saveQuestion = async () => {
  try {
    if (!form.content || !form.subject_id || !form.type) {
      toast.error('Vui lòng điền đầy đủ thông tin!')
      return
    }

    if (isEditing.value) {
      toast.promise(
        async () => {
          // Giả lập chỉnh sửa câu hỏi
          const index = questions.value.findIndex(q => q.id === form.id)
          if (index !== -1) {
            questions.value[index] = {
              ...questions.value[index],
              content: form.content,
              subject_id: form.subject_id,
              subject_name: subjects.value.find(s => s.id === form.subject_id)?.name || 'Unknown',
              type: form.type
            }
          }
          dialogOpen.value = false
        },
        {
          loading: 'Đang cập nhật câu hỏi...',
          success: 'Câu hỏi đã được cập nhật!',
          error: 'Lỗi khi cập nhật câu hỏi.'
        }
      )
    } else {
      toast.promise(
        async () => {
          // Giả lập thêm câu hỏi mới
          const newQuestion = {
            id: questions.value.length + 1,
            content: form.content,
            subject_id: form.subject_id,
            subject_name: subjects.value.find(s => s.id === form.subject_id)?.name || 'Unknown',
            type: form.type
          }
          questions.value.push(newQuestion)
          dialogOpen.value = false
        },
        {
          loading: 'Đang thêm câu hỏi...',
          success: 'Câu hỏi đã được thêm!',
          error: 'Lỗi khi thêm câu hỏi.'
        }
      )
    }
  } catch (error) {
    console.error('Error saving question:', error)
    toast.error('Lỗi khi lưu câu hỏi.')
  }
}

const deleteQuestion = async (id) => {
  toast.promise(
    async () => {
      // Giả lập xóa câu hỏi với delay
      await new Promise(resolve => setTimeout(resolve, 1000))
      questions.value = questions.value.filter(q => q.id !== id)
    },
    {
      loading: 'Đang xóa câu hỏi...',
      success: 'Câu hỏi đã được xóa!',
      error: 'Lỗi khi xóa câu hỏi.'
    }
  )
}
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
