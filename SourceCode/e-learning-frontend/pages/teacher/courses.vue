<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Khóa học của tôi</h1>
      <Input placeholder="Tìm kiếm lớp học..." v-model="searchQuery" class="max-w-sm" />
    </div>
    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <Card v-for="course in filteredCourses" :key="course.id"
        class="border border-border shadow-sm hover:shadow-md transition-shadow">
        <CardHeader>
          <CardTitle class="text-lg">{{ course.name }}</CardTitle>
          <CardDescription>{{ course.subject_name }}</CardDescription>
        </CardHeader>
        <CardContent>
          <div class="space-y-2">
            <div class="flex items-center">
              <Icon icon="heroicons:users" class="h-5 w-5 mr-2 text-muted-foreground" />
              <span>{{ course.student_count }} học viên</span>
            </div>
            <div class="flex items-center">
              <Icon icon="heroicons:calendar" class="h-5 w-5 mr-2 text-muted-foreground" />
              <span>{{ course.semester }}</span>
            </div>
          </div>
        </CardContent>
        <CardFooter>
          <Button variant="outline" as="NuxtLink" :to="`/teacher/courses/${course.id}`" class="w-full">
            <Icon icon="heroicons:eye" class="mr-2 h-4 w-4" />
            Xem chi tiết
          </Button>
        </CardFooter>
      </Card>
    </div>
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

const courses = ref([])
const searchQuery = ref('')

const filteredCourses = computed(() => {
  return courses.value.filter(course =>
    course.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    course.subject_name.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

const fetchCourses = async () => {
  try {
    const response = await $fetch('/api/classes?role=teacher')
    courses.value = response
  } catch (error) {
    console.error('Error fetching courses:', error)
    useToast().error('Lỗi khi tải danh sách lớp học.')
  }
}

fetchCourses()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}
</style>
