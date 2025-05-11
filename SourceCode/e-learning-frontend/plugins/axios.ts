// plugins/axios.ts
import { defineNuxtPlugin } from '#app';
import axios from 'axios';
import type { AxiosInstance, AxiosError } from 'axios';

export default defineNuxtPlugin((nuxtApp) => {
  // Sử dụng cấu hình hoặc URL mặc định
  const baseURL = process.env.NUXT_API_BASE_URL || 'http://localhost:3000/api/v1';
  
  const api: AxiosInstance = axios.create({
    baseURL,
    headers: {
      'Content-Type': 'application/json',
    },
    timeout: 10000, // 10 seconds
  });

  // Request interceptor to add authentication token
  api.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  // Response interceptor to handle common errors
  api.interceptors.response.use(
    (response) => response,
    (error: AxiosError) => {
      const status = error.response?.status;
      
      // Handle authentication errors
      if (status === 401) {
        // Clear invalid token
        localStorage.removeItem('token');
        localStorage.removeItem('user_role');
        localStorage.removeItem('school_id');
        
        // Redirect to login page
        navigateTo('/login');
      }
      
      return Promise.reject(error);
    }
  );

  return {
    provide: {
      axios: api,
    },
  };
});