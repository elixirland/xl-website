// TODO: Clean up and test this code

const CardMedia = {
  cardMediaElements: null,
  debounceTime: 1500,

  init() {
    // Delay the initialization of the card media elements to ensure that the
    // onscroll event listener is not triggered during, or just after, the
    // initial page load.

    document.addEventListener("DOMContentLoaded", () => {
      setTimeout(() => {
        this.cardMediaElements = document.querySelectorAll("[data-card-media]")
        
        if (this.cardMediaElements.length === 0) return

        const mediaQuery = window.matchMedia("(max-width: 500px)")

        if (mediaQuery.matches) {
          this.playPreviewOnScroll()
        } else {
          this.playPreviewOnHover()
        }

        // TODO: Instead of viewport size, let user agent type decide what triggers
        // video playback

        window.addEventListener("resize", () => {
          this.resetAllProjectCards()

          const windowWidth = window.innerWidth || document.documentElement.clientWidth

          if (windowWidth < 500) {
            this.playPreviewOnScroll()
          } else {
            this.playPreviewOnHover()
          }
        })
      }, 500)
    })
  },

  playPreviewOnScroll() {
    // On scroll check if a thumbnail of thumbnail is in the center of the viewport
    // If it is, play the video
    let debounceTimeout

    window.addEventListener("scroll", () => {
      clearTimeout(debounceTimeout)

      this.cardMediaElements.forEach((cardMediaElement) => {
        const img = cardMediaElement.querySelector("img")
        const video = cardMediaElement.querySelector("video")

        if (img.hasBrokenSrc) return

        const rect = cardMediaElement.getBoundingClientRect()
        const windowHeight = window.innerHeight || document.documentElement.clientHeight
        const windowWidth = window.innerWidth || document.documentElement.clientWidth

        const verticalMargin = (windowHeight - rect.height) / 2 * 0.60

        const isElementInViewport = (
          rect.top >= verticalMargin &&
          rect.left >= 0 &&
          rect.bottom <= windowHeight - verticalMargin &&
          rect.right <= windowWidth
        )

        if (isElementInViewport) {
          debounceTimeout = setTimeout(() => {
            img.style.display = "none"
            video.style.display = "block"
            video.play()
          }, this.debounceTime)
        } else {
          img.style.display = "block"
          video.style.display = "none"
          video.pause()
          video.currentTime = 0
        }

        video.onended = () => {
          img.style.display = "block"
          video.style.display = "none"
        }
      })
    })
  },

  playPreviewOnHover() {
      // On hover, play the video
      this.cardMediaElements.forEach((cardMediaElement) => {
        const img = cardMediaElement.querySelector("img")
        const video = cardMediaElement.querySelector("video")
  
        img.hasBrokenSrc = false
  
        img.onerror = () => {
          img.style.display = "none"
          img.hasBrokenSrc = true
          video.style.display = "block"
          video.play()
        }
  
        img.onmouseenter = () => {
          img.style.display = "none"
          video.style.display = "block"
          video.play()
        }
  
        video.onmouseleave = () => {
          if (!img.hasBrokenSrc) {
            img.style.display = "block"
            video.style.display = "none"
          }
          video.pause()
          video.currentTime = 0
        }
      })
    },

  resetAllProjectCards() {
    this.cardMediaElements.forEach((cardMediaElement) => {
      const img = cardMediaElement.querySelector("img")
      const video = cardMediaElement.querySelector("video")

      img.style.display = "block"
      video.style.display = "none"
      video.pause()
      video.currentTime = 0
    })
  }
}

export default CardMedia
