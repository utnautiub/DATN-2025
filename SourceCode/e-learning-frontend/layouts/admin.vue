<template>
  <div class="min-h-screen flex bg-background">
    <!-- Desktop Sidebar -->
    <aside class="hidden md:flex w-72 flex-col border-r">
      <div class="p-4 border-b">
        <NuxtLink to="/admin/dashboard" class="text-xl font-bold">E-Learning Admin</NuxtLink>
      </div>
      <nav class="flex-1 p-2">
        <ScrollArea class="h-[calc(100vh-5rem)]">
          <div class="space-y-2">
            <!-- Tab Cụm 1 -->
            <div>
              <Button class="w-full justify-start" :variant="activeTab === 'cluster1' ? 'secondary' : 'ghost'"
                @click="activeTab = 'cluster1'">
                <Icon icon="heroicons:building-office" class="mr-2 h-5 w-5" />
                Quản lý cơ sở vật chất
              </Button>
              <div v-if="activeTab === 'cluster1'" class="pl-4 space-y-1">
                <Button v-for="item in cluster1Items" :key="item.path"
                  :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start">
                  <NuxtLink :to="item.path" class="flex items-center w-full">
                    <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                    {{ item.label }}
                  </NuxtLink>
                </Button>
              </div>
            </div>

            <!-- Tab Cụm 2 -->
            <div>
              <Button class="w-full justify-start" :variant="activeTab === 'cluster2' ? 'secondary' : 'ghost'"
                @click="activeTab = 'cluster2'">
                <Icon icon="heroicons:academic-cap" class="mr-2 h-5 w-5" />
                Quản lý chương trình đào tạo
              </Button>
              <div v-if="activeTab === 'cluster2'" class="pl-4 space-y-1">
                <Button v-for="item in cluster2Items" :key="item.path"
                  :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start">
                  <NuxtLink :to="item.path" class="flex items-center w-full">
                    <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                    {{ item.label }}
                  </NuxtLink>
                </Button>
              </div>
            </div>

            <!-- Tab Cụm 3 -->
            <div>
              <Button class="w-full justify-start" :variant="activeTab === 'cluster3' ? 'secondary' : 'ghost'"
                @click="activeTab = 'cluster3'">
                <Icon icon="heroicons:users" class="mr-2 h-5 w-5" />
                Quản lý học tập
              </Button>
              <div v-if="activeTab === 'cluster3'" class="pl-4 space-y-1">
                <Button v-for="item in cluster3Items" :key="item.path"
                  :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start">
                  <NuxtLink :to="item.path" class="flex items-center w-full">
                    <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                    {{ item.label }}
                  </NuxtLink>
                </Button>
              </div>
            </div>
          </div>
        </ScrollArea>
      </nav>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col">
      <!-- Header -->
      <header class="border-b flex items-center gap-4 p-2.5 sticky top-0 bg-background/80 backdrop-blur-md z-50">
        <div class="flex items-center justify-between md:justify-end gap-4 w-full">
          <!-- Mobile Menu Button -->
          <Drawer v-model:open="mobileMenuOpen">
            <DrawerTrigger asChild>
              <Button variant="outline" size="icon"
                class="border size-10 rounded-xl p-2 hover:bg-neutral-100 dark:hover:bg-neutral-900 transition-colors duration-300 md:hidden">
                <Icon icon="heroicons:bars-3-20-solid" class="h-6 w-6" />
              </Button>
            </DrawerTrigger>

            <DrawerContent class="min-h-[95%]">
              <DrawerHeader class="border-b p-4 flex justify-between">
                <DrawerTitle class="flex items-center gap-2">
                  <NuxtLink to="/admin/dashboard" class="text-xl font-bold" @click="mobileMenuOpen = false">
                    E-Learning Admin
                  </NuxtLink>
                </DrawerTitle>
                <Button variant="outline" size="icon" class="size-8" @click="mobileMenuOpen = false">
                  <Icon icon="heroicons:x-mark-20-solid" class="h-6 w-6" />
                </Button>
              </DrawerHeader>
              <ScrollArea class="h-[calc(100vh-4rem)]">
                <div class="p-4 space-y-2">
                  <!-- Tab Cụm 1 -->
                  <div>
                    <Button class="w-full justify-start" :variant="activeTab === 'cluster1' ? 'secondary' : 'ghost'"
                      @click="activeTab = 'cluster1'; mobileMenuOpen = false">
                      <Icon icon="heroicons:building-office" class="mr-2 h-5 w-5" />
                      Quản lý cơ sở vật chất
                    </Button>
                    <div v-if="activeTab === 'cluster1'" class="pl-4 space-y-1">
                      <Button v-for="item in cluster1Items" :key="item.path"
                        :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start"
                        @click="mobileMenuOpen = false">
                        <NuxtLink :to="item.path" class="flex items-center w-full">
                          <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                          {{ item.label }}
                        </NuxtLink>
                      </Button>
                    </div>
                  </div>

                  <!-- Tab Cụm 2 -->
                  <div>
                    <Button class="w-full justify-start" :variant="activeTab === 'cluster2' ? 'secondary' : 'ghost'"
                      @click="activeTab = 'cluster2'; mobileMenuOpen = false">
                      <Icon icon="heroicons:academic-cap" class="mr-2 h-5 w-5" />
                      Quản lý chương trình đào tạo
                    </Button>
                    <div v-if="activeTab === 'cluster2'" class="pl-4 space-y-1">
                      <Button v-for="item in cluster2Items" :key="item.path"
                        :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start"
                        @click="mobileMenuOpen = false">
                        <NuxtLink :to="item.path" class="flex items-center w-full">
                          <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                          {{ item.label }}
                        </NuxtLink>
                      </Button>
                    </div>
                  </div>

                  <!-- Tab Cụm 3 -->
                  <div>
                    <Button class="w-full justify-start" :variant="activeTab === 'cluster3' ? 'secondary' : 'ghost'"
                      @click="activeTab = 'cluster3'; mobileMenuOpen = false">
                      <Icon icon="heroicons:users" class="mr-2 h-5 w-5" />
                      Quản lý học tập
                    </Button>
                    <div v-if="activeTab === 'cluster3'" class="pl-4 space-y-1">
                      <Button v-for="item in cluster3Items" :key="item.path"
                        :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start"
                        @click="mobileMenuOpen = false">
                        <NuxtLink :to="item.path" class="flex items-center w-full">
                          <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                          {{ item.label }}
                        </NuxtLink>
                      </Button>
                    </div>
                  </div>
                </div>
              </ScrollArea>
            </DrawerContent>
          </Drawer>

          <!-- Actions -->
          <div class="flex items-center justify-end gap-2">
            <LanguageSelector />
            <ThemeSwitcher />

            <!-- User menu -->
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" class="relative h-10 w-10 rounded-full">
                  <Avatar class="h-8 w-8">
                    <AvatarImage src="https://ui-avatars.com/api/?name=Admin+User&background=0D8ABC&color=fff"
                      alt="Avatar" />
                    <AvatarFallback>AD</AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent class="w-56" align="end">
                <DropdownMenuLabel>Tài khoản của tôi</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem>
                  <NuxtLink to="/admin/profile" class="flex items-center">
                    <Icon icon="heroicons:user-circle" class="mr-2 h-4 w-4" />
                    <span>Hồ sơ</span>
                  </NuxtLink>
                </DropdownMenuItem>
                <DropdownMenuItem>
                  <Icon icon="heroicons:cog-6-tooth" class="mr-2 h-4 w-4" />
                  <span>Cài đặt</span>
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem class="text-red-600" @click="logout">
                  <Icon icon="heroicons:arrow-left-on-rectangle" class="mr-2 h-4 w-4" />
                  <span>Đăng xuất</span>
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </header>

      <!-- Page Content -->
      <main class="flex-1 overflow-auto p-6">
        <slot />
      </main>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { Icon } from '@iconify/vue';

const route = useRoute();
const router = useRouter();
const mobileMenuOpen = ref(false);
const activeTab = ref('cluster1');

// Menu items cho Cụm 1
const cluster1Items = [
  {
    label: 'Thông tin trường',
    path: '/admin/school',
    icon: 'heroicons:building-office',
  },
  {
    label: 'Quản lý tòa nhà',
    path: '/admin/buildings',
    icon: 'heroicons:building-office-2',
  },
  {
    label: 'Quản lý phòng học',
    path: '/admin/rooms',
    icon: 'heroicons:home',
  },
  {
    label: 'Quản lý thiết bị',
    path: '/admin/equipment',
    icon: 'heroicons:computer-desktop',
  },
  {
    label: 'Quản lý sự cố thiết bị',
    path: '/admin/equipment-reports',
    icon: 'heroicons:exclamation-triangle',
  },
];

// Menu items cho Cụm 2
const cluster2Items = [
  {
    label: 'Quản lý khoa',
    path: '/admin/departments',
    icon: 'heroicons:academic-cap',
  },
  {
    label: 'Quản lý ngành',
    path: '/admin/majors',
    icon: 'heroicons:book-open',
  },
  {
    label: 'Quản lý chương trình đào tạo',
    path: '/admin/training-programs',
    icon: 'heroicons:document-text',
  },
  {
    label: 'Quản lý môn học trong chương trình',
    path: '/admin/training-program-subjects',
    icon: 'heroicons:document-plus',
  },
  {
    label: 'Quản lý môn học',
    path: '/admin/subjects',
    icon: 'heroicons:clipboard-document',
  },
];

// Menu items cho Cụm 3
const cluster3Items = [
  {
    label: 'Dashboard',
    path: '/admin/dashboard',
    icon: 'heroicons:chart-bar',
  },
  {
    label: 'Quản lý người dùng',
    path: '/admin/users',
    icon: 'heroicons:users',
  },
  {
    label: 'Quản lý lớp học',
    path: '/admin/classes',
    icon: 'heroicons:building-office',
  },
  {
    label: 'Quản lý khóa học',
    path: '/admin/courses',
    icon: 'heroicons:book-open',
  },
  {
    label: 'Quản lý lịch học',
    path: '/admin/schedules',
    icon: 'heroicons:clock',
  },
  {
    label: 'Phân công môn học',
    path: '/admin/subject-assignments',
    icon: 'heroicons:academic-cap',
  },
  {
    label: 'Quản lý ghi danh',
    path: '/admin/enrollments',
    icon: 'heroicons:user-plus',
  },
];

const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('user_role');
  localStorage.removeItem('school_id');
  router.push('/login');
};
</script>

<style scoped></style>