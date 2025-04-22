<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Giám sát tiến độ học tập</h1>
    <div class="grid gap-4 md:grid-cols-2">
      <Card>
        <CardHeader>
          <CardTitle>Tiến độ lớp học</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Lớp học</TableHead>
                <TableHead>Tiến độ</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="progress in classProgress" :key="progress.id">
                <TableCell>{{ progress.class_name }}</TableCell>
                <TableCell>{{ progress.progress }}%</TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>Tiến độ học sinh</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Học sinh</TableHead>
                <TableHead>Tiến độ</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="progress in studentProgress" :key="progress.id">
                <TableCell>{{ progress.student_name }}</TableCell>
                <TableCell>{{ progress.progress }}%</TableCell>
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
import { useLanguage } from '~/composables/useLanguage';

// Set the layout for this page
definePageMeta({
  layout: 'admin',
});

// Get translations
const { t } = useLanguage();

// Check if user is logged in and is admin
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'admin') {
    // Redirect to login if not logged in as admin
    navigateTo('/login');
  }
});

const classProgress = ref([])
const studentProgress = ref([])

const fetchClassProgress = async () => {
  try {
    const response = await $fetch('/api/learning-progress/classes')
    classProgress.value = response
  } catch (error) {
    console.error('Error fetching class progress:', error)
  }
}

const fetchStudentProgress = async () => {
  try {
    const response = await $fetch('/api/learning-progress/students')
    studentProgress.value = response
  } catch (error) {
    console.error('Error fetching student progress:', error)
  }
}

fetchClassProgress()
fetchStudentProgress()
</script>
