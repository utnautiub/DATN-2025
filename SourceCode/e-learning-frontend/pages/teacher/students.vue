<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý học viên</h1>
      <Input placeholder="Tìm kiếm học viên..." v-model="searchQuery" class="max-w-sm" />
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách học viên</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Họ tên</TableHead>
              <TableHead>Email</TableHead>
              <TableHead>Lớp học</TableHead>
              <TableHead>Tiến độ</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="student in filteredStudents" :key="student.id">
              <TableCell>{{ student.full_name }}</TableCell>
              <TableCell>{{ student.email }}</TableCell>
              <TableCell>{{ student.class_name }}</TableCell>
              <TableCell>{{ student.progress }}%</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" as="NuxtLink" :to="`/teacher/students/${student.id}`">
                  <Icon icon="heroicons:eye" class="h-4 w-4" />
                  Xem chi tiết
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
import { ref, computed } from 'vue'

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

const students = ref([])
const searchQuery = ref('')

const filteredStudents = computed(() => {
  return students.value.filter(student =>
    student.full_name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    student.email.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

const fetchStudents = async () => {
  try {
    const response = await $fetch('/api/students')
    students.value = response
  } catch (error) {
    console.error('Error fetching students:', error)
    useToast().error('Lỗi khi tải danh sách học viên.')
  }
}

fetchStudents()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
