export default defineNuxtRouteMiddleware((to, from) => {
  if (process.client) {
    const userRole = localStorage.getItem('user_role');
    const token = localStorage.getItem('token');
    if ((to.path === '/' || to.path === '/login') && userRole && token) {
      console.log('Redirecting authenticated user from landing page');
      
      switch (userRole) {
        case 'SuperAdmin':
          return navigateTo('/super-admin/dashboard');
        case 'AdminSchools':
          return navigateTo('/admin/dashboard');
        case 'Teacher':
          return navigateTo('/teacher/dashboard');
        case 'Student':
          return navigateTo('/student/dashboard');
        default:
          localStorage.removeItem('token');
          localStorage.removeItem('user_role');
          localStorage.removeItem('school_id');
      }
    }
    const protectedPaths = ['/admin/', '/super-admin/', '/teacher/', '/student/'];
    if (protectedPaths.some(path => to.path.startsWith(path)) && (!userRole || !token)) {
      console.log('Redirecting unauthenticated user to login');
      return navigateTo('/login');
    }
  }
});
