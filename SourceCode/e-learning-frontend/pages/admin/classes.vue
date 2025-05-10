<!-- pages/admin/classes.vue -->
<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý lớp quản lý</h1>

    <!-- Form to create a new class -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createClass" class="space-y-4">
        <div>
          <Label for="name">Tên lớp</Label>
          <Input id="name" v-model="newClass.name" required />
        </div>
        <div>
          <Label for="homeroom_teacher_id">Giáo viên chủ nhiệm</Label>
          <Select v-model="newClass.homeroom_teacher_id">
            <SelectTrigger class="w-full">
              <SelectValue placeholder="-- Chọn giáo viên --" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">
                {{ teacher.teacher?.name || teacher.username }}
              </SelectItem>
            </SelectContent>
          </Select>
        </div>
        <Button type="submit" :disabled="loading">Thêm lớp</Button>
      </form>
    </Card>

    <!-- Classes List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên lớp</TableHead>
            <TableHead>Giáo viên chủ nhiệm</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="schoolClass in classes" :key="schoolClass.id">
            <TableCell>{{ schoolClass.name }}</TableCell>
            <TableCell>{{ schoolClass.homeroom_teacher?.teacher?.name || 'Chưa có' }}</TableCell>
            <TableCell class="flex gap-2">
              <Button variant="outline" @click="openEditDialog(schoolClass)">Sửa</Button>
              <Button variant="destructive" @click="deleteClass(schoolClass.id)">Xóa</Button>
            </TableCell>
          </TableRow>
          <TableRow v-if="classes.length === 0">
            <TableCell colspan="3" class="text-center py-4">Chưa có lớp học nào</TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Class Dialog -->
    <Dialog v-model:open="showEditDialog">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Chỉnh sửa lớp học</DialogTitle>
          <DialogDescription>
            Cập nhật thông tin cho lớp học. Nhấn lưu khi hoàn tất.
          </DialogDescription>
        </DialogHeader>
        <div class="space-y-4 py-2">
          <div class="space-y-2">
            <Label for="edit-name">Tên lớp</Label>
            <Input id="edit-name" v-model="editingClass.name" placeholder="Nhập tên lớp" required />
          </div>
          <div class="space-y-2">
            <Label for="edit-teacher">Giáo viên chủ nhiệm</Label>
            <Select v-model="editingClass.homeroom_teacher_id">
              <SelectTrigger class="w-full">
                <SelectValue placeholder="-- Chọn giáo viên --" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">
                  {{ teacher.teacher?.name || teacher.username }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="showEditDialog = false">Hủy</Button>
          <Button @click="updateClass" :disabled="updating">Lưu thay đổi</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import type { AxiosResponse } from 'axios';
import { toast } from 'vue-sonner';

interface Teacher {
  id: number;
  username: string;
  teacher?: { name: string };
}

interface SchoolClass {
  id: number;
  name: string;
  homeroom_teacher_id: number;
  homeroom_teacher?: { id: number; teacher?: { name: string } };
}

const { $axios } = useNuxtApp();

const classes = ref<SchoolClass[]>([]);
const teachers = ref<Teacher[]>([]);
const newClass = ref<{ name: string; homeroom_teacher_id: string | number }>({ name: '', homeroom_teacher_id: '' });
const loading = ref<boolean>(false);

// Biến cho chức năng chỉnh sửa
const showEditDialog = ref<boolean>(false);
const editingClass = ref<SchoolClass>({ id: 0, name: '', homeroom_teacher_id: 0 });
const updating = ref<boolean>(false);

const fetchClasses = async () => {
  try {
    const response: AxiosResponse<SchoolClass[]> = await $axios.get('/school_classes');
    classes.value = response.data;
  } catch (error) {
    console.error('Error fetching classes:', error);
    toast.error('Lỗi', {
      description: 'Không thể tải danh sách lớp học'
    });
  }
};

const fetchTeachers = async () => {
  try {
    // Lấy tất cả người dùng có vai trò là Teacher
    const response: AxiosResponse<Teacher[]> = await $axios.get('/users?role=Teacher');
    teachers.value = response.data;
  } catch (error) {
    console.error('Error fetching teachers:', error);
    toast.error('Lỗi', {
      description: 'Không thể tải danh sách giáo viên'
    });
  }
};

const createClass = async () => {
  try {
    loading.value = true;
    await $axios.post('/school_classes', newClass.value);
    newClass.value = { name: '', homeroom_teacher_id: '' };
    await fetchClasses();
    toast.success('Thành công', {
      description: 'Đã thêm lớp học mới'
    });
  } catch (error: any) {
    console.error('Error creating class:', error);
    const errorMessage = error.response?.data?.errors?.join(', ') || 'Không thể tạo lớp học mới';
    toast.error('Lỗi', {
      description: errorMessage
    });
  } finally {
    loading.value = false;
  }
};

const openEditDialog = (schoolClass: SchoolClass) => {
  editingClass.value = { ...schoolClass };
  showEditDialog.value = true;
};

const updateClass = async () => {
  try {
    updating.value = true;
    await $axios.put(`/school_classes/${editingClass.value.id}`, editingClass.value);
    await fetchClasses();
    showEditDialog.value = false;
    toast.success('Thành công', {
      description: 'Đã cập nhật thông tin lớp học'
    });
  } catch (error: any) {
    console.error('Error updating class:', error);
    const errorMessage = error.response?.data?.errors?.join(', ') || 'Không thể cập nhật thông tin lớp học';
    toast.error('Lỗi', {
      description: errorMessage
    });
  } finally {
    updating.value = false;
  }
};

const deleteClass = async (id: number) => {
  try {
    await $axios.delete(`/school_classes/${id}`);
    await fetchClasses();
    toast.success('Thành công', {
      description: 'Đã xóa lớp học'
    });
  } catch (error) {
    console.error('Error deleting class:', error);
    toast.error('Lỗi', {
      description: 'Không thể xóa lớp học'
    });
  }
};

onMounted(() => {
  fetchClasses();
  fetchTeachers();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>