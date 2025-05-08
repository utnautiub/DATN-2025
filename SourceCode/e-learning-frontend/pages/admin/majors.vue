<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý ngành</h1>

    <!-- Form to create a new major -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createMajor" class="space-y-4">
        <div>
          <Label for="name">Tên ngành</Label>
          <Input id="name" v-model="newMajor.name" required />
        </div>
        <div>
          <Label for="code">Mã ngành</Label>
          <Input id="code" v-model="newMajor.code" required />
        </div>
        <div>
          <Label for="department_id">Khoa</Label>
          <select id="department_id" v-model="newMajor.department_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn khoa</option>
            <option v-for="department in departments" :key="department.id" :value="department.id">
              {{ department.name }}
            </option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Thêm ngành</Button>
      </form>
    </Card>

    <!-- Majors List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên ngành</TableHead>
            <TableHead>Mã ngành</TableHead>
            <TableHead>Khoa</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="major in majors" :key="major.id">
            <TableCell>{{ major.name }}</TableCell>
            <TableCell>{{ major.code }}</TableCell>
            <TableCell>{{ major.department?.name || 'N/A' }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="openEditMajorModal(major)">Sửa</Button>
              <Button variant="destructive" @click="deleteMajor(major.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Major Modal -->
    <Dialog v-model:open="showEditModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Sửa ngành</DialogTitle>
        </DialogHeader>
        <form @submit.prevent="updateMajor" class="space-y-4">
          <div>
            <Label for="edit-name">Tên ngành</Label>
            <Input id="edit-name" v-model="editMajor.name" required />
          </div>
          <div>
            <Label for="edit-code">Mã ngành</Label>
            <Input id="edit-code" v-model="editMajor.code" required />
          </div>
          <div>
            <Label for="edit-department_id">Khoa</Label>
            <select id="edit-department_id" v-model="editMajor.department_id" required
              class="w-full px-4 py-2 border rounded-lg">
              <option value="0">Chọn khoa</option>
              <option v-for="department in departments" :key="department.id" :value="department.id">
                {{ department.name }}
              </option>
            </select>
          </div>
          <Button type="submit" :disabled="loading">Cập nhật</Button>
        </form>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import type { AxiosResponse } from 'axios';

interface Major {
  id: number;
  name: string;
  code: string;
  department_id: number;
  department?: { name: string };
}

interface Department {
  id: number;
  name: string;
}

const { $axios } = useNuxtApp();

const majors = ref<Major[]>([]);
const departments = ref<Department[]>([]);
const newMajor = ref<Major>({ id: 0, name: '', code: '', department_id: 0 });
const editMajor = ref<Major>({ id: 0, name: '', code: '', department_id: 0 });
const loading = ref<boolean>(false);
const showEditModal = ref<boolean>(false);

const fetchMajors = async () => {
  try {
    const response: AxiosResponse<Major[]> = await $axios.get('/majors');
    majors.value = response.data;
  } catch (error) {
    console.error('Error fetching majors:', error);
  }
};

const fetchDepartments = async () => {
  try {
    const response: AxiosResponse<Department[]> = await $axios.get('/departments');
    departments.value = response.data;
  } catch (error) {
    console.error('Error fetching departments:', error);
  }
};

const createMajor = async () => {
  try {
    loading.value = true;
    await $axios.post('/majors', newMajor.value);
    newMajor.value = { id: 0, name: '', code: '', department_id: 0 };
    await fetchMajors();
  } catch (error) {
    console.error('Error creating major:', error);
  } finally {
    loading.value = false;
  }
};

const openEditMajorModal = (major: Major) => {
  editMajor.value = { ...major };
  showEditModal.value = true;
};

const updateMajor = async () => {
  try {
    loading.value = true;
    await $axios.put(`/majors/${editMajor.value.id}`, editMajor.value);
    showEditModal.value = false;
    await fetchMajors();
  } catch (error) {
    console.error('Error updating major:', error);
  } finally {
    loading.value = false;
  }
};

const deleteMajor = async (id: number) => {
  try {
    await $axios.delete(`/majors/${id}`);
    await fetchMajors();
  } catch (error) {
    console.error('Error deleting major:', error);
  }
};

onMounted(() => {
  fetchMajors();
  fetchDepartments();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>