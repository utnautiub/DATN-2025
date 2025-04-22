<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Giám sát kỳ thi</h1>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách ca thi được phân công</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Kỳ thi</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Phòng thi</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="session in examSessions" :key="session.id">
              <TableCell>{{ session.exam_name }}</TableCell>
              <TableCell>{{ new Date(session.start_time).toLocaleString() }} - {{ new
                Date(session.end_time).toLocaleString() }}</TableCell>
              <TableCell>{{ session.classroom_name }}</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="startSupervision(session)">
                  <Icon icon="heroicons:eye" class="h-4 w-4" />
                  Bắt đầu giám sát
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
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

const examSessions = ref([])

const fetchExamSessions = async () => {
  try {
    const response = await $fetch('/api/exam-sessions?role=supervisor')
    examSessions.value = response
  } catch (error) {
    console.error('Error fetching exam sessions:', error)
  }
}

const startSupervision = (session: any) => {
  // Giả định mở link giám sát (Zoom hoặc công cụ khác)
  window.open(session.supervision_link, '_blank')
  useToast().success(`Bắt đầu giám sát ca thi ${session.exam_name}`)
}

fetchExamSessions()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
