import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="select"
export default class extends Controller {
  connect() {
    this.ts = new TomSelect(this.element, {
      create: true,
      render: {
        option_create: (data, escape) =>
          `<div class="create"><strong>${escape(
            data.input
          )}</strong> を追加 &hellip;</div>`,
        no_results: () =>
          '<div class="no-results">該当する項目が見つかりません。</div>',
      },
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
