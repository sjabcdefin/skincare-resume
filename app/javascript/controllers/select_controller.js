import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const selectedValue = this.element.dataset.value;

    const options = JSON.parse(this.element.dataset.options).map((allergy) => ({
      value: allergy,
      text: allergy,
    }));

    const includedOptions = options.find(
      (option) => option.value === selectedValue,
    );

    if (selectedValue && !includedOptions) {
      options.push({ value: selectedValue, text: selectedValue });
    }

    this.ts = new window.TomSelect(this.element, {
      create: true,
      options: options,
      items: selectedValue ? [selectedValue] : [],
      placeholder: this.element.dataset.placeholder,
      render: {
        option_create: (data, escape) =>
          `<div class="create"><strong>${escape(
            data.input,
          )}</strong> ${this.element.dataset.createLabel}</div>`,
        no_results: () => "",
      },
    });

    const wrapper = this.ts.wrapper;
    if (this.element.dataset.error === "true") {
      wrapper.classList.add("error");
    }
  }
}
