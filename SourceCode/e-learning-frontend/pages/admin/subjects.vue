<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý môn học</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm môn học
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên môn học</TableHead>
          <TableHead>Mã môn học</TableHead>
          <TableHead>Số tín chỉ</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="subject in subjects" :key="subject.id">
          <TableCell>{{ subject.name }}</TableCell>
          <TableCell>{{ subject.code }}</TableCell>
          <TableCell>{{ subject.credits }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(subject)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteSubject(subject.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa môn học' : 'Thêm môn học' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên môn học</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Mã môn học</Label>
            <Input v-model="form.code" />
          </div>
          <div>
            <Label>Số tín chỉ</Label>
            <Input v-model="form.credits" type="number" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveSubject">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const subjects = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  code: '',
  credits: 0
})

const fetchSubjects = async () => {
  try {
    const response = await $fetch('/api/subjects')
    subjects.value = response
  } catch (error) {
    console.error('Error fetching subjects:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.name = ''
  form.code = ''
  form.credits = 0
  dialogOpen.value = true
}

const openEditDialog = (subject: any) => {
  isEditing.value = true
  form.id = subject.id
  form.name = subject.name
  form.code = subject.code
  form.credits = subject.credits
  dialogOpen.value = true
}

const saveSubject = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/subjects/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, code: form.code, credits: form.credits }
      })
    } else {
      await $fetch('/api/subjects', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchSubjects()
  } catch (error) {
    console.error('Error saving subject:', error)
  }
}

const deleteSubject = async (id: number) => {
  try {
    await $fetch(`/api/subjects/${id}`, { method: 'DELETE' })
    fetchSubjects()
  } catch (error) {
    console.error('Error deleting subject:', error)
  }
}

fetchSubjects()
</script>
