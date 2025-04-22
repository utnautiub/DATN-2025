<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Báo cáo tài chính</h1>
    <Card>
      <CardHeader>
        <CardTitle>Lọc báo cáo</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="space-y-4">
          <div>
            <Label>Thời gian bắt đầu</Label>
            <Input v-model="filter.start_date" type="date" />
          </div>
          <div>
            <Label>Thời gian kết thúc</Label>
            <Input v-model="filter.end_date" type="date" />
          </div>
          <Button @click="fetchReports">Lọc</Button>
        </div>
      </CardContent>
    </Card>
    <Card>
      <CardHeader>
        <CardTitle>Kết quả báo cáo</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Ngày</TableHead>
              <TableHead>Doanh thu</TableHead>
              <TableHead>Chi phí</TableHead>
              <TableHead>Lợi nhuận</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="report in reports" :key="report.id">
              <TableCell>{{ report.date }}</TableCell>
              <TableCell>{{ report.revenue }}</TableCell>
              <TableCell>{{ report.expenses }}</TableCell>
              <TableCell>{{ report.profit }}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
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
  start_date: '',
  end_date: ''
})

const fetchReports = async () => {
  try {
    const response = await $fetch('/api/financial-reports', {
      query: { start_date: filter.start_date, end_date: filter.end_date }
    })
    reports.value = response
  } catch (error) {
    console.error('Error fetching reports:', error)
  }
}
</script>
