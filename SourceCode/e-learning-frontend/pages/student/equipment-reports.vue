<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Báo cáo sự cố thiết bị</h1>

    <!-- Form to create a new equipment report -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createReport" class="space-y-4">
        <div>
          <Label for="building_id">Tòa nhà</Label>
          <select id="building_id" v-model="selectedBuildingId" class="w-full px-4 py-2 border rounded-lg"
            @change="fetchRooms">
            <option value="0">Chọn tòa nhà</option>
            <option v-for="building in buildings" :key="building.id" :value="building.id">
              {{ building.name }}
            </option>
          </select>
        </div>
        <div>
          <Label for="room_id">Phòng học</Label>
          <select id="room_id" v-model="selectedRoomId" class="w-full px-4 py-2 border rounded-lg"
            @change="fetchEquipmentItems">
            <option value="0">Chọn phòng học</option>
            <option v-for="room in filteredRooms" :key="room.id" :value="room.id">
              {{ room.name }} ({{ room.building?.name || 'N/A' }})
            </option>
          </select>
        </div>
        <div>
          <Label for="equipment_item_id">Thiết bị</Label>
          <select id="equipment_item_id" v-model="newReport.equipment_item_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="0">Chọn thiết bị</option>
            <option v-for="item in filteredEquipmentItems" :key="item.id" :value="item.id">
              {{ item.room_equipment?.name }} (Mã: {{ item.code }}) - {{ item.status }}
            </option>
          </select>
        </div>
        <div>
          <Label for="description">Mô tả sự cố</Label>
          <Input id="description" v-model="newReport.description" required />
        </div>
        <div>
          <Label for="status">Trạng thái sự cố</Label>
          <select id="status" v-model="newReport.status" required class="w-full px-4 py-2 border rounded-lg">
            <option value="Pending">Đang chờ xử lý</option>
            <option value="InProgress">Đang xử lý</option>
            <option value="Resolved">Đã giải quyết</option>
          </select>
        </div>
        <div v-if="error" class="text-red-500 text-sm">
          {{ error }}
        </div>
        <Button type="submit" :disabled="loading">Báo cáo sự cố</Button>
      </form>
    </Card>

    <!-- Student's Equipment Reports List -->
    <Card>
      <h2 class="text-xl font-bold mb-4">Danh sách báo cáo của bạn</h2>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Phòng học</TableHead>
            <TableHead>Tòa nhà</TableHead>
            <TableHead>Tên thiết bị</TableHead>
            <TableHead>Mã thiết bị</TableHead>
            <TableHead>Mô tả sự cố</TableHead>
            <TableHead>Trạng thái sự cố</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="report in reports" :key="report.id">
            <TableCell>{{ report.equipment_item?.room_equipment?.room?.name || 'N/A' }}</TableCell>
            <TableCell>{{ report.equipment_item?.room_equipment?.room?.building?.name || 'N/A' }}</TableCell>
            <TableCell>{{ report.equipment_item?.room_equipment?.name || 'N/A' }}</TableCell>
            <TableCell>{{ report.equipment_item?.code || 'N/A' }}</TableCell>
            <TableCell>{{ report.description }}</TableCell>
            <TableCell>{{ report.status }}</TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref, computed } from 'vue';
import type { AxiosResponse } from 'axios';

interface Building {
  id: number;
  name: string;
}

interface Room {
  id: number;
  name: string;
  building_id: number;
  building?: Building;
}

interface EquipmentItem {
  id: number;
  code: string;
  status: string;
  room_equipment?: {
    name: string;
    room?: Room;
  };
}

interface EquipmentReport {
  id: number;
  equipment_item_id: number;
  description: string;
  status: string;
  equipment_item?: EquipmentItem;
}

const { $axios } = useNuxtApp();

const buildings = ref<Building[]>([]);
const rooms = ref<Room[]>([]);
const equipmentItems = ref<EquipmentItem[]>([]);
const reports = ref<EquipmentReport[]>([]);
const newReport = ref<EquipmentReport>({ id: 0, equipment_item_id: 0, description: '', status: 'Pending' });
const selectedBuildingId = ref<number>(0);
const selectedRoomId = ref<number>(0);
const loading = ref<boolean>(false);
const error = ref<string>('');

const fetchBuildings = async () => {
  try {
    const response: AxiosResponse<Building[]> = await $axios.get('/buildings');
    buildings.value = response.data;
  } catch (error) {
    console.error('Error fetching buildings:', error);
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

const fetchEquipmentItems = async () => {
  try {
    const response: AxiosResponse<EquipmentItem[]> = await $axios.get('/room_equipments');
    equipmentItems.value = response.data.flatMap((equipment: any) => equipment.equipment_items || []);
  } catch (error) {
    console.error('Error fetching equipment items:', error);
  }
};

const fetchReports = async () => {
  try {
    const response: AxiosResponse<EquipmentReport[]> = await $axios.get('/equipment_reports');
    reports.value = response.data;
  } catch (error) {
    console.error('Error fetching reports:', error);
  }
};

const filteredRooms = computed(() => {
  if (selectedBuildingId.value === 0) {
    return rooms.value;
  }
  return rooms.value.filter(room => room.building_id === selectedBuildingId.value);
});

const filteredEquipmentItems = computed(() => {
  if (selectedRoomId.value === 0) {
    return equipmentItems.value;
  }
  return equipmentItems.value.filter(item => item.room_equipment?.room?.id === selectedRoomId.value);
});

const createReport = async () => {
  try {
    loading.value = true;
    error.value = '';
    await $axios.post('/equipment_reports', newReport.value);
    newReport.value = { id: 0, equipment_item_id: 0, description: '', status: 'Pending' };
    selectedBuildingId.value = 0;
    selectedRoomId.value = 0;
    await fetchReports();
  } catch (error: any) {
    console.error('Error creating report:', error);
    error.value = error.response?.data?.error || 'Không thể tạo báo cáo. Vui lòng thử lại.';
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchBuildings();
  fetchRooms();
  fetchEquipmentItems();
  fetchReports();
});

definePageMeta({
  layout: 'student',
});
</script>

<style scoped></style>