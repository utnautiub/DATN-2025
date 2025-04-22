<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý học phí</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm học phí
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Học sinh</TableHead>
          <TableHead>Khóa học</TableHead>
          <TableHead>Số tiền</TableHead>
          <TableHead>Trạng thái</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="fee in fees" :key="fee.id">
          <TableCell>{{ fee.student_name }}</TableCell>
          <TableCell>{{ fee.course_name }}</TableCell>
          <TableCell>{{ fee.amount }}</TableCell>
          <TableCell>{{ fee.status }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(fee)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteFee(fee.id)">
              <Icon icon="heroicons:trash" class="h-4 w-4" />
            </Button>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>

    <!-- Create/Edit Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa học phí' : 'Thêm học phí' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Học sinh</Label>
            <Select v-model="form.student_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn học sinh" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="student in students" :key="student.id" :value="student.id">
                  {{ student.full_name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Khóa học</Label>
            <Select v-model="form.course_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn khóa học" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="course in courses" :key="course.id" :value="course.id">
                  {{ course.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Số tiền</Label>
            <Input v-model="form.amount" type="number" />
          </div>
          <div>
            <Label>Trạng thái</Label>
            <Select v-model="form.status">
              <SelectTrigger>
                <SelectValue placeholder="Chọn trạng thái" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="Pending">Chưa thanh toán</SelectItem>
                <SelectItem value="Paid">Đã thanh toán</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveFee">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
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

const fees = ref([])
const students = ref([])
const courses = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  student_id: null,
  course_id: null,
  amount: 0,
  status: ''
})

const fetchFees = async () => {
  try {
    const response = await $fetch('/api/fees')
    fees.value = response
  } catch (error) {
    console.error('Error fetching fees:', error)
  }
}

const fetchStudents = async () => {
  try {
    const response = await $fetch('/api/users?role=Student')
    students.value = response
  } catch (error) {
    console.error('Error fetching students:', error)
  }
}

const fetchCourses = async () => {
  try {
    const response = await $fetch('/api/courses')
    courses.value = response
  } catch (error) {
    console.error('Error fetching courses:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.student_id = null
  form.course_id = null
  form.amount = 0
  form.status = ''
  dialogOpen.value = true
}

const openEditDialog = (fee: any) => {
  isEditing.value = true
  form.id = fee.id
  form.student_id = fee.student_id
  form.course_id = fee.course_id
  form.amount = fee.amount
  form.status = fee.status
  dialogOpen.value = true
}

const saveFee = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/fees/${form.id}`, {
        method: 'PUT',
        body: { student_id: form.student_id, course_id: form.course_id, amount: form.amount, status: form.status }
      })
    } else {
      await $fetch('/api/fees', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchFees()
  } catch (error) {
    console.error('Error saving fee:', error)
  }
}

const deleteFee = async (id: number) => {
  try {
    await $fetch(`/api/fees/${id}`, { method: 'DELETE' })
    fetchFees()
  } catch (error) {
    console.error('Error deleting fee:', error)
  }
}

fetchFees()
fetchStudents()
fetchCourses()
</script>
