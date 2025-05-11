<template>
  <div>
    <Timeline :data="timelineData" class="mb-[150px]" />
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
        src: 'https://tlus.edu.vn/wp-content/uploads/2024/04/khoa14.jpg',
        alt: 'Trụ sở chính tại Hà Nội',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "1964",
    content: h('div', [
      h('p', 'Đổi tên thành Trường Đại học Thủy Lợi, chính thức mở rộng đào tạo và nghiên cứu chuyên ngành thủy lợi.'),
      h('img', {
        src: 'https://huongnghiep.hocmai.vn/wp-content/uploads/2022/02/148434662-2961600134114291-582-2356-7538-1631711557.jpg',
        alt: 'Lễ khánh thành trường',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "1997",
    content: h('div', [
      h('p', 'Trường mở rộng cơ sở đào tạo tại TP.HCM, đánh dấu bước phát triển quan trọng cho việc mở rộng đào tạo thủy lợi ở miền Nam.'),
      h('img', {
        src: 'https://tlus.edu.vn/wp-content/uploads/2023/04/pci4-1.jpg',
        alt: 'Cơ sở 2',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "2001",
    content: h('div', [
      h('p', 'Trường mở ngành Công nghệ Thông tin và thành lập Khoa Công nghệ Thông tin, đánh dấu sự mở rộng sang lĩnh vực công nghệ mới.'),
      h('img', {
        src: 'https://scontent.fhan14-5.fna.fbcdn.net/v/t39.30808-6/453076121_989717493078665_1884255192949327936_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=9rSmjpENsNAQ7kNvwFR220f&_nc_oc=Admzb2_tLmK6I18VAVaxVD9mfh2fvK5kTbYvZq4yiVFQxJWdrm0VkF-xKEFFXy3jNsFimXQU1Gb9Kix7Q3YtUjQX&_nc_zt=23&_nc_ht=scontent.fhan14-5.fna&_nc_gid=8lHVIPpgQI33NNxFxYO9oQ&oh=00_AfKmT6H6STbvoEAYnNO2Ao4Ezosy-pGEFAMaqtcR5w26PA&oe=6825BB5F',
        alt: 'Logo Đại học Thủy lợi',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "2006",
    content: h('div', [
      h('p', 'Trường bắt đầu áp dụng chiến lược phát triển 2006-2020, tập trung vào đào tạo đa ngành, bao gồm Công nghệ Thông tin.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/1609.png',
        alt: 'Đại học Thủy lợi',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "2012",
    content: h('div', [
      h('p', 'Thành lập Trung tâm Đào tạo Quốc tế, mở rộng hợp tác quốc tế và cung cấp chương trình đào tạo đạt chuẩn quốc tế.'),
      h('img', {
        src: 'https://sie.tlu.edu.vn/Portals/0/image002.jpg',
        alt: 'Trung tâm đào tạo quốc tế',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "2015",
    content: h('div', [
      h('p', 'Hợp tác với Samsung Electronics phát triển phòng lab CNTT và tuyển dụng sinh viên ngành Công nghệ Thông tin sau khi tốt nghiệp.'),
      h('img', {
        src: 'https://resource.kinhtedothi.vn/2021/12/22/samsung-lab.jpg',
        alt: 'Hợp tác CNTT',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "2019",
    content: h('div', [
      h('p', 'Kỷ niệm 60 năm thành lập trường, đánh dấu chặng đường phát triển và đóng góp cho ngành thủy lợi Việt Nam.'),
      h('img', {
        src: 'https://www.tlu.edu.vn/Portals/0/2019/Thang11/huanchuthumb.jpg',
        alt: 'Chương trình đào tạo CNTT',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  },
  {
    title: "2024",
    content: h('div', [
      h('p', 'Kỷ niệm 65 năm thành lập Trường Đại học Thủy lợi, đẩy mạnh các chương trình nghiên cứu ứng dụng trong ngành Công nghệ Thông tin và Thủy lợi.'),
      h('img', {
        src: 'https://ddk.1cdn.vn/2024/11/16/tl2.jpg',
        alt: 'Kỷ niệm 65 năm',
        class: 'rounded-lg object-cover mt-4 h-full w-full'
      })
    ])
  }
];


useHead({
  title: 'Lịch sử phát triển - Đại học Thủy Lợi',
  meta: [
    {
      name: 'description',
      content: 'Hành trình phát triển của Trường Đại học Thủy Lợi từ năm 1959 đến nay'
    }
  ]
})
</script>
