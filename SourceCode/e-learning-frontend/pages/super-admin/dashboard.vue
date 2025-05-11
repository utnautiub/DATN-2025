<template>
  <div class="container mx-auto p-6 space-y-8">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold tracking-tight">Super Admin Dashboard</h1>
        <p class="text-muted-foreground mt-1">Quản lý tổng quan hệ thống E-Learning</p>
      </div>
      <Button variant="outline" size="sm" class="gap-1">
        <Icon icon="heroicons:arrow-path" class="h-4 w-4" />
        Làm mới
      </Button>
    </div>

    <!-- Overview Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
        <CardHeader class="pb-2">
          <CardTitle class="text-base font-medium">Tổng số trường học</CardTitle>
          <CardDescription>Số lượng trường đang hoạt động</CardDescription>
        </CardHeader>
        <CardContent>
          <div class="flex items-center gap-2">
            <div class="text-4xl font-bold">{{ schools.length }}</div>
            <Badge variant="outline" class="text-xs">
              <Icon icon="heroicons:building-office" class="mr-1 h-3 w-3" />
              Trường
            </Badge>
          </div>
        </CardContent>
        <CardFooter class="pt-0">
          <NuxtLink to="/super-admin/schools" class="text-sm text-primary flex items-center hover:underline">
            Xem chi tiết
            <Icon icon="heroicons:arrow-right" class="ml-1 h-4 w-4" />
          </NuxtLink>
        </CardFooter>
      </Card>

      <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
        <CardHeader class="pb-2">
          <CardTitle class="text-base font-medium">Tổng số Admin Schools</CardTitle>
          <CardDescription>Số lượng tài khoản quản trị trường</CardDescription>
        </CardHeader>
        <CardContent>
          <div class="flex items-center gap-2">
            <div class="text-4xl font-bold">{{ adminAccounts.length }}</div>
            <Badge variant="outline" class="text-xs">
              <Icon icon="heroicons:users" class="mr-1 h-3 w-3" />
              Tài khoản
            </Badge>
          </div>
        </CardContent>
        <CardFooter class="pt-0">
          <NuxtLink to="/super-admin/admin-accounts" class="text-sm text-primary flex items-center hover:underline">
            Xem chi tiết
            <Icon icon="heroicons:arrow-right" class="ml-1 h-4 w-4" />
          </NuxtLink>
        </CardFooter>
      </Card>

      <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
        <CardHeader class="pb-2">
          <CardTitle class="text-base font-medium">Hoạt động gần đây</CardTitle>
          <CardDescription>Thống kê 7 ngày qua</CardDescription>
        </CardHeader>
        <CardContent>
          <div class="flex items-center gap-2">
            <div class="text-4xl font-bold">--</div>
            <Badge variant="outline" class="text-xs">
              <Icon icon="heroicons:chart-bar" class="mr-1 h-3 w-3" />
              Hoạt động
            </Badge>
          </div>
        </CardContent>
        <CardFooter class="pt-0">
          <Button variant="ghost" size="sm" class="text-sm text-muted-foreground p-0 h-auto">
            Chức năng đang phát triển
          </Button>
        </CardFooter>
      </Card>
    </div>

    <!-- Quick Actions -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Hành động nhanh</h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card class="hover:bg-accent/50 transition-all duration-200 cursor-pointer border-border/50 hover:shadow-md">
          <NuxtLink to="/super-admin/schools" class="block p-4">
            <div class="flex flex-col items-center text-center gap-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary">
                <Icon icon="heroicons:building-office" class="h-6 w-6" />
              </div>
              <h3 class="font-medium">Tạo trường học</h3>
              <p class="text-sm text-muted-foreground">Thêm trường học mới vào hệ thống</p>
            </div>
          </NuxtLink>
        </Card>

        <Card class="hover:bg-accent/50 transition-all duration-200 cursor-pointer border-border/50 hover:shadow-md">
          <NuxtLink to="/super-admin/admin-accounts" class="block p-4">
            <div class="flex flex-col items-center text-center gap-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary">
                <Icon icon="heroicons:user-plus" class="h-6 w-6" />
              </div>
              <h3 class="font-medium">Tạo Admin Schools</h3>
              <p class="text-sm text-muted-foreground">Thêm tài khoản quản trị trường</p>
            </div>
          </NuxtLink>
        </Card>
      </div>
    </div>

    <!-- Schools List -->
    <div>
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold">Danh sách trường học</h2>
        <NuxtLink to="/super-admin/schools">
          <Button variant="outline" size="sm">Xem tất cả</Button>
        </NuxtLink>
      </div>

      <Card class="border-border/50 overflow-hidden shadow-sm">
        <CardContent class="p-0">
          <Table>
            <TableHeader>
              <TableRow class="hover:bg-accent/50">
                <TableHead>Tên trường</TableHead>
                <TableHead>Địa chỉ</TableHead>
                <TableHead>Số điện thoại</TableHead>
                <TableHead>Email</TableHead>
                <TableHead class="text-right">Hành động</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="school in schools.slice(0, 5)" :key="school.id" class="hover:bg-accent/50 transition-colors duration-200">
                <TableCell class="font-medium">{{ school.name }}</TableCell>
                <TableCell>{{ school.address }}</TableCell>
                <TableCell>{{ school.phone || '—' }}</TableCell>
                <TableCell>{{ school.email || '—' }}</TableCell>
                <TableCell class="text-right">
                  <NuxtLink :to="`/super-admin/schools/${school.id}`">
                    <Button variant="ghost" size="sm" class="h-8 w-8 p-0 hover:bg-primary/10 hover:text-primary">
                      <Icon icon="heroicons:eye" class="h-4 w-4" />
                    </Button>
                  </NuxtLink>
                </TableCell>
              </TableRow>
              <TableRow v-if="schools.length === 0">
                <TableCell colspan="5" class="text-center h-24 text-muted-foreground">
                  Không có dữ liệu trường học
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
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
const isLoading = ref<boolean>(true);

const fetchSchools = async () => {
  try {
    const response: AxiosResponse<School[]> = await $axios.get('/schools');
    schools.value = response.data;
  } catch (error) {
    console.error('Error fetching schools:', error);
  } finally {
    isLoading.value = false;
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
