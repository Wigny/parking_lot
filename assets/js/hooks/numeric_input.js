const NumericInput = {
  mounted() {
    this.el.addEventListener('input', () => {
      this.el.value = this.el.value.replace(/\D+/g, '')
    });
  },
};

export default NumericInput;
