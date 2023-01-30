const ReadClipboard = {
  mounted() {
    if (!this.el.value) {
      navigator.clipboard.readText().then((value) => {
        this.el.value = value;
      });
    }
  },
};

export default ReadClipboard;
