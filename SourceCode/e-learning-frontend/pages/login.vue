<template>
  <div class="min-h-screen flex mt-[-72px] items-center justify-center">
    <Card class="p-8 sm:rounded-lg sm:shadow-md sm:border-solid border-none bg-card-none shadow-none w-full max-w-md">
      <div class="text-center mb-8">
        <h1 class="text-2xl font-bold text-primary">E-Learning</h1>
        <p class="mt-2">{{ t('login.title') }}</p>
      </div>

      <!-- Bước 1: Nhập username và password -->
      <form v-if="!requiresSchoolSelection" @submit.prevent="handleInitialLogin" class="space-y-6">
        <div>
          <Label for="username" class="block text-sm font-medium mb-1">{{ t('common.username') }}</Label>
          <input id="username" v-model="username" type="text" required
            class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" placeholder="Username" />
        </div>
        <div>
          <Label for="password" class="block text-sm font-medium mb-1">{{ t('common.password') }}</Label>
          <input id="password" v-model="password" type="password" required
            class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" placeholder="••••••••" />
        </div>
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-2">
            <Checkbox id="remember-me" v-model="rememberMe" />
            <Label for="remember-me">{{ t('common.rememberMe') }}</Label>
          </div>
          <div class="text-sm">
            <NuxtLink to="/forgot-password" class="text-primary hover:underline">{{ t('common.forgotPassword') }}
            </NuxtLink>
          </div>
        </div>
        <div v-if="error" class="text-red-500 text-sm text-center">
          {{ error }}
        </div>
        <div>
          <Button type="submit" class="w-full" :disabled="loading">
            <span v-if="loading">Đang {{ t('common.login').toLowerCase() }}...</span>
            <span v-else>{{ t('common.login') }}</span>
          </Button>
        </div>
      </form>

      <!-- Bước 2: Chọn trường nếu trùng username -->
      <form v-else @submit.prevent="handleFinalLogin" class="space-y-6">
        <div>
          <Label for="school_id" class="block text-sm font-medium mb-1">Trường học</Label>
          <select id="school_id" v-model="school_id" required class="w-full px-4 py-2 border rounded-lg">
            <option v-for="school in schools" :key="school.id" :value="school.id">{{ school.name }}</option>
          </select>
        </div>
        <div v-if="error" class="text-red-500 text-sm text-center">
          {{ error }}
        </div>
        <div>
          <Button type="submit" class="w-full" :disabled="loading">
            <span v-if="loading">Đang {{ t('common.login').toLowerCase() }}...</span>
            <span v-else>Tiếp tục</span>
          </Button>
        </div>
      </form>

      <div class="mt-6 text-center">
        <NuxtLink :to="localePath('/')" class="text-primary hover:underline">
          <Button variant="outline">
            <Label>{{ t('common.backToHome') }}</Label>
          </Button>
        </NuxtLink>
      </div>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { useLanguage } from '~/composables/useLanguage';
import { useLocalePath } from '#i18n';
import type { AxiosResponse } from 'axios';

const router = useRouter();
const { t } = useLanguage();
const localePath = useLocalePath();
const { $axios } = useNuxtApp();

interface School {
  id: number;
  name: string;
}

interface User {
  id: number;
  username: string;
  role: string;
  school_id: number | null;
}

interface InitialLoginResponse {
  schools?: School[];
  requires_school_selection?: boolean;
  user?: User;
  token?: string;
}

const username = ref<string>('');
const password = ref<string>('');
const rememberMe = ref<boolean>(false);
const loading = ref<boolean>(false);
const error = ref<string>('');
const requiresSchoolSelection = ref<boolean>(false);
const schools = ref<School[]>([]);
const school_id = ref<string>('');

const handleInitialLogin = async () => {
  try {
    loading.value = true;
    error.value = '';

    const response: AxiosResponse<InitialLoginResponse> = await $axios.post('/login', {
      username: username.value,
      password: password.value,
    });

    if (response.data.requires_school_selection) {
      // Nếu trùng username, hiển thị dropdown chọn trường
      schools.value = response.data.schools || [];
      requiresSchoolSelection.value = true;
    } else {
      // Nếu không trùng username, đăng nhập thành công hoặc báo lỗi
      const { user, token } = response.data;
      localStorage.setItem('token', token);
      localStorage.setItem('user_role', user.role);
      localStorage.setItem('school_id', String(user.school_id));

      switch (user.role) {
        case 'SuperAdmin':
          router.push('/super-admin/dashboard');
          break;
        case 'AdminSchools':
          router.push('/admin/dashboard');
          break;
        case 'Teacher':
          router.push('/teacher/dashboard');
          break;
        case 'Student':
          router.push('/student/dashboard');
          break;
        default:
          error.value = t('login.invalidRole');
      }
    }
  } catch (err: any) {
    console.error('Initial login error:', err);
    error.value = err.response?.data?.error || t('login.invalidCredentials');
  } finally {
    loading.value = false;
  }
};

const handleFinalLogin = async () => {
  try {
    loading.value = true;
    error.value = '';

    const response: AxiosResponse<InitialLoginResponse> = await $axios.post('/login', {
      username: username.value,
      password: password.value,
      school_id: school_id.value,
    });

    const { user, token } = response.data;
    localStorage.setItem('token', token);
    localStorage.setItem('user_role', user.role);
    localStorage.setItem('school_id', String(user.school_id));

    switch (user.role) {
      case 'SuperAdmin':
        router.push('/super-admin/dashboard');
        break;
      case 'AdminSchools':
        router.push('/admin/dashboard');
        break;
      case 'Teacher':
        router.push('/teacher/dashboard');
        break;
      case 'Student':
        router.push('/student/dashboard');
        break;
      default:
        error.value = t('login.invalidRole');
    }
  } catch (err: any) {
    console.error('Final login error:', err);
    error.value = err.response?.data?.error || t('login.invalidCredentials');
  } finally {
    loading.value = false;
  }
};

definePageMeta({
  layout: 'landing',
});
</script>

<style scoped></style>
