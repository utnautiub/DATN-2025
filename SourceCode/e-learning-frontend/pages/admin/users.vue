<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý người dùng</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm người dùng
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Họ tên</TableHead>
          <TableHead>Email</TableHead>
          <TableHead>Vai trò</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="user in users" :key="user.id">
          <TableCell>{{ user.full_name }}</TableCell>
          <TableCell>{{ user.email }}</TableCell>
          <TableCell>{{ user.role }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(user)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteUser(user.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa người dùng' : 'Thêm người dùng' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Họ tên</Label>
            <Input v-model="form.full_name" />
          </div>
          <div>
            <Label>Email</Label>
            <Input v-model="form.email" type="email" />
          </div>
          <div>
            <Label>Vai trò</Label>
            <Select v-model="form.role">
              <SelectTrigger>
                <SelectValue placeholder="Chọn vai trò" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="Student">Học sinh</SelectItem>
                <SelectItem value="Teacher">Giáo viên</SelectItem>
                <SelectItem value="Admin">Quản trị viên</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div v-if="!isEditing">
            <Label>Mật khẩu</Label>
            <Input v-model="form.password" type="password" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveUser">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const users = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  full_name: '',
  email: '',
  role: '',
  password: ''
})

const fetchUsers = async () => {
  try {
    const response = await $fetch('/api/users')
    users.value = response
  } catch (error) {
    console.error('Error fetching users:', error)
  }
}

const openCreateDialog = () => {
  isEditing.value = false
  form.id = null
  form.full_name = ''
  form.email = ''
  form.role = ''
  form.password = ''
  dialogOpen.value = true
}

const openEditDialog = (user: any) => {
  isEditing.value = true
  form.id = user.id
  form.full_name = user.full_name
  form.email = user.email
  form.role = user.role
  dialogOpen.value = true
}

const saveUser = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/users/${form.id}`, {
        method: 'PUT',
        body: { full_name: form.full_name, email: form.email, role: form.role }
      })
    } else {
      await $fetch('/api/users', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchUsers()
  } catch (error) {
    console.error('Error saving user:', error)
  }
}

const deleteUser = async (id: number) => {
  try {
    await $fetch(`/api/users/${id}`, { method: 'DELETE' })
    fetchUsers()
  } catch (error) {
    console.error('Error deleting user:', error)
  }
}

fetchUsers()
</script>
