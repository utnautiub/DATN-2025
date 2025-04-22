<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Phê duyệt kết quả thi</h1>
    <Card>
      <CardHeader>
        <CardTitle>Kết quả thi</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Học viên</TableHead>
              <TableHead>Kỳ thi</TableHead>
              <TableHead>Điểm</TableHead>
              <TableHead>Trạng thái</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="result in examResults" :key="result.id">
              <TableCell>{{ result.student_name }}</TableCell>
              <TableCell>{{ result.exam_name }}</TableCell>
              <TableCell>{{ result.score }}</TableCell>
              <TableCell>
                <Badge :variant="result.status === 'Approved' ? 'success' : 'warning'">
                  {{ result.status }}
                </Badge>
              </TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="approveResult(result.id)"
                  :disabled="result.status === 'Approved'">
                  <Icon icon="heroicons:check-badge" class="h-4 w-4" />
                  Phê duyệt
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

const examResults = ref([])

const fetchExamResults = async () => {
  try {
    const response = await $fetch('/api/exam-results')
    examResults.value = response
  } catch (error) {
    console.error('Error fetching exam results:', error)
  }
}

const approveResult = async (id: number) => {
  try {
    await $fetch(`/api/exam-results/${id}/approve`, {
      method: 'PUT'
    })
    fetchExamResults()
    useToast().success('Kết quả thi đã được phê duyệt!')
  } catch (error) {
    console.error('Error approving result:', error)
    useToast().error('Lỗi khi phê duyệt kết quả.')
  }
}

fetchExamResults()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
