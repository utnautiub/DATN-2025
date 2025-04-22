<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý điểm danh</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tạo buổi điểm danh
      </Button>
    </div>

    <Tabs default-value="attendance" class="space-y-4">
      <TabsList>
        <TabsTrigger value="attendance">Điểm danh</TabsTrigger>
        <TabsTrigger value="qr">Mã QR</TabsTrigger>
        <TabsTrigger value="gps">Phạm vi GPS</TabsTrigger>
        <TabsTrigger value="report">Báo cáo</TabsTrigger>
      </TabsList>

      <!-- Attendance Tab -->
      <TabsContent value="attendance">
        <Card>
          <CardHeader>
            <CardTitle>Điểm danh học viên</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Học viên</TableHead>
                  <TableHead>Lớp</TableHead>
                  <TableHead>Trạng thái</TableHead>
                  <TableHead>Thời gian</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="record in attendanceRecords" :key="record.id">
                  <TableCell>{{ record.student_name }}</TableCell>
                  <TableCell>{{ record.class_name }}</TableCell>
                  <TableCell>
                    <Badge :variant="record.status === 'Present' ? 'success' : 'destructive'">
                      {{ record.status }}
                    </Badge>
                  </TableCell>
                  <TableCell>{{ new Date(record.time).toLocaleString() }}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </TabsContent>

      <!-- QR Code Tab -->
      <TabsContent value="qr">
        <Card>
          <CardHeader>
            <CardTitle>Tạo mã QR cho điểm danh</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="flex items-center gap-4">
              <Select v-model="selectedClass">
                <SelectTrigger>
                  <SelectValue placeholder="Chọn lớp" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem v-for="classItem in classes" :key="classItem.id" :value="classItem.id">
                    {{ classItem.name }}
                  </SelectItem>
                </SelectContent>
              </Select>
              <Button @click="generateQRCode">Tạo mã QR</Button>
            </div>
            <div v-if="qrCode" class="mt-4 flex justify-center">
              <img :src="qrCode" alt="QR Code" class="h-48 w-48" />
            </div>
          </CardContent>
        </Card>
      </TabsContent>

      <!-- GPS Tab -->
      <TabsContent value="gps">
        <Card>
          <CardHeader>
            <CardTitle>Thiết lập phạm vi GPS</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="space-y-4">
              <div>
                <Label>Kinh độ</Label>
                <Input v-model="gpsSettings.latitude" type="number" step="0.0001" />
              </div>
              <div>
                <Label>Vĩ độ</Label>
                <Input v-model="gpsSettings.longitude" type="number" step="0.0001" />
              </div>
              <div>
                <Label>Bán kính (mét)</Label>
                <Input v-model="gpsSettings.radius" type="number" />
              </div>
              <Button @click="saveGPSSettings">Lưu phạm vi GPS</Button>
            </div>
          </CardContent>
        </Card>
      </TabsContent>

      <!-- Report Tab -->
      <TabsContent value="report">
        <Card>
          <CardHeader>
            <CardTitle>Báo cáo điểm danh</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Lớp</TableHead>
                  <TableHead>Ngày</TableHead>
                  <TableHead>Tỷ lệ hiện diện</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="report in attendanceReports" :key="report.id">
                  <TableCell>{{ report.class_name }}</TableCell>
                  <TableCell>{{ new Date(report.date).toLocaleDateString() }}</TableCell>
                  <TableCell>{{ report.attendance_rate }}%</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </TabsContent>
    </Tabs>

    <!-- Create Attendance Session Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Tạo buổi điểm danh</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Lớp học</Label>
            <Select v-model="form.class_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn lớp" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="classItem in classes" :key="classItem.id" :value="classItem.id">
                  {{ classItem.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Ngày điểm danh</Label>
            <Input v-model="form.date" type="date" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="createAttendanceSession">Tạo</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref, reactive } from 'vue'
import QRCode from 'qrcode'

definePageMeta({
  layout: 'teacher',
});

// Check if user is logged in and is teacher
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'teacher') {
    // Redirect to login if not logged in as teacher
    navigateTo('/teacher/login');
  }
});

const attendanceRecords = ref([])
const attendanceReports = ref([])
const classes = ref([])
const selectedClass = ref(null)
const qrCode = ref('')
const dialogOpen = ref(false)
const form = reactive({
  class_id: null,
  date: ''
})
const gpsSettings = reactive({
  latitude: 0,
  longitude: 0,
  radius: 100
})

const fetchAttendanceRecords = async () => {
  try {
    const response = await $fetch('/api/attendance')
    attendanceRecords.value = response
  } catch (error) {
    console.error('Error fetching attendance records:', error)
  }
}

const fetchAttendanceReports = async () => {
  try {
    const response = await $fetch('/api/attendance/reports')
    attendanceReports.value = response
  } catch (error) {
    console.error('Error fetching attendance reports:', error)
  }
}

const fetchClasses = async () => {
  try {
    const response = await $fetch('/api/classes?role=teacher')
    classes.value = response
  } catch (error) {
    console.error('Error fetching classes:', error)
  }
}

const generateQRCode = async () => {
  if (!selectedClass.value) {
    useToast().error('Vui lòng chọn lớp học!')
    return
  }
  try {
    const qrData = JSON.stringify({ class_id: selectedClass.value, timestamp: new Date().toISOString() })
    qrCode.value = await QRCode.toDataURL(qrData)
    useToast().success('Mã QR đã được tạo!')
  } catch (error) {
    console.error('Error generating QR code:', error)
    useToast().error('Lỗi khi tạo mã QR.')
  }
}

const saveGPSSettings = async () => {
  try {
    await $fetch('/api/attendance/gps', {
      method: 'PUT',
      body: gpsSettings
    })
    useToast().success('Phạm vi GPS đã được lưu!')
  } catch (error) {
    console.error('Error saving GPS settings:', error)
    useToast().error('Lỗi khi lưu phạm vi GPS.')
  }
}

const createAttendanceSession = async () => {
  try {
    await $fetch('/api/attendance/sessions', {
      method: 'POST',
      body: form
    })
    dialogOpen.value = false
    fetchAttendanceRecords()
    useToast().success('Buổi điểm danh đã được tạo!')
  } catch (error) {
    console.error('Error creating attendance session:', error)
    useToast().error('Lỗi khi tạo buổi điểm danh.')
  }
}

const openCreateDialog = () => {
  form.class_id = null
  form.date = ''
  dialogOpen.value = true
}

fetchAttendanceRecords()
fetchAttendanceReports()
fetchClasses()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
