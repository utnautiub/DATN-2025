<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý trường học</h1>

    <!-- Form to create a new school -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createSchool" class="space-y-4">
        <div>
          <Label for="name">Tên trường</Label>
          <Input id="name" v-model="newSchool.name" required />
        </div>
        <div>
          <Label for="address">Địa chỉ</Label>
          <Input id="address" v-model="newSchool.address" required />
        </div>
        <div>
          <Label for="phone">Số điện thoại</Label>
          <Input id="phone" v-model="newSchool.phone" />
        </div>
        <div>
          <Label for="email">Email</Label>
          <Input id="email" v-model="newSchool.email" type="email" />
        </div>
        <Button type="submit" :disabled="loading">Thêm trường</Button>
      </form>
    </Card>

    <!-- Schools List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên trường</TableHead>
            <TableHead>Địa chỉ</TableHead>
            <TableHead>Số điện thoại</TableHead>
            <TableHead>Email</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="school in schools" :key="school.id">
            <TableCell>{{ school.name }}</TableCell>
            <TableCell>{{ school.address }}</TableCell>
            <TableCell>{{ school.phone }}</TableCell>
            <TableCell>{{ school.email }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editSchool(school)">Sửa</Button>
              <Button variant="destructive" @click="deleteSchool(school.id)">Xóa</Button>
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

interface School {
  id: number;
  name: string;
  address: string;
  phone: string | null;
  email: string | null;
}

const { $axios } = useNuxtApp();

const schools = ref<School[]>([]);
const newSchool = ref<School>({ id: 0, name: '', address: '', phone: '', email: '' });
const loading = ref<boolean>(false);

const fetchSchools = async () => {
  try {
    const response: AxiosResponse<School[]> = await $axios.get('/schools');
    schools.value = response.data;
  } catch (error) {
    console.error('Error fetching schools:', error);
  }
};

const createSchool = async () => {
  try {
    loading.value = true;
    await $axios.post('/schools', newSchool.value);
    newSchool.value = { id: 0, name: '', address: '', phone: '', email: '' };
    await fetchSchools();
  } catch (error) {
    console.error('Error creating school:', error);
  } finally {
    loading.value = false;
  }
};

const editSchool = (school: School) => {
  // Placeholder for edit functionality
  console.log('Editing school:', school);
};

const deleteSchool = async (id: number) => {
  try {
    await $axios.delete(`/schools/${id}`);
    await fetchSchools();
  } catch (error) {
    console.error('Error deleting school:', error);
  }
};

onMounted(fetchSchools);

definePageMeta({
  layout: 'super-admin',
});
</script>

<style scoped></style>