<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý môn học</h1>

    <!-- Form to create a new subject -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createSubject" class="space-y-4">
        <div>
          <Label for="name">Tên môn học</Label>
          <Input id="name" v-model="newSubject.name" required />
        </div>
        <div>
          <Label for="code">Mã môn học</Label>
          <Input id="code" v-model="newSubject.code" required />
        </div>
        <div>
          <Label for="description">Mô tả</Label>
          <Input id="description" v-model="newSubject.description" />
        </div>
        <Button type="submit" :disabled="loading">Thêm môn học</Button>
      </form>
    </Card>

    <!-- Subjects List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên môn học</TableHead>
            <TableHead>Mã môn học</TableHead>
            <TableHead>Mô tả</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="subject in subjects" :key="subject.id">
            <TableCell>{{ subject.name }}</TableCell>
            <TableCell>{{ subject.code }}</TableCell>
            <TableCell>{{ subject.description || 'N/A' }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="openEditSubjectModal(subject)">Sửa</Button>
              <Button variant="destructive" @click="deleteSubject(subject.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Subject Modal -->
    <Dialog v-model:open="showEditModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Sửa môn học</DialogTitle>
        </DialogHeader>
        <form @submit.prevent="updateSubject" class="space-y-4">
          <div>
            <Label for="edit-name">Tên môn học</Label>
            <Input id="edit-name" v-model="editSubject.name" required />
          </div>
          <div>
            <Label for="edit-code">Mã môn học</Label>
            <Input id="edit-code" v-model="editSubject.code" required />
          </div>
          <div>
            <Label for="edit-description">Mô tả</Label>
            <Input id="edit-description" v-model="editSubject.description" />
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

interface Subject {
  id: number;
  name: string;
  code: string;
  description?: string;
}

const { $axios } = useNuxtApp();

const subjects = ref<Subject[]>([]);
const newSubject = ref<Subject>({ id: 0, name: '', code: '', description: '' });
const editSubject = ref<Subject>({ id: 0, name: '', code: '', description: '' });
const loading = ref<boolean>(false);
const showEditModal = ref<boolean>(false);

const fetchSubjects = async () => {
  try {
    const response: AxiosResponse<Subject[]> = await $axios.get('/subjects');
    subjects.value = response.data;
  } catch (error) {
    console.error('Error fetching subjects:', error);
  }
};

const createSubject = async () => {
  try {
    loading.value = true;
    await $axios.post('/subjects', newSubject.value);
    newSubject.value = { id: 0, name: '', code: '', description: '' };
    await fetchSubjects();
  } catch (error) {
    console.error('Error creating subject:', error);
  } finally {
    loading.value = false;
  }
};

const openEditSubjectModal = (subject: Subject) => {
  editSubject.value = { ...subject };
  showEditModal.value = true;
};

const updateSubject = async () => {
  try {
    loading.value = true;
    await $axios.put(`/subjects/${editSubject.value.id}`, editSubject.value);
    showEditModal.value = false;
    await fetchSubjects();
  } catch (error) {
    console.error('Error updating subject:', error);
  } finally {
    loading.value = false;
  }
};

const deleteSubject = async (id: number) => {
  try {
    await $axios.delete(`/subjects/${id}`);
    await fetchSubjects();
  } catch (error) {
    console.error('Error deleting subject:', error);
  }
};

onMounted(() => {
  fetchSubjects();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>