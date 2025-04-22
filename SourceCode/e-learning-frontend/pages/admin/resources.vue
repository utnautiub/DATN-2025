<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý tài liệu</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm tài liệu
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên tài liệu</TableHead>
          <TableHead>Loại</TableHead>
          <TableHead>Ngày tải lên</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="resource in resources" :key="resource.id">
          <TableCell>{{ resource.title }}</TableCell>
          <TableCell>{{ resource.type }}</TableCell>
          <TableCell>{{ new Date(resource.uploaded_at).toLocaleDateString() }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(resource)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteResource(resource.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa tài liệu' : 'Thêm tài liệu' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên tài liệu</Label>
            <Input v-model="form.title" />
          </div>
          <div>
            <Label>Loại tài liệu</Label>
            <Select v-model="form.type">
              <SelectTrigger>
                <SelectValue placeholder="Chọn loại" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="Lecture">Bài giảng</SelectItem>
                <SelectItem value="Document">Tài liệu</SelectItem>
                <SelectItem value="Video">Video</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Tệp</Label>
            <Input type="file" @change="handleFileUpload" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveResource">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const resources = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  title: '',
  type: '',
  file: null
})

const fetchResources = async () => {
  try {
    const response = await $fetch('/api/resources')
    resources.value = response
  } catch (error) {
    console.error('Error fetching resources:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.title = ''
  form.type = ''
  form.file = null
  dialogOpen.value = true
}

const openEditDialog = (resource: any) => {
  isEditing.value = true
  form.id = resource.id
  form.title = resource.title
  form.type = resource.type
  form.file = null
  dialogOpen.value = true
}

const handleFileUpload = (event: any) => {
  form.file = event.target.files[0]
}

const saveResource = async () => {
  try {
    const formData = new FormData()
    formData.append('title', form.title)
    formData.append('type', form.type)
    if (form.file) formData.append('file', form.file)

    if (isEditing.value) {
      await $fetch(`/api/resources/${form.id}`, {
        method: 'PUT',
        body: formData
      })
    } else {
      await $fetch('/api/resources', {
        method: 'POST',
        body: formData
      })
    }
    dialogOpen.value = false
    fetchResources()
  } catch (error) {
    console.error('Error saving resource:', error)
  }
}

const deleteResource = async (id: number) => {
  try {
    await $fetch(`/api/resources/${id}`, { method: 'DELETE' })
    fetchResources()
  } catch (error) {
    console.error('Error deleting resource:', error)
  }
}

fetchResources()
</script>
