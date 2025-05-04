<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Super Admin Dashboard</h1>

    <!-- Overview Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-6">
      <Card>
        <CardHeader>
          <CardTitle>Tổng số trường học</CardTitle>
        </CardHeader>
        <CardContent>
          <p class="text-3xl font-bold">{{ schools.length }}</p>
        </CardContent>
      </Card>
      <Card>
        <CardHeader>
          <CardTitle>Tổng số Admin Schools</CardTitle>
        </CardHeader>
        <CardContent>
          <p class="text-3xl font-bold">{{ adminAccounts.length }}</p>
        </CardContent>
      </Card>
    </div>

    <!-- Quick Actions -->
    <div class="mb-6">
      <h2 class="text-xl font-semibold mb-4">Hành động nhanh</h2>
      <div class="flex gap-4">
        <NuxtLink to="/super-admin/schools">
          <Button>Tạo trường học</Button>
        </NuxtLink>
        <NuxtLink to="/super-admin/admin-accounts">
          <Button>Tạo tài khoản Admin Schools</Button>
        </NuxtLink>
      </div>
    </div>

    <!-- Schools List -->
    <Card>
      <CardHeader>
        <CardTitle>Danh sách trường học</CardTitle>
      </CardHeader>
      <CardContent>
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
                <NuxtLink :to="`/super-admin/schools/${school.id}`">
                  <Button variant="outline">Xem chi tiết</Button>
                </NuxtLink>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
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

interface AdminAccount {
  id: number;
  username: string;
  role: string;
  school_id: number;
}

const { $axios } = useNuxtApp();

const schools = ref<School[]>([]);
const adminAccounts = ref<AdminAccount[]>([]);

const fetchSchools = async () => {
  try {
    const response: AxiosResponse<School[]> = await $axios.get('/schools');
    schools.value = response.data;
  } catch (error) {
    console.error('Error fetching schools:', error);
  }
};

const fetchAdminAccounts = async () => {
  try {
    const response: AxiosResponse<AdminAccount[]> = await $axios.get('/users');
    adminAccounts.value = response.data.filter(user => user.role === 'AdminSchools');
  } catch (error) {
    console.error('Error fetching admin accounts:', error);
  }
};

onMounted(() => {
  fetchSchools();
  fetchAdminAccounts();
});

definePageMeta({
  layout: 'super-admin',
});
</script>

<style scoped></style>