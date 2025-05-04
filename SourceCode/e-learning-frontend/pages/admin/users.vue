<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý người dùng</h1>

    <!-- Form to create a new user -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createUser" class="space-y-4">
        <div>
          <Label for="username">Tên đăng nhập</Label>
          <Input id="username" v-model="newUser.username" required />
        </div>
        <div>
          <Label for="password">Mật khẩu</Label>
          <Input id="password" v-model="newUser.password" type="password" required />
        </div>
        <div>
          <Label for="role">Vai trò</Label>
          <select id="role" v-model="newUser.role" required class="w-full px-4 py-2 border rounded-lg">
            <option value="Teacher">Teacher</option>
            <option value="Student">Student</option>
          </select>
        </div>
        <div v-if="error" class="text-red-500 text-sm">
          {{ error }}
        </div>
        <Button type="submit" :disabled="loading">Tạo tài khoản</Button>
      </form>
    </Card>

    <!-- Users List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên đăng nhập</TableHead>
            <TableHead>Vai trò</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="user in users" :key="user.id">
            <TableCell>{{ user.username }}</TableCell>
            <TableCell>{{ user.role }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editUser(user)">Sửa</Button>
              <Button v-if="canDeleteUser(user)" variant="destructive" @click="deleteUser(user.id)">Xóa</Button>
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

interface User {
  id: number;
  username: string;
  role: string;
  school_id: number;
}

const { $axios } = useNuxtApp();

const users = ref<User[]>([]);
const newUser = ref<{ username: string; password: string; role: string }>({ username: '', password: '', role: '' });
const loading = ref<boolean>(false);
const error = ref<string>('');

const currentUserRole = ref<string | null>(localStorage.getItem('user_role'));

const fetchUsers = async () => {
  try {
    const response: AxiosResponse<User[]> = await $axios.get('/users');
    users.value = response.data;
  } catch (error) {
    console.error('Error fetching users:', error);
  }
};

const createUser = async () => {
  try {
    loading.value = true;
    error.value = '';
    await $axios.post('/users', newUser.value);
    newUser.value = { username: '', password: '', role: '' };
    await fetchUsers();
  } catch (error: any) {
    console.error('Error creating user:', error);
    if (error.response?.data?.errors) {
      error.value = error.response.data.errors.join(', ');
    } else {
      error.value = 'Không thể tạo tài khoản. Vui lòng thử lại.';
    }
  } finally {
    loading.value = false;
  }
};

const editUser = (user: User) => {
  // Placeholder for edit functionality
  console.log('Editing user:', user);
};

const canDeleteUser = (user: User) => {
  if (currentUserRole.value === 'SuperAdmin') {
    return true;
  }
  if (currentUserRole.value === 'AdminSchools' && user.role === 'AdminSchools') {
    return false;
  }
  return true;
};

const deleteUser = async (id: number) => {
  try {
    await $axios.delete(`/users/${id}`);
    await fetchUsers();
  } catch (error: any) {
    console.error('Error deleting user:', error);
    if (error.response?.data?.error) {
      error.value = error.response.data.error;
    } else {
      error.value = 'Không thể xóa tài khoản. Vui lòng thử lại.';
    }
  }
};

onMounted(fetchUsers);

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>