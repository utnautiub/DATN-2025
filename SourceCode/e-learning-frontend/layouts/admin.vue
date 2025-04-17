<template>
  <div class="min-h-screen flex bg-gray-100">
    <!-- Sidebar -->
    <aside class="bg-primary text-white w-64 flex-shrink-0 hidden md:block">
      <div class="p-4 border-b border-primary-dark">
        <NuxtLink to="/admin/dashboard" class="text-xl font-bold">E-Learning Admin</NuxtLink>
      </div>
      <nav class="p-4">
        <ul class="space-y-2">
          <li>
            <NuxtLink to="/admin/dashboard" class="flex items-center p-2 rounded hover:bg-primary-dark transition">
              <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/admin/users" class="flex items-center p-2 rounded hover:bg-primary-dark transition">
              <i class="fas fa-users mr-3"></i> Quản lý người dùng
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/admin/courses" class="flex items-center p-2 rounded hover:bg-primary-dark transition">
              <i class="fas fa-book mr-3"></i> Quản lý khóa học
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/admin/reports" class="flex items-center p-2 rounded hover:bg-primary-dark transition">
              <i class="fas fa-chart-bar mr-3"></i> Báo cáo
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/admin/settings" class="flex items-center p-2 rounded hover:bg-primary-dark transition">
              <i class="fas fa-cog mr-3"></i> Cài đặt hệ thống
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
              class="pl-10 pr-4 py-2 w-full border rounded-lg focus:outline-none focus:ring-1 focus:ring-primary"
            />
          </div>
        </div>

        <!-- User menu -->
        <div class="flex items-center space-x-4">
          <div class="relative">
            <button class="flex items-center text-gray-700 focus:outline-none">
              <span class="mr-2 hidden md:inline-block">Admin</span>
              <img
                src="https://ui-avatars.com/api/?name=Admin+User&background=0D8ABC&color=fff"
                alt="Avatar"
                class="h-8 w-8 rounded-full object-cover"
              />
            </button>
            <!-- Dropdown Menu -->
            <div class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 hidden">
              <NuxtLink to="/admin/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Hồ sơ</NuxtLink>
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
// Admin layout
// Note: middleware will be handled at the page level instead of layout level
</script>

<style>
/* Custom styles for admin layout */
</style>
