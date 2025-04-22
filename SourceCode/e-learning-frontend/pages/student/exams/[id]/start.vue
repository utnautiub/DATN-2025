<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">{{ exam.subject_name }} - {{ exam.type === 'Quiz' ? 'Kiểm tra' : 'Thi' }}</h1>

    <!-- Mobile: Drawer for question list -->
    <div class="md:hidden">
      <Button @click="drawerOpen = true" class="mb-4">
        <Icon icon="heroicons:menu" class="mr-2 h-5 w-5" />
        Danh sách câu hỏi
      </Button>
      <Drawer v-model:open="drawerOpen">
        <DrawerContent>
          <DrawerHeader>
            <DrawerTitle>Danh sách câu hỏi</DrawerTitle>
          </DrawerHeader>
          <DrawerContent class="p-4">
            <div class="space-y-2">
              <Button v-for="question in exam.questions" :key="question.id"
                :variant="currentQuestion?.id === question.id ? 'secondary' : 'ghost'" class="w-full justify-start"
                @click="selectQuestion(question)">
                Câu {{ question.id }}
              </Button>
            </div>
          </DrawerContent>
          <DrawerFooter>
            <Button variant="outline" @click="drawerOpen = false">Đóng</Button>
          </DrawerFooter>
        </DrawerContent>
      </Drawer>
    </div>

    <!-- Main Exam Interface -->
    <div class="grid gap-4 md:grid-cols-4">
      <!-- Desktop: Question List (Left) -->
      <Card class="hidden md:block md:col-span-1 border border-border shadow-sm">
        <CardHeader>
          <CardTitle>Danh sách câu hỏi</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="space-y-2">
            <Button v-for="question in exam.questions" :key="question.id"
              :variant="currentQuestion?.id === question.id ? 'secondary' : 'ghost'" class="w-full justify-start"
              @click="selectQuestion(question)">
              Câu {{ question.id }}
            </Button>
          </div>
        </CardContent>
      </Card>

      <!-- Question Content (Right) -->
      <Card class="md:col-span-3 border border-border shadow-sm">
        <CardHeader>
          <CardTitle v-if="currentQuestion">Câu {{ currentQuestion.id }}: {{ currentQuestion.content }}</CardTitle>
          <CardTitle v-else>Chọn một câu hỏi để bắt đầu</CardTitle>
        </CardHeader>
        <CardContent v-if="currentQuestion" class="space-y-4">
          <!-- Multiple Choice -->
          <div v-if="currentQuestion.type === 'MultipleChoice'">
            <div v-for="option in currentQuestion.options" :key="option.id" class="flex items-center">
              <RadioGroup v-model="answers[currentQuestion.id]" class="flex items-center">
                <RadioGroupItem :value="option.id" :id="'option-' + option.id" />
                <Label :for="'option-' + option.id" class="ml-2">{{ option.content }}</Label>
              </RadioGroup>
            </div>
          </div>
          <!-- Essay -->
          <div v-else>
            <Textarea v-model="answers[currentQuestion.id]" placeholder="Nhập câu trả lời của bạn..." />
          </div>
        </CardContent>
        <CardFooter>
          <Button @click="submitExam">Nộp bài</Button>
        </CardFooter>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { navigateTo, useRoute } from '#app'
import { toast } from 'vue-sonner'
import { Icon } from '@iconify/vue'

definePageMeta({
  layout: 'student',
})

const route = useRoute()
const examId = route.params.id
const exam = ref({})
const currentQuestion = ref(null)
const answers = ref({})
const drawerOpen = ref(false)

const demoExam = {
  id: 1,
  subject_name: "Toán",
  type: "Quiz",
  questions: [
    {
      id: 1,
      content: "Giải phương trình: 2x + 3 = 7",
      type: "MultipleChoice",
      options: [
        { id: 1, content: "x = 1" },
        { id: 2, content: "x = 2" },
        { id: 3, content: "x = 3" },
        { id: 4, content: "x = 4" }
      ]
    },
    {
      id: 2,
      content: "Tìm nghiệm của phương trình: x^2 - 4 = 0",
      type: "MultipleChoice",
      options: [
        { id: 1, content: "x = ±2" },
        { id: 2, content: "x = ±4" },
        { id: 3, content: "x = 0" },
        { id: 4, content: "Không có nghiệm" }
      ]
    },
    {
      id: 3,
      content: "Giải thích tại sao 1 + 1 = 2?",
      type: "Essay"
    }
  ]
}

onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'student') {
    navigateTo('/student/login')
  } else {
    fetchExam()
  }
})

const fetchExam = async () => {
  try {
    // Sử dụng dữ liệu mẫu
    exam.value = demoExam
    if (exam.value.questions.length > 0) {
      currentQuestion.value = exam.value.questions[0] // Chọn câu hỏi đầu tiên
    }
    // Uncomment để gọi API thực tế
    // const response = await $fetch(`/api/student/exams/${examId}`)
    // exam.value = response
    // if (exam.value.questions.length > 0) {
    //   currentQuestion.value = exam.value.questions[0]
    // }
  } catch (error) {
    console.error('Error fetching exam:', error)
    toast.error('Lỗi khi tải bài kiểm tra/thi.')
  }
}

const selectQuestion = (question) => {
  currentQuestion.value = question
  drawerOpen.value = false
}

const submitExam = async () => {
  try {
    // Giả lập nộp bài (thay thế bằng logic thực tế)
    console.log('Answers submitted:', answers.value)
    toast.success('Bài kiểm tra/thi đã được nộp!')
    navigateTo('/student/exams')
    // Uncomment để gọi API thực tế
    // await $fetch(`/api/student/exams/${examId}/submit`, {
    //   method: 'POST',
    //   body: answers.value
    // })
    // toast.success('Bài kiểm tra/thi đã được nộp!')
    // navigateTo('/student/exams')
  } catch (error) {
    console.error('Error submitting exam:', error)
    toast.error('Lỗi khi nộp bài.')
  }
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
