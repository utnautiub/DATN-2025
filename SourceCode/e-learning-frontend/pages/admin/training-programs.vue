<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý chương trình đào tạo</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm chương trình
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên chương trình</TableHead>
          <TableHead>Mô tả</TableHead>
          <TableHead>Thời gian</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="program in programs" :key="program.id">
          <TableCell>{{ program.name }}</TableCell>
          <TableCell>{{ program.description }}</TableCell>
          <TableCell>{{ program.duration }} tháng</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(program)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteProgram(program.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa chương trình' : 'Thêm chương trình' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên chương trình</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Mô tả</Label>
            <Textarea v-model="form.description" />
          </div>
          <div>
            <Label>Thời gian (tháng)</Label>
            <Input v-model="form.duration" type="number" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveProgram">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const programs = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  description: '',
  duration: 0
})

const fetchPrograms = async () => {
  try {
    const response = await $fetch('/api/training-programs')
    programs.value = response
  } catch (error) {
    console.error('Error fetching programs:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.name = ''
  form.description = ''
  form.duration = 0
  dialogOpen.value = true
}

const openEditDialog = (program: any) => {
  isEditing.value = true
  form.id = program.id
  form.name = program.name
  form.description = program.description
  form.duration = program.duration
  dialogOpen.value = true
}

const saveProgram = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/training-programs/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, description: form.description, duration: form.duration }
      })
    } else {
      await $fetch('/api/training-programs', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchPrograms()
  } catch (error) {
    console.error('Error saving program:', error)
  }
}

const deleteProgram = async (id: number) => {
  try {
    await $fetch(`/api/training-programs/${id}`, { method: 'DELETE' })
    fetchPrograms()
  } catch (error) {
    console.error('Error deleting program:', error)
  }
}

fetchPrograms()
</script>
