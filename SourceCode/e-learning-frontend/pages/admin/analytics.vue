<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Phân tích dữ liệu</h1>
    <div class="grid gap-4 md:grid-cols-2">
      <Card>
        <CardHeader>
          <CardTitle>Tỷ lệ hoàn thành khóa học</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="text-center text-2xl">{{ completionRate }}%</div>
        </CardContent>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>Hiệu suất học tập</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Khóa học</TableHead>
                <TableHead>Điểm trung bình</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="performance in performanceData" :key="performance.id">
                <TableCell>{{ performance.course_name }}</TableCell>
                <TableCell>{{ performance.average_score }}</TableCell>
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

const completionRate = ref(0)
const performanceData = ref([])

const fetchAnalytics = async () => {
  try {
    const response = await $fetch('/api/analytics')
    completionRate.value = response.completion_rate
    performanceData.value = response.performance
  } catch (error) {
    console.error('Error fetching analytics:', error)
  }
}

fetchAnalytics()
</script>
