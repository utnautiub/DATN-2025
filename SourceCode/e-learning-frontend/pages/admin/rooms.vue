<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý phòng học</h1>

    <!-- Form to create a new classroom -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createClassroom" class="space-y-4">
        <div>
          <Label for="building_id">Tòa nhà</Label>
          <select id="building_id" v-model="newClassroom.building_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option v-for="building in buildings" :key="building.id" :value="building.id">{{ building.name }}</option>
          </select>
        </div>
        <div>
          <Label for="name">Tên phòng học</Label>
          <Input id="name" v-model="newClassroom.name" required />
        </div>
        <div>
          <Label for="capacity">Sức chứa</Label>
          <Input id="capacity" v-model="newClassroom.capacity" type="number" required />
        </div>
        <Button type="submit" :disabled="loading">Thêm phòng học</Button>
      </form>
    </Card>

    <!-- Classrooms List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tòa nhà</TableHead>
            <TableHead>Tên phòng học</TableHead>
            <TableHead>Sức chứa</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="classroom in classrooms" :key="classroom.id">
            <TableCell>{{ classroom.building?.name || 'N/A' }}</TableCell>
            <TableCell>{{ classroom.name }}</TableCell>
            <TableCell>{{ classroom.capacity }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editClassroom(classroom)">Sửa</Button>
              <Button variant="destructive" @click="deleteClassroom(classroom.id)">Xóa</Button>
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

interface Building {
  id: number;
  name: string;
}

interface Classroom {
  id: number;
  building_id: number;
  name: string;
  capacity: number;
  building?: Building;
}

const { $axios } = useNuxtApp();

const buildings = ref<Building[]>([]);
const classrooms = ref<Classroom[]>([]);
const newClassroom = ref<Classroom>({ id: 0, building_id: 0, name: '', capacity: 0 });
const loading = ref<boolean>(false);

const fetchBuildings = async () => {
  try {
    const response: AxiosResponse<Building[]> = await $axios.get('/buildings');
    buildings.value = response.data;
  } catch (error) {
    console.error('Error fetching buildings:', error);
  }
};

const fetchClassrooms = async () => {
  try {
    const response: AxiosResponse<Classroom[]> = await $axios.get('/rooms');
    classrooms.value = response.data;
  } catch (error) {
    console.error('Error fetching classrooms:', error);
  }
};

const createClassroom = async () => {
  try {
    loading.value = true;
    await $axios.post('/rooms', newClassroom.value);
    newClassroom.value = { id: 0, building_id: 0, name: '', capacity: 0 };
    await fetchClassrooms();
  } catch (error) {
    console.error('Error creating classroom:', error);
  } finally {
    loading.value = false;
  }
};

const editClassroom = (classroom: Classroom) => {
  // Placeholder for edit functionality
  console.log('Editing classroom:', classroom);
};

const deleteClassroom = async (id: number) => {
  try {
    await $axios.delete(`/rooms/${id}`);
    await fetchClassrooms();
  } catch (error) {
    console.error('Error deleting classroom:', error);
  }
};

onMounted(() => {
  fetchBuildings();
  fetchClassrooms();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>