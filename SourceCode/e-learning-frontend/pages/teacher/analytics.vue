<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Phân tích học tập</h1>
    <div class="grid gap-4 md:grid-cols-2">
      <Card>
        <CardHeader>
          <CardTitle>Tỷ lệ hoàn thành lớp học</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-center text-2xl font-semibold">{{ completionRate }}%</div>
          <p class="text-sm text-muted-foreground text-center mt-2">Tỷ lệ hoàn thành trung bình của các lớp</p>
        </CardContent>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>Hiệu suất học viên</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Học viên</TableHead>
                <TableHead>Điểm trung bình</TableHead>
                <TableHead>Tiến độ</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="student in studentPerformance" :key="student.id">
                <TableCell>{{ student.student_name }}</TableCell>
                <TableCell>{{ student.average_score }}</TableCell>
                <TableCell>{{ student.progress }}%</TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
      <Card class="md:col-span-2">
        <CardHeader>
          <CardTitle>Tiến độ giảng dạy</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Lớp học</TableHead>
                <TableHead>Tiến độ</TableHead>
                <TableHead>Số bài giảng hoàn thành</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="progress in teachingProgress" :key="progress.id">
                <TableCell>{{ progress.class_name }}</TableCell>
                <TableCell>{{ progress.progress }}%</TableCell>
                <TableCell>{{ progress.completed_lessons }}</TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

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


const completionRate = ref(0)
const studentPerformance = ref([])
const teachingProgress = ref([])

const fetchAnalytics = async () => {
  try {
    const response = await $fetch('/api/analytics')
    completionRate.value = response.completion_rate
    studentPerformance.value = response.student_performance
    teachingProgress.value = response.teaching_progress
  } catch (error) {
    console.error('Error fetching analytics:', error)
  }
}

fetchAnalytics()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
