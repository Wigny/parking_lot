const InputUppercase = {
  mounted() {
    this.el.addEventListener("input", () => {
      this.el.value = this.el.value.toUpperCase();
    });
  },
};

export default InputUppercase;
