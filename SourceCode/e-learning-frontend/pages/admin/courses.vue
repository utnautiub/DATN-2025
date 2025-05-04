<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý lớp học phần</h1>

    <!-- Form to create a new course -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createCourse" class="space-y-4">
        <div>
          <Label for="name">Tên lớp</Label>
          <Input id="name" v-model="newCourse.name" required />
        </div>
        <div>
          <Label for="subject_id">Môn học</Label>
          <select id="subject_id" v-model="newCourse.subject_id" required class="w-full px-4 py-2 border rounded-lg">
            <option v-for="subject in subjects" :key="subject.id" :value="subject.id">{{ subject.name }}</option>
          </select>
        </div>
        <div>
          <Label for="teacher_id">Giáo viên phụ trách</Label>
          <select id="teacher_id" v-model="newCourse.teacher_id" required class="w-full px-4 py-2 border rounded-lg">
            <option v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">{{ teacher.name }}</option>
          </select>
        </div>
        <div>
          <Label for="mode">Hình thức học</Label>
          <select id="mode" v-model="newCourse.mode" required class="w-full px-4 py-2 border rounded-lg">
            <option value="Trực tuyến">Trực tuyến</option>
            <option value="Trực tiếp">Trực tiếp</option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Thêm lớp học phần</Button>
      </form>
    </Card>

    <!-- Courses List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên lớp</TableHead>
            <TableHead>Môn học</TableHead>
            <TableHead>Giáo viên phụ trách</TableHead>
            <TableHead>Hình thức học</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="course in courses" :key="course.id">
            <TableCell>{{ course.name }}</TableCell>
            <TableCell>{{ course.subject?.name }}</TableCell>
            <TableCell>{{ course.teacher?.name }}</TableCell>
            <TableCell>{{ course.mode }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editCourse(course)">Sửa</Button>
              <Button variant="destructive" @click="deleteCourse(course.id)">Xóa</Button>
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

interface Subject {
  id: number;
  name: string;
}

interface Teacher {
  id: number;
  name: string;
}

interface Course {
  id: number;
  name: string;
  subject_id: number;
  teacher_id: number;
  mode: string;
  subject?: Subject;
  teacher?: Teacher;
}

const { $axios } = useNuxtApp();

const courses = ref<Course[]>([]);
const subjects = ref<Subject[]>([]);
const teachers = ref<Teacher[]>([]);
const newCourse = ref<{ name: string; subject_id: string; teacher_id: string; mode: string }>({
  name: '',
  subject_id: '',
  teacher_id: '',
  mode: '',
});
const loading = ref<boolean>(false);

const fetchCourses = async () => {
  try {
    const response: AxiosResponse<Course[]> = await $axios.get('/courses');
    courses.value = response.data;
  } catch (error) {
    console.error('Error fetching courses:', error);
  }
};

const fetchSubjects = async () => {
  try {
    const response: AxiosResponse<Subject[]> = await $axios.get('/subjects');
    subjects.value = response.data;
  } catch (error) {
    console.error('Error fetching subjects:', error);
  }
};

const fetchTeachers = async () => {
  try {
    const response: AxiosResponse<User[]> = await $axios.get('/users');
    teachers.value = response.data.filter(user => user.role === 'Teacher');
  } catch (error) {
    console.error('Error fetching teachers:', error);
  }
};

const createCourse = async () => {
  try {
    loading.value = true;
    await $axios.post('/courses', newCourse.value);
    newCourse.value = { name: '', subject_id: '', teacher_id: '', mode: '' };
    await fetchCourses();
  } catch (error) {
    console.error('Error creating course:', error);
  } finally {
    loading.value = false;
  }
};

const editCourse = (course: Course) => {
  // Placeholder for edit functionality
  console.log('Editing course:', course);
};

const deleteCourse = async (id: number) => {
  try {
    await $axios.delete(`/courses/${id}`);
    await fetchCourses();
  } catch (error) {
    console.error('Error deleting course:', error);
  }
};

onMounted(() => {
  fetchCourses();
  fetchSubjects();
  fetchTeachers();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>