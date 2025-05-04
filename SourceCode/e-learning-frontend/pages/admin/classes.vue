<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý lớp quản lý</h1>

    <!-- Form to create a new class -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createClass" class="space-y-4">
        <div>
          <Label for="name">Tên lớp</Label>
          <Input id="name" v-model="newClass.name" required />
        </div>
        <div>
          <Label for="homeroom_teacher_id">Giáo viên chủ nhiệm</Label>
          <select id="homeroom_teacher_id" v-model="newClass.homeroom_teacher_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">{{ teacher.name }}</option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Thêm lớp</Button>
      </form>
    </Card>

    <!-- Classes List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên lớp</TableHead>
            <TableHead>Giáo viên chủ nhiệm</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="schoolClass in classes" :key="schoolClass.id">
            <TableCell>{{ schoolClass.name }}</TableCell>
            <TableCell>{{ schoolClass.homeroom_teacher?.name }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editClass(schoolClass)">Sửa</Button>
              <Button variant="destructive" @click="deleteClass(schoolClass.id)">Xóa</Button>
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

interface Teacher {
  id: number;
  name: string;
}

interface SchoolClass {
  id: number;
  name: string;
  homeroom_teacher_id: number;
  homeroom_teacher?: Teacher;
}

const { $axios } = useNuxtApp();

const classes = ref<SchoolClass[]>([]);
const teachers = ref<Teacher[]>([]);
const newClass = ref<{ name: string; homeroom_teacher_id: string }>({ name: '', homeroom_teacher_id: '' });
const loading = ref<boolean>(false);

const fetchClasses = async () => {
  try {
    const response: AxiosResponse<SchoolClass[]> = await $axios.get('/classes');
    classes.value = response.data;
  } catch (error) {
    console.error('Error fetching classes:', error);
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

const createClass = async () => {
  try {
    loading.value = true;
    await $axios.post('/classes', newClass.value);
    newClass.value = { name: '', homeroom_teacher_id: '' };
    await fetchClasses();
  } catch (error) {
    console.error('Error creating class:', error);
  } finally {
    loading.value = false;
  }
};

const editClass = (schoolClass: SchoolClass) => {
  // Placeholder for edit functionality
  console.log('Editing class:', schoolClass);
};

const deleteClass = async (id: number) => {
  try {
    await $axios.delete(`/classes/${id}`);
    await fetchClasses();
  } catch (error) {
    console.error('Error deleting class:', error);
  }
};

onMounted(() => {
  fetchClasses();
  fetchTeachers();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>