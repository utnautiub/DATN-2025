<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý môn học trong chương trình đào tạo</h1>

    <!-- Form to assign a subject to a training program -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createTrainingProgramSubject" class="space-y-4">
        <div>
          <Label for="program_id">Chương trình đào tạo</Label>
          <select id="program_id" v-model="newTrainingProgramSubject.program_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn chương trình</option>
            <option v-for="program in trainingPrograms" :key="program.id" :value="program.id">
              {{ program.name }}
            </option>
          </select>
        </div>
        <div>
          <Label for="subject_id">Môn học</Label>
          <select id="subject_id" v-model="newTrainingProgramSubject.subject_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn môn học</option>
            <option v-for="subject in subjects" :key="subject.id" :value="subject.id">
              {{ subject.name }}
            </option>
          </select>
        </div>
        <div>
          <Label for="semester">Học kỳ</Label>
          <Input id="semester" type="number" v-model.number="newTrainingProgramSubject.semester" required />
        </div>
        <Button type="submit" :disabled="loading">Thêm môn học</Button>
      </form>
    </Card>

    <!-- Training Program Subjects List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Chương trình đào tạo</TableHead>
            <TableHead>Ngành</TableHead>
            <TableHead>Khoa</TableHead>
            <TableHead>Môn học</TableHead>
            <TableHead>Học kỳ</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="programSubject in trainingProgramSubjects" :key="programSubject.id">
            <TableCell>{{ programSubject.training_program?.name || 'N/A' }}</TableCell>
            <TableCell>{{ programSubject.training_program?.major?.name || 'N/A' }}</TableCell>
            <TableCell>{{ programSubject.training_program?.major?.department?.name || 'N/A' }}</TableCell>
            <TableCell>{{ programSubject.subject?.name || 'N/A' }}</TableCell>
            <TableCell>{{ programSubject.semester }}</TableCell>
            <TableCell>
              <Button variant="destructive" @click="deleteTrainingProgramSubject(programSubject.id)">Xóa</Button>
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

interface TrainingProgramSubject {
  id: number;
  program_id: number;
  subject_id: number;
  semester: number;
  training_program?: { name: string; major?: { name: string; department?: { name: string } } };
  subject?: { name: string };
}

interface TrainingProgram {
  id: number;
  name: string;
}

interface Subject {
  id: number;
  name: string;
}

const { $axios } = useNuxtApp();

const trainingProgramSubjects = ref<TrainingProgramSubject[]>([]);
const trainingPrograms = ref<TrainingProgram[]>([]);
const subjects = ref<Subject[]>([]);
const newTrainingProgramSubject = ref<TrainingProgramSubject>({ id: 0, program_id: 0, subject_id: 0, semester: 1 });
const loading = ref<boolean>(false);

const fetchTrainingProgramSubjects = async () => {
  try {
    const response: AxiosResponse<TrainingProgramSubject[]> = await $axios.get('/training_program_subjects');
    trainingProgramSubjects.value = response.data;
  } catch (error) {
    console.error('Error fetching training program subjects:', error);
  }
};

const fetchTrainingPrograms = async () => {
  try {
    const response: AxiosResponse<TrainingProgram[]> = await $axios.get('/training_programs');
    trainingPrograms.value = response.data;
  } catch (error) {
    console.error('Error fetching training programs:', error);
  }
};

const fetchSubjects = async () => {
  try {
    const response: AxiosResponse<Subject[]> = await $axios.get('/subjects');
    subjects.value = response.data;
  } catch (error) {
    console.error('Error fetching subjects:', error);
  }
};

const createTrainingProgramSubject = async () => {
  try {
    loading.value = true;
    await $axios.post('/training_program_subjects', newTrainingProgramSubject.value);
    newTrainingProgramSubject.value = { id: 0, program_id: 0, subject_id: 0, semester: 1 };
    await fetchTrainingProgramSubjects();
  } catch (error) {
    console.error('Error creating training program subject:', error);
  } finally {
    loading.value = false;
  }
};

const deleteTrainingProgramSubject = async (id: number) => {
  try {
    await $axios.delete(`/training_program_subjects/${id}`);
    await fetchTrainingProgramSubjects();
  } catch (error) {
    console.error('Error deleting training program subject:', error);
  }
};

onMounted(() => {
  fetchTrainingProgramSubjects();
  fetchTrainingPrograms();
  fetchSubjects();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>