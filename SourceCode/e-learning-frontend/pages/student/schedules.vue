<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Lịch học</h1>

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
  day_of_week: string;
  start_time: string;
  end_time: string;
  room_id: number | null;
  meet_link: string | null;
  course?: Course;
  room?: Room;
}

const { $axios } = useNuxtApp();

const schedules = ref<Schedule[]>([]);

const fetchSchedules = async () => {
  try {
    const response: AxiosResponse<Schedule[]> = await $axios.get('/schedules');
    schedules.value = response.data;
  } catch (error) {
    console.error('Error fetching schedules:', error);
  }
};

onMounted(fetchSchedules);

definePageMeta({
  layout: 'student',
});
</script>

<style scoped></style>