<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Lịch giảng dạy</h1>
    <Card>
      <CardHeader>
        <CardTitle>Lịch giảng dạy</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Lớp học</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Phòng học</TableHead>
              <TableHead>Trạng thái</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="schedule in schedules" :key="schedule.id">
              <TableCell>{{ schedule.class_name }}</TableCell>
              <TableCell>{{ new Date(schedule.start_time).toLocaleString() }} - {{ new
                Date(schedule.end_time).toLocaleString() }}</TableCell>
              <TableCell>{{ schedule.classroom_name }}</TableCell>
              <TableCell>
                <Badge :variant="schedule.status === 'Upcoming' ? 'warning' : 'success'">
                  {{ schedule.status }}
                </Badge>
              </TableCell>
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

const schedules = ref([])

const fetchSchedules = async () => {
  try {
    const response = await $fetch('/api/teacher/schedules')
    schedules.value = response
  } catch (error) {
    console.error('Error fetching schedules:', error)
    useToast().error('Lỗi khi tải lịch giảng dạy.')
  }
}

fetchSchedules()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
