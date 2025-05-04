// plugins/axios.ts
import { defineNuxtPlugin } from '#app';
import axios from 'axios';
import type { AxiosInstance } from 'axios';

export default defineNuxtPlugin((nuxtApp) => {
  const api: AxiosInstance = axios.create({
    baseURL: 'http://localhost:3000/api/v1',
    headers: {
      'Content-Type': 'application/json',
    },
  });

  api.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  return {
    provide: {
      axios: api,
    },
  };
});