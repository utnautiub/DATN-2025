<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Học phí</h1>
      <Button variant="outline" size="sm" @click="fetchTuition">
        <Icon icon="heroicons:arrow-path" class="h-4 w-4 mr-2" />
        Làm mới
      </Button>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>Thông tin học phí</CardTitle>
        <CardDescription>Chi tiết học phí học kỳ hiện tại</CardDescription>
      </CardHeader>
      <CardContent class="space-y-4">
        <div class="grid gap-4 md:grid-cols-2">
          <div>
            <Label>Học kỳ</Label>
            <Input :value="tuition.semester" disabled class="bg-muted" />
          </div>
          <div>
            <Label>Số tiền</Label>
            <Input :value="formatCurrency(tuition.amount)" disabled class="bg-muted" />
          </div>
        </div>
        <div>
          <Label>Trạng thái</Label>
          <div class="mt-1">
            <Badge :variant="tuition.status === 'Paid' ? 'success' : 'warning'" class="text-sm">
              {{ tuition.status === 'Paid' ? 'Đã thanh toán' : 'Chưa thanh toán' }}
            </Badge>
          </div>
        </div>
        <div v-if="tuition.status !== 'Paid'" class="pt-4">
          <Button @click="payTuition" class="w-full md:w-auto" :disabled="isProcessing">
            <Icon v-if="!isProcessing" icon="heroicons:credit-card" class="h-4 w-4 mr-2" />
            <Icon v-else icon="heroicons:arrow-path" class="h-4 w-4 mr-2 animate-spin" />
            {{ isProcessing ? 'Đang xử lý...' : 'Thanh toán ngay' }}
          </Button>
        </div>
      </CardContent>
    </Card>

    <!-- Lịch sử thanh toán -->
    <Card v-if="paymentHistory.length > 0">
      <CardHeader>
        <CardTitle>Lịch sử thanh toán</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Ngày</TableHead>
              <TableHead>Học kỳ</TableHead>
              <TableHead>Số tiền</TableHead>
              <TableHead>Phương thức</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="payment in paymentHistory" :key="payment.id">
              <TableCell>{{ formatDate(payment.date) }}</TableCell>
              <TableCell>{{ payment.semester }}</TableCell>
              <TableCell>{{ formatCurrency(payment.amount) }}</TableCell>
              <TableCell>{{ payment.method }}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { navigateTo } from '#app'
import { toast } from 'vue-sonner'
import { Icon } from '@iconify/vue'

definePageMeta({
  layout: 'student',
})

const tuition = ref({
  semester: '',
  amount: 0,
  status: ''
})

const isProcessing = ref(false)

const paymentHistory = ref([
  {
    id: 1,
    date: '2024-01-15',
    semester: 'Học kỳ 2 - 2023-2024',
    amount: 5000000,
    method: 'Chuyển khoản'
  }
])

const demoTuition = {
  semester: "Học kỳ 1 - 2024-2025",
  amount: 5000000,
  status: "Unpaid"
}

onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'student') {
    navigateTo('/student/login')
  } else {
    fetchTuition()
  }
})

const fetchTuition = async () => {
  try {
    tuition.value = demoTuition
    // Uncomment để gọi API thực tế
    // const response = await $fetch('/api/student/tuition')
    // tuition.value = response
  } catch (error) {
    console.error('Error fetching tuition:', error)
    toast.error('Lỗi khi tải thông tin học phí')
  }
}

const payTuition = async () => {
  if (isProcessing.value) return

  try {
    isProcessing.value = true
    // Giả lập thời gian xử lý
    await new Promise(resolve => setTimeout(resolve, 2000))

    // Giả lập thanh toán (thay thế bằng logic thực tế)
    tuition.value.status = 'Paid'

    // Thêm vào lịch sử thanh toán
    paymentHistory.value.unshift({
      id: Date.now(),
      date: new Date().toISOString().split('T')[0],
      semester: tuition.value.semester,
      amount: tuition.value.amount,
      method: 'Chuyển khoản'
    })

    toast.success('Thanh toán học phí thành công!')

    // Uncomment để gọi API thực tế
    // await $fetch('/api/student/tuition/pay', {
    //   method: 'POST'
    // })
    // await fetchTuition()
  } catch (error) {
    console.error('Error paying tuition:', error)
    toast.error('Lỗi khi thanh toán học phí')
  } finally {
    isProcessing.value = false
  }
}

// Utility functions
const formatCurrency = (amount: number) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(amount)
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('vi-VN')
}
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
