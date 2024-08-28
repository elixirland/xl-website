const ProjectPreview = {
  init() {
    const projectPreviewElement = document.querySelector("[data-project-preview]");

    if (!projectPreviewElement) return;
    
    const initialPlayButton = projectPreviewElement.querySelector("[data-play-button]");
    const videoElement = projectPreviewElement.querySelector("video");
    const durationElement = projectPreviewElement.querySelector("[data-video-duration]");

    videoElement.onloadedmetadata = () => {
      const duration = videoElement.duration;
      const minutes = Math.floor(duration / 60);
      const seconds = Math.floor(duration % 60);
      durationElement.textContent = `${minutes}:${seconds < 10 ? `0${seconds}` : seconds}`;
      videoElement.style.display = "block";
    }


    initialPlayButton.onclick = () => {
      initialPlayButton.style.display = "none";
      videoElement.play();
      videoElement.controls = true;
    };
  }
};

export default ProjectPreview;
