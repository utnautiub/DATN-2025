<template>
  <div>
    <!-- Hero Section -->
    <section class="bg-gradient-to-r mt-30 from-primary to-blue-600 text-white py-20">
      <div class="container mx-auto px-4 text-center">
        <h1 class="text-4xl md:text-5xl font-bold mb-6">{{ t('landing.hero.title') }}</h1>
        <p class="text-xl md:text-2xl mb-8 max-w-3xl mx-auto">{{ t('landing.hero.subtitle') }}</p>
        <div class="flex flex-col sm:flex-row justify-center gap-4">
          <NuxtLink to="/login" class="btn btn-lg bg-white text-primary hover:bg-gray-100">
            {{ t('landing.hero.startLearning') }}
          </NuxtLink>
          <NuxtLink to="/#courses" class="btn btn-lg btn-outline border-white text-white hover:bg-white hover:text-primary">
            {{ t('landing.hero.exploreCourses') }}
          </NuxtLink>
        </div>
      </div>
    </section>

    <!-- Featured Courses Section -->
    <section id="courses" class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold mb-4">{{ t('landing.courses.title') }}</h2>
          <p class="text-gray-600 max-w-2xl mx-auto">{{ t('landing.courses.description') }}</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- Course Card 1 -->
          <div class="bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:-translate-y-1 hover:shadow-lg">
            <div class="relative">
              <img src="https://placehold.co/600x400/3b82f6/FFFFFF/png?text=Development" alt="Course" class="w-full h-48 object-cover">
              <div class="absolute top-4 right-4 bg-primary text-white px-2 py-1 rounded text-sm font-semibold">
                {{ t('landing.courses.popular') }}
              </div>
            </div>
            <div class="p-6">
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm text-gray-500">{{ t('landing.courses.webDevelopment') }}</span>
                <div class="flex items-center">
                  <i class="fas fa-star text-yellow-400"></i>
                  <span class="ml-1 text-sm font-semibold">4.8</span>
                </div>
              </div>
              <h3 class="text-xl font-semibold mb-2">{{ t('landing.courses.fullstackTitle') }}</h3>
              <p class="text-gray-600 mb-4 line-clamp-2">{{ t('landing.courses.fullstackDescription') }}</p>
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <img src="https://ui-avatars.com/api/?name=John+Doe" alt="Instructor" class="h-8 w-8 rounded-full">
                  <span class="ml-2 text-sm font-medium">{{ t('landing.courses.instructor1') }}</span>
                </div>
                <span class="font-bold text-primary">{{ t('landing.courses.price1') }}</span>
              </div>
            </div>
          </div>

          <!-- Course Card 2 -->
          <div class="bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:-translate-y-1 hover:shadow-lg">
            <div class="relative">
              <img src="https://placehold.co/600x400/10b981/FFFFFF/png?text=Data+Science" alt="Course" class="w-full h-48 object-cover">
            </div>
            <div class="p-6">
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm text-gray-500">{{ t('landing.courses.dataScience') }}</span>
                <div class="flex items-center">
                  <i class="fas fa-star text-yellow-400"></i>
                  <span class="ml-1 text-sm font-semibold">4.7</span>
                </div>
              </div>
              <h3 class="text-xl font-semibold mb-2">{{ t('landing.courses.mlTitle') }}</h3>
              <p class="text-gray-600 mb-4 line-clamp-2">{{ t('landing.courses.mlDescription') }}</p>
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <img src="https://ui-avatars.com/api/?name=Jane+Smith" alt="Instructor" class="h-8 w-8 rounded-full">
                  <span class="ml-2 text-sm font-medium">{{ t('landing.courses.instructor2') }}</span>
                </div>
                <span class="font-bold text-primary">{{ t('landing.courses.price2') }}</span>
              </div>
            </div>
          </div>

          <!-- Course Card 3 -->
          <div class="bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:-translate-y-1 hover:shadow-lg">
            <div class="relative">
              <img src="https://placehold.co/600x400/6366f1/FFFFFF/png?text=Mobile+Dev" alt="Course" class="w-full h-48 object-cover">
            </div>
            <div class="p-6">
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm text-gray-500">{{ t('landing.courses.mobileDev') }}</span>
                <div class="flex items-center">
                  <i class="fas fa-star text-yellow-400"></i>
                  <span class="ml-1 text-sm font-semibold">4.9</span>
                </div>
              </div>
              <h3 class="text-xl font-semibold mb-2">{{ t('landing.courses.flutterTitle') }}</h3>
              <p class="text-gray-600 mb-4 line-clamp-2">{{ t('landing.courses.flutterDescription') }}</p>
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <img src="https://ui-avatars.com/api/?name=David+Johnson" alt="Instructor" class="h-8 w-8 rounded-full">
                  <span class="ml-2 text-sm font-medium">{{ t('landing.courses.instructor3') }}</span>
                </div>
                <span class="font-bold text-primary">{{ t('landing.courses.price3') }}</span>
              </div>
            </div>
          </div>
        </div>

        <div class="text-center mt-12">
          <NuxtLink to="" class="btn btn-primary">
            {{ t('landing.courses.viewAll') }}
          </NuxtLink>
        </div>
      </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-16">
      <div class="container mx-auto px-4">
        <div class="flex flex-col lg:flex-row items-center gap-12">
          <div class="lg:w-1/2">
            <img src="https://placehold.co/800x600/e2e8f0/64748b/png?text=About+Us" alt="About Us" class="rounded-lg shadow-lg">
          </div>
          <div class="lg:w-1/2">
            <h2 class="text-3xl font-bold mb-6">{{ t('landing.about.title') }}</h2>
            <p class="text-gray-600 mb-6">{{ t('landing.about.description') }}</p>
            <div class="grid grid-cols-2 gap-6 mb-8">
              <div>
                <div class="text-3xl font-bold text-primary mb-2">1200+</div>
                <p class="text-gray-600">{{ t('landing.about.courseVariety') }}</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">250+</div>
                <p class="text-gray-600">{{ t('landing.about.professionalInstructors') }}</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">15,000+</div>
                <p class="text-gray-600">{{ t('landing.about.registeredStudents') }}</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">98%</div>
                <p class="text-gray-600">{{ t('landing.about.satisfactionRate') }}</p>
              </div>
            </div>
            <NuxtLink to="/#contact" class="btn btn-primary">
              {{ t('landing.about.contactUs') }}
            </NuxtLink>
          </div>
        </div>
      </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold mb-4">{{ t('landing.contact.title') }}</h2>
          <p class="text-gray-600 max-w-2xl mx-auto">{{ t('landing.contact.description') }}</p>
        </div>

        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-md p-8">
          <form>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">{{ t('landing.contact.name') }}</label>
                <input type="text" id="name" class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" :placeholder="t('landing.contact.namePlaceholder')">
              </div>
              <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">{{ t('landing.contact.email') }}</label>
                <input type="email" id="email" class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" :placeholder="t('landing.contact.emailPlaceholder')">
              </div>
            </div>
            <div class="mb-6">
              <label for="subject" class="block text-sm font-medium text-gray-700 mb-1">{{ t('landing.contact.subject') }}</label>
              <input type="text" id="subject" class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" :placeholder="t('landing.contact.subjectPlaceholder')">
            </div>
            <div class="mb-6">
              <label for="message" class="block text-sm font-medium text-gray-700 mb-1">{{ t('landing.contact.message') }}</label>
              <textarea id="message" rows="5" class="w-full px-4 py-2 border rounded-lg focus:ring-primary focus:border-primary" :placeholder="t('landing.contact.messagePlaceholder')"></textarea>
            </div>
            <div class="text-center">
              <button type="submit" class="btn btn-primary px-8">
                {{ t('landing.contact.sendMessage') }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </section>
  </div>
</template>

<script lang="ts" setup>
const { t } = useLanguage();

definePageMeta({
  layout: 'landing'
});

useHead({
  title: t('landing.hero.title'),
  meta: [
    {
      name: 'description',
      content: t('landing.hero.subtitle')
    }
  ]
});
</script>

<style>
</style>

