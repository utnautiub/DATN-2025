<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý lớp học</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm lớp học
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên lớp</TableHead>
          <TableHead>Môn học</TableHead>
          <TableHead>Giảng viên</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="classItem in classes" :key="classItem.id">
          <TableCell>{{ classItem.name }}</TableCell>
          <TableCell>{{ classItem.subject_name }}</TableCell>
          <TableCell>{{ classItem.teacher_name }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(classItem)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteClass(classItem.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa lớp học' : 'Thêm lớp học' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên lớp</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Môn học</Label>
            <Select v-model="form.subject_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn môn học" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="subject in subjects" :key="subject.id" :value="subject.id">
                  {{ subject.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Giảng viên</Label>
            <Select v-model="form.teacher_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn giảng viên" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="teacher in teachers" :key="teacher.id" :value="teacher.id">
                  {{ teacher.full_name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveClass">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const classes = ref([])
const subjects = ref([])
const teachers = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  subject_id: null,
  teacher_id: null
})

const fetchClasses = async () => {
  try {
    const response = await $fetch('/api/classes')
    classes.value = response
  } catch (error) {
    console.error('Error fetching classes:', error)
  }
}

const fetchSubjects = async () => {
  try {
    const response = await $fetch('/api/subjects')
    subjects.value = response
  } catch (error) {
    console.error('Error fetching subjects:', error)
  }
}

const fetchTeachers = async () => {
  try {
    const response = await $fetch('/api/users?role=Teacher')
    teachers.value = response
  } catch (error) {
    console.error('Error fetching teachers:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.name = ''
  form.subject_id = null
  form.teacher_id = null
  dialogOpen.value = true
}

const openEditDialog = (classItem: any) => {
  isEditing.value = true
  form.id = classItem.id
  form.name = classItem.name
  form.subject_id = classItem.subject_id
  form.teacher_id = classItem.teacher_id
  dialogOpen.value = true
}

const saveClass = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/classes/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, subject_id: form.subject_id, teacher_id: form.teacher_id }
      })
    } else {
      await $fetch('/api/classes', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchClasses()
  } catch (error) {
    console.error('Error saving class:', error)
  }
}

const deleteClass = async (id: number) => {
  try {
    await $fetch(`/api/classes/${id}`, { method: 'DELETE' })
    fetchClasses()
  } catch (error) {
    console.error('Error deleting class:', error)
  }
}

fetchClasses()
fetchSubjects()
fetchTeachers()
</script>
