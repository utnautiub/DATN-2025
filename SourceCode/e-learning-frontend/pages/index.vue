<template>
  <div>
    <section class="py-40 mt-4 bg-gradient-to-b to-primary/5 from-background">
      <div class="container mx-auto px-4 text-center">
        <div class="flex justify-center mb-6">
          <img src="https://tlu.edu.vn/Portals/_default/skins/tluvie/images/logo.png" alt="Đại học Thủy Lợi" class="h-24" />
        </div>
        <h1 class="text-4xl md:text-5xl font-bold mb-6 text-primary">{{ t('homepage.title') }}</h1>
        <p class="text-xl md:text-2xl mb-8 max-w-3xl mx-auto text-muted-foreground">{{ t('homepage.subtitle') }}</p>
        <div class="flex flex-col sm:flex-row justify-center gap-4">
          <NuxtLink to="/login">
            <Button size="lg" class="font-medium">
              {{ t('homepage.login') }}
            </Button>
          </NuxtLink>
          <NuxtLink to="/#features">
            <Button size="lg" variant="outline" class="font-medium">
              {{ t('homepage.learnMore') }}
            </Button>
          </NuxtLink>
        </div>
      </div>
    </section>

    <section id="features" class="py-16">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold mb-4">{{ t('homepage.features.title') }}</h2>
          <p class="text-muted-foreground max-w-2xl mx-auto">{{ t('homepage.features.description') }}</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardHeader class="pb-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary w-fit">
                <Icon icon="heroicons:academic-cap" class="h-6 w-6" />
              </div>
              <CardTitle class="text-xl font-medium mt-4">{{ t('homepage.features.learning.title') }}</CardTitle>
              <CardDescription>{{ t('homepage.features.learning.description') }}</CardDescription>
            </CardHeader>
            <CardContent>
              <ul class="space-y-2 text-muted-foreground">
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.learning.feature1') }}</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.learning.feature2') }}</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.learning.feature3') }}</span>
                </li>
              </ul>
            </CardContent>
          </Card>

          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardHeader class="pb-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary w-fit">
                <Icon icon="heroicons:document-text" class="h-6 w-6" />
              </div>
              <CardTitle class="text-xl font-medium mt-4">{{ t('homepage.features.management.title') }}</CardTitle>
              <CardDescription>{{ t('homepage.features.management.description') }}</CardDescription>
            </CardHeader>
            <CardContent>
              <ul class="space-y-2 text-muted-foreground">
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.management.feature1') }}</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.management.feature2') }}</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.management.feature3') }}</span>
                </li>
              </ul>
            </CardContent>
          </Card>

          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardHeader class="pb-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary w-fit">
                <Icon icon="heroicons:chart-bar" class="h-6 w-6" />
              </div>
              <CardTitle class="text-xl font-medium mt-4">{{ t('homepage.features.reporting.title') }}</CardTitle>
              <CardDescription>{{ t('homepage.features.reporting.description') }}</CardDescription>
            </CardHeader>
            <CardContent>
              <ul class="space-y-2 text-muted-foreground">
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.reporting.feature1') }}</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.reporting.feature2') }}</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>{{ t('homepage.features.reporting.feature3') }}</span>
                </li>
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>

    <section class="py-16 bg-muted/50">
      <div class="container mx-auto px-4">
        <div class="flex flex-col lg:flex-row items-center gap-12">
          <div class="lg:w-1/2">
            <img src="https://i1-vnexpress.vnecdn.net/2023/08/21/316222594-3471214863152813-531-5319-3204-1692602206.jpg?w=0&h=0&q=100&dpr=2&fit=crop&s=jIfZ_imTBAzXv25MX78IKA" alt="Đại học Thủy Lợi" 
              class="rounded-lg shadow-lg object-cover h-full">
          </div>
          <div class="lg:w-1/2">
            <h2 class="text-3xl font-bold mb-6">{{ t('homepage.about.title') }}</h2>
            <p class="text-muted-foreground mb-6">{{ t('homepage.about.description') }}</p>
            <div class="grid grid-cols-2 gap-6 mb-8">
              <div>
                <div class="text-3xl font-bold text-primary mb-2">65+</div>
                <p class="text-muted-foreground">{{ t('homepage.about.years') }}</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">300+</div>
                <p class="text-muted-foreground">{{ t('homepage.about.teachers') }}</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">24,066+</div>
                <p class="text-muted-foreground">{{ t('homepage.about.students') }}</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">45+</div>
                <p class="text-muted-foreground">{{ t('homepage.about.programs') }}</p>
              </div>
            </div>
            <div class="space-x-4">
              <NuxtLink to="/history">
                <Button variant="outline">
                  {{ t('homepage.about.history') }}
                </Button>
              </NuxtLink>
              <a href="https://www.tlu.edu.vn" target="_blank" rel="noopener noreferrer">
                <Button variant="secondary">
                  {{ t('homepage.about.officialWebsite') }}
                </Button>
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="py-16">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold mb-4">{{ t('homepage.contact.title') }}</h2>
        <p class="text-muted-foreground max-w-2xl mx-auto mb-8">{{ t('homepage.contact.description') }}</p>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardContent class="pt-6">
              <div class="flex flex-col items-center">
                <div class="p-3 rounded-full bg-primary/10 text-primary mb-4">
                  <Icon icon="heroicons:envelope" class="h-6 w-6" />
                </div>
                <h3 class="font-medium mb-2">{{ t('homepage.contact.email') }}</h3>
                <p class="text-muted-foreground mb-4">daotao@tlu.edu.vn</p>
                <a href="mailto:daotao@tlu.edu.vn">
                  <Button variant="outline" size="sm">{{ t('homepage.contact.sendEmail') }}</Button>
                </a>
              </div>
            </CardContent>
          </Card>
          
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardContent class="pt-6">
              <div class="flex flex-col items-center">
                <div class="p-3 rounded-full bg-primary/10 text-primary mb-4">
                  <Icon icon="heroicons:phone" class="h-6 w-6" />
                </div>
                <h3 class="font-medium mb-2">{{ t('homepage.contact.phone') }}</h3>
                <p class="text-muted-foreground mb-4">024.3852.2201</p>
                <a href="tel:+842438522201">
                  <Button variant="outline" size="sm">{{ t('homepage.contact.callNow') }}</Button>
                </a>
              </div>
            </CardContent>
          </Card>
          
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardContent class="pt-6">
              <div class="flex flex-col items-center">
                <div class="p-3 rounded-full bg-primary/10 text-primary mb-4">
                  <Icon icon="heroicons:map-pin" class="h-6 w-6" />
                </div>
                <h3 class="font-medium mb-2">{{ t('homepage.contact.address') }}</h3>
                <p class="text-muted-foreground mb-4">175 Tây Sơn, Đống Đa, Hà Nội</p>
                <a href="https://maps.app.goo.gl/dCDR4KH9z3U27RkL8" target="_blank" rel="noopener noreferrer">
                  <Button variant="outline" size="sm">{{ t('homepage.contact.viewMap') }}</Button>
                </a>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  </div>
</template>

<script lang="ts" setup>
import { Icon } from '@iconify/vue';
const { t } = useLanguage();
const router = useRouter();

definePageMeta({
  layout: 'landing'
});

useHead({
  title: t('homepage.title') + ' - ' + t('homepage.subtitle'),
  meta: [
    {
      name: 'description',
      content: t('homepage.features.description')
    }
  ]
});

onMounted(() => {
  // Kiểm tra nếu người dùng đã đăng nhập thì redirect về trang tương ứng
  const token = localStorage.getItem('token');
  const userRole = localStorage.getItem('user_role');
  
  if (token && userRole) {
    switch (userRole) {
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
    }
  }
});
</script>

<style></style>
