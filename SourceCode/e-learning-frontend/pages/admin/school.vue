<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Thông tin trường học</h1>

    <!-- School Details -->
    <Card class="p-6 mb-6">
      <div v-if="school" class="space-y-4">
        <div>
          <Label>Tên trường</Label>
          <p class="text-lg">{{ school.name }}</p>
        </div>
        <div>
          <Label>Địa chỉ</Label>
          <p>{{ school.address }}</p>
        </div>
        <div>
          <Label>Số điện thoại</Label>
          <p>{{ school.phone }}</p>
        </div>
        <div>
          <Label>Email</Label>
          <p>{{ school.email }}</p>
        </div>
      </div>
      <div v-else class="text-red-500">
        {{ error || 'Không tìm thấy thông tin trường học.' }}
      </div>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import type { AxiosResponse } from 'axios';

interface School {
  id: number;
  name: string;
  address: string;
  phone: string;
  email: string;
}

const { $axios } = useNuxtApp();

const school = ref<School | null>(null);
const error = ref<string>('');

const fetchSchool = async () => {
  try {
    const schoolId = 1; // Giả sử school_id của Admin Schools là 1, cần lấy từ @current_user nếu có
    const response: AxiosResponse<School> = await $axios.get(`/schools/${schoolId}`);
    school.value = response.data;
    console.log('Fetched school:', school.value);
  } catch (err: any) {
    console.error('Error fetching school:', err);
    error.value = err.response?.data?.error || 'Không thể tải thông tin trường học. Vui lòng thử lại.';
  }
};

onMounted(() => {
  fetchSchool();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>