<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Tổng quan</h1>
    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <Card class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">Số lớp học</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-3xl font-semibold">{{ stats.class_count }}</div>
          <p class="text-sm text-muted-foreground">Lớp học được phân công</p>
        </CardContent>
      </Card>
      <Card class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">Số học viên</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-3xl font-semibold">{{ stats.student_count }}</div>
          <p class="text-sm text-muted-foreground">Học viên đang theo học</p>
        </CardContent>
      </Card>
      <Card class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">Bài tập chờ chấm</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-3xl font-semibold">{{ stats.pending_assignments }}</div>
          <p class="text-sm text-muted-foreground">Bài tập cần chấm điểm</p>
        </CardContent>
      </Card>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Lịch giảng dạy sắp tới</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Lớp học</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Phòng học</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="schedule in upcomingSchedules" :key="schedule.id">
              <TableCell>{{ schedule.class_name }}</TableCell>
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

const stats = ref({
  class_count: 0,
  student_count: 0,
  pending_assignments: 0
})
const upcomingSchedules = ref([])

const fetchStats = async () => {
  try {
    const response = await $fetch('/api/teacher/stats')
    stats.value = response
  } catch (error) {
    console.error('Error fetching stats:', error)
    useToast().error('Lỗi khi tải thống kê.')
  }
}

const fetchUpcomingSchedules = async () => {
  try {
    const response = await $fetch('/api/teacher/schedules/upcoming')
    upcomingSchedules.value = response
  } catch (error) {
    console.error('Error fetching schedules:', error)
    useToast().error('Lỗi khi tải lịch giảng dạy.')
  }
}

fetchStats()
fetchUpcomingSchedules()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}
</style>
