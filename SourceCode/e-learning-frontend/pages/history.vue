<template>
  <div>
    <Timeline :data="timelineData" class="mb-[150px]" />
    
    <!-- Gallery chung cho toàn bộ ảnh timeline -->
    <div ref="galleryRef" class="gallery-container">
      <div v-viewer="viewerOptions" ref="viewerRef">
        <img 
          v-for="(image, index) in timelineImages" 
          :key="index"
          :src="image.src"
          :alt="image.alt || ''"
          :data-caption="image.caption || ''"
          class="hidden"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { h, ref, onMounted, nextTick } from 'vue'
// Xóa import không cần thiết này vì đã có plugin v-viewer
// import Viewer from 'viewerjs';

definePageMeta({
  layout: 'landing'
});

// Sửa lại cách khởi tạo viewer
const viewerOptions = {
  zoomable: true,
  scalable: true,
  rotatable: true,
  movable: true,
  navbar: true,
  title: true,
  toolbar: true,
  tooltip: true
};

const { t } = useI18n();

// Thu thập tất cả các ảnh sử dụng trong timeline
const timelineImages = [
  {
    src: 'https://tlus.edu.vn/wp-content/uploads/2024/04/khoa14.jpg',
    alt: t('history.timeline.1959.imgAlt'),
    caption: t('history.timeline.1959.imgCaption')
  },
  {
    src: 'https://huongnghiep.hocmai.vn/wp-content/uploads/2022/02/148434662-2961600134114291-582-2356-7538-1631711557.jpg',
    alt: t('history.timeline.1964.imgAlt'),
    caption: t('history.timeline.1964.imgCaption')
  },
  {
    src: 'https://tlus.edu.vn/wp-content/uploads/2023/04/pci4-1.jpg',
    alt: t('history.timeline.1997.imgAlt'),
    caption: t('history.timeline.1997.imgCaption')
  },
  {
    src: 'https://scontent.fhan14-5.fna.fbcdn.net/v/t39.30808-6/453076121_989717493078665_1884255192949327936_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=9rSmjpENsNAQ7kNvwFR220f&_nc_oc=Admzb2_tLmK6I18VAVaxVD9mfh2fvK5kTbYvZq4yiVFQxJWdrm0VkF-xKEFFXy3jNsFimXQU1Gb9Kix7Q3YtUjQX&_nc_zt=23&_nc_ht=scontent.fhan14-5.fna&_nc_gid=8lHVIPpgQI33NNxFxYO9oQ&oh=00_AfKmT6H6STbvoEAYnNO2Ao4Ezosy-pGEFAMaqtcR5w26PA&oe=6825BB5F',
    alt: t('history.timeline.2001.imgAlt'),
    caption: t('history.timeline.2001.imgCaption')
  },
  {
    src: 'https://www.tlu.edu.vn/Portals/0/1609.png',
    alt: t('history.timeline.2006.imgAlt'),
    caption: t('history.timeline.2006.imgCaption')
  },
  {
    src: 'https://sie.tlu.edu.vn/Portals/0/image002.jpg',
    alt: t('history.timeline.2012.imgAlt'),
    caption: t('history.timeline.2012.imgCaption')
  },
  {
    src: 'https://resource.kinhtedothi.vn/2021/12/22/samsung-lab.jpg',
    alt: t('history.timeline.2015.imgAlt'),
    caption: t('history.timeline.2015.imgCaption')
  },
  {
    src: 'https://www.tlu.edu.vn/Portals/0/2019/Thang11/huanchuthumb.jpg',
    alt: t('history.timeline.2019.imgAlt'),
    caption: t('history.timeline.2019.imgCaption')
  },
  {
    src: 'https://ddk.1cdn.vn/2024/11/16/tl2.jpg',
    alt: t('history.timeline.2024.imgAlt'),
    caption: t('history.timeline.2024.imgCaption')
  }
];

const viewerRef = ref<any>(null);

const showImage = (index: number) => {
  if (viewerRef.value && viewerRef.value.$viewer) {
    viewerRef.value.$viewer.view(index);
  }
};

// Định nghĩa dữ liệu timeline với các mốc thời gian
const timelineData = [
  {
    title: t('history.timeline.1959.title'),
    content: h('div', [
      h('p', t('history.timeline.1959.content')),
      h('img', {
        src: timelineImages[0].src,
        alt: timelineImages[0].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(0)
      })
    ])
  },
  {
    title: t('history.timeline.1964.title'),
    content: h('div', [
      h('p', t('history.timeline.1964.content')),
      h('img', {
        src: timelineImages[1].src,
        alt: timelineImages[1].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(1)
      })
    ])
  },
  {
    title: t('history.timeline.1997.title'),
    content: h('div', [
      h('p', t('history.timeline.1997.content')),
      h('img', {
        src: timelineImages[2].src,
        alt: timelineImages[2].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(2)
      })
    ])
  },
  {
    title: t('history.timeline.2001.title'),
    content: h('div', [
      h('p', t('history.timeline.2001.content')),
      h('img', {
        src: timelineImages[3].src,
        alt: timelineImages[3].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(3)
      })
    ])
  },
  {
    title: t('history.timeline.2006.title'),
    content: h('div', [
      h('p', t('history.timeline.2006.content')),
      h('img', {
        src: timelineImages[4].src,
        alt: timelineImages[4].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(4)
      })
    ])
  },
  {
    title: t('history.timeline.2012.title'),
    content: h('div', [
      h('p', t('history.timeline.2012.content')),
      h('img', {
        src: timelineImages[5].src,
        alt: timelineImages[5].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(5)
      })
    ])
  },
  {
    title: t('history.timeline.2015.title'),
    content: h('div', [
      h('p', t('history.timeline.2015.content')),
      h('img', {
        src: timelineImages[6].src,
        alt: timelineImages[6].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(6)
      })
    ])
  },
  {
    title: t('history.timeline.2019.title'),
    content: h('div', [
      h('p', t('history.timeline.2019.content')),
      h('img', {
        src: timelineImages[7].src,
        alt: timelineImages[7].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(7)
      })
    ])
  },
  {
    title: t('history.timeline.2024.title'),
    content: h('div', [
      h('p', t('history.timeline.2024.content')),
      h('img', {
        src: timelineImages[8].src,
        alt: timelineImages[8].alt,
        class: 'rounded-lg object-cover mt-4 h-full w-full cursor-pointer',
        onClick: () => showImage(8)
      })
    ])
  }
];

useHead({
  title: t('history.pageTitle'),
  meta: [
    {
      name: 'description',
      content: t('history.pageDescription')
    }
  ]
})
</script>

<style scoped>
.gallery-container {
  position: absolute;
  width: 0;
  height: 0;
  overflow: hidden;
}

.hidden {
  display: none;
}
</style>
