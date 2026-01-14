import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const selectedValue = this.element.dataset.value;

    const options = [
      "金属(ニッケル)",
      "金属(コバルト)",
      "金属(クロム)",
      "金属(パラジウム)",
      "金属(金)",
      "金属(銀)",
      "金属(亜鉛)",
      "花粉(スギ)",
      "花粉(ヒノキ)",
      "花粉(ブタクサ)",
      "花粉(ヨモギ)",
      "花粉(イネ)",
    ].map((allergy) => ({ value: allergy, text: allergy }));

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
      placeholder: "アレルギー名を選択または入力してください。",
      render: {
        option_create: (data, escape) =>
          `<div class="create"><strong>${escape(
            data.input,
          )}</strong> を追加 &hellip;</div>`,
        no_results: () =>
          '<div class="no-results">該当する項目が見つかりません。</div>',
      },
    });
  }
}
