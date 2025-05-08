<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý tòa nhà</h1>

    <!-- Form to create a new building -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createBuilding" class="space-y-4">
        <div>
          <Label for="name">Tên tòa nhà</Label>
          <Input id="name" v-model="newBuilding.name" required />
        </div>
        <div>
          <Label>Chọn vị trí trên bản đồ</Label>
          <div style="height: 400px;">
            <ClientOnly>
              <l-map ref="map" :zoom="19" :max-zoom="19" :center="[newBuilding.latitude, newBuilding.longitude]"
                @click="onMapClick" style="height: 100%;">
                <l-tile-layer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  attribution='© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                  :max-zoom="19" />
                <l-marker :lat-lng="[newBuilding.latitude, newBuilding.longitude]" :draggable="true"
                  @update:lat-lng="onMarkerDrag" />
              </l-map>
            </ClientOnly>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <Label for="latitude">Vĩ độ (Latitude)</Label>
            <Input id="latitude" v-model="newBuilding.latitude" type="number" step="any" required readonly />
          </div>
          <div>
            <Label for="longitude">Kinh độ (Longitude)</Label>
            <Input id="longitude" v-model="newBuilding.longitude" type="number" step="any" required readonly />
          </div>
        </div>
        <Button type="submit" :disabled="loading">Thêm tòa nhà</Button>
      </form>
    </Card>

    <!-- Buildings List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên tòa nhà</TableHead>
            <TableHead>Vị trí</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="building in buildings" :key="building.id">
            <TableCell>{{ building.name }}</TableCell>
            <TableCell>{{ building.latitude }}, {{ building.longitude }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editBuilding(building)">Sửa</Button>
              <Button variant="destructive" @click="deleteBuilding(building.id)">Xóa</Button>
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
import { LMap, LTileLayer, LMarker } from '@vue-leaflet/vue-leaflet';

interface Building {
  id: number;
  name: string;
  latitude: number;
  longitude: number;
}

const { $axios } = useNuxtApp();

// Đặt vĩ độ và kinh độ mặc định theo yêu cầu
const buildings = ref<Building[]>([]);
const newBuilding = ref<Building>({
  id: 0,
  name: '',
  latitude: 21.007138467894272, // Vĩ độ mặc định
  longitude: 105.8249205350876, // Kinh độ mặc định
});
const loading = ref<boolean>(false);

const fetchBuildings = async () => {
  try {
    const response: AxiosResponse<Building[]> = await $axios.get('/buildings');
    buildings.value = response.data;
  } catch (error) {
    console.error('Error fetching buildings:', error);
  }
};

const createBuilding = async () => {
  try {
    loading.value = true;
    await $axios.post('/buildings', newBuilding.value);
    newBuilding.value = {
      id: 0,
      name: '',
      latitude: 21.007138467894272, // Reset về vĩ độ mặc định
      longitude: 105.8249205350876, // Reset về kinh độ mặc định
    };
    await fetchBuildings();
  } catch (error) {
    console.error('Error creating building:', error);
  } finally {
    loading.value = false;
  }
};

const editBuilding = (building: Building) => {
  // Placeholder for edit functionality
  console.log('Editing building:', building);
};

const deleteBuilding = async (id: number) => {
  try {
    await $axios.delete(`/buildings/${id}`);
    await fetchBuildings();
  } catch (error) {
    console.error('Error deleting building:', error);
  }
};

const onMapClick = (event: any) => {
  newBuilding.value.latitude = event.latlng.lat;
  newBuilding.value.longitude = event.latlng.lng;
};

const onMarkerDrag = (latLng: any) => {
  newBuilding.value.latitude = latLng.lat;
  newBuilding.value.longitude = latLng.lng;
};

onMounted(fetchBuildings);

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped>
/* Đảm bảo bản đồ hiển thị đúng */
:deep(.leaflet-container) {
  height: 100%;
  width: 100%;
}
</style>