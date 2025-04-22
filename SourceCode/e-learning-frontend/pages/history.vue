<template>
  <div>
    <Timeline :data="timelineData" />
  </div>
</template>

<script setup lang="ts">
import { h } from 'vue'

definePageMeta({
  layout: 'landing'
});

const timelineData = [
  {
    title: "1959",
    content: h('div', [
      h('p', 'Thành lập Học viện Thủy Lợi và Điện Lực, đặt nền móng cho đào tạo kỹ sư thủy lợi và thủy điện tại Việt Nam.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2020/10/anh1.jpg',
        alt: 'Trụ sở chính tại Hà Nội',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  },
  {
    title: "1986",
    content: h('div', [
      h('p', 'Nâng cấp thành Trường Đại học Thủy Lợi, mở rộng quy mô đào tạo và nghiên cứu.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2020/10/anh2.jpg',
        alt: 'Toàn cảnh khuôn viên trường',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  },
  {
    title: "2004",
    content: h('div', [
      h('p', 'Trở thành trường đại học trọng điểm quốc gia, thuộc Bộ Nông nghiệp và Phát triển Nông thôn.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2019/10/ky-niem-60-nam.jpg',
        alt: 'Lễ kỷ niệm 60 năm thành lập',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  },
  {
    title: "2017",
    content: h('div', [
      h('p', 'Mở cơ sở tại TP. Hồ Chí Minh, mở rộng quy mô đào tạo ở miền Nam.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2020/10/anh3.jpg',
        alt: 'Cơ sở tại TP. Hồ Chí Minh',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  },
  {
    title: "2019",
    content: h('div', [
      h('p', 'Kỷ niệm 60 năm thành lập, vinh danh đóng góp trong giáo dục và thủy lợi.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2019/10/ky-niem-60-nam.jpg',
        alt: 'Lễ kỷ niệm 60 năm thành lập',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  },
  {
    title: "2023",
    content: h('div', [
      h('p', 'Ra mắt trung tâm nghiên cứu biến đổi khí hậu, tập trung vào giải pháp bền vững cho tài nguyên nước.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2020/10/anh4.jpg',
        alt: 'Hoạt động nghiên cứu và đào tạo',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  },
  {
    title: "2024",
    content: h('div', [
      h('p', 'Kỷ niệm 65 năm thành lập, tổ chức các sự kiện tôn vinh đóng góp trong giáo dục và quản lý tài nguyên nước.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/Images/2019/10/ky-niem-60-nam.jpg',
        alt: 'Lễ kỷ niệm 60 năm thành lập',
        class: 'rounded-lg object-cover h-44 w-full'
      })
    ])
  }
];


useHead({
})
</script>
