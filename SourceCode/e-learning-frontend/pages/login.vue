<template>
  <div class="min-h-screen flex mt-[-72px ] items-center justify-center">
    <Card class="p-8 sm:rounded-lg sm:shadow-md sm:border-solid border-none bg-card-none shadow-none w-full max-w-md">
      <div class="text-center mb-8">
        <h1 class="text-2xl font-bold text-primary">E-Learning</h1>
        <p class="mt-2">{{ t('login.title') }}</p>
      </div>

      <form @submit.prevent="handleLogin" class="space-y-6">
        <div>
          <Label for="email" class="block text-sm font-medium mb-1">{{ t('common.email') }}</Label>
          <input id="email" v-model="email" type="email" required
            class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary"
            placeholder="email@example.com" />
        </div>

        <div>
          <label for="password" class="block text-sm font-medium mb-1">{{ t('common.password') }}</label>
          <input id="password" v-model="password" type="password" required
            class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" placeholder="••••••••" />
        </div>



        <div class="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <Checkbox id="remember-me" />
            <label htmlFor="remember-me"
              className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              {{ t('common.rememberMe') }}
            </label>
          </div>

          <div class="text-sm">
            <a href="#" class="">{{ t('common.forgotPassword') }}</a>
          </div>
        </div>

        <div v-if="error" class="text-red-500 text-sm text-center">
          {{ error }}
        </div>

        <div>
          <button type="submit"
            class="w-full py-2 px-4 bg-primary hover:bg-primary-dark text-white font-semibold rounded-lg transition"
            :disabled="loading">
            <span v-if="loading">Đang {{ t('common.login').toLowerCase() }}...</span>
            <span v-else>{{ t('common.login') }}</span>
          </button>
        </div>
      </form>

      <div class="mt-8 border-t pt-6">
        <p class="text-sm text-center mb-4">{{ t('login.quickLogin') }}</p>
        <div class="grid grid-cols-3 gap-3">
          <button @click="quickLogin('admin@example.com', 'password123')"
            class="py-2 px-4 border border-gray-300 rounded-md text-sm font-medium hover:bg-gray-50">
            <span>{{ t('login.admin') }}</span>
          </button>
          <button @click="quickLogin('teacher@example.com', 'password123')"
            class="py-2 px-4 border border-gray-300 rounded-md text-sm font-medium hover:bg-gray-50">
            <span>{{ t('login.teacher') }}</span>
          </button>
          <button @click="quickLogin('student@example.com', 'password123')"
            class="py-2 px-4 border border-gray-300 rounded-md text-sm font-medium hover:bg-gray-50">
            <span>{{ t('login.student') }}</span>
          </button>
        </div>
      </div>

      <div class="mt-6 text-center">
        <NuxtLink :to="localePath('/')" class="">
          <Button>
            <Label class="text-white">{{ t('common.backToHome') }}</Label>
          </Button>
        </NuxtLink>
      </div>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { useLanguage } from '~/composables/useLanguage';
import { useTheme } from '~/composables/useTheme';
import { useLocalePath } from '#i18n';

const router = useRouter();
const { t } = useLanguage();
const { isDark } = useTheme();
const localePath = useLocalePath();

const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');

const quickLogin = (userEmail: string, userPassword: string) => {
  email.value = userEmail;
  password.value = userPassword;
  handleLogin();
};

const handleLogin = async () => {
  try {
    loading.value = true;
    error.value = '';

    let role = null;

    if (email.value === 'admin@example.com' && password.value === 'password123') {
      role = 'admin';
    } else if (email.value === 'teacher@example.com' && password.value === 'password123') {
      role = 'teacher';
    } else if (email.value === 'student@example.com' && password.value === 'password123') {
      role = 'student';
    }

    if (role) {
      localStorage.setItem('user_role', role);
      localStorage.setItem('user_email', email.value);

      router.push(`/${role}/dashboard`);
    } else {
      error.value = t('login.invalidCredentials');
    }
  } catch (err) {
    console.error('Login error:', err);
    error.value = t('login.error');
  } finally {
    loading.value = false;
  }
};

definePageMeta({
  layout: 'landing',
});
</script>

<style scoped></style>
