<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold">Dashboard Giảng Viên</h1>
      <p class="text-gray-600">Xin chào Giảng viên, chào mừng trở lại với hệ thống quản lý khóa học.</p>
    </div>

    <!-- Stats Overview -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-indigo-100 text-indigo-600">
            <i class="fas fa-book text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">Khóa học của tôi</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">12</span>
              <span class="text-green-500 text-sm ml-2">+2 mới</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-blue-100 text-blue-600">
            <i class="fas fa-user-graduate text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">Học viên</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">256</span>
              <span class="text-green-500 text-sm ml-2">+14%</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
            <i class="fas fa-star text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">Đánh giá</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">4.8</span>
              <span class="text-green-500 text-sm ml-2">+0.2</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-green-100 text-green-600">
            <i class="fas fa-coins text-2xl"></i>
          </div>
          <div class="ml-4">
            <h3 class="text-gray-500 text-sm">Thu nhập</h3>
            <div class="flex items-center">
              <span class="text-2xl font-semibold">24.5tr</span>
              <span class="text-green-500 text-sm ml-2">+5.3%</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- My Courses and Students Activities -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
      <!-- My Courses -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
          <h3 class="font-semibold">Khóa học của tôi</h3>
          <button class="text-sm text-indigo-600">Xem tất cả</button>
        </div>
        <div class="p-4">
          <ul class="divide-y">
            <li class="py-3">
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <div class="h-12 w-12 rounded-lg bg-blue-100 flex items-center justify-center text-blue-600">
                    <i class="fas fa-code"></i>
                  </div>
                  <div class="ml-4">
                    <p class="text-sm font-medium">Fullstack Web Development</p>
                    <div class="flex items-center text-xs text-gray-500">
                      <span>142 học viên</span>
                      <span class="mx-2">•</span>
                      <div class="flex items-center">
                        <i class="fas fa-star text-yellow-400 mr-1"></i>
                        <span>4.9</span>
                      </div>
                    </div>
                  </div>
                </div>
                <span class="text-xs bg-green-100 text-green-600 px-2 py-1 rounded-full">Đang hoạt động</span>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <div class="h-12 w-12 rounded-lg bg-purple-100 flex items-center justify-center text-purple-600">
                    <i class="fas fa-mobile-alt"></i>
                  </div>
                  <div class="ml-4">
                    <p class="text-sm font-medium">Flutter for Beginners</p>
                    <div class="flex items-center text-xs text-gray-500">
                      <span>78 học viên</span>
                      <span class="mx-2">•</span>
                      <div class="flex items-center">
                        <i class="fas fa-star text-yellow-400 mr-1"></i>
                        <span>4.7</span>
                      </div>
                    </div>
                  </div>
                </div>
                <span class="text-xs bg-green-100 text-green-600 px-2 py-1 rounded-full">Đang hoạt động</span>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <div class="h-12 w-12 rounded-lg bg-green-100 flex items-center justify-center text-green-600">
                    <i class="fas fa-brain"></i>
                  </div>
                  <div class="ml-4">
                    <p class="text-sm font-medium">Machine Learning cơ bản</p>
                    <div class="flex items-center text-xs text-gray-500">
                      <span>36 học viên</span>
                      <span class="mx-2">•</span>
                      <div class="flex items-center">
                        <i class="fas fa-star text-yellow-400 mr-1"></i>
                        <span>4.8</span>
                      </div>
                    </div>
                  </div>
                </div>
                <span class="text-xs bg-yellow-100 text-yellow-600 px-2 py-1 rounded-full">Bản nháp</span>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <!-- Student Activities -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
          <h3 class="font-semibold">Hoạt động học viên</h3>
          <button class="text-sm text-indigo-600">Xem tất cả</button>
        </div>
        <div class="p-4">
          <ul class="divide-y">
            <li class="py-3">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Nguyen+Van+A&background=3B82F6&color=fff" alt="Student" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Nguyễn Văn A đã hoàn thành bài tập</p>
                  <p class="text-xs text-gray-500">Fullstack Web Development • 10 phút trước</p>
                </div>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Tran+Thi+B&background=3B82F6&color=fff" alt="Student" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Trần Thị B đã đặt câu hỏi</p>
                  <p class="text-xs text-gray-500">Machine Learning cơ bản • 30 phút trước</p>
                </div>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Le+Van+C&background=3B82F6&color=fff" alt="Student" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Lê Văn C đã đánh giá khóa học</p>
                  <p class="text-xs text-gray-500">Flutter for Beginners • 1 giờ trước</p>
                </div>
              </div>
            </li>
            <li class="py-3">
              <div class="flex items-center">
                <img src="https://ui-avatars.com/api/?name=Pham+Thi+D&background=3B82F6&color=fff" alt="Student" class="h-10 w-10 rounded-full">
                <div class="ml-4">
                  <p class="text-sm font-medium">Phạm Thị D đã đăng ký khóa học mới</p>
                  <p class="text-xs text-gray-500">Machine Learning cơ bản • 2 giờ trước</p>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="bg-white rounded-lg shadow p-6">
      <h3 class="font-semibold mb-4">Thao tác nhanh</h3>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-book-medical text-2xl text-indigo-600 mb-2"></i>
          <span class="text-sm">Tạo khóa học</span>
        </button>
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-tasks text-2xl text-blue-600 mb-2"></i>
          <span class="text-sm">Tạo bài tập</span>
        </button>
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-video text-2xl text-red-600 mb-2"></i>
          <span class="text-sm">Thêm video</span>
        </button>
        <button class="p-4 border rounded-lg hover:bg-gray-50 transition flex flex-col items-center justify-center">
          <i class="fas fa-users text-2xl text-green-600 mb-2"></i>
          <span class="text-sm">Xem học viên</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
// Teacher dashboard page

// Set the layout for this page
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
</script>

<style scoped>
/* Custom styles for dashboard */
</style>
