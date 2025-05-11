import 'viewerjs/dist/viewer.css'
import VueViewer from 'v-viewer'

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.use(VueViewer, {
    defaultOptions: {
      zIndex: 9999,
      navbar: true,
      title: true,
      toolbar: {
        zoomIn: true,
        zoomOut: true,
        oneToOne: true,
        reset: true,
        prev: true,
        next: true,
        rotateLeft: true,
        rotateRight: true,
        flipHorizontal: true,
        flipVertical: true,
        play: {
          show: true,
          size: 'large',
        },
      },
      backdrop: true,
      button: true,
      keyboard: true,
      fullscreen: true,
      movable: true,
      rotatable: true,
      scalable: true,
      transition: true,
      loop: false
    }
  })
}) 