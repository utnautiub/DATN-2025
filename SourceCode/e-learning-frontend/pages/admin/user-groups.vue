<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý nhóm người dùng</h1>

    <!-- Form to create a new user group -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createUserGroup" class="space-y-4">
        <div>
          <Label for="name">Tên nhóm</Label>
          <Input id="name" v-model="newUserGroup.name" required />
        </div>
        <div>
          <Label for="description">Mô tả</Label>
          <Input id="description" v-model="newUserGroup.description" />
        </div>
        <div>
          <Label for="users">Người dùng</Label>
          <select id="users" v-model="newUserGroup.user_ids" multiple class="w-full px-4 py-2 border rounded-lg">
            <option v-for="user in users" :key="user.id" :value="user.id">{{ user.username }}</option>
          </select>
        </div>
        <Button type="submit" :disabled="loading">Tạo nhóm</Button>
      </form>
    </Card>

    <!-- User Groups List -->
    <Card>
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
          <TableRow v-for="group in userGroups" :key="group.id">
            <TableCell>{{ group.name }}</TableCell>
            <TableCell>{{ group.description }}</TableCell>
            <TableCell>{{ group.users?.length || 0 }}</TableCell>
            <TableCell>
              <Button variant="outline" @click="editUserGroup(group)">Sửa</Button>
              <Button variant="destructive" @click="deleteUserGroup(group.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import type { AxiosResponse } from 'axios';

interface User {
  id: number;
  username: string;
}

interface UserGroup {
  id: number;
  name: string;
  description: string;
  user_ids: number[];
  users?: User[];
}

const { $axios } = useNuxtApp();

const users = ref<User[]>([]);
const userGroups = ref<UserGroup[]>([]);
const newUserGroup = ref<UserGroup>({ id: 0, name: '', description: '', user_ids: [] });
const loading = ref<boolean>(false);

const fetchUsers = async () => {
  try {
    const response: AxiosResponse<User[]> = await $axios.get('/users');
    users.value = response.data;
  } catch (error) {
    console.error('Error fetching users:', error);
  }
};

const fetchUserGroups = async () => {
  try {
    const response: AxiosResponse<UserGroup[]> = await $axios.get('/user_groups');
    userGroups.value = response.data;
  } catch (error) {
    console.error('Error fetching user groups:', error);
  }
};

const createUserGroup = async () => {
  try {
    loading.value = true;
    await $axios.post('/user_groups', newUserGroup.value);
    newUserGroup.value = { id: 0, name: '', description: '', user_ids: [] };
    await fetchUserGroups();
  } catch (error) {
    console.error('Error creating user group:', error);
  } finally {
    loading.value = false;
  }
};

const editUserGroup = (group: UserGroup) => {
  // Placeholder for edit functionality
  console.log('Editing user group:', group);
};

const deleteUserGroup = async (id: number) => {
  try {
    await $axios.delete(`/user_groups/${id}`);
    await fetchUserGroups();
  } catch (error) {
    console.error('Error deleting user group:', error);
  }
};

onMounted(() => {
  fetchUsers();
  fetchUserGroups();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>