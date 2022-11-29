const constraints = {
  video: {
    facingMode: "environment",
    width: { min: 1024, ideal: 1280, max: 1920 },
    height: { min: 576, ideal: 720, max: 1080 },
  },
  audio: false,
}

const StartCamera = {
  mounted() {
    const hook = this;
    const video = this.el;
    const canvas = document.createElement("canvas");

    navigator.mediaDevices
      .getUserMedia(constraints)
      .then((stream) => {
        video.srcObject = stream;
        video.onloadedmetadata = () => {
          video.play();

          canvas.width = video.videoWidth;
          canvas.height = video.videoHeight;

          const context = canvas.getContext("2d");

          setInterval(() => {
            context.drawImage(video, 0, 0, video.videoWidth, video.videoHeight);

            hook.pushEvent("video_snapshot", canvas.toDataURL("image/png"))
          }, 3000);
        }
      });
  }
}

export default StartCamera;
