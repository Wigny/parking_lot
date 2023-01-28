const DrawCanvas = {
  updated() {
    const context = this.el.getContext("2d");
    const image = new Image();

    image.onload = () => {
      context.drawImage(image, 0, 0);
    };

    image.src = this.el.dataset.image;
  },
};

export default DrawCanvas;
