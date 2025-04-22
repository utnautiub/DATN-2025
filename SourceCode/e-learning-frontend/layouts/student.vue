<template>
  <div class="min-h-screen flex bg-background">
    <!-- Desktop Sidebar -->
    <aside class="hidden md:flex w-72 flex-col border-r">
      <div class="p-4 border-b">
        <NuxtLink to="/student/dashboard" class="text-xl font-bold">E-Learning Sinh viên</NuxtLink>
      </div>
      <nav class="flex-1 p-2">
        <ScrollArea class="h-[calc(100vh-5rem)]">
          <div class="space-y-1">
            <Button v-for="item in menuItems" :key="item.path"
              :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start">
              <NuxtLink :to="item.path" class="flex items-center w-full">
                <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                {{ item.label }}
              </NuxtLink>
            </Button>
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
                  <NuxtLink to="/student/dashboard" class="text-xl font-bold" @click="mobileMenuOpen = false">
                    E-Learning Sinh viên
                  </NuxtLink>
                </DrawerTitle>
                <Button variant="outline" size="icon" class="size-8" @click="mobileMenuOpen = false">
                  <Icon icon="heroicons:x-mark-20-solid" class="h-6 w-6" />
                </Button>
              </DrawerHeader>
              <ScrollArea class="h-[calc(100vh-4rem)]">
                <div class="p-4 space-y-1">
                  <Button v-for="item in menuItems" :key="item.path"
                    :variant="route.path === item.path ? 'secondary' : 'ghost'" class="w-full justify-start"
                    @click="mobileMenuOpen = false">
                    <NuxtLink :to="item.path" class="flex items-center w-full">
                      <Icon :icon="item.icon" class="mr-2 h-5 w-5" />
                      {{ item.label }}
                    </NuxtLink>
                  </Button>
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
                    <AvatarImage src="https://ui-avatars.com/api/?name=Student+User&background=4F46E5&color=fff"
                      alt="Avatar" />
                    <AvatarFallback>ST</AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent class="w-56" align="end">
                <DropdownMenuLabel>Tài khoản của tôi</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem>
                  <NuxtLink to="/student/profile" class="flex items-center">
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

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref } from 'vue'
import { useRoute, navigateTo } from '#app'

const route = useRoute()
const mobileMenuOpen = ref(false)

const menuItems = [
  {
    label: 'Dashboard',
    path: '/student/dashboard',
    icon: 'heroicons:chart-bar'
  },
  {
    label: 'Chương trình đào tạo',
    path: '/student/training-program',
    icon: 'heroicons:book-open'
  },
  {
    label: 'Đăng ký môn học',
    path: '/student/register-courses',
    icon: 'heroicons:plus-circle'
  },
  {
    label: 'Khóa học của tôi',
    path: '/student/my-courses',
    icon: 'heroicons:academic-cap'
  },
  {
    label: 'Lịch học và thi',
    path: '/student/schedule',
    icon: 'heroicons:calendar'
  },
  {
    label: 'Điểm danh',
    path: '/student/attendance',
    icon: 'heroicons:check-circle'
  },
  {
    label: 'Bài giảng',
    path: '/student/lessons',
    icon: 'heroicons:video-camera'
  },
  {
    label: 'Tài liệu học tập',
    path: '/student/resources',
    icon: 'heroicons:document-text'
  },
  {
    label: 'Lớp học trực tuyến',
    path: '/student/online-classes',
    icon: 'heroicons:video-camera'
  },
  {
    label: 'Bài tập',
    path: '/student/assignments',
    icon: 'heroicons:clipboard-document-list'
  },
  {
    label: 'Kiểm tra & Thi',
    path: '/student/exams',
    icon: 'heroicons:clipboard-document-check'
  },
  {
    label: 'Diễn đàn',
    path: '/student/forums',
    icon: 'heroicons:chat-bubble-left-right'
  },
  {
    label: 'Tin nhắn',
    path: '/student/messages',
    icon: 'heroicons:envelope'
  },
  {
    label: 'Phản hồi & Đánh giá',
    path: '/student/feedback',
    icon: 'heroicons:star'
  },
  {
    label: 'Thông báo',
    path: '/student/notifications',
    icon: 'heroicons:bell'
  },
  {
    label: 'Tiến độ học tập',
    path: '/student/progress',
    icon: 'heroicons:chart-pie'
  },
  {
    label: 'Điểm số',
    path: '/student/grades',
    icon: 'heroicons:chart-bar-square'
  },
  {
    label: 'Học phí',
    path: '/student/tuition',
    icon: 'heroicons:currency-dollar'
  },
  {
    label: 'Lịch sử giao dịch',
    path: '/student/transactions',
    icon: 'heroicons:receipt-refund'
  },
  {
    label: 'Cài đặt thông báo',
    path: '/student/notification-settings',
    icon: 'heroicons:cog-6-tooth'
  }
]

const logout = () => {
  localStorage.removeItem('user_role')
  navigateTo('/login')
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
