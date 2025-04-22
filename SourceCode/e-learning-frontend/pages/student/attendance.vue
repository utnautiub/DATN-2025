<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Điểm danh</h1>

    <Tabs default-value="scan" class="space-y-4">
      <TabsList>
        <TabsTrigger value="scan">Quét QR Code</TabsTrigger>
        <TabsTrigger value="history">Lịch sử điểm danh</TabsTrigger>
      </TabsList>

      <!-- Scan QR Code Tab -->
      <TabsContent value="scan">
        <Card>
          <CardHeader>
            <CardTitle>Quét QR Code để điểm danh</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="space-y-4">
              <div v-if="!locationVerified" class="text-center">
                <p class="text-muted-foreground mb-4">Vui lòng xác thực vị trí để điểm danh</p>
                <div class="space-y-2">
                  <Button @click="verifyLocation" :disabled="isRequestingLocation" class="w-full md:w-auto">
                    <Icon :icon="isRequestingLocation ? 'heroicons:arrow-path' : 'heroicons:map-pin'"
                      class="h-4 w-4 mr-2" :class="{ 'animate-spin': isRequestingLocation }" />
                    {{ isRequestingLocation ? 'Đang xác thực...' : 'Xác thực vị trí GPS' }}
                  </Button>
                  <p v-if="locationPermission === 'denied'" class="text-sm text-red-500">
                    Bạn đã chặn quyền truy cập vị trí. Vui lòng cấp quyền trong cài đặt thiết bị.
                  </p>
                </div>
              </div>
              <div v-else>
                <p class="text-green-500 mb-4">Vị trí đã được xác thực!</p>
                <!-- Mini Map -->
                <div class="mb-4">
                  <p class="text-muted-foreground mb-2">Vị trí hiện tại của bạn:</p>
                  <ClientOnly>
                    <LMap style="height: 200px;" :center="mapCenter" :zoom="15">
                      <LTileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        attribution="&copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors" />
                      <LMarker :lat-lng="mapCenter" />
                    </LMap>
                  </ClientOnly>
                </div>
                <div class="flex justify-center">
                  <Button @click="scanQRCode">Quét QR Code</Button>
                </div>
                <div v-if="qrResult" class="mt-4 text-center">
                  <p class="text-green-500">Điểm danh thành công!</p>
                  <p>Lớp: {{ qrResult.class_name }}</p>
                  <p>Thời gian: {{ new Date(qrResult.time).toLocaleString() }}</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </TabsContent>

      <!-- Attendance History Tab -->
      <TabsContent value="history">
        <Card>
          <CardHeader>
            <CardTitle>Lịch sử điểm danh</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Lớp học</TableHead>
                  <TableHead>Thời gian</TableHead>
                  <TableHead>Trạng thái</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="record in attendanceRecords" :key="record.id">
                  <TableCell>{{ record.class_name }}</TableCell>
                  <TableCell>{{ new Date(record.time).toLocaleString() }}</TableCell>
                  <TableCell>
                    <Badge :variant="record.status === 'Present' ? 'success' : 'destructive'">
                      {{ record.status }}
                    </Badge>
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </TabsContent>
    </Tabs>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { navigateTo } from '#app'
import { toast } from 'vue-sonner'
import 'leaflet/dist/leaflet.css'
import { LMap, LTileLayer, LMarker } from '@vue-leaflet/vue-leaflet'

definePageMeta({
  layout: 'student',
})

const attendanceRecords = ref([])
const locationVerified = ref(false)
const qrResult = ref(null)
const mapCenter = ref([0, 0]) // [latitude, longitude]
const locationPermission = ref<PermissionState>('prompt') // 'granted' | 'denied' | 'prompt'
const isRequestingLocation = ref(false)

const demoAttendanceRecords = [
  {
    id: 1,
    class_name: "Lớp Toán 101",
    time: "2025-04-19T08:00:00Z",
    status: "Present"
  },
  {
    id: 2,
    class_name: "Lớp Văn 102",
    time: "2025-04-18T10:00:00Z",
    status: "Absent"
  }
]

onMounted(async () => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'student') {
    navigateTo('/student/login')
  } else {
    fetchAttendanceRecords()
    // Check location permission status
    try {
      const permission = await navigator.permissions.query({ name: 'geolocation' })
      locationPermission.value = permission.state

      // Listen for permission changes
      permission.addEventListener('change', () => {
        locationPermission.value = permission.state
        if (permission.state === 'granted') {
          getCurrentPosition()
        }
      })
    } catch (error) {
      console.error('Error checking location permission:', error)
    }
  }
})

const fetchAttendanceRecords = async () => {
  try {
    attendanceRecords.value = demoAttendanceRecords
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/student/attendance')
    // attendanceRecords.value = response
  } catch (error) {
    console.error('Error fetching attendance records:', error)
    toast.error('Lỗi khi tải lịch sử điểm danh')
  }
}

const requestLocationPermission = async () => {
  if (!navigator.geolocation) {
    toast.error('Trình duyệt không hỗ trợ định vị GPS')
    return
  }

  isRequestingLocation.value = true
  try {
    const position = await new Promise<GeolocationPosition>((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      })
    })

    const { latitude, longitude } = position.coords
    locationVerified.value = true
    mapCenter.value = [latitude, longitude]
    toast.success('Vị trí đã được xác thực!')

  } catch (error: any) {
    console.error('Error getting location:', error)
    let errorMessage = 'Không thể xác thực vị trí'

    switch (error.code) {
      case error.PERMISSION_DENIED:
        errorMessage = 'Vui lòng cấp quyền truy cập vị trí trong cài đặt thiết bị'
        break
      case error.POSITION_UNAVAILABLE:
        errorMessage = 'Không thể xác định vị trí. Vui lòng kiểm tra GPS'
        break
      case error.TIMEOUT:
        errorMessage = 'Hết thời gian yêu cầu vị trí. Vui lòng thử lại'
        break
    }
    toast.error(errorMessage)
  } finally {
    isRequestingLocation.value = false
  }
}

const getCurrentPosition = async () => {
  if (locationPermission.value === 'granted') {
    await requestLocationPermission()
  }
}

const verifyLocation = async () => {
  if (locationPermission.value === 'denied') {
    toast.error('Vui lòng cấp quyền truy cập vị trí trong cài đặt thiết bị')
    return
  }
  await requestLocationPermission()
}

const scanQRCode = async () => {
  toast.promise(
    new Promise((resolve) => {
      // Giả lập quét QR Code (thay thế bằng thư viện quét QR thực tế như @zxing/library)
      setTimeout(() => {
        const demoQRResult = {
          class_name: "Lớp Toán 101",
          time: new Date().toISOString()
        }
        qrResult.value = demoQRResult
        fetchAttendanceRecords()
        resolve(demoQRResult)
      }, 1000)
    }),
    {
      loading: 'Đang quét QR Code...',
      success: 'Điểm danh thành công!',
      error: 'Lỗi khi quét QR Code'
    }
  )
}
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* Add these styles to handle Leaflet images */
.leaflet-control-container .leaflet-control {
  z-index: 999;
}

.leaflet-pane {
  z-index: 20;
}
</style>
