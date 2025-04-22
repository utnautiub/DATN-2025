<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Báo cáo tổng thể</h1>
    <Card>
      <CardHeader>
        <CardTitle>Lọc báo cáo</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="space-y-4">
          <div>
            <Label>Loại báo cáo</Label>
            <Select v-model="filter.report_type">
              <SelectTrigger>
                <SelectValue placeholder="Chọn loại báo cáo" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="users">Người dùng</SelectItem>
                <SelectItem value="courses">Khóa học</SelectItem>
                <SelectItem value="learning">Học tập</SelectItem>
                <SelectItem value="financial">Tài chính</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <Label>Thời gian bắt đầu</Label>
              <Input v-model="filter.start_date" type="date" />
            </div>
            <div>
              <Label>Thời gian kết thúc</Label>
              <Input v-model="filter.end_date" type="date" />
            </div>
          </div>
          <Button @click="fetchReports">Tạo báo cáo</Button>
        </div>
      </CardContent>
    </Card>

    <Card>
      <CardHeader>
        <CardTitle>Kết quả báo cáo</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="reports.length === 0" class="text-center text-gray-500">
          Chưa có dữ liệu báo cáo. Vui lòng chọn loại báo cáo và lọc.
        </div>
        <div v-else>
          <!-- User Report -->
          <div v-if="filter.report_type === 'users'">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Vai trò</TableHead>
                  <TableHead>Số lượng</TableHead>
                  <TableHead>Tăng trưởng</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="report in reports" :key="report.role">
                  <TableCell>{{ report.role }}</TableCell>
                  <TableCell>{{ report.count }}</TableCell>
                  <TableCell>{{ report.growth }}%</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>
          <!-- Course Report -->
          <div v-if="filter.report_type === 'courses'">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Khóa học</TableHead>
                  <TableHead>Số học sinh</TableHead>
                  <TableHead>Tỷ lệ hoàn thành</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="report in reports" :key="report.course_id">
                  <TableCell>{{ report.course_name }}</TableCell>
                  <TableCell>{{ report.student_count }}</TableCell>
                  <TableCell>{{ report.completion_rate }}%</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>
          <!-- Learning Report -->
          <div v-if="filter.report_type === 'learning'">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Lớp học</TableHead>
                  <TableHead>Tiến độ trung bình</TableHead>
                  <TableHead>Số bài tập hoàn thành</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="report in reports" :key="report.class_id">
                  <TableCell>{{ report.class_name }}</TableCell>
                  <TableCell>{{ report.average_progress }}%</TableCell>
                  <TableCell>{{ report.completed_assignments }}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>
          <!-- Financial Report -->
          <div v-if="filter.report_type === 'financial'">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Tháng</TableHead>
                  <TableHead>Doanh thu</TableHead>
                  <TableHead>Chi phí</TableHead>
                  <TableHead>Lợi nhuận</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="report in reports" :key="report.month">
                  <TableCell>{{ report.month }}</TableCell>
                  <TableCell>{{ report.revenue }}</TableCell>
                  <TableCell>{{ report.expenses }}</TableCell>
                  <TableCell>{{ report.profit }}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useLanguage } from '~/composables/useLanguage';

// Set the layout for this page
definePageMeta({
  layout: 'admin',
});

// Get translations
const { t } = useLanguage();

// Check if user is logged in and is admin
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'admin') {
    // Redirect to login if not logged in as admin
    navigateTo('/login');
  }
});

const reports = ref([])
const filter = reactive({
  report_type: '',
  start_date: '',
  end_date: ''
})

const fetchReports = async () => {
  try {
    const response = await $fetch('/api/reports', {
      query: {
        report_type: filter.report_type,
        start_date: filter.start_date,
        end_date: filter.end_date
      }
    })
    reports.value = response
  } catch (error) {
    console.error('Error fetching reports:', error)
  }
}
</script>
