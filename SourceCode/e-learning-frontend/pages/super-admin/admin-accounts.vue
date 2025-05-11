<template>
  <div class="container mx-auto py-10 space-y-10">
    <Card class="overflow-hidden border-border/50 shadow-md">
      <div class="px-6 py-5 border-b">
        <div class="flex items-center gap-3">
          <div class="p-3 rounded-full bg-primary/10 text-primary">
            <Icon icon="heroicons:user-plus" class="h-6 w-6" />
          </div>
          <div>
            <CardTitle class="text-2xl">Tạo Tài Khoản Admin Mới</CardTitle>
            <CardDescription>Nhập thông tin để tạo tài khoản quản trị trường học</CardDescription>
          </div>
        </div>
      </div>
      <CardContent class="p-6">
        <form @submit.prevent="createAdminAccount" class="space-y-8">
          <div class="grid md:grid-cols-1">
            <div class="space-y-3">
              <Label for="school_id" class="text-sm font-medium flex items-center gap-2">
                <Icon icon="heroicons:building-office" class="h-5 w-5 text-muted-foreground" />
                Trường Học
              </Label>
              <Select v-model="newAdmin.school_id">
                <SelectTrigger class="w-full">
                  <SelectValue placeholder="Chọn trường học" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem v-for="school in schools" :key="school.id" :value="school.id">
                    {{ school.name }}
                  </SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div class="space-y-3 md:col-span-2">
              <div class="space-y-3">
                <Label for="username" class="text-sm font-medium flex items-center gap-2">
                  <Icon icon="heroicons:user" class="h-5 w-5 text-muted-foreground" />
                  Tên Đăng Nhập
                </Label>
                <Input id="username" v-model="newAdmin.username" placeholder="Nhập tên đăng nhập" required />
              </div>
              <Label for="password" class="text-sm font-medium flex items-center gap-2">
                <Icon icon="heroicons:lock-closed" class="h-5 w-5 text-muted-foreground" />
                Mật Khẩu
              </Label>
              <div class="relative">
                <Input id="password" v-model="newAdmin.password" :type="showPassword ? 'text' : 'password'"
                  placeholder="Nhập mật khẩu" required />
                <Button type="button" variant="ghost" size="sm"
                  class="absolute right-0 top-0 h-full px-4 hover:text-primary"
                  @click="showPassword = !showPassword">
                  <Icon :icon="showPassword ? 'heroicons:eye-slash' : 'heroicons:eye'" class="h-5 w-5" />
                </Button>
              </div>
            </div>
          </div>
          <div v-if="error"
            class="p-4 bg-destructive/10 border border-destructive/20 rounded-lg text-destructive text-sm flex items-start gap-3">
            <Icon icon="heroicons:exclamation-triangle" class="h-5 w-5 flex-shrink-0" />
            <span>{{ error }}</span>
          </div>
          <div class="flex justify-end">
            <Button type="submit" :disabled="loading" class="gap-2">
              <Icon v-if="loading" icon="heroicons:arrow-path" class="h-5 w-5 animate-spin" />
              <Icon v-else icon="heroicons:user-plus" class="h-5 w-5" />
              Tạo Tài Khoản
            </Button>
          </div>
        </form>
      </CardContent>
    </Card>

    <!-- Admin List -->
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h2 class="text-2xl font-semibold flex items-center gap-3">
          <div class="p-2 rounded-full bg-primary/10 text-primary">
            <Icon icon="heroicons:users" class="h-6 w-6" />
          </div>
          Danh Sách Tài Khoản Admin
        </h2>
        <div class="flex items-center gap-3 w-full sm:w-auto">
          <div class="relative w-full sm:w-72">
            <Input placeholder="Tìm kiếm tài khoản..." class="pl-10" v-model="searchQuery" />
            <Icon icon="heroicons:magnifying-glass"
              class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-muted-foreground" />
          </div>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" class="gap-2">
                <Icon icon="heroicons:funnel" class="h-5 w-5" />
                Lọc
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent class="w-56">
              <DropdownMenuLabel class="font-medium">Sắp xếp theo</DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem class="cursor-pointer" @click="sortAdmins('username', 'asc')">
                <Icon icon="heroicons:arrows-up-down" class="h-4 w-4 mr-2" />
                Tên đăng nhập (A-Z)
              </DropdownMenuItem>
              <DropdownMenuItem class="cursor-pointer" @click="sortAdmins('username', 'desc')">
                <Icon icon="heroicons:arrows-down-up" class="h-4 w-4 mr-2" />
                Tên đăng nhập (Z-A)
              </DropdownMenuItem>
              <DropdownMenuItem class="cursor-pointer" @click="sortAdmins('school', 'asc')">
                <Icon icon="heroicons:building-office" class="h-4 w-4 mr-2" />
                Trường học (A-Z)
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      <Card class="border-border/50 overflow-hidden shadow-md">
        <CardContent class="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead class="font-medium">Tên Đăng Nhập</TableHead>
                <TableHead class="font-medium">Trường Học</TableHead>
                <TableHead class="font-medium">Vai Trò</TableHead>
                <TableHead class="text-right font-medium">Hành Động</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow v-for="admin in filteredAdmins" :key="admin.id"
                class="hover:bg-accent/50 transition-colors duration-200 group">
                <TableCell class="font-medium">
                  <div class="flex items-center gap-3">
                    <Avatar>
                      <AvatarFallback class="bg-primary/10 text-primary">
                        {{ admin.username.charAt(0).toUpperCase() }}
                      </AvatarFallback>
                    </Avatar>
                    {{ admin.username }}
                  </div>
                </TableCell>
                <TableCell>
                  <div class="flex items-center gap-2 text-muted-foreground">
                    <Icon icon="heroicons:building-office" class="h-5 w-5" />
                    {{ admin.school?.name || 'Không có trường' }}
                  </div>
                </TableCell>
                <TableCell>
                  <Badge variant="secondary">
                    {{ admin.role }}
                  </Badge>
                </TableCell>
                <TableCell class="text-right">
                  <div
                    class="flex justify-end gap-3 opacity-80 group-hover:opacity-100 transition-opacity duration-200">
                    <Button variant="ghost" size="sm" class="h-9 w-9 p-0 hover:text-primary hover:bg-primary/10"
                      @click="editAdmin(admin)">
                      <Icon icon="heroicons:pencil-square" class="h-5 w-5" />
                      <span class="sr-only">Sửa</span>
                    </Button>
                    <AlertDialog>
                      <AlertDialogTrigger asChild>
                        <Button variant="ghost" size="sm" class="h-9 w-9 p-0 hover:text-destructive hover:bg-destructive/10">
                          <Icon icon="heroicons:trash" class="h-5 w-5" />
                          <span class="sr-only">Xóa</span>
                        </Button>
                      </AlertDialogTrigger>
                      <AlertDialogContent>
                        <AlertDialogHeader>
                          <AlertDialogTitle class="text-xl">Xác Nhận Xóa Tài Khoản</AlertDialogTitle>
                          <AlertDialogDescription>
                            Bạn có chắc chắn muốn xóa tài khoản "{{ admin.username }}"? Hành động này không thể hoàn
                            tác.
                          </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                          <AlertDialogCancel>Hủy</AlertDialogCancel>
                          <AlertDialogAction @click="deleteAdmin(admin.id)"
                            class="bg-destructive hover:bg-destructive/90 text-destructive-foreground">
                            Xóa
                          </AlertDialogAction>
                        </AlertDialogFooter>
                      </AlertDialogContent>
                    </AlertDialog>
                  </div>
                </TableCell>
              </TableRow>
              <TableRow v-if="filteredAdmins.length === 0">
                <TableCell colspan="4" class="text-center h-40 text-muted-foreground">
                  <div class="flex flex-col items-center gap-4">
                    <div class="p-5 rounded-full bg-muted">
                      <Icon icon="heroicons:users" class="h-10 w-10 text-muted-foreground" />
                    </div>
                    <p>Không tìm thấy tài khoản Admin</p>
                    <Button variant="outline" size="sm" @click="fetchAdmins">
                      Làm Mới
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>

    <!-- Edit Dialog -->
    <Dialog v-model:open="showEditDialog">
      <DialogContent class="sm:max-w-md">
        <DialogHeader>
          <DialogTitle class="text-xl">Chỉnh Sửa Tài Khoản Admin</DialogTitle>
          <DialogDescription>
            Cập nhật thông tin tài khoản admin "{{ editingAdmin.username }}"
          </DialogDescription>
        </DialogHeader>
        <form @submit.prevent="updateAdmin" class="space-y-6">
          <div class="space-y-4">
            <div class="space-y-2">
              <Label for="edit-username">Tên đăng nhập</Label>
              <Input id="edit-username" v-model="editingAdmin.username" required />
            </div>

            <div class="space-y-2">
              <Label for="edit-school">Trường học</Label>
              <Select v-model="editingAdmin.school_id">
                <SelectTrigger>
                  <SelectValue placeholder="Chọn trường học" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem v-for="school in schools" :key="school.id" :value="school.id">
                    {{ school.name }}
                  </SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div class="space-y-2">
              <Label for="edit-password">Mật khẩu mới (để trống nếu không đổi)</Label>
              <div class="relative">
                <Input id="edit-password" v-model="editingAdmin.password" :type="showEditPassword ? 'text' : 'password'"
                  placeholder="Nhập mật khẩu mới" />
                <Button type="button" variant="ghost" size="sm"
                  class="absolute right-0 top-0 h-full px-4 hover:text-primary"
                  @click="showEditPassword = !showEditPassword">
                  <Icon :icon="showEditPassword ? 'heroicons:eye-slash' : 'heroicons:eye'" class="h-5 w-5" />
                </Button>
              </div>
            </div>
          </div>

          <DialogFooter class="gap-2 sm:gap-0">
            <Button type="button" variant="outline" @click="showEditDialog = false">
              Hủy
            </Button>
            <Button type="submit" :disabled="loading" class="gap-2">
              <Icon v-if="loading" icon="heroicons:arrow-path" class="h-4 w-4 animate-spin" />
              Cập nhật
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref, computed } from 'vue';
import type { AxiosResponse } from 'axios';
import { toast } from 'vue-sonner';

interface School {
  id: number;
  name: string;
}

interface AdminAccount {
  id: number;
  username: string;
  role: string;
  school_id: number | null;
  school?: School | null;
  password?: string;
}

const { $axios } = useNuxtApp();

const schools = ref<School[]>([]);
const admins = ref<AdminAccount[]>([]);
const newAdmin = ref<{ school_id: string; username: string; password: string }>({
  school_id: '',
  username: '',
  password: ''
});
const loading = ref<boolean>(false);
const error = ref<string>('');
const showPassword = ref<boolean>(false);
const showEditPassword = ref<boolean>(false);
const showEditDialog = ref<boolean>(false);
const searchQuery = ref<string>('');
const editingAdmin = ref<AdminAccount>({
  id: 0,
  username: '',
  role: 'AdminSchools',
  school_id: 0,
  school: null,
  password: ''
});
const sortKey = ref<string>('username');
const sortOrder = ref<'asc' | 'desc'>('asc');

const fetchSchools = async () => {
  try {
    const response: AxiosResponse<School[]> = await $axios.get('/schools');
    schools.value = response.data;
  } catch (error) {
    console.error('Error fetching schools:', error);
    toast.error('Không thể tải danh sách trường học', {
      description: 'Vui lòng thử lại sau'
    });
  }
};

const fetchAdmins = async () => {
  try {
    loading.value = true;
    const response: AxiosResponse<AdminAccount[]> = await $axios.get('/users');
    admins.value = response.data.filter(user => user.role === 'AdminSchools');
    toast.success('Đã tải danh sách tài khoản', {
      duration: 2000
    });
  } catch (error) {
    console.error('Error fetching admins:', error);
    toast.error('Không thể tải danh sách tài khoản Admin', {
      description: 'Vui lòng thử lại sau'
    });
  } finally {
    loading.value = false;
  }
};

const createAdminAccount = async () => {
  try {
    loading.value = true;
    error.value = '';

    if (!newAdmin.value.school_id) {
      error.value = 'Vui lòng chọn trường học';
      loading.value = false;
      return;
    }

    await $axios.post(`/schools/${newAdmin.value.school_id}/admin_accounts`, newAdmin.value);
    newAdmin.value = { school_id: '', username: '', password: '' };
    await fetchAdmins();

    toast.success('Tạo tài khoản thành công', {
      description: 'Đã tạo tài khoản Admin mới'
    });
  } catch (error: any) {
    console.error('Error creating admin account:', error);
    if (error.response?.data?.errors) {
      error.value = error.response.data.errors.join(', ');
    } else {
      error.value = 'Không thể tạo tài khoản. Vui lòng thử lại.';
    }

    toast.error('Tạo tài khoản thất bại', {
      description: error.value
    });
  } finally {
    loading.value = false;
  }
};

const editAdmin = (admin: AdminAccount) => {
  editingAdmin.value = { ...admin, password: '' };
  showEditDialog.value = true;
};

const updateAdmin = async () => {
  try {
    loading.value = true;

    const payload: any = {
      username: editingAdmin.value.username,
      school_id: editingAdmin.value.school_id
    };

    if (editingAdmin.value.password) {
      payload.password = editingAdmin.value.password;
    }

    await $axios.put(`/users/${editingAdmin.value.id}`, payload);
    showEditDialog.value = false;
    await fetchAdmins();

    toast.success('Cập nhật thành công', {
      description: 'Đã cập nhật tài khoản Admin'
    });
  } catch (error) {
    console.error('Error updating admin:', error);
    toast.error('Cập nhật thất bại', {
      description: 'Không thể cập nhật tài khoản Admin'
    });
  } finally {
    loading.value = false;
  }
};

const deleteAdmin = async (id: number) => {
  try {
    loading.value = true;
    await $axios.delete(`/users/${id}`);
    await fetchAdmins();
    toast.success('Xóa thành công', {
      description: 'Đã xóa tài khoản Admin'
    });
  } catch (error) {
    console.error('Error deleting admin:', error);
    toast.error('Xóa thất bại', {
      description: 'Không thể xóa tài khoản Admin'
    });
  } finally {
    loading.value = false;
  }
};

const sortAdmins = (key: string, order: 'asc' | 'desc') => {
  sortKey.value = key;
  sortOrder.value = order;
};

const filteredAdmins = computed(() => {
  let filtered = [...admins.value];

  // Filter by search query
  if (searchQuery.value) {
    filtered = filtered.filter(admin =>
      admin.username.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      admin.school?.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    );
  }

  // Sort
  filtered.sort((a, b) => {
    let valueA, valueB;

    if (sortKey.value === 'username') {
      valueA = a.username.toLowerCase();
      valueB = b.username.toLowerCase();
    } else {
      valueA = a.school?.name?.toLowerCase() || '';
      valueB = b.school?.name?.toLowerCase() || '';
    }

    if (sortOrder.value === 'asc') {
      return valueA.localeCompare(valueB);
    } else {
      return valueB.localeCompare(valueA);
    }
  });

  return filtered;
});

onMounted(() => {
  fetchSchools();
  fetchAdmins();
});

definePageMeta({
  layout: 'super-admin',
});
</script>

<style scoped>
.card-hover {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card-hover:hover {
  transform: translateY(-4px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
}

.table-row {
  transition: background-color 0.2s ease;
}
</style>