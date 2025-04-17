<template>
  <div class="w-full min-h-[calc(100dvh-100px)] flex items-center justify-center overflow-x-hidden">
    <div class="w-full h-full">
      <Timeline :data="timelineData" />
    </div>
  </div>
</template>

<script setup lang="ts">
import Timeline from '~/components/Timeline.vue'

definePageMeta({
  layout: 'landing'
});

const timelineData = [
  {
    title: "2022",
    content: `
      <div>
        <p class="text-neutral-800 dark:text-neutral-200 text-sm md:text-base font-normal mb-8">
          Khởi đầu dự án với tầm nhìn mang đến một nền tảng học tập trực tuyến hiện đại. <br>
          Tập trung vào xây dựng các tính năng cốt lõi và thiết kế trải nghiệm người dùng.
        </p>
        <div class="grid grid-cols-2 gap-4">
          <img src="/images/history/2022_1.jpg" alt="2022" 
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
          <img src="/images/history/2022_2.jpg" alt="2022"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
          <img src="/images/history/2022_3.jpg" alt="2022"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
          <img src="/images/history/2022_4.jpg" alt="2022"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
        </div>
      </div>
    `
  },
  {
    title: "Đầu 2023",
    content: `
      <div>
        <p class="text-neutral-800 dark:text-neutral-200 text-sm md:text-base font-normal mb-8">
          Mở rộng quy mô và tính năng của nền tảng. <br>
          Tập trung vào việc phát triển các tính năng học tập tương tác và cải thiện trải nghiệm người dùng.
        </p>
        <div class="grid grid-cols-2 gap-4">
          <img src="/images/history/2023_1.jpg" alt="2023"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
          <img src="/images/history/2023_2.jpg" alt="2023"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
        </div>
      </div>
    `
  },
  {
    title: "2023",
    content: `
      <div>
        <p class="text-neutral-800 dark:text-neutral-200 text-sm md:text-base font-normal mb-8">
          Tối ưu hóa hiệu suất và cải thiện trải nghiệm người dùng. <br>
          Giải quyết các thách thức kỹ thuật và nâng cao khả năng mở rộng của sản phẩm.
        </p>
        <div class="grid grid-cols-1 gap-4">
          <img src="/images/history/2023_3.jpg" alt="2023"
               class="rounded-lg object-cover w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
        </div>
      </div>
    `
  },
  {
    title: "2024",
    content: `
      <div>
        <p class="text-neutral-800 dark:text-neutral-200 text-sm md:text-base font-normal mb-8">
          Phát triển các tính năng mới và tích hợp công nghệ tiên tiến. <br>
          Mở rộng đội ngũ phát triển và cải thiện quy trình làm việc.
        </p>
        <div class="grid grid-cols-1 gap-4">
          <img src="/images/history/2024_1.jpg" alt="2024"
               class="rounded-lg object-cover w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
        </div>
      </div>
    `
  },
  {
    title: "Điểm nhấn 2024",
    content: `
      <div>
        <p class="text-neutral-800 dark:text-neutral-200 text-sm md:text-base font-normal mb-8">
          Trong năm qua, chúng tôi đã đạt được nhiều thành tựu đáng kể:
        </p>
        <div class="mb-8">
          <div class="flex gap-2 items-center text-neutral-700 dark:text-neutral-300 text-sm md:text-base">
            ✅ Ra mắt nhiều khóa học mới với nội dung chất lượng cao
          </div>
          <div class="flex gap-2 items-center text-neutral-700 dark:text-neutral-300 text-sm md:text-base">
            ✅ Cải thiện trải nghiệm học tập với công nghệ mới
          </div>
          <div class="flex gap-2 items-center text-neutral-700 dark:text-neutral-300 text-sm md:text-base">
            ✅ Xây dựng cộng đồng học tập sôi động
          </div>
          <div class="flex gap-2 items-center text-neutral-700 dark:text-neutral-300 text-sm md:text-base">
            ✅ Tối ưu hóa giao diện người dùng
          </div>
          <div class="flex gap-2 items-center text-neutral-700 dark:text-neutral-300 text-sm md:text-base">
            ✅ Phát triển tính năng học tập cá nhân hóa
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <img src="/images/history/2024_2.jpg" alt="2024"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
          <img src="/images/history/2024_3.jpg" alt="2024"
               class="rounded-lg object-cover h-20 md:h-44 lg:h-60 w-full shadow-[0_0_24px_rgba(34,_42,_53,_0.06),_0_1px_1px_rgba(0,_0,_0,_0.05),_0_0_0_1px_rgba(34,_42,_53,_0.04),_0_0_4px_rgba(34,_42,_53,_0.08),_0_16px_68px_rgba(47,_48,_55,_0.05),_0_1px_0_rgba(255,_255,_255,_0.1)_inset]" />
        </div>
      </div>
    `
  }
];

useHead({
  title: 'Lịch sử phát triển | E-Learning Platform',
  meta: [
    {
      name: 'description',
      content: 'Khám phá hành trình phát triển của nền tảng học tập trực tuyến hàng đầu.'
    }
  ]
});
</script>



