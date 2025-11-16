import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="select"
export default class extends Controller {
  connect() {
    new TomSelect(this.element, {
      create: true,
    });
  }
}
