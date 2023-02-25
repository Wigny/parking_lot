const InputPatternConstraint = {
  mounted() {
    this.el.addEventListener("beforeinput", (e) => {
      let beforeValue = this.el.value;

      e.target.addEventListener("input", () => {
        if (this.el.validity.patternMismatch) {
          this.el.value = beforeValue;
        }
      }, { once: true });
    });
  },
};

export default InputPatternConstraint;
