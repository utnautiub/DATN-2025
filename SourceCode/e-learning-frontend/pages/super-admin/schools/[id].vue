<template>
  <div>
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-2xl font-bold">Chi tiết trường học</h1>
        <p class="text-muted-foreground">Xem và quản lý thông tin chi tiết của trường học</p>
      </div>
      <div class="flex gap-2">
        <Button variant="outline" @click="router.back()">
          <Icon icon="heroicons:arrow-left" class="mr-2 h-4 w-4" />
          Quay lại
        </Button>
        <Button variant="outline" @click="openEditDialog()">
          <Icon icon="heroicons:pencil-square" class="mr-2 h-4 w-4" />
          Chỉnh sửa
        </Button>
      </div>
    </div>

    <div v-if="loading">
      <div class="flex items-center justify-center h-64">
        <Spinner class="h-8 w-8" />
      </div>
    </div>

    <div v-else-if="error" class="p-4 border border-red-200 rounded-md bg-red-50 text-red-600">
      {{ error }}
    </div>

    <div v-else-if="school" class="space-y-6">
      <!-- Thông tin cơ bản -->
      <Card>
        <CardHeader>
          <CardTitle>Thông tin cơ bản</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <Label>Tên trường</Label>
              <p class="text-lg font-medium">{{ school.name }}</p>
            </div>
            <div>
              <Label>Địa chỉ</Label>
              <p>{{ school.address }}</p>
            </div>
            <div>
              <Label>Số điện thoại</Label>
              <p>{{ school.phone || '—' }}</p>
            </div>
            <div>
              <Label>Email</Label>
              <p>{{ school.email || '—' }}</p>
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- Thống kê -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card>
          <CardContent class="pt-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground">Tổng số khoa</p>
                <p class="text-2xl font-bold">{{ school.stats?.departments_count || 0 }}</p>
              </div>
              <Icon icon="heroicons:academic-cap" class="h-8 w-8 text-primary" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent class="pt-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground">Tổng số tòa nhà</p>
                <p class="text-2xl font-bold">{{ school.stats?.buildings_count || 0 }}</p>
              </div>
              <Icon icon="heroicons:building-office-2" class="h-8 w-8 text-primary" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent class="pt-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground">Tổng số giáo viên</p>
                <p class="text-2xl font-bold">{{ school.stats?.teachers_count || 0 }}</p>
              </div>
              <Icon icon="heroicons:user-group" class="h-8 w-8 text-primary" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent class="pt-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground">Tổng số học sinh</p>
                <p class="text-2xl font-bold">{{ school.stats?.students_count || 0 }}</p>
              </div>
              <Icon icon="heroicons:users" class="h-8 w-8 text-primary" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent class="pt-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground">Tổng số lớp học</p>
                <p class="text-2xl font-bold">{{ school.stats?.classes_count || 0 }}</p>
              </div>
              <Icon icon="heroicons:rectangle-group" class="h-8 w-8 text-primary" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent class="pt-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground">Tổng số khóa học</p>
                <p class="text-2xl font-bold">{{ school.stats?.courses_count || 0 }}</p>
              </div>
              <Icon icon="heroicons:book-open" class="h-8 w-8 text-primary" />
            </div>
          </CardContent>
        </Card>
      </div>

      <!-- Danh sách Admin của trường -->
      <Card>
        <CardHeader>
          <CardTitle>Quản trị viên trường học</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Tên đăng nhập</TableHead>
                <TableHead>Vai trò</TableHead>
                <TableHead class="text-right">Hành động</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="admin in school.users" :key="admin.id">
                <TableCell>{{ admin.username }}</TableCell>
                <TableCell>{{ admin.role }}</TableCell>
                <TableCell class="text-right">
                  <Button variant="ghost" size="sm" class="h-8 w-8 p-0">
                    <Icon icon="heroicons:eye" class="h-4 w-4" />
                  </Button>
                </TableCell>
              </TableRow>
              <TableRow v-if="!school.users || school.users.length === 0">
                <TableCell colspan="3" class="text-center py-4">
                  Chưa có quản trị viên nào
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
          <Button @click="updateSchool" :disabled="updating">Lưu thay đổi</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { AxiosResponse } from 'axios';
import { toast } from 'vue-sonner';

interface School {
  id: number;
  name: string;
  address: string;
  phone: string;
  email: string;
  departments?: any[];
  buildings?: any[];
  users?: any[];
  stats?: {
    departments_count: number;
    buildings_count: number;
    teachers_count: number;
    students_count: number;
    classes_count: number;
    courses_count: number;
  };
}

const route = useRoute();
const router = useRouter();
const { $axios } = useNuxtApp();

const schoolId = route.params.id;
const school = ref<School | null>(null);
const loading = ref<boolean>(true);
const error = ref<string>('');

// Biến cho chức năng chỉnh sửa
const showEditDialog = ref<boolean>(false);
const editingSchool = ref<Partial<School>>({});
const updating = ref<boolean>(false);

const fetchSchool = async () => {
  try {
    loading.value = true;
    const response: AxiosResponse<School> = await $axios.get(`/schools/${schoolId}`);
    school.value = response.data;
  } catch (err: any) {
    console.error('Error fetching school:', err);
    error.value = err.response?.data?.error || 'Không thể tải thông tin trường học. Vui lòng thử lại.';
    toast.error('Lỗi', {
      description: 'Không thể tải thông tin trường học'
    });
  } finally {
    loading.value = false;
  }
};

const openEditDialog = () => {
  if (school.value) {
    editingSchool.value = {
      id: school.value.id,
      name: school.value.name,
      address: school.value.address,
      phone: school.value.phone,
      email: school.value.email
    };
    showEditDialog.value = true;
  }
};

const updateSchool = async () => {
  try {
    updating.value = true;
    await $axios.put(`/schools/${schoolId}`, editingSchool.value);
    await fetchSchool();
    showEditDialog.value = false;
    toast.success('Thành công', {
      description: 'Đã cập nhật thông tin trường học'
    });
  } catch (err: any) {
    console.error('Error updating school:', err);
    toast.error('Lỗi', {
      description: 'Không thể cập nhật thông tin trường học'
    });
  } finally {
    updating.value = false;
  }
};

onMounted(() => {
  fetchSchool();
});

definePageMeta({
  layout: 'super-admin',
});
</script>
