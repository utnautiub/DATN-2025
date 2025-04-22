<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý lịch học</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm lịch học
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Lớp học</TableHead>
          <TableHead>Thời gian</TableHead>
          <TableHead>Phòng học</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="schedule in schedules" :key="schedule.id">
          <TableCell>{{ schedule.class_name }}</TableCell>
          <TableCell>{{ schedule.start_time }} - {{ schedule.end_time }}</TableCell>
          <TableCell>{{ schedule.classroom_name }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(schedule)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteSchedule(schedule.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa lịch học' : 'Thêm lịch học' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Lớp học</Label>
            <Select v-model="form.class_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn lớp học" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="classItem in classes" :key="classItem.id" :value="classItem.id">
                  {{ classItem.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Thời gian bắt đầu</Label>
            <Input v-model="form.start_time" type="datetime-local" />
          </div>
          <div>
            <Label>Thời gian kết thúc</Label>
            <Input v-model="form.end_time" type="datetime-local" />
          </div>
          <div>
            <Label>Phòng học</Label>
            <Select v-model="form.classroom_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn phòng học" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="classroom in classrooms" :key="classroom.id" :value="classroom.id">
                  {{ classroom.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveSchedule">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const schedules = ref([])
const classes = ref([])
const classrooms = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  class_id: null,
  start_time: '',
  end_time: '',
  classroom_id: null
})

const fetchSchedules = async () => {
  try {
    const response = await $fetch('/api/schedules')
    schedules.value = response
  } catch (error) {
    console.error('Error fetching schedules:', error)
  }
}

const fetchClasses = async () => {
  try {
    const response = await $fetch('/api/classes')
    classes.value = response
  } catch (error) {
    console.error('Error fetching classes:', error)
  }
}

const fetchClassrooms = async () => {
  try {
    const response = await $fetch('/api/classrooms')
    classrooms.value = response
  } catch (error) {
    console.error('Error fetching classrooms:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.class_id = null
  form.start_time = ''
  form.end_time = ''
  form.classroom_id = null
  dialogOpen.value = true
}

const openEditDialog = (schedule: any) => {
  isEditing.value = true
  form.id = schedule.id
  form.class_id = schedule.class_id
  form.start_time = schedule.start_time
  form.end_time = schedule.end_time
  form.classroom_id = schedule.classroom_id
  dialogOpen.value = true
}

const saveSchedule = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/schedules/${form.id}`, {
        method: 'PUT',
        body: { class_id: form.class_id, start_time: form.start_time, end_time: form.end_time, classroom_id: form.classroom_id }
      })
    } else {
      await $fetch('/api/schedules', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchSchedules()
  } catch (error) {
    console.error('Error saving schedule:', error)
  }
}

const deleteSchedule = async (id: number) => {
  try {
    await $fetch(`/api/schedules/${id}`, { method: 'DELETE' })
    fetchSchedules()
  } catch (error) {
    console.error('Error deleting schedule:', error)
  }
}

fetchSchedules()
fetchClasses()
fetchClassrooms()
</script>
