<template>
  <div class="min-h-screen flex bg-gray-100">
    <!-- Sidebar -->
    <aside class="bg-indigo-700 text-white w-64 flex-shrink-0 hidden md:block">
      <div class="p-4 border-b border-indigo-800">
        <NuxtLink to="/teacher/dashboard" class="text-xl font-bold">E-Learning Giảng viên</NuxtLink>
      </div>
      <nav class="p-4">
        <ul class="space-y-2">
          <li>
            <NuxtLink to="/teacher/dashboard" class="flex items-center p-2 rounded hover:bg-indigo-800 transition">
              <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/teacher/courses" class="flex items-center p-2 rounded hover:bg-indigo-800 transition">
              <i class="fas fa-book mr-3"></i> Khóa học của tôi
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/teacher/assignments" class="flex items-center p-2 rounded hover:bg-indigo-800 transition">
              <i class="fas fa-tasks mr-3"></i> Bài tập
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/teacher/students" class="flex items-center p-2 rounded hover:bg-indigo-800 transition">
              <i class="fas fa-user-graduate mr-3"></i> Học viên
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/teacher/calendar" class="flex items-center p-2 rounded hover:bg-indigo-800 transition">
              <i class="fas fa-calendar-alt mr-3"></i> Lịch giảng dạy
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/teacher/messages" class="flex items-center p-2 rounded hover:bg-indigo-800 transition">
              <i class="fas fa-envelope mr-3"></i> Tin nhắn
            </NuxtLink>
          </li>
        </ul>
      </nav>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <!-- Header -->
      <header class="bg-white shadow-sm py-4 px-6 flex justify-between items-center">
        <!-- Mobile menu button -->
        <button class="md:hidden text-gray-600">
          <i class="fas fa-bars text-xl"></i>
        </button>

        <!-- Search -->
        <div class="hidden md:flex items-center flex-grow max-w-md mx-4">
          <div class="relative w-full">
            <span class="absolute inset-y-0 left-0 flex items-center pl-3">
              <i class="fas fa-search text-gray-400"></i>
            </span>
            <input
              type="text"
              placeholder="Tìm kiếm..."
              class="pl-10 pr-4 py-2 w-full border rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-600"
            />
          </div>
        </div>

        <!-- User menu -->
        <div class="flex items-center space-x-4">
          <!-- Notifications -->
          <button class="text-gray-500 hover:text-gray-700 relative">
            <i class="fas fa-bell text-xl"></i>
            <span class="absolute top-0 right-0 h-2 w-2 rounded-full bg-red-500"></span>
          </button>

          <!-- Profile -->
          <div class="relative">
            <button class="flex items-center text-gray-700 focus:outline-none">
              <span class="mr-2 hidden md:inline-block">Giảng viên</span>
              <img
                src="https://ui-avatars.com/api/?name=Teacher+User&background=4F46E5&color=fff"
                alt="Avatar"
                class="h-8 w-8 rounded-full object-cover"
              />
            </button>
            <!-- Dropdown Menu -->
            <div class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 hidden">
              <NuxtLink to="/teacher/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Hồ sơ</NuxtLink>
              <button class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                Đăng xuất
              </button>
            </div>
          </div>
        </div>
      </header>

      <!-- Page Content -->
      <main class="flex-1 overflow-auto p-6 bg-gray-100">
        <slot />
      </main>
    </div>
  </div>
</template>

<script lang="ts" setup>
// Teacher layout
// Note: middleware will be handled at the page level instead of layout level
</script>

<style>
/* Custom styles for teacher layout */
</style>
