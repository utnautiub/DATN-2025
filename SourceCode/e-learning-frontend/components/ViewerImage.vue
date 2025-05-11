<template>
  <div class="viewer-image-container">
    <img 
      :src="src" 
      :alt="alt" 
      :class="imgClass" 
      v-viewer="options"
      @click="viewImage($event)"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const props = defineProps({
  src: {
    type: String,
    required: true
  },
  alt: {
    type: String,
    default: 'Image'
  },
  caption: {
    type: String,
    default: ''
  },
  imgClass: {
    type: String,
    default: 'rounded-lg object-cover cursor-pointer'
  }
});

const options = ref({
  // override the default options if needed
  title: props.caption ? [props.caption] : false,
  toolbar: {
    zoomIn: true,
    zoomOut: true,
    oneToOne: true,
    reset: true,
    prev: false,
    next: false,
    rotateLeft: true,
    rotateRight: true,
    flipHorizontal: true,
    flipVertical: true,
  },
  transition: true,
  movable: true,
  scalable: true,
  backdrop: 'static'
});

const viewImage = (e: Event) => {
  const target = e.target as HTMLImageElement;
  const viewer = (target as any).$viewer;
  if (viewer) {
    viewer.show();
  }
};
</script>

<style scoped>
.viewer-image-container {
  display: inline-block;
  position: relative;
}
</style> 