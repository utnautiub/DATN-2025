<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold">Chấm điểm</h1>
    <Card>
      <CardHeader>
        <CardTitle>Bài nộp của học viên</CardTitle>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Học viên</TableHead>
              <TableHead>Bài tập/Kiểm tra</TableHead>
              <TableHead>Trạng thái</TableHead>
              <TableHead>Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="submission in submissions" :key="submission.id">
              <TableCell>{{ submission.student_name }}</TableCell>
              <TableCell>{{ submission.title }}</TableCell>
              <TableCell>
                <Badge :variant="submission.status === 'Graded' ? 'success' : 'warning'">
                  {{ submission.status }}
                </Badge>
              </TableCell>
              <TableCell>
                <Button variant="outline" size="sm" @click="openGradeDialog(submission)">
                  <Icon icon="heroicons:pencil-square" class="h-4 w-4" />
                  Chấm điểm
                </Button>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>

    <!-- Grade Submission Dialog -->
    <Dialog v-model:open="dialogOpen">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Chấm điểm bài nộp</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Học viên</Label>
            <Input :value="form.student_name" disabled />
          </div>
          <div>
            <Label>Bài tập/Kiểm tra</Label>
            <Input :value="form.title" disabled />
          </div>
          <div>
            <Label>Điểm</Label>
            <Input v-model="form.score" type="number" />
          </div>
          <div>
            <Label>Phản hồi</Label>
            <Textarea v-model="form.feedback" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveGrade">Lưu điểm</Button>
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

const submissions = ref([])
const dialogOpen = ref(false)
const form = reactive({
  id: null,
  student_name: '',
  title: '',
  score: 0,
  feedback: ''
})

const fetchSubmissions = async () => {
  try {
    const response = await $fetch('/api/submissions')
    submissions.value = response
  } catch (error) {
    console.error('Error fetching submissions:', error)
  }
}

const openGradeDialog = (submission: any) => {
  form.id = submission.id
  form.student_name = submission.student_name
  form.title = submission.title
  form.score = submission.score || 0
  form.feedback = submission.feedback || ''
  dialogOpen.value = true
}

const saveGrade = async () => {
  try {
    await $fetch(`/api/submissions/${form.id}/grade`, {
      method: 'PUT',
      body: { score: form.score, feedback: form.feedback }
    })
    dialogOpen.value = false
    fetchSubmissions()
    useToast().success('Điểm đã được lưu!')
  } catch (error) {
    console.error('Error saving grade:', error)
    useToast().error('Lỗi khi lưu điểm.')
  }
}

fetchSubmissions()
</script>

<style scoped>
.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
