<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold">{{ t('admin.dashboard') }}</h1>
      <p class="text-gray-600">{{ t('admin.welcome') }}</p>
    </div>

    <!-- Stats Overview -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-primary/10 text-primary">
            <i class="fas fa-users text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">{{ t('admin.stats.totalUsers') }}</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">15,340</span>
              <span class="text-green-500 text-sm ml-2">+5.2%</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-indigo-100 text-indigo-600">
            <i class="fas fa-book text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">{{ t('admin.stats.courses') }}</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">1,204</span>
              <span class="text-green-500 text-sm ml-2">+12.8%</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-green-100 text-green-600">
            <i class="fas fa-graduation-cap text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">{{ t('admin.stats.completed') }}</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">8,742</span>
              <span class="text-green-500 text-sm ml-2">+3.7%</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
            <i class="fas fa-coins text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">{{ t('admin.stats.revenue') }}</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">249.5tr</span>
              <span class="text-green-500 text-sm ml-2">+8.3%</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity and New Users -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
      <!-- Recent Activity -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
          <h3 class="font-semibold">{{ t('admin.recentActivity.title') }}</h3>
          <button class="text-sm text-primary">{{ t('common.viewAll') }}</button>
        </div>
        <div class="p-4">
          <ul class="divide-y">
            <li class="py-3">
              <div class="flex items-center">
                <div class="h-10 w-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600">
                  <i class="fas fa-user-plus"></i>
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium">Một giảng viên mới đã đăng ký</p>
                  <span class="text-xs text-gray-500">5 phút trước</span>
                </div>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center">
                <div class="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                  <i class="fas fa-book"></i>
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium">Khóa học 'Flutter cơ bản' đã được xuất bản</p>
                  <span class="text-xs text-gray-500">30 phút trước</span>
                </div>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center">
                <div class="h-10 w-10 rounded-full bg-red-100 flex items-center justify-center text-red-600">
                  <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium">Báo cáo spam từ khóa học 'Marketing Digital'</p>
                  <span class="text-xs text-gray-500">1 giờ trước</span>
                </div>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center">
                <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                  <i class="fas fa-money-bill"></i>
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium">Giao dịch mới: 2,500,000đ</p>
                  <span class="text-xs text-gray-500">3 giờ trước</span>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <!-- New Users -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
          <h3 class="font-semibold">{{ t('admin.newUsers.title') }}</h3>
          <button class="text-sm text-primary">{{ t('common.viewAll') }}</button>
        </div>
        <div class="p-4">
          <ul class="divide-y">
            <li class="py-3 flex items-center justify-between">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Nguyen+Van+A&background=2563EB&color=fff" alt="User" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Nguyễn Văn A</p>
                  <p class="text-xs text-gray-500">student@example.com</p>
                </div>
              </div>
              <span class="text-xs bg-green-100 text-green-600 px-2 py-1 rounded-full">Học viên</span>
            </li>
            <li class="py-3 flex items-center justify-between">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Tran+Thi+B&background=7C3AED&color=fff" alt="User" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Trần Thị B</p>
                  <p class="text-xs text-gray-500">teacher@example.com</p>
                </div>
              </div>
              <span class="text-xs bg-indigo-100 text-indigo-600 px-2 py-1 rounded-full">Giảng viên</span>
            </li>
            <li class="py-3 flex items-center justify-between">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Le+Van+C&background=2563EB&color=fff" alt="User" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Lê Văn C</p>
                  <p class="text-xs text-gray-500">student2@example.com</p>
                </div>
              </div>
              <span class="text-xs bg-green-100 text-green-600 px-2 py-1 rounded-full">Học viên</span>
            </li>
            <li class="py-3 flex items-center justify-between">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Pham+Van+D&background=2563EB&color=fff" alt="User" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Phạm Văn D</p>
                  <p class="text-xs text-gray-500">student3@example.com</p>
                </div>
              </div>
              <span class="text-xs bg-green-100 text-green-600 px-2 py-1 rounded-full">Học viên</span>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="bg-white rounded-lg shadow p-6">
      <h3 class="font-semibold mb-4">{{ t('admin.quickActions.title') }}</h3>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-user-plus text-2xl text-primary mb-2"></i>
          <span class="text-sm">Thêm người dùng</span>
        </button>
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-book-medical text-2xl text-indigo-600 mb-2"></i>
          <span class="text-sm">Thêm khóa học</span>
        </button>
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-chart-line text-2xl text-green-600 mb-2"></i>
          <span class="text-sm">Báo cáo</span>
        </button>
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-cog text-2xl text-gray-600 mb-2"></i>
          <span class="text-sm">Cài đặt</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
// Admin dashboard page
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
</script>

<style scoped>
/* Custom styles for dashboard */
</style>
