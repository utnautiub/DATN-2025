<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý tài liệu</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tải lên tài liệu
      </Button>
    </div>
    <Card>
      <CardHeader>
        <CardTitle>Danh sách tài liệu</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tiêu đề</TableHead>
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
                <Button variant="outline" size="sm" @click="downloadResource(resource.url)" class="mr-2">
                  <Icon icon="heroicons:download" class="h-4 w-4" />
                </Button>
                <Button variant="destructive" size="sm" @click="deleteResource(resource.id)">
                  <Icon icon="heroicons:trash" class="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Upload Resource Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Tải lên tài liệu</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tiêu đề</Label>
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
          <Button @click="uploadResource">Tải lên</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref, reactive } from 'vue'

definePageMeta({
  layout: 'teacher',
});

// Check if user is logged in and is teacher
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'teacher') {
    // Redirect to login if not logged in as teacher
    navigateTo('/teacher/login');
  }
});

const resources = ref([])
const dialogOpen = ref(false)
const form = reactive({
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

const handleFileUpload = (event: any) => {
  form.file = event.target.files[0]
}

const uploadResource = async () => {
  try {
    const formData = new FormData()
    formData.append('title', form.title)
    formData.append('type', form.type)
    if (form.file) formData.append('file', form.file)

    await $fetch('/api/resources', {
      method: 'POST',
      body: formData
    })
    dialogOpen.value = false
    fetchResources()
    useToast().success('Tài liệu đã được tải lên!')
  } catch (error) {
    console.error('Error uploading resource:', error)
    useToast().error('Lỗi khi tải lên tài liệu.')
  }
}

const deleteResource = async (id: number) => {
  try {
    await $fetch(`/api/resources/${id}`, { method: 'DELETE' })
    fetchResources()
    useToast().success('Tài liệu đã được xóa!')
  } catch (error) {
    console.error('Error deleting resource:', error)
    useToast().error('Lỗi khi xóa tài liệu.')
  }
}

const downloadResource = (url: string) => {
  window.open(url, '_blank')
}

fetchResources()
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
