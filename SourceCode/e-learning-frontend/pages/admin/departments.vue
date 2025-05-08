<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý khoa</h1>

    <!-- Form to create a new department -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createDepartment" class="space-y-4">
        <div>
          <Label for="name">Tên khoa</Label>
          <Input id="name" v-model="newDepartment.name" required />
        </div>
        <div>
          <Label for="code">Mã khoa</Label>
          <Input id="code" v-model="newDepartment.code" required />
        </div>
        <Button type="submit" :disabled="loading">Thêm khoa</Button>
      </form>
    </Card>

    <!-- Departments List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên khoa</TableHead>
            <TableHead>Mã khoa</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="department in departments" :key="department.id">
            <TableCell>{{ department.name }}</TableCell>
            <TableCell>{{ department.code }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="openEditDepartmentModal(department)">Sửa</Button>
              <Button variant="destructive" @click="deleteDepartment(department.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Department Modal -->
    <Dialog v-model:open="showEditModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Sửa khoa</DialogTitle>
        </DialogHeader>
        <form @submit.prevent="updateDepartment" class="space-y-4">
          <div>
            <Label for="edit-name">Tên khoa</Label>
            <Input id="edit-name" v-model="editDepartment.name" required />
          </div>
          <div>
            <Label for="edit-code">Mã khoa</Label>
            <Input id="edit-code" v-model="editDepartment.code" required />
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

interface Department {
  id: number;
  name: string;
  code: string;
}

const { $axios } = useNuxtApp();

const departments = ref<Department[]>([]);
const newDepartment = ref<Department>({ id: 0, name: '', code: '' });
const editDepartment = ref<Department>({ id: 0, name: '', code: '' });
const loading = ref<boolean>(false);
const showEditModal = ref<boolean>(false);

const fetchDepartments = async () => {
  try {
    const response: AxiosResponse<Department[]> = await $axios.get('/departments');
    departments.value = response.data;
  } catch (error) {
    console.error('Error fetching departments:', error);
  }
};

const createDepartment = async () => {
  try {
    loading.value = true;
    await $axios.post('/departments', newDepartment.value);
    newDepartment.value = { id: 0, name: '', code: '' };
    await fetchDepartments();
  } catch (error) {
    console.error('Error creating department:', error);
  } finally {
    loading.value = false;
  }
};

const openEditDepartmentModal = (department: Department) => {
  editDepartment.value = { ...department };
  showEditModal.value = true;
};

const updateDepartment = async () => {
  try {
    loading.value = true;
    await $axios.put(`/departments/${editDepartment.value.id}`, editDepartment.value);
    showEditModal.value = false;
    await fetchDepartments();
  } catch (error) {
    console.error('Error updating department:', error);
  } finally {
    loading.value = false;
  }
};

const deleteDepartment = async (id: number) => {
  try {
    await $axios.delete(`/departments/${id}`);
    await fetchDepartments();
  } catch (error) {
    console.error('Error deleting department:', error);
  }
};

onMounted(() => {
  fetchDepartments();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>