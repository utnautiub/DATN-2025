<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold">Dashboard Học Viên</h1>
      <p class="text-gray-600">Xin chào <span class="font-medium">Nguyễn Văn A</span>, chào mừng trở lại với hành trình học tập của bạn.</p>
    </div>

    <!-- Course Progress Overview -->
    <div class="bg-white rounded-lg shadow-md p-6 mb-6">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-lg font-semibold">Tiến độ học tập</h2>
        <NuxtLink to="/student/progress" class="text-sm text-green-600 hover:text-green-700">Xem tất cả</NuxtLink>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <!-- Course 1 -->
        <div class="border rounded-lg p-4 hover:shadow-md transition">
          <div class="flex items-center justify-between mb-3">
            <h3 class="font-medium">Fullstack Web Development</h3>
            <span class="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full">Đang học</span>
          </div>
          <div class="mb-2">
            <div class="flex items-center justify-between text-sm text-gray-600 mb-1">
              <span>Tiến độ</span>
              <span>45%</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-green-600 h-2 rounded-full" style="width: 45%"></div>
            </div>
          </div>
          <div class="text-sm text-gray-600">
            <p>Bài học tiếp theo: <span class="font-medium">JavaScript Promises</span></p>
            <p class="mt-1">Thời gian còn lại: <span class="font-medium">4 giờ 30 phút</span></p>
          </div>
          <NuxtLink 
            to="/student/courses/1" 
            class="mt-3 text-center block w-full py-2 bg-green-600 hover:bg-green-700 text-white rounded-md transition"
          >
            Tiếp tục học
          </NuxtLink>
        </div>

        <!-- Course 2 -->
        <div class="border rounded-lg p-4 hover:shadow-md transition">
          <div class="flex items-center justify-between mb-3">
            <h3 class="font-medium">Flutter for Beginners</h3>
            <span class="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full">Đang học</span>
          </div>
          <div class="mb-2">
            <div class="flex items-center justify-between text-sm text-gray-600 mb-1">
              <span>Tiến độ</span>
              <span>20%</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-green-600 h-2 rounded-full" style="width: 20%"></div>
            </div>
          </div>
          <div class="text-sm text-gray-600">
            <p>Bài học tiếp theo: <span class="font-medium">Flutter Layouts</span></p>
            <p class="mt-1">Thời gian còn lại: <span class="font-medium">9 giờ 15 phút</span></p>
          </div>
          <NuxtLink 
            to="/student/courses/2" 
            class="mt-3 text-center block w-full py-2 bg-green-600 hover:bg-green-700 text-white rounded-md transition"
          >
            Tiếp tục học
          </NuxtLink>
        </div>

        <!-- Course 3 -->
        <div class="border rounded-lg p-4 hover:shadow-md transition">
          <div class="flex items-center justify-between mb-3">
            <h3 class="font-medium">Machine Learning cơ bản</h3>
            <span class="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full">Mới đăng ký</span>
          </div>
          <div class="mb-2">
            <div class="flex items-center justify-between text-sm text-gray-600 mb-1">
              <span>Tiến độ</span>
              <span>0%</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-green-600 h-2 rounded-full" style="width: 0%"></div>
            </div>
          </div>
          <div class="text-sm text-gray-600">
            <p>Bài học tiếp theo: <span class="font-medium">Giới thiệu về ML</span></p>
            <p class="mt-1">Thời gian ước tính: <span class="font-medium">12 giờ</span></p>
          </div>
          <NuxtLink 
            to="/student/courses/3" 
            class="mt-3 text-center block w-full py-2 bg-green-600 hover:bg-green-700 text-white rounded-md transition"
          >
            Bắt đầu học
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- Upcoming Assignments and Recommended Courses -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
      <!-- Upcoming Assignments -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-lg font-semibold">Bài tập sắp đến hạn</h2>
          <NuxtLink to="/student/assignments" class="text-sm text-green-600 hover:text-green-700">Xem tất cả</NuxtLink>
        </div>

        <ul class="divide-y">
          <li class="py-3 first:pt-0 last:pb-0">
            <div class="flex justify-between">
              <div>
                <h3 class="font-medium">Xây dựng Landing Page</h3>
                <p class="text-sm text-gray-600">Fullstack Web Development</p>
              </div>
              <div class="text-right">
                <span class="text-xs bg-red-100 text-red-600 px-2 py-1 rounded-full">Còn 2 ngày</span>
                <p class="text-sm text-gray-600 mt-1">20/04/2025</p>
              </div>
            </div>
          </li>
          <li class="py-3 first:pt-0 last:pb-0">
            <div class="flex justify-between">
              <div>
                <h3 class="font-medium">UI/UX cho ứng dụng mobile</h3>
                <p class="text-sm text-gray-600">Flutter for Beginners</p>
              </div>
              <div class="text-right">
                <span class="text-xs bg-yellow-100 text-yellow-600 px-2 py-1 rounded-full">Còn 5 ngày</span>
                <p class="text-sm text-gray-600 mt-1">23/04/2025</p>
              </div>
            </div>
          </li>
          <li class="py-3 first:pt-0 last:pb-0">
            <div class="flex justify-between">
              <div>
                <h3 class="font-medium">Bài kiểm tra giữa kỳ</h3>
                <p class="text-sm text-gray-600">Fullstack Web Development</p>
              </div>
              <div class="text-right">
                <span class="text-xs bg-green-100 text-green-600 px-2 py-1 rounded-full">Còn 10 ngày</span>
                <p class="text-sm text-gray-600 mt-1">28/04/2025</p>
              </div>
            </div>
          </li>
        </ul>
      </div>

      <!-- Recommended Courses -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-lg font-semibold">Khóa học đề xuất</h2>
          <NuxtLink to="/student/catalog" class="text-sm text-green-600 hover:text-green-700">Xem tất cả</NuxtLink>
        </div>

        <ul class="divide-y">
          <li class="py-3 first:pt-0 last:pb-0">
            <div class="flex">
              <div class="h-16 w-16 rounded-lg bg-blue-100 flex-shrink-0 flex items-center justify-center">
                <i class="fas fa-server text-blue-600 text-xl"></i>
              </div>
              <div class="ml-4 flex-grow">
                <div class="flex justify-between">
                  <h3 class="font-medium">Node.js Backend Development</h3>
                  <div class="flex items-center">
                    <i class="fas fa-star text-yellow-400 text-xs"></i>
                    <span class="text-sm ml-1">4.9</span>
                  </div>
                </div>
                <p class="text-sm text-gray-600">Phù hợp với kỹ năng hiện tại của bạn</p>
                <p class="text-sm font-semibold mt-1">799.000đ</p>
              </div>
            </div>
          </li>
          <li class="py-3 first:pt-0 last:pb-0">
            <div class="flex">
              <div class="h-16 w-16 rounded-lg bg-purple-100 flex-shrink-0 flex items-center justify-center">
                <i class="fas fa-database text-purple-600 text-xl"></i>
              </div>
              <div class="ml-4 flex-grow">
                <div class="flex justify-between">
                  <h3 class="font-medium">SQL và cơ sở dữ liệu</h3>
                  <div class="flex items-center">
                    <i class="fas fa-star text-yellow-400 text-xs"></i>
                    <span class="text-sm ml-1">4.7</span>
                  </div>
                </div>
                <p class="text-sm text-gray-600">Bổ trợ cho khóa Fullstack Web</p>
                <p class="text-sm font-semibold mt-1">599.000đ</p>
              </div>
            </div>
          </li>
          <li class="py-3 first:pt-0 last:pb-0">
            <div class="flex">
              <div class="h-16 w-16 rounded-lg bg-red-100 flex-shrink-0 flex items-center justify-center">
                <i class="fas fa-certificate text-red-600 text-xl"></i>
              </div>
              <div class="ml-4 flex-grow">
                <div class="flex justify-between">
                  <h3 class="font-medium">Khóa học AWS Certified</h3>
                  <div class="flex items-center">
                    <i class="fas fa-star text-yellow-400 text-xs"></i>
                    <span class="text-sm ml-1">4.8</span>
                  </div>
                </div>
                <p class="text-sm text-gray-600">Hot nhất tuần này</p>
                <p class="text-sm font-semibold mt-1">1.299.000đ</p>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>

    <!-- Recent Activities -->
    <div class="bg-white rounded-lg shadow-md p-6 mb-6">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-lg font-semibold">Hoạt động gần đây</h2>
        <a href="#" class="text-sm text-green-600 hover:text-green-700">Xem tất cả</a>
      </div>

      <div class="relative pl-8 before:content-[''] before:absolute before:top-2 before:left-3 before:bottom-0 before:w-px before:bg-gray-200">
        <div class="mb-6 relative">
          <div class="absolute top-0.5 left-[-30px] h-5 w-5 rounded-full bg-green-500 flex items-center justify-center">
            <i class="fas fa-check text-white text-xs"></i>
          </div>
          <span class="text-sm text-gray-500">Hôm nay, 15:30</span>
          <p class="font-medium">Hoàn thành bài học "JavaScript Basics"</p>
          <p class="text-sm text-gray-600">Fullstack Web Development</p>
        </div>

        <div class="mb-6 relative">
          <div class="absolute top-0.5 left-[-30px] h-5 w-5 rounded-full bg-blue-500 flex items-center justify-center">
            <i class="fas fa-file-alt text-white text-xs"></i>
          </div>
          <span class="text-sm text-gray-500">Hôm nay, 13:15</span>
          <p class="font-medium">Nộp bài tập "HTML/CSS Layout Challenge"</p>
          <p class="text-sm text-gray-600">Fullstack Web Development</p>
        </div>

        <div class="mb-6 relative">
          <div class="absolute top-0.5 left-[-30px] h-5 w-5 rounded-full bg-indigo-500 flex items-center justify-center">
            <i class="fas fa-graduation-cap text-white text-xs"></i>
          </div>
          <span class="text-sm text-gray-500">Hôm qua, 17:40</span>
          <p class="font-medium">Đăng ký khóa học mới "Machine Learning cơ bản"</p>
          <p class="text-sm text-gray-600">Khóa học của giảng viên Trần Thị B</p>
        </div>

        <div class="mb-6 relative">
          <div class="absolute top-0.5 left-[-30px] h-5 w-5 rounded-full bg-yellow-500 flex items-center justify-center">
            <i class="fas fa-star text-white text-xs"></i>
          </div>
          <span class="text-sm text-gray-500">14/04/2025, 09:10</span>
          <p class="font-medium">Đánh giá 5 sao cho khóa học "Flutter for Beginners"</p>
          <p class="text-sm text-gray-600">"Khóa học rất dễ hiểu và thực tế"</p>
        </div>
      </div>
    </div>

    <!-- Quick Stats and Learning Streak -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
      <div class="bg-white rounded-lg shadow-md p-6 col-span-full md:col-span-1">
        <h3 class="font-semibold mb-2">Streak học tập</h3>
        <div class="flex flex-col items-center">
          <div class="h-24 w-24 rounded-full border-4 border-green-500 flex items-center justify-center mb-2">
            <span class="text-3xl font-bold">7</span>
          </div>
          <p class="text-sm text-gray-600">ngày liên tiếp</p>
          <p class="text-xs text-center mt-2">Duy trì streak để nhận phần thưởng!</p>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6 col-span-full md:col-span-3">
        <h3 class="font-semibold mb-4">Thống kê học tập</h3>
        <div class="grid grid-cols-3 gap-4 mb-4">
          <div class="bg-gray-50 p-3 rounded-lg text-center">
            <p class="text-3xl font-bold text-blue-600">12</p>
            <p class="text-sm text-gray-600">Giờ học tháng này</p>
          </div>
          <div class="bg-gray-50 p-3 rounded-lg text-center">
            <p class="text-3xl font-bold text-purple-600">3</p>
            <p class="text-sm text-gray-600">Khóa học đang học</p>
          </div>
          <div class="bg-gray-50 p-3 rounded-lg text-center">
            <p class="text-3xl font-bold text-green-600">5</p>
            <p class="text-sm text-gray-600">Chứng chỉ đạt được</p>
          </div>
        </div>
        <div class="flex justify-between items-center text-sm">
          <p class="text-gray-600">Mục tiêu: <span class="font-medium">20 giờ học/tháng</span></p>
          <p class="text-green-600">60% hoàn thành</p>
        </div>
        <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
          <div class="bg-green-600 h-2 rounded-full" style="width: 60%"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
// Student dashboard page

// Set the layout for this page
definePageMeta({
  layout: 'student',
});

// Check if user is logged in and is student
onMounted(() => {
  const userRole = localStorage.getItem('user_role');
  if (!userRole || userRole !== 'student') {
    // Redirect to login if not logged in as student
    navigateTo('/student/login');
  }
});
</script>

<style scoped>
/* Custom styles for dashboard */
</style>
