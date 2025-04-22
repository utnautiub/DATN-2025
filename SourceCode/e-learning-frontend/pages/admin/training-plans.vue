<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý kế hoạch đào tạo</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm kế hoạch
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên kế hoạch</TableHead>
          <TableHead>Chương trình</TableHead>
          <TableHead>Học kỳ</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="plan in plans" :key="plan.id">
          <TableCell>{{ plan.name }}</TableCell>
          <TableCell>{{ plan.program_name }}</TableCell>
          <TableCell>{{ plan.semester }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(plan)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deletePlan(plan.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa kế hoạch' : 'Thêm kế hoạch' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên kế hoạch</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Chương trình</Label>
            <Select v-model="form.program_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn chương trình" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="program in programs" :key="program.id" :value="program.id">
                  {{ program.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Học kỳ</Label>
            <Input v-model="form.semester" />
          </div>
          <div>
            <Label>Môn học</Label>
            <Select v-model="form.subjects" multiple>
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
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="savePlan">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const plans = ref([])
const programs = ref([])
const subjects = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  program_id: null,
  semester: '',
  subjects: []
})

const fetchPlans = async () => {
  try {
    const response = await $fetch('/api/training-plans')
    plans.value = response
  } catch (error) {
    console.error('Error fetching plans:', error)
  }
}

const fetchPrograms = async () => {
  try {
    const response = await $fetch('/api/training-programs')
    programs.value = response
  } catch (error) {
    console.error('Error fetching programs:', error)
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

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.name = ''
  form.program_id = null
  form.semester = ''
  form.subjects = []
  dialogOpen.value = true
}

const openEditDialog = (plan: any) => {
  isEditing.value = true
  form.id = plan.id
  form.name = plan.name
  form.program_id = plan.program_id
  form.semester = plan.semester
  form.subjects = plan.subjects
  dialogOpen.value = true
}

const savePlan = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/training-plans/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, program_id: form.program_id, semester: form.semester, subjects: form.subjects }
      })
    } else {
      await $fetch('/api/training-plans', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchPlans()
  } catch (error) {
    console.error('Error saving plan:', error)
  }
}

const deletePlan = async (id: number) => {
  try {
    await $fetch(`/api/training-plans/${id}`, { method: 'DELETE' })
    fetchPlans()
  } catch (error) {
    console.error('Error deleting plan:', error)
  }
}

fetchPlans()
fetchPrograms()
fetchSubjects()
</script>
