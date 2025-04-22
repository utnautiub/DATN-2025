<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý phòng học</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm phòng học
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên phòng</TableHead>
          <TableHead>Sức chứa</TableHead>
          <TableHead>Trang thiết bị</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="classroom in classrooms" :key="classroom.id">
          <TableCell>{{ classroom.name }}</TableCell>
          <TableCell>{{ classroom.capacity }}</TableCell>
          <TableCell>{{ classroom.equipment }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(classroom)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteClassroom(classroom.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa phòng học' : 'Thêm phòng học' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên phòng</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Sức chứa</Label>
            <Input v-model="form.capacity" type="number" />
          </div>
          <div>
            <Label>Trang thiết bị</Label>
            <Textarea v-model="form.equipment" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveClassroom">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref, reactive } from 'vue'
import { useLanguage } from '~/composables/useLanguage';

definePageMeta({
  layout: 'admin',
});

const { t } = useLanguage();

onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'admin') {
    navigateTo('/login');
  }
});

const classrooms = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  capacity: 0,
  equipment: ''
})

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
  form.name = ''
  form.capacity = 0
  form.equipment = ''
  dialogOpen.value = true
}

const openEditDialog = (classroom: any) => {
  isEditing.value = true
  form.id = classroom.id
  form.name = classroom.name
  form.capacity = classroom.capacity
  form.equipment = classroom.equipment
  dialogOpen.value = true
}

const saveClassroom = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/classrooms/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, capacity: form.capacity, equipment: form.equipment }
      })
    } else {
      await $fetch('/api/classrooms', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchClassrooms()
  } catch (error) {
    console.error('Error saving classroom:', error)
  }
}

const deleteClassroom = async (id: number) => {
  try {
    await $fetch(`/api/classrooms/${id}`, { method: 'DELETE' })
    fetchClassrooms()
  } catch (error) {
    console.error('Error deleting classroom:', error)
  }
}

fetchClassrooms()
</script>
