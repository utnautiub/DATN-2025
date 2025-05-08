<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý chương trình đào tạo</h1>

    <!-- Form to create a new training program -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createTrainingProgram" class="space-y-4">
        <div>
          <Label for="name">Tên chương trình</Label>
          <Input id="name" v-model="newTrainingProgram.name" required />
        </div>
        <div>
          <Label for="start_year">Năm bắt đầu</Label>
          <Input id="start_year" type="number" v-model.number="newTrainingProgram.start_year" required />
        </div>
        <div>
          <Label for="end_year">Năm kết thúc</Label>
          <Input id="end_year" type="number" v-model.number="newTrainingProgram.end_year" required />
        </div>
        <div>
          <Label for="major_id">Ngành</Label>
          <select id="major_id" v-model="newTrainingProgram.major_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn ngành</option>
            <option v-for="major in majors" :key="major.id" :value="major.id">
              {{ major.name }}
            </option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Thêm chương trình</Button>
      </form>
    </Card>

    <!-- Training Programs List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên chương trình</TableHead>
            <TableHead>Năm bắt đầu</TableHead>
            <TableHead>Năm kết thúc</TableHead>
            <TableHead>Ngành</TableHead>
            <TableHead>Khoa</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="program in trainingPrograms" :key="program.id">
            <TableCell>{{ program.name }}</TableCell>
            <TableCell>{{ program.start_year }}</TableCell>
            <TableCell>{{ program.end_year }}</TableCell>
            <TableCell>{{ program.major?.name || 'N/A' }}</TableCell>
            <TableCell>{{ program.major?.department?.name || 'N/A' }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="openEditTrainingProgramModal(program)">Sửa</Button>
              <Button variant="destructive" @click="deleteTrainingProgram(program.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Training Program Modal -->
    <Dialog v-model:open="showEditModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Sửa chương trình đào tạo</DialogTitle>
        </DialogHeader>
        <form @submit.prevent="updateTrainingProgram" class="space-y-4">
          <div>
            <Label for="edit-name">Tên chương trình</Label>
            <Input id="edit-name" v-model="editTrainingProgram.name" required />
          </div>
          <div>
            <Label for="edit-start_year">Năm bắt đầu</Label>
            <Input id="edit-start_year" type="number" v-model.number="editTrainingProgram.start_year" required />
          </div>
          <div>
            <Label for="edit-end_year">Năm kết thúc</Label>
            <Input id="edit-end_year" type="number" v-model.number="editTrainingProgram.end_year" required />
          </div>
          <div>
            <Label for="edit-major_id">Ngành</Label>
            <select id="edit-major_id" v-model="editTrainingProgram.major_id" required
              class="w-full px-4 py-2 border rounded-lg">
              <option value="0">Chọn ngành</option>
              <option v-for="major in majors" :key="major.id" :value="major.id">
                {{ major.name }}
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

interface TrainingProgram {
  id: number;
  name: string;
  start_year: number;
  end_year: number;
  major_id: number;
  major?: { name: string; department?: { name: string } };
}

interface Major {
  id: number;
  name: string;
}

const { $axios } = useNuxtApp();

const trainingPrograms = ref<TrainingProgram[]>([]);
const majors = ref<Major[]>([]);
const newTrainingProgram = ref<TrainingProgram>({ id: 0, name: '', start_year: 0, end_year: 0, major_id: 0 });
const editTrainingProgram = ref<TrainingProgram>({ id: 0, name: '', start_year: 0, end_year: 0, major_id: 0 });
const loading = ref<boolean>(false);
const showEditModal = ref<boolean>(false);

const fetchTrainingPrograms = async () => {
  try {
    const response: AxiosResponse<TrainingProgram[]> = await $axios.get('/training_programs');
    trainingPrograms.value = response.data;
  } catch (error) {
    console.error('Error fetching training programs:', error);
  }
};

const fetchMajors = async () => {
  try {
    const response: AxiosResponse<Major[]> = await $axios.get('/majors');
    majors.value = response.data;
  } catch (error) {
    console.error('Error fetching majors:', error);
  }
};

const createTrainingProgram = async () => {
  try {
    loading.value = true;
    await $axios.post('/training_programs', newTrainingProgram.value);
    newTrainingProgram.value = { id: 0, name: '', start_year: 0, end_year: 0, major_id: 0 };
    await fetchTrainingPrograms();
  } catch (error) {
    console.error('Error creating training program:', error);
  } finally {
    loading.value = false;
  }
};

const openEditTrainingProgramModal = (program: TrainingProgram) => {
  editTrainingProgram.value = { ...program };
  showEditModal.value = true;
};

const updateTrainingProgram = async () => {
  try {
    loading.value = true;
    await $axios.put(`/training_programs/${editTrainingProgram.value.id}`, editTrainingProgram.value);
    showEditModal.value = false;
    await fetchTrainingPrograms();
  } catch (error) {
    console.error('Error updating training program:', error);
  } finally {
    loading.value = false;
  }
};

const deleteTrainingProgram = async (id: number) => {
  try {
    await $axios.delete(`/training_programs/${id}`);
    await fetchTrainingPrograms();
  } catch (error) {
    console.error('Error deleting training program:', error);
  }
};

onMounted(() => {
  fetchTrainingPrograms();
  fetchMajors();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>