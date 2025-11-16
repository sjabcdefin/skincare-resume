import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="select"
export default class extends Controller {
  connect() {
    this.ts = new TomSelect(this.element, {
      create: true,
    });

    const wrapper = this.ts.wrapper;
    if (this.element.dataset.error === "true") {
      wrapper.classList.add("error");
    }

    const selectedValue = this.element.dataset.value;
    if (selectedValue) {
      this.ts.addOption({ value: selectedValue, text: selectedValue });
      this.ts.setValue(selectedValue, true);
    }
  }
}
