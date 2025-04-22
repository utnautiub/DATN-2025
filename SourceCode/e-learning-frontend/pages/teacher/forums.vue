<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Quản lý diễn đàn</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Tạo chủ đề
      </Button>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="flex justify-center items-center h-64">
      <div class="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-primary"></div>
    </div>

    <!-- Error or Empty State -->
    <div v-else-if="error" class="text-center text-red-500">
      {{ error }}
    </div>
    <div v-else-if="threads.length === 0" class="text-center text-muted-foreground">
      Chưa có chủ đề nào. Hãy tạo một chủ đề mới để bắt đầu thảo luận!
    </div>

    <!-- Thread List -->
    <Card v-else class="border border-border shadow-sm">
      <CardHeader>
        <CardTitle>Danh sách chủ đề</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tiêu đề</TableHead>
              <TableHead>Lớp học</TableHead>
              <TableHead>Số bài đăng</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="thread in threads" :key="thread.id">
              <TableCell>{{ thread.title }}</TableCell>
              <TableCell>{{ thread.class_name }}</TableCell>
              <TableCell>{{ thread.post_count }}</TableCell>
              <TableCell>
                <Button variant="outline" size="sm" as="NuxtLink" :to="`/teacher/forums/${thread.id}`" class="mr-2">
                  <Icon icon="heroicons:eye" class="h-4 w-4" />
                </Button>
                <Button variant="destructive" size="sm" @click="deleteThread(thread.id)">
                  <Icon icon="heroicons:trash" class="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Create Thread Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Tạo chủ đề mới</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tiêu đề</Label>
            <Input v-model="form.title" />
          </div>
          <div>
            <Label>Lớp học</Label>
            <Select v-model="form.class_id">
              <SelectTrigger>
                <SelectValue placeholder="Chọn lớp" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="classItem in classes" :key="classItem.id" :value="classItem.id">
                  {{ classItem.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Nội dung</Label>
            <Textarea v-model="form.content" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="createThread">Tạo</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref, reactive, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import { navigateTo } from '#app'

definePageMeta({
  layout: 'teacher',
})

// State variables
const threads = ref([])
const classes = ref([])
const dialogOpen = ref(false)
const form = reactive({
  title: '',
  class_id: null,
  content: ''
})
const isLoading = ref(true)
const error = ref(null)

// Dữ liệu mẫu
const demoThreads = [
  {
    id: 1,
    title: "Thảo luận bài tập tuần 1",
    class_name: "Lớp Toán 101",
    post_count: 5
  },
  {
    id: 2,
    title: "Hướng dẫn giải bài tập số 3",
    class_name: "Lớp Toán 101",
    post_count: 3
  },
  {
    id: 3,
    title: "Chia sẻ tài liệu ôn thi giữa kỳ",
    class_name: "Lớp Văn 102",
    post_count: 8
  },
  {
    id: 4,
    title: "Hỏi đáp về lịch thi cuối kỳ",
    class_name: "Lớp Hóa 103",
    post_count: 2
  }
]

const demoClasses = [
  { id: 1, name: "Lớp Toán 101" },
  { id: 2, name: "Lớp Văn 102" },
  { id: 3, name: "Lớp Hóa 103" }
]

// Check if user is logged in and is teacher
onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'teacher') {
    navigateTo('/teacher/login')
  } else {
    fetchThreads()
    fetchClasses()
  }
})

const fetchThreads = async () => {
  try {
    isLoading.value = true
    threads.value = demoThreads
    console.log('Threads loaded:', threads.value)
  } catch (err) {
    console.error('Error fetching threads:', err)
    error.value = 'Không thể tải danh sách chủ đề. Vui lòng thử lại sau.'
    toast.error(error.value)
  } finally {
    isLoading.value = false
  }
}

const fetchClasses = async () => {
  try {
    classes.value = demoClasses
    console.log('Classes loaded:', classes.value)
  } catch (error) {
    console.error('Error fetching classes:', error)
    toast.error('Lỗi khi tải danh sách lớp học.')
  }
}

const createThread = async () => {
  try {
    // Giả lập tạo chủ đề
    const newThread = {
      id: threads.value.length + 1,
      title: form.title,
      class_name: classes.value.find(c => c.id === form.class_id)?.name || 'Unknown',
      post_count: 0
    }
    threads.value.push(newThread)
    dialogOpen.value = false
    toast.success('Chủ đề đã được tạo thành công!')
  } catch (error) {
    console.error('Error creating thread:', error)
    toast.error('Lỗi khi tạo chủ đề.')
  }
}

const deleteThread = async (id) => {
  toast.promise(
    // Promise function
    async () => {
      // Giả lập xóa chủ đề
      await new Promise(resolve => setTimeout(resolve, 1000)) // Giả lập delay
      threads.value = threads.value.filter(thread => thread.id !== id)
    },
    {
      loading: 'Đang xóa chủ đề...',
      success: 'Chủ đề đã được xóa thành công!',
      error: 'Lỗi khi xóa chủ đề.'
    }
  )
}

const openCreateDialog = () => {
  form.title = ''
  form.class_id = null
  form.content = ''
  dialogOpen.value = true
}
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
