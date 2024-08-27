const ProjectPreview = {
  init() {
    const projectPreviewElement = document.querySelector("[data-project-preview]");

    if (!projectPreviewElement) return;
    
    const initialPlayButton = projectPreviewElement.querySelector("[data-play-button]");
    const videoElement = projectPreviewElement.querySelector("video");

    initialPlayButton.onclick = () => {
      initialPlayButton.style.display = "none";
      videoElement.play();
      videoElement.controls = true;
    };
  }
};

export default ProjectPreview;
