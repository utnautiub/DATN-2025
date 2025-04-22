<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Quản lý nhóm người dùng</h1>
      <Button @click="openCreateDialog">
        <Icon icon="heroicons:plus" class="mr-2 h-5 w-5" />
        Thêm nhóm
      </Button>
    </div>

    <!-- Table -->
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Tên nhóm</TableHead>
          <TableHead>Mô tả</TableHead>
          <TableHead>Số thành viên</TableHead>
          <TableHead>Hành động</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="group in groups" :key="group.id">
          <TableCell>{{ group.name }}</TableCell>
          <TableCell>{{ group.description }}</TableCell>
          <TableCell>{{ group.member_count }}</TableCell>
          <TableCell>
            <Button variant="outline" size="sm" @click="openEditDialog(group)" class="mr-2">
              <Icon icon="heroicons:pencil" class="h-4 w-4" />
            </Button>
            <Button variant="destructive" size="sm" @click="deleteGroup(group.id)">
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
          <DialogTitle>{{ isEditing ? 'Chỉnh sửa nhóm' : 'Thêm nhóm' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div>
            <Label>Tên nhóm</Label>
            <Input v-model="form.name" />
          </div>
          <div>
            <Label>Mô tả</Label>
            <Textarea v-model="form.description" />
          </div>
          <div>
            <Label>Thành viên</Label>
            <Select v-model="form.members" multiple>
              <SelectTrigger>
                <SelectValue placeholder="Chọn thành viên" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="user in users" :key="user.id" :value="user.id">
                  {{ user.full_name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="dialogOpen = false">Hủy</Button>
          <Button @click="saveGroup">{{ isEditing ? 'Cập nhật' : 'Thêm' }}</Button>
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

const groups = ref([])
const users = ref([])
const dialogOpen = ref(false)
const isEditing = ref(false)
const form = reactive({
  id: null,
  name: '',
  description: '',
  members: []
})

const fetchGroups = async () => {
  try {
    const response = await $fetch('/api/user-groups')
    groups.value = response
  } catch (error) {
    console.error('Error fetching groups:', error)
  }
}

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
  form.name = ''
  form.description = ''
  form.members = []
  dialogOpen.value = true
}

const openEditDialog = (group: any) => {
  isEditing.value = true
  form.id = group.id
  form.name = group.name
  form.description = group.description
  form.members = group.members
  dialogOpen.value = true
}

const saveGroup = async () => {
  try {
    if (isEditing.value) {
      await $fetch(`/api/user-groups/${form.id}`, {
        method: 'PUT',
        body: { name: form.name, description: form.description, members: form.members }
      })
    } else {
      await $fetch('/api/user-groups', {
        method: 'POST',
        body: form
      })
    }
    dialogOpen.value = false
    fetchGroups()
  } catch (error) {
    console.error('Error saving group:', error)
  }
}

const deleteGroup = async (id: number) => {
  try {
    await $fetch(`/api/user-groups/${id}`, { method: 'DELETE' })
    fetchGroups()
  } catch (error) {
    console.error('Error deleting group:', error)
  }
}

fetchGroups()
fetchUsers()
</script>
