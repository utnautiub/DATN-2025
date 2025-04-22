<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Kiểm tra & Thi</h1>

    <Tabs default-value="upcoming" class="space-y-4">
      <TabsList>
        <TabsTrigger value="upcoming">Sắp tới</TabsTrigger>
        <TabsTrigger value="results">Kết quả</TabsTrigger>
      </TabsList>

      <!-- Upcoming Exams Tab -->
      <TabsContent value="upcoming">
        <Card>
          <CardHeader>
            <CardTitle>Lịch kiểm tra & thi sắp tới</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Môn học</TableHead>
                  <TableHead>Loại</TableHead>
                  <TableHead>Thời gian</TableHead>
                  <TableHead>Hành động</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="exam in upcomingExams" :key="exam.id">
                  <TableCell>{{ exam.subject_name }}</TableCell>
                  <TableCell>{{ exam.type === 'Quiz' ? 'Kiểm tra' : 'Thi' }}</TableCell>
                  <TableCell>{{ new Date(exam.start_time).toLocaleString() }}</TableCell>
                  <TableCell>
                    <Button variant="outline" size="sm" @click="startExam(exam)">
                      <Icon icon="heroicons:play" class="h-4 w-4" />
                      Bắt đầu
                    </Button>
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </TabsContent>

      <!-- Exam Results Tab -->
      <TabsContent value="results">
        <Card>
          <CardHeader>
            <CardTitle>Kết quả kiểm tra & thi</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Môn học</TableHead>
                  <TableHead>Loại</TableHead>
                  <TableHead>Điểm</TableHead>
                  <TableHead>Ngày thi</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="result in examResults" :key="result.id">
                  <TableCell>{{ result.subject_name }}</TableCell>
                  <TableCell>{{ result.type === 'Quiz' ? 'Kiểm tra' : 'Thi' }}</TableCell>
                  <TableCell>{{ result.score }}</TableCell>
                  <TableCell>{{ new Date(result.date).toLocaleDateString() }}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </TabsContent>
    </Tabs>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { navigateTo } from '#app'
import { toast } from 'vue-sonner'
import { Icon } from '@iconify/vue'

definePageMeta({
  layout: 'student',
})

const upcomingExams = ref([])
const examResults = ref([])

const demoUpcomingExams = [
  {
    id: 1,
    subject_name: "Toán",
    type: "Quiz",
    start_time: "2025-04-21T08:00:00Z"
  },
  {
    id: 2,
    subject_name: "Văn",
    type: "Exam",
    start_time: "2025-04-22T10:00:00Z"
  }
]

const demoExamResults = [
  {
    id: 1,
    subject_name: "Toán",
    type: "Quiz",
    score: 8.5,
    date: "2025-04-15T08:00:00Z"
  },
  {
    id: 2,
    subject_name: "Hóa",
    type: "Exam",
    score: 7.0,
    date: "2025-04-10T10:00:00Z"
  }
]

onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'student') {
    navigateTo('/student/login')
  } else {
    fetchUpcomingExams()
    fetchExamResults()
  }
})

const fetchUpcomingExams = async () => {
  try {
    upcomingExams.value = demoUpcomingExams
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/student/exams/upcoming')
    // upcomingExams.value = response
  } catch (error) {
    console.error('Error fetching upcoming exams:', error)
    toast.error('Lỗi khi tải lịch kiểm tra & thi.')
  }
}

const fetchExamResults = async () => {
  try {
    examResults.value = demoExamResults
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/student/exams/results')
    // examResults.value = response
  } catch (error) {
    console.error('Error fetching exam results:', error)
    toast.error('Lỗi khi tải kết quả kiểm tra & thi.')
  }
}

const startExam = (exam) => {
  // Chuyển hướng đến trang thi
  navigateTo(`/student/exams/${exam.id}/start`)
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
