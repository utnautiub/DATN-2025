<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý ghi danh</h1>

    <!-- Form to create a new enrollment -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createEnrollment" class="space-y-4">
        <div>
          <Label for="student_id">Học sinh</Label>
          <select id="student_id" v-model="newEnrollment.student_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn học sinh</option>
            <option v-for="student in students" :key="student.id" :value="student.id">
              {{ student.name }}
            </option>
          </select>
        </div>
        <div>
          <Label for="course_id">Khóa học</Label>
          <select id="course_id" v-model="newEnrollment.course_id" required class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn khóa học</option>
            <option v-for="course in courses" :key="course.id" :value="course.id">
              {{ course.name }}
            </option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Ghi danh</Button>
      </form>
    </Card>

    <!-- Enrollments List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Học sinh</TableHead>
            <TableHead>Khóa học</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="enrollment in enrollments" :key="enrollment.id">
            <TableCell>{{ enrollment.student?.name || 'N/A' }}</TableCell>
            <TableCell>{{ enrollment.course?.name || 'N/A' }}</TableCell>
            <TableCell>
              <Button variant="destructive" @click="deleteEnrollment(enrollment.id)">Xóa</Button>
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

interface Enrollment {
  id: number;
  student_id: number;
  course_id: number;
  student?: { name: string };
  course?: { name: string };
}

interface Student {
  id: number;
  name: string;
}

interface Course {
  id: number;
  name: string;
}

const { $axios } = useNuxtApp();

const enrollments = ref<Enrollment[]>([]);
const students = ref<Student[]>([]);
const courses = ref<Course[]>([]);
const newEnrollment = ref<Enrollment>({ id: 0, student_id: 0, course_id: 0 });
const loading = ref<boolean>(false);

const fetchEnrollments = async () => {
  try {
    const response: AxiosResponse<Enrollment[]> = await $axios.get('/enrollments');
    enrollments.value = response.data;
  } catch (error) {
    console.error('Error fetching enrollments:', error);
  }
};

const fetchStudents = async () => {
  try {
    const response: AxiosResponse<Student[]> = await $axios.get('/users?role=Student');
    students.value = response.data.map(user => ({
      id: user.id,
      name: user.username
    }));
  } catch (error) {
    console.error('Error fetching students:', error);
  }
};

const fetchCourses = async () => {
  try {
    const response: AxiosResponse<Course[]> = await $axios.get('/courses');
    courses.value = response.data;
  } catch (error) {
    console.error('Error fetching courses:', error);
  }
};

const createEnrollment = async () => {
  try {
    loading.value = true;
    await $axios.post('/enrollments', newEnrollment.value);
    newEnrollment.value = { id: 0, student_id: 0, course_id: 0 };
    await fetchEnrollments();
  } catch (error) {
    console.error('Error creating enrollment:', error);
  } finally {
    loading.value = false;
  }
};

const deleteEnrollment = async (id: number) => {
  try {
    await $axios.delete(`/enrollments/${id}`);
    await fetchEnrollments();
  } catch (error) {
    console.error('Error deleting enrollment:', error);
  }
};

onMounted(() => {
  fetchEnrollments();
  fetchStudents();
  fetchCourses();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>