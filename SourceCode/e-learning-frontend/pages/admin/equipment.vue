<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý sự cố thiết bị</h1>

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
            @change="fetchEquipmentItemsForRoom">
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
        <div v-if="error" class="text-red-500 text-sm">
          {{ error }}
        </div>
        <Button type="submit" :disabled="loading">Báo cáo sự cố</Button>
      </form>
    </Card>

    <!-- Equipment Reports List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Phòng học</TableHead>
            <TableHead>Tòa nhà</TableHead>
            <TableHead>Tên thiết bị</TableHead>
            <TableHead>Mã thiết bị</TableHead>
            <TableHead>Mô tả sự cố</TableHead>
            <TableHead>Trạng thái sự cố</TableHead>
            <TableHead>Người báo cáo</TableHead>
            <TableHead>Hành động</TableHead>
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
            <TableCell>{{ report.user?.username || 'N/A' }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="openEditReportModal(report)">Sửa</Button>
              <Button variant="destructive" @click="deleteReport(report.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- Edit Report Modal -->
    <Dialog v-model:open="showEditModal">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Sửa báo cáo sự cố</DialogTitle>
        </DialogHeader>
        <form @submit.prevent="updateReport" class="space-y-4">
          <div>
            <Label for="edit-description">Mô tả sự cố</Label>
            <Input id="edit-description" v-model="editReport.description" required />
          </div>
          <div>
            <Label for="edit-status">Trạng thái sự cố</Label>
            <select id="edit-status" v-model="editReport.status" required class="w-full px-4 py-2 border rounded-lg">
              <option value="Pending">Đang chờ xử lý</option>
              <option value="InProgress">Đang xử lý</option>
              <option value="Resolved">Đã giải quyết</option>
            </select>
          </div>
          <div v-if="error" class="text-red-500 text-sm">
            {{ error }}
          </div>
          <Button type="submit" :disabled="loading">Cập nhật</Button>
        </form>
      </DialogContent>
    </Dialog>
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
  user_id: number;
  description: string;
  status: string;
  equipment_item?: EquipmentItem;
  user?: { id: number; username: string };
}

const { $axios } = useNuxtApp();

const buildings = ref<Building[]>([]);
const rooms = ref<Room[]>([]);
const equipmentItems = ref<EquipmentItem[]>([]);
const reports = ref<EquipmentReport[]>([]);
const newReport = ref<EquipmentReport>({ id: 0, equipment_item_id: 0, user_id: 0, description: '', status: 'Pending' });
const editReport = ref<EquipmentReport>({ id: 0, equipment_item_id: 0, user_id: 0, description: '', status: 'Pending' });
const selectedBuildingId = ref<number>(0);
const selectedRoomId = ref<number>(0);
const loading = ref<boolean>(false);
const error = ref<string>('');
const showEditModal = ref<boolean>(false);

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
    const response: AxiosResponse<any[]> = await $axios.get('/room_equipments');
    equipmentItems.value = response.data.flatMap((equipment: any) =>
      (equipment.equipment_items || []).map((item: EquipmentItem) => ({
        ...item,
        room_equipment: {
          name: equipment.name,
          room: equipment.room
        }
      }))
    );
    console.log('Fetched equipment items:', equipmentItems.value);
  } catch (error) {
    console.error('Error fetching equipment items:', error);
  }
};

const fetchEquipmentItemsForRoom = async () => {
  if (selectedRoomId.value === 0) {
    equipmentItems.value = [];
    return;
  }
  try {
    const response: AxiosResponse<any[]> = await $axios.get('/room_equipments');
    equipmentItems.value = response.data
      .filter((equipment: any) => equipment.room?.id === selectedRoomId.value)
      .flatMap((equipment: any) =>
        (equipment.equipment_items || []).map((item: EquipmentItem) => ({
          ...item,
          room_equipment: {
            name: equipment.name,
            room: equipment.room
          }
        }))
      );
    console.log('Filtered equipment items for room:', equipmentItems.value);
  } catch (error) {
    console.error('Error fetching equipment items for room:', error);
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
    return [];
  }
  return equipmentItems.value.filter(item => item.room_equipment?.room?.id === selectedRoomId.value);
});

const createReport = async () => {
  try {
    loading.value = true;
    error.value = '';
    newReport.value.status = 'Pending'; // Đặt mặc định trạng thái là Pending
    await $axios.post('/equipment_reports', newReport.value);
    newReport.value = { id: 0, equipment_item_id: 0, user_id: 0, description: '', status: 'Pending' };
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

const openEditReportModal = (report: EquipmentReport) => {
  editReport.value = { ...report };
  showEditModal.value = true;
};

const updateReport = async () => {
  try {
    loading.value = true;
    error.value = '';
    await $axios.put(`/equipment_reports/${editReport.value.id}`, editReport.value);
    showEditModal.value = false;
    await fetchReports();
  } catch (error: any) {
    console.error('Error updating report:', error);
    error.value = error.response?.data?.error || 'Không thể cập nhật báo cáo. Vui lòng thử lại.';
  } finally {
    loading.value = false;
  }
};

const deleteReport = async (id: number) => {
  try {
    await $axios.delete(`/equipment_reports/${id}`);
    await fetchReports();
  } catch (error) {
    console.error('Error deleting report:', error);
  }
};

onMounted(() => {
  fetchBuildings();
  fetchRooms();
  fetchEquipmentItems();
  fetchReports();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>