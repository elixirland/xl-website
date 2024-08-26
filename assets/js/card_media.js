// TODO: Clean up and test this code

const CardMedia = {
  init() {
    const cardMediaElements = document.querySelectorAll("[data-card-media]")

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
}

export default CardMedia
