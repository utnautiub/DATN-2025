<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý tài khoản Admin Schools</h1>

    <!-- Form to create a new admin account -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createAdminAccount" class="space-y-4">
        <div>
          <Label for="school_id">Trường</Label>
          <select id="school_id" v-model="newAdmin.school_id" required class="w-full px-4 py-2 border rounded-lg">
            <option v-for="school in schools" :key="school.id" :value="school.id">{{ school.name }}</option>
          </select>
        </div>
        <div>
          <Label for="username">Tên đăng nhập</Label>
          <Input id="username" v-model="newAdmin.username" required />
        </div>
        <div>
          <Label for="password">Mật khẩu</Label>
          <Input id="password" v-model="newAdmin.password" type="password" required />
        </div>
        <div v-if="error" class="text-red-500 text-sm">
          {{ error }}
        </div>
        <Button type="submit" :disabled="loading">Tạo tài khoản Admin</Button>
      </form>
    </Card>

    <!-- Admin Accounts List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên đăng nhập</TableHead>
            <TableHead>Trường</TableHead>
            <TableHead>Vai trò</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="admin in admins" :key="admin.id">
            <TableCell>{{ admin.username }}</TableCell>
            <TableCell>{{ admin.school?.name || 'N/A' }}</TableCell>
            <TableCell>{{ admin.role }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editAdmin(admin)">Sửa</Button>
              <Button variant="destructive" @click="deleteAdmin(admin.id)">Xóa</Button>
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
}

interface AdminAccount {
  id: number;
  username: string;
  role: string;
  school_id: number;
  school?: School;
}

const { $axios } = useNuxtApp();

const schools = ref<School[]>([]);
const admins = ref<AdminAccount[]>([]);
const newAdmin = ref<{ school_id: string; username: string; password: string }>({ school_id: '', username: '', password: '' });
const loading = ref<boolean>(false);
const error = ref<string>('');

const fetchSchools = async () => {
  try {
    const response: AxiosResponse<School[]> = await $axios.get('/schools');
    schools.value = response.data;
  } catch (error) {
    console.error('Error fetching schools:', error);
  }
};

const fetchAdmins = async () => {
  try {
    const response: AxiosResponse<AdminAccount[]> = await $axios.get('/users');
    admins.value = response.data.filter(user => user.role === 'AdminSchools');
  } catch (error) {
    console.error('Error fetching admins:', error);
  }
};

const createAdminAccount = async () => {
  try {
    loading.value = true;
    error.value = '';
    await $axios.post(`/schools/${newAdmin.value.school_id}/admin_accounts`, newAdmin.value);
    newAdmin.value = { school_id: '', username: '', password: '' };
    await fetchAdmins();
  } catch (error: any) {
    console.error('Error creating admin account:', error);
    if (error.response?.data?.errors) {
      error.value = error.response.data.errors.join(', ');
    } else {
      error.value = 'Không thể tạo tài khoản. Vui lòng thử lại.';
    }
  } finally {
    loading.value = false;
  }
};

const editAdmin = (admin: AdminAccount) => {
  // Placeholder for edit functionality
  console.log('Editing admin:', admin);
};

const deleteAdmin = async (id: number) => {
  try {
    await $axios.delete(`/users/${id}`);
    await fetchAdmins();
  } catch (error) {
    console.error('Error deleting admin:', error);
  }
};

onMounted(() => {
  fetchSchools();
  fetchAdmins();
});

definePageMeta({
  layout: 'super-admin',
});
</script>

<style scoped></style>