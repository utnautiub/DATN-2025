<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý lịch học</h1>

    <!-- Form to create a new schedule -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createSchedule" class="space-y-4">
        <div>
          <Label for="course_id">Lớp học phần</Label>
          <select id="course_id" v-model="newSchedule.course_id" required class="w-full px-4 py-2 border rounded-lg">
            <option v-for="course in courses" :key="course.id" :value="course.id">{{ course.name }}</option>
          </select>
        </div>
        <div>
          <Label for="day_of_week">Ngày trong tuần</Label>
          <Input id="day_of_week" v-model="newSchedule.day_of_week" required />
        </div>
        <div>
          <Label for="start_time">Thời gian bắt đầu</Label>
          <Input id="start_time" v-model="newSchedule.start_time" type="time" required />
        </div>
        <div>
          <Label for="end_time">Thời gian kết thúc</Label>
          <Input id="end_time" v-model="newSchedule.end_time" type="time" required />
        </div>
        <div>
          <Label for="room_id">Phòng học</Label>
          <select id="room_id" v-model="newSchedule.room_id" class="w-full px-4 py-2 border rounded-lg">
            <option v-for="room in rooms" :key="room.id" :value="room.id">{{ room.name }}</option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Thêm lịch học</Button>
      </form>
    </Card>

    <!-- Schedules List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Lớp học phần</TableHead>
            <TableHead>Ngày</TableHead>
            <TableHead>Thời gian</TableHead>
            <TableHead>Phòng học</TableHead>
            <TableHead>Link Google Meet</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="schedule in schedules" :key="schedule.id">
            <TableCell>{{ schedule.course?.name }}</TableCell>
            <TableCell>{{ schedule.day_of_week }}</TableCell>
            <TableCell>{{ schedule.start_time }} - {{ schedule.end_time }}</TableCell>
            <TableCell>{{ schedule.room?.name }}</TableCell>
            <TableCell>
              <a v-if="schedule.meet_link" :href="schedule.meet_link" target="_blank">Tham gia</a>
              <span v-else>Chưa tạo link</span>
            </TableCell>
            <TableCell>
              <Button variant="outline" @click="editSchedule(schedule)">Sửa</Button>
              <Button variant="destructive" @click="deleteSchedule(schedule.id)">Xóa</Button>
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

interface Course {
  id: number;
  name: string;
}

interface Room {
  id: number;
  name: string;
}

interface Schedule {
  id: number;
  course_id: number;
  class_id: number | null;
  day_of_week: string;
  start_time: string;
  end_time: string;
  room_id: number | null;
  meet_link: string | null;
  status: string;
  course?: Course;
  room?: Room;
}

const { $axios } = useNuxtApp();

const schedules = ref<Schedule[]>([]);
const courses = ref<Course[]>([]);
const rooms = ref<Room[]>([]);
const newSchedule = ref<{
  course_id: string;
  class_id: string;
  day_of_week: string;
  start_time: string;
  end_time: string;
  room_id: string;
}>({
  course_id: '',
  class_id: '',
  day_of_week: '',
  start_time: '',
  end_time: '',
  room_id: '',
});
const loading = ref<boolean>(false);

const fetchSchedules = async () => {
  try {
    const response: AxiosResponse<Schedule[]> = await $axios.get('/schedules');
    schedules.value = response.data;
  } catch (error) {
    console.error('Error fetching schedules:', error);
  }
};

const fetchCourses = async () => {
  try {
    const response: AxiosResponse<Course[]> = await $axios.get('/courses');
    courses.value = response.data;
  } catch (error) {
    console.error('Error fetching courses:', error);
  }
};

const fetchRooms = async () => {
  try {
    const response: AxiosResponse<Room[]> = await $axios.get('/rooms');
    rooms.value = response.data;
  } catch (error) {
    console.error('Error fetching rooms:', error);
  }
};

const createSchedule = async () => {
  try {
    loading.value = true;
    await $axios.post('/schedules', newSchedule.value);
    newSchedule.value = { course_id: '', class_id: '', day_of_week: '', start_time: '', end_time: '', room_id: '' };
    await fetchSchedules();
  } catch (error) {
    console.error('Error creating schedule:', error);
  } finally {
    loading.value = false;
  }
};

const editSchedule = (schedule: Schedule) => {
  // Placeholder for edit functionality
  console.log('Editing schedule:', schedule);
};

const deleteSchedule = async (id: number) => {
  try {
    await $axios.delete(`/schedules/${id}`);
    await fetchSchedules();
  } catch (error) {
    console.error('Error deleting schedule:', error);
  }
};

onMounted(() => {
  fetchSchedules();
  fetchCourses();
  fetchRooms();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>