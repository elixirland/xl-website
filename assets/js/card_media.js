// TODO: Clean up and test this code

const CardMedia = {
  init() {
    const cardMediaElements = document.querySelectorAll("[data-card-media]")
    
    if (cardMediaElements.length === 0) return

    const mediaQuery = window.matchMedia("(max-width: 500px)")

    if (mediaQuery.matches) {
      // On scroll check if a thumbnail of thumbnail is in the center of the viewport
      // If it is, play the video
      let debounceTimeout

      window.addEventListener("scroll", () => {

        clearTimeout(debounceTimeout)

        cardMediaElements.forEach((cardMediaElement) => {
          const img = cardMediaElement.querySelector("img")
          const video = cardMediaElement.querySelector("video")

          if (img.hasBrokenSrc) return

          const rect = cardMediaElement.getBoundingClientRect()
          const windowHeight = window.innerHeight || document.documentElement.clientHeight
          const windowWidth = window.innerWidth || document.documentElement.clientWidth

          const verticalMargin = (windowHeight - rect.height) / 2 * 0.66

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
            }, 2000)
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
    } else {
      // On hover, play the video
      cardMediaElements.forEach((cardMediaElement) => {
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
    }

    // TODO: Instead of viewport size, let user agent type decide what triggers
    // video playback

    window.addEventListener("resize", () => {

      cardMediaElements.forEach((cardMediaElement) => {
        const img = cardMediaElement.querySelector("img")
        const video = cardMediaElement.querySelector("video")

        img.style.display = "block"
        video.style.display = "none"
        video.pause()
        video.currentTime = 0
      })

      const windowWidth = window.innerWidth || document.documentElement.clientWidth

      if (windowWidth < 500) {
        window.addEventListener("scroll", () => {
          clearTimeout(debounceTimeout)

          cardMediaElements.forEach((cardMediaElement) => {
            const img = cardMediaElement.querySelector("img")
            const video = cardMediaElement.querySelector("video")

            if (img.hasBrokenSrc) return

            const rect = cardMediaElement.getBoundingClientRect()
            const windowHeight = window.innerHeight || document.documentElement.clientHeight
            const windowWidth = window.innerWidth || document.documentElement.clientWidth

            const verticalMargin = (windowHeight - rect.height) / 2 * 0.66

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
              }, 2000)
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
      } else {
        cardMediaElements.forEach((cardMediaElement) => {
          const img = cardMediaElement.querySelector("img")
          const video = cardMediaElement.querySelector("video")

          img.onmouseenter = () => {
            img.style.display = "none"
            video.style.display = "block"
            video.play()
          }

          video.onmouseleave = () => {
            img.style.display = "block"
            video.style.display = "none"
            video.pause()
            video.currentTime = 0
          }
        })
      }
    })
  }
}

export default CardMedia
