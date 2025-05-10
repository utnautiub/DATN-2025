<template>
  <div class="container mx-auto p-6 space-y-8">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold tracking-tight">Quản lý trường học</h1>
        <p class="text-muted-foreground mt-1">Thêm, sửa và xóa thông tin trường học</p>
      </div>
      <Button variant="outline" size="sm" class="gap-1" @click="fetchSchools">
        <Icon icon="heroicons:arrow-path" class="h-4 w-4" />
        Làm mới
      </Button>
    </div>

    <!-- Form to create a new school -->
    <Card>
      <CardHeader>
        <CardTitle>Thêm trường học mới</CardTitle>
        <CardDescription>Điền thông tin để tạo trường học mới trong hệ thống</CardDescription>
      </CardHeader>
      <CardContent>
        <form @submit.prevent="createSchool" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="space-y-2">
              <Label for="name">Tên trường</Label>
              <Input id="name" v-model="newSchool.name" placeholder="Nhập tên trường" required />
            </div>
            <div class="space-y-2">
              <Label for="address">Địa chỉ</Label>
              <Input id="address" v-model="newSchool.address" placeholder="Nhập địa chỉ" required />
            </div>
            <div class="space-y-2">
              <Label for="phone">Số điện thoại</Label>
              <Input id="phone" v-model="newSchool.phone" placeholder="Nhập số điện thoại" />
            </div>
            <div class="space-y-2">
              <Label for="email">Email</Label>
              <Input id="email" v-model="newSchool.email" type="email" placeholder="Nhập email" />
            </div>
          </div>
          <div class="flex justify-end">
            <Button type="submit" :disabled="loading" class="gap-2">
              <Icon v-if="loading" icon="heroicons:arrow-path" class="h-4 w-4 animate-spin" />
              <Icon v-else icon="heroicons:plus" class="h-4 w-4" />
              Thêm trường
            </Button>
          </div>
        </form>
      </CardContent>
    </Card>

    <!-- Schools List -->
    <div>
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold">Danh sách trường học</h2>
        <div class="flex items-center gap-2">
          <Input placeholder="Tìm kiếm trường học..." class="w-64" />
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" size="sm" class="gap-1">
                <Icon icon="heroicons:funnel" class="h-4 w-4" />
                Lọc
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent>
              <DropdownMenuLabel>Sắp xếp theo</DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem>Tên (A-Z)</DropdownMenuItem>
              <DropdownMenuItem>Tên (Z-A)</DropdownMenuItem>
              <DropdownMenuItem>Mới nhất</DropdownMenuItem>
              <DropdownMenuItem>Cũ nhất</DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      <Card>
        <CardContent class="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Tên trường</TableHead>
                <TableHead>Địa chỉ</TableHead>
                <TableHead>Số điện thoại</TableHead>
                <TableHead>Email</TableHead>
                <TableHead class="text-right">Hành động</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="school in schools" :key="school.id">
                <TableCell class="font-medium">{{ school.name }}</TableCell>
                <TableCell>{{ school.address }}</TableCell>
                <TableCell>{{ school.phone || '—' }}</TableCell>
                <TableCell>{{ school.email || '—' }}</TableCell>
                <TableCell class="text-right">
                  <div class="flex justify-end gap-2">
                    <NuxtLink :to="`/super-admin/schools/${school.id}`">
                      <Button variant="ghost" size="sm" class="h-8 w-8 p-0">
                        <Icon icon="heroicons:eye" class="h-4 w-4" />
                      </Button>
                    </NuxtLink>
                    <Button variant="ghost" size="sm" class="h-8 w-8 p-0" @click="editSchool(school)">
                      <Icon icon="heroicons:pencil-square" class="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="sm" class="h-8 w-8 p-0" @click="confirmDelete(school.id)">
                      <Icon icon="heroicons:trash" class="h-4 w-4" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
              <TableRow v-if="schools.length === 0">
                <TableCell colspan="5" class="text-center h-24 text-muted-foreground">
                  <div class="flex flex-col items-center gap-2">
                    <Icon icon="heroicons:building-office" class="h-8 w-8 text-muted-foreground/50" />
                    <p>Không có dữ liệu trường học</p>
                    <Button variant="outline" size="sm" @click="fetchSchools">Làm mới</Button>
                  </div>
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>

    <!-- Edit School Dialog -->
    <Dialog v-model:open="showEditDialog">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Chỉnh sửa thông tin trường học</DialogTitle>
          <DialogDescription>
            Cập nhật thông tin cho trường học. Nhấn lưu khi hoàn tất.
          </DialogDescription>
        </DialogHeader>
        <div class="space-y-4 py-2">
          <div class="space-y-2">
            <Label for="edit-name">Tên trường</Label>
            <Input id="edit-name" v-model="editingSchool.name" placeholder="Nhập tên trường" required />
          </div>
          <div class="space-y-2">
            <Label for="edit-address">Địa chỉ</Label>
            <Input id="edit-address" v-model="editingSchool.address" placeholder="Nhập địa chỉ" required />
          </div>
          <div class="space-y-2">
            <Label for="edit-phone">Số điện thoại</Label>
            <Input id="edit-phone" v-model="editingSchool.phone" placeholder="Nhập số điện thoại" />
          </div>
          <div class="space-y-2">
            <Label for="edit-email">Email</Label>
            <Input id="edit-email" v-model="editingSchool.email" type="email" placeholder="Nhập email" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="showEditDialog = false">Hủy</Button>
          <Button @click="updateSchool" :disabled="loading">Lưu thay đổi</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
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
const showEditDialog = ref<boolean>(false);
const editingSchool = ref<School>({ id: 0, name: '', address: '', phone: '', email: '' });

const fetchSchools = async () => {
  try {
    loading.value = true;
    const response: AxiosResponse<School[]> = await $axios.get('/schools');
    schools.value = response.data;
  } catch (error) {
    console.error('Error fetching schools:', error);
    toast({
      title: 'Lỗi',
      description: 'Không thể tải danh sách trường học',
      variant: 'destructive',
    });
  } finally {
    loading.value = false;
  }
};

const createSchool = async () => {
  try {
    loading.value = true;
    await $axios.post('/schools', newSchool.value);
    newSchool.value = { id: 0, name: '', address: '', phone: '', email: '' };
    await fetchSchools();
    toast({
      title: 'Thành công',
      description: 'Đã thêm trường học mới',
    });
  } catch (error) {
    console.error('Error creating school:', error);
    toast({
      title: 'Lỗi',
      description: 'Không thể thêm trường học',
      variant: 'destructive',
    });
  } finally {
    loading.value = false;
  }
};

const editSchool = (school: School) => {
  editingSchool.value = { ...school };
  showEditDialog.value = true;
};

const updateSchool = async () => {
  try {
    loading.value = true;
    await $axios.put(`/schools/${editingSchool.value.id}`, editingSchool.value);
    await fetchSchools();
    showEditDialog.value = false;
    toast({
      title: 'Thành công',
      description: 'Đã cập nhật thông tin trường học',
    });
  } catch (error) {
    console.error('Error updating school:', error);
    toast({
      title: 'Lỗi',
      description: 'Không thể cập nhật thông tin trường học',
      variant: 'destructive',
    });
  } finally {
    loading.value = false;
  }
};

const deleteSchool = async (id: number) => {
  try {
    await $axios.delete(`/schools/${id}`);
    await fetchSchools();
    toast({
      title: 'Thành công',
      description: 'Đã xóa trường học',
    });
  } catch (error) {
    console.error('Error deleting school:', error);
    toast({
      title: 'Lỗi',
      description: 'Không thể xóa trường học',
      variant: 'destructive',
    });
  }
};

onMounted(fetchSchools);

definePageMeta({
  layout: 'super-admin',
});
</script>

<style scoped></style>
