<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Tổng quan</h1>
    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <Card class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">Số môn học</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-3xl font-semibold">{{ stats.course_count }}</div>
          <p class="text-sm text-muted-foreground">Môn học đang theo học</p>
        </CardContent>
      </Card>
      <Card class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">Bài tập chưa nộp</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-3xl font-semibold">{{ stats.pending_assignments }}</div>
          <p class="text-sm text-muted-foreground">Bài tập cần hoàn thành</p>
        </CardContent>
      </Card>
      <Card class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">Thông báo mới</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-3xl font-semibold">{{ stats.new_notifications }}</div>
          <p class="text-sm text-muted-foreground">Thông báo chưa đọc</p>
        </CardContent>
      </Card>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Lịch học sắp tới</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Môn học</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Phòng học</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="schedule in upcomingSchedules" :key="schedule.id">
              <TableCell>{{ schedule.subject_name }}</TableCell>
              <TableCell>{{ new Date(schedule.start_time).toLocaleString() }}</TableCell>
              <TableCell>{{ schedule.classroom_name }}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { navigateTo } from '#app'

definePageMeta({
  layout: 'student',
})

onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'student') {
    navigateTo('/student/login')
  } else {
    fetchStats()
    fetchUpcomingSchedules()
  }
})

const stats = ref({
  course_count: 0,
  pending_assignments: 0,
  new_notifications: 0
})

const upcomingSchedules = ref([])

// Dữ liệu mẫu
const demoStats = {
  course_count: 3,
  pending_assignments: 2,
  new_notifications: 5
}

const demoUpcomingSchedules = [
  {
    id: 1,
    subject_name: "Toán",
    start_time: "2025-04-21T08:00:00Z",
    classroom_name: "Phòng 101"
  },
  {
    id: 2,
    subject_name: "Văn",
    start_time: "2025-04-21T10:00:00Z",
    classroom_name: "Phòng 102"
  }
]

const fetchStats = async () => {
  try {
    stats.value = demoStats
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/student/stats')
    // stats.value = response
  } catch (error) {
    console.error('Error fetching stats:', error)
  }
}

const fetchUpcomingSchedules = async () => {
  try {
    upcomingSchedules.value = demoUpcomingSchedules
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/student/schedules/upcoming')
    // upcomingSchedules.value = response
  } catch (error) {
    console.error('Error fetching schedules:', error)
  }
}
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}
</style>
