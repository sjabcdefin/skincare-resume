import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
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

    this.ts = new window.TomSelect(this.element, {
      create: true,
      options: options,
      placeholder: "アレルギー名を選択または入力してください。",
    });
  }
}
