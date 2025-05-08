<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Phân công môn học</h1>

    <!-- Form to create a new subject assignment -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createSubjectAssignment" class="space-y-4">
        <div>
          <Label for="subject_id">Môn học</Label>
          <select id="subject_id" v-model="newSubjectAssignment.subject_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn môn học</option>
            <option v-for="subject in subjects" :key="subject.id" :value="subject.id">
              {{ subject.name }}
            </option>
          </select>
        </div>
        <div>
          <Label for="teacher_id">Giáo viên</Label>
          <select id="teacher_id" v-model="newSubjectAssignment.teacher_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn giáo viên</option>
            <option v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">
              {{ teacher.name }}
            </option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Phân công</Button>
      </form>
    </Card>

    <!-- Subject Assignments List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Môn học</TableHead>
            <TableHead>Giáo viên</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="assignment in subjectAssignments" :key="assignment?.id || Math.random()">
            <TableCell>{{ assignment?.subject?.name || 'N/A' }}</TableCell>
            <TableCell>{{ assignment?.teacher?.name || 'N/A' }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="openEditSubjectAssignmentModal(assignment)">Sửa</Button>
              <Button variant="destructive" @click="deleteSubjectAssignment(assignment.id)">Xóa</Button>
            </TableCell>
          </TableRow>
          <TableRow v-if="!subjectAssignments || subjectAssignments.length === 0">
            <TableCell colspan="3">Không có dữ liệu phân công môn học.</TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Subject Assignment Modal -->
    <Dialog v-model:open="showEditModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Sửa phân công môn học</DialogTitle>
        </DialogHeader>
        <form @submit.prevent="updateSubjectAssignment" class="space-y-4">
          <div>
            <Label for="edit-subject_id">Môn học</Label>
            <select id="edit-subject_id" v-model="editSubjectAssignment.subject_id" required
              class="w-full px-4 py-2 border rounded-lg">
              <option value="0">Chọn môn học</option>
              <option v-for="subject in subjects" :key="subject.id" :value="subject.id">
                {{ subject.name }}
              </option>
            </select>
          </div>
          <div>
            <Label for="edit-teacher_id">Giáo viên</Label>
            <select id="edit-teacher_id" v-model="editSubjectAssignment.teacher_id" required
              class="w-full px-4 py-2 border rounded-lg">
              <option value="0">Chọn giáo viên</option>
              <option v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">
                {{ teacher.name }}
              </option>
            </select>
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

interface SubjectAssignment {
  id: number;
  subject_id: number;
  teacher_id: number;
  subject?: { name: string };
  teacher?: { name: string };
}

interface Subject {
  id: number;
  name: string;
}

interface Teacher {
  id: number;
  name: string;
}

const { $axios } = useNuxtApp();

const subjectAssignments = ref<SubjectAssignment[]>([]);
const subjects = ref<Subject[]>([]);
const teachers = ref<Teacher[]>([]);
const newSubjectAssignment = ref<SubjectAssignment>({ id: 0, subject_id: 0, teacher_id: 0 });
const editSubjectAssignment = ref<SubjectAssignment>({ id: 0, subject_id: 0, teacher_id: 0 });
const loading = ref<boolean>(false);
const showEditModal = ref<boolean>(false);

const fetchSubjectAssignments = async () => {
  try {
    const response: AxiosResponse<SubjectAssignment[]> = await $axios.get('/subject_assignments');
    // Đảm bảo dữ liệu là mảng
    subjectAssignments.value = Array.isArray(response.data) ? response.data : [];
    console.log('Fetched subject assignments:', subjectAssignments.value);
  } catch (error) {
    console.error('Error fetching subject assignments:', error);
    subjectAssignments.value = []; // Đặt lại thành mảng rỗng nếu có lỗi
  }
};

const fetchSubjects = async () => {
  try {
    const response: AxiosResponse<Subject[]> = await $axios.get('/subjects');
    subjects.value = Array.isArray(response.data) ? response.data : [];
    console.log('Fetched subjects:', subjects.value);
  } catch (error) {
    console.error('Error fetching subjects:', error);
    subjects.value = [];
  }
};

const fetchTeachers = async () => {
  try {
    const response: AxiosResponse<Teacher[]> = await $axios.get('/teachers');
    teachers.value = Array.isArray(response.data) ? response.data : [];
    console.log('Fetched teachers:', teachers.value);
  } catch (error) {
    console.error('Error fetching teachers:', error);
    teachers.value = [];
  }
};

const createSubjectAssignment = async () => {
  try {
    loading.value = true;
    await $axios.post('/subject_assignments', newSubjectAssignment.value);
    newSubjectAssignment.value = { id: 0, subject_id: 0, teacher_id: 0 };
    await fetchSubjectAssignments();
  } catch (error) {
    console.error('Error creating subject assignment:', error);
  } finally {
    loading.value = false;
  }
};

const openEditSubjectAssignmentModal = (assignment: SubjectAssignment) => {
  editSubjectAssignment.value = { ...assignment };
  showEditModal.value = true;
};

const updateSubjectAssignment = async () => {
  try {
    loading.value = true;
    await $axios.put(`/subject_assignments/${editSubjectAssignment.value.id}`, editSubjectAssignment.value);
    showEditModal.value = false;
    await fetchSubjectAssignments();
  } catch (error) {
    console.error('Error updating subject assignment:', error);
  } finally {
    loading.value = false;
  }
};

const deleteSubjectAssignment = async (id: number) => {
  try {
    await $axios.delete(`/subject_assignments/${id}`);
    await fetchSubjectAssignments();
  } catch (error) {
    console.error('Error deleting subject assignment:', error);
  }
};

onMounted(() => {
  fetchSubjectAssignments();
  fetchSubjects();
  fetchTeachers();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>