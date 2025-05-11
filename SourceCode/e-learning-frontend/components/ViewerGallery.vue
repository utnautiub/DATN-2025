<template>
  <div class="viewer-gallery-container">
    <div class="images-container" v-viewer="options">
      <img 
        v-for="(image, index) in images"
        :key="index"
        :src="typeof image === 'string' ? image : image.src"
        :alt="typeof image === 'string' ? '' : (image.alt || '')"
        :data-caption="typeof image === 'string' ? '' : (image.caption || '')"
        :class="imgClass"
        class="gallery-image"
        @click="viewImage($event, index)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface ImageItem {
  src: string;
  alt?: string;
  caption?: string;
}

type ImageArray = Array<string | ImageItem>;

const props = defineProps({
  images: {
    type: Array as () => ImageArray,
    required: true
  },
  imgClass: {
    type: String,
    default: 'rounded-lg object-cover cursor-pointer'
  }
});

const options = ref({
  // Gallery specific options
  navbar: true,
  title: true,
  toolbar: true,
  tooltip: true,
  movable: true,
  zoomable: true,
  rotatable: true,
  scalable: true,
  transition: true,
  fullscreen: true,
  keyboard: true,
  url: 'src',
  ready: function(e: any) {
    // Viewer initialized
  },
  show: function(e: any) {
    // Viewer shown
  },
  viewed: function(e: any) {
    // Image viewed
    // Set caption dynamically from data attribute
    const target = e.detail.originalImage;
    const caption = target.getAttribute('data-caption');
    if (caption) {
      const viewer = e.detail.viewer;
      viewer.title = caption;
    }
  }
});

const viewImage = (e: Event, index: number) => {
  const target = e.target as HTMLElement;
  const viewer = (target.parentElement as any).$viewer;
  if (viewer) {
    viewer.view(index);
  }
};
</script>

<style scoped>
.viewer-gallery-container {
  width: 100%;
}

.images-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.gallery-image {
  transition: all 0.3s ease;
}

.gallery-image:hover {
  opacity: 0.9;
  transform: scale(1.02);
}
</style> 