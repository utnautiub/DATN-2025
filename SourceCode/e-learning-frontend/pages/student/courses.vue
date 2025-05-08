<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Đăng ký môn học</h1>

    <!-- Available Courses -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên lớp học phần</TableHead>
            <TableHead>Giáo viên</TableHead>
            <TableHead>Hình thức học</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="course in courses" :key="course.id">
            <TableCell>{{ course.name }}</TableCell>
            <TableCell>{{ course.teacher?.user?.username || 'N/A' }}</TableCell>
            <TableCell>{{ course.mode }}</TableCell>
            <TableCell>
              <Button v-if="!isEnrolled(course.id)" @click="enroll(course.id)">Đăng ký</Button>
              <Button v-else disabled>Đã đăng ký</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import type { AxiosResponse } from 'axios';

interface Course {
  id: number;
  name: string;
  teacher?: { user?: { username: string } };
  mode: string;
}

const { $axios } = useNuxtApp();

const courses = ref<Course[]>([]);
const enrollments = ref<number[]>([]);

const fetchCourses = async () => {
  try {
    const response: AxiosResponse<Course[]> = await $axios.get('/courses');
    courses.value = response.data;
  } catch (error) {
    console.error('Error fetching courses:', error);
  }
};

const fetchEnrollments = async () => {
  try {
    const response: AxiosResponse<any[]> = await $axios.get('/enrollments');
    enrollments.value = response.data.map(enrollment => enrollment.course_id);
  } catch (error) {
    console.error('Error fetching enrollments:', error);
  }
};

const enroll = async (courseId: number) => {
  try {
    await $axios.post('/enrollments', { course_id: courseId });
    enrollments.value.push(courseId);
  } catch (error) {
    console.error('Error enrolling in course:', error);
  }
};

const isEnrolled = (courseId: number) => {
  return enrollments.value.includes(courseId);
};

onMounted(() => {
  fetchCourses();
  fetchEnrollments();
});

definePageMeta({
  layout: 'student',
});
</script>

<style scoped></style>