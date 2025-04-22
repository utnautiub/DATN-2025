<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý diễn đàn</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm diễn đàn
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên diễn đàn</TableHead>
          <TableHead>Mô tả</TableHead>
          <TableHead>Số bài đăng</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="forum in forums" :key="forum.id">
          <TableCell>{{ forum.name }}</TableCell>
          <TableCell>{{ forum.description }}</TableCell>
          <TableCell>{{ forum.post_count }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(forum)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteForum(forum.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa diễn đàn' : 'Thêm diễn đàn' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên diễn đàn</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Mô tả</Label>
            <Textarea v-model="form.description" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveForum">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const forums = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  description: ''
})

const fetchForums = async () => {
  try {
    const response = await $fetch('/api/forums')
    forums.value = response
  } catch (error) {
    console.error('Error fetching forums:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.name = ''
  form.description = ''
  dialogOpen.value = true
}

const openEditDialog = (forum: any) => {
  isEditing.value = true
  form.id = forum.id
  form.name = forum.name
  form.description = forum.description
  dialogOpen.value = true
}

const saveForum = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/forums/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, description: form.description }
      })
    } else {
      await $fetch('/api/forums', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchForums()
  } catch (error) {
    console.error('Error saving forum:', error)
  }
}

const deleteForum = async (id: number) => {
  try {
    await $fetch(`/api/forums/${id}`, { method: 'DELETE' })
    fetchForums()
  } catch (error) {
    console.error('Error deleting forum:', error)
  }
}

fetchForums()
</script>
