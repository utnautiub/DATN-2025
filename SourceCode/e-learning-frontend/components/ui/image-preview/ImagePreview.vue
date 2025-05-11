<template>
  <div class="image-preview-container">
    <!-- Hình ảnh thumbnail có thể nhấp -->
    <div 
      class="relative cursor-pointer overflow-hidden rounded-lg transition-all duration-300 hover:shadow-lg group"
      @click="openPreview"
    >
      <img 
        :src="src" 
        :alt="alt || 'Hình ảnh'" 
        class="w-full h-auto object-cover transition-transform duration-500 group-hover:scale-105" 
        @error="handleImageError"
      />
      <div class="absolute inset-0 flex items-center justify-center bg-black/30 opacity-0 transition-opacity duration-300 group-hover:opacity-100">
        <Icon 
          icon="heroicons:magnifying-glass-plus-20-solid" 
          class="text-white h-8 w-8" 
        />
      </div>
    </div>

    <!-- Dialog xem trước hình ảnh -->
    <Dialog v-model:open="isPreviewOpen">
      <DialogContent class="fixed inset-0 m-0 p-0 max-w-none h-screen bg-black/90">
        <div class="relative w-full h-full flex flex-col">
          <!-- Thanh công cụ -->
          <div class="absolute top-4 right-4 z-20 flex gap-2">
            <Button variant="outline" size="icon" class="rounded-full backdrop-blur-md bg-white/20 hover:bg-white/30 dark:bg-black/20 dark:hover:bg-black/30" @click="zoomIn">
              <Icon icon="heroicons:plus-20-solid" class="h-5 w-5 text-white" />
            </Button>
            <Button variant="outline" size="icon" class="rounded-full backdrop-blur-md bg-white/20 hover:bg-white/30 dark:bg-black/20 dark:hover:bg-black/30" @click="zoomOut">
              <Icon icon="heroicons:minus-20-solid" class="h-5 w-5 text-white" />
            </Button>
            <Button variant="outline" size="icon" class="rounded-full backdrop-blur-md bg-white/20 hover:bg-white/30 dark:bg-black/20 dark:hover:bg-black/30" @click="resetZoom">
              <Icon icon="heroicons:arrow-path-20-solid" class="h-5 w-5 text-white" />
            </Button>
            <Button variant="outline" size="icon" class="rounded-full backdrop-blur-md bg-white/20 hover:bg-white/30 dark:bg-black/20 dark:hover:bg-black/30" @click="closePreview">
              <Icon icon="heroicons:x-mark-20-solid" class="h-5 w-5 text-white" />
            </Button>
          </div>
          
          <!-- Container hình ảnh với khả năng zoom và pan -->
          <div 
            class="relative flex-1 flex items-center justify-center overflow-hidden"
            @mousedown="startDrag"
            @mousemove="onDrag"
            @mouseup="stopDrag"
            @mouseleave="stopDrag"
            @touchstart="startDragTouch"
            @touchmove="onDragTouch"
            @touchend="stopDrag"
            @wheel.prevent="handleZoom"
          >
            <img 
              ref="previewImage"
              :src="src" 
              :alt="alt || 'Hình ảnh xem trước'" 
              class="max-h-full max-w-full object-contain transition-transform duration-200 ease-out select-none"
              :style="{ 
                transform: `translate(${position.x}px, ${position.y}px) scale(${zoom})`,
                cursor: isDragging ? 'grabbing' : 'grab'
              }" 
              @error="handleImageError"
            />
          </div>
          
          <!-- Caption nếu có -->
          <div v-if="caption" class="p-4 text-center text-sm text-white bg-black/50">
            {{ caption }}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, nextTick } from 'vue';
import { Icon } from '@iconify/vue';

interface Props {
  src: string;
  alt?: string;
  caption?: string;
}

const props = defineProps<Props>();

// Trạng thái của dialog
const isPreviewOpen = ref(false);

// Trạng thái zoom và pan
const zoom = ref(1);
const position = reactive({ x: 0, y: 0 });
const isDragging = ref(false);
const dragStart = reactive({ x: 0, y: 0 });
const positionStart = reactive({ x: 0, y: 0 });
const previewImage = ref<HTMLImageElement | null>(null);

// Xử lý lỗi tải hình ảnh
const handleImageError = (e: Event) => {
  const img = e.target as HTMLImageElement;
  img.src = 'https://via.placeholder.com/300x200?text=Hình+ảnh+không+tải+được'; // Hình ảnh mặc định
  img.alt = 'Hình ảnh không tải được';
};

// Mở dialog xem trước
const openPreview = () => {
  resetZoom();
  isPreviewOpen.value = true;
  nextTick(() => {
    resetPosition();
  });
};

// Đóng dialog xem trước
const closePreview = () => {
  isPreviewOpen.value = false;
};

// Xử lý zoom
const zoomIn = () => {
  zoom.value = Math.min(zoom.value + 0.2, 5);
  restrictPosition();
};

const zoomOut = () => {
  zoom.value = Math.max(zoom.value - 0.2, 0.5);
  restrictPosition();
};

const resetZoom = () => {
  zoom.value = 1;
  position.x = 0;
  position.y = 0;
};

const handleZoom = (e: WheelEvent) => {
  const zoomStep = e.deltaY < 0 ? 0.2 : -0.2;
  zoom.value = Math.max(0.5, Math.min(5, zoom.value + zoomStep));
  restrictPosition();
};

// Xử lý kéo thả (drag & pan)
const startDrag = (e: MouseEvent) => {
  e.preventDefault();
  isDragging.value = true;
  dragStart.x = e.clientX;
  dragStart.y = e.clientY;
  positionStart.x = position.x;
  positionStart.y = position.y;
};

const startDragTouch = (e: TouchEvent) => {
  if (e.touches.length === 1) {
    e.preventDefault();
    isDragging.value = true;
    dragStart.x = e.touches[0].clientX;
    dragStart.y = e.touches[0].clientY;
    positionStart.x = position.x;
    positionStart.y = position.y;
  }
};

const onDrag = (e: MouseEvent) => {
  if (isDragging.value) {
    position.x = positionStart.x + (e.clientX - dragStart.x);
    position.y = positionStart.y + (e.clientY - dragStart.y);
    restrictPosition();
  }
};

const onDragTouch = (e: TouchEvent) => {
  if (isDragging.value && e.touches.length === 1) {
    e.preventDefault();
    position.x = positionStart.x + (e.touches[0].clientX - dragStart.x);
    position.y = positionStart.y + (e.touches[0].clientY - dragStart.y);
    restrictPosition();
  }
};

const stopDrag = () => {
  isDragging.value = false;
};

// Giới hạn vị trí kéo thả
const restrictPosition = () => {
  if (!previewImage.value) return;

  const container = previewImage.value.parentElement;
  if (!container) return;

  const imgRect = previewImage.value.getBoundingClientRect();
  const containerRect = container.getBoundingClientRect();

  const scaledWidth = imgRect.width * zoom.value;
  const scaledHeight = imgRect.height * zoom.value;

  const maxX = Math.max(0, (scaledWidth - containerRect.width) / 2 / zoom.value);
  const maxY = Math.max(0, (scaledHeight - containerRect.height) / 2 / zoom.value);

  position.x = Math.max(-maxX, Math.min(maxX, position.x));
  position.y = Math.max(-maxY, Math.min(maxY, position.y));
};

// Căn giữa hình ảnh khi mở
const resetPosition = () => {
  position.x = 0;
  position.y = 0;
  restrictPosition();
};
</script>
<style scoped>
img:focus {
  outline: none;
}

/* Đảm bảo container không bị tràn */
.image-preview-container {
  max-width: 100%;
}

/* Tối ưu hóa hiệu ứng cho dialog */
:deep(.dialog-content) {
  max-height: 100vh;
  overflow: hidden;
}

/* Đảm bảo hình ảnh không bị kéo chọn */
img {
  user-select: none;
  -webkit-user-drag: none;
}
</style>
