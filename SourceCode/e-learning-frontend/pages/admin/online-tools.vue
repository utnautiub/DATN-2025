<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Cấu hình công cụ trực tuyến</h1>
    <Card class="p-6">
      <h2 class="text-xl font-semibold mb-4">Liên kết tài khoản Google cho giáo viên</h2>
      <div class="space-y-4">
        <div>
          <Label for="teacher_id">Giáo viên</Label>
          <select id="teacher_id" v-model="selectedTeacherId" class="w-full px-4 py-2 border rounded-lg">
            <option v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">{{ teacher.user?.username }}
            </option>
          </select>
        </div>
        <Button @click="linkGoogleAccount" :disabled="loading">Liên kết tài khoản Google</Button>
      </div>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import type { AxiosResponse } from 'axios';

interface Teacher {
  id: number;
  user?: { username: string };
}

const { $axios } = useNuxtApp();

const teachers = ref<Teacher[]>([]);
const selectedTeacherId = ref<string>('');
const loading = ref<boolean>(false);

const fetchTeachers = async () => {
  try {
    const response: AxiosResponse<Teacher[]> = await $axios.get('/teachers');
    teachers.value = response.data;
  } catch (error) {
    console.error('Error fetching teachers:', error);
  }
};

const linkGoogleAccount = async () => {
  try {
    loading.value = true;
    // Placeholder: Logic tích hợp Google OAuth sẽ được thêm sau
    console.log('Linking Google account for teacher:', selectedTeacherId.value);
  } catch (error) {
    console.error('Error linking Google account:', error);
  } finally {
    loading.value = false;
  }
};

onMounted(fetchTeachers);

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>