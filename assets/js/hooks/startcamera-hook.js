const constraints = {
  video: {
    facingMode: "environment",
    width: { min: 1024, ideal: 1280, max: 1920 },
    height: { min: 576, ideal: 720, max: 1080 },
  },
  audio: false
}

const toBase64 = (blob) => new Promise((resolve) => {
  const reader = new FileReader();
  reader.onloadend = () => resolve(reader.result);
  reader.readAsDataURL(blob);
});

const StartCamera = {
  mounted() {
    const hook = this;
    const video = this.el;

    navigator.mediaDevices
      .getUserMedia(constraints)
      .then((stream) => {
        video.srcObject = stream;

        const tracks = stream.getVideoTracks();
        const imageCapture = new ImageCapture(tracks[0]);

        setInterval(() => {
          imageCapture
            .takePhoto()
            .then(toBase64)
            .then(base64 => hook.pushEvent("video_snapshot", base64));
        }, 1000);
      });
  }
}

export default StartCamera;
