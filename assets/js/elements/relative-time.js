class RelativeTime extends HTMLTimeElement {
  #formatter;

  constructor() {
    super();

    this.#formatter = new Intl.DateTimeFormat([], {
      dateStyle: "short",
      timeStyle: "medium",
    });
  }

  connectedCallback() {
    const date = Date.parse(this.dateTime);

    this.textContent = this.#formatter.format(date);
    this.title = this.dateTime;
  }
}

customElements.define("relative-time", RelativeTime, { extends: "time" });
