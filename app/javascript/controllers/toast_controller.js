import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    this.element.classList.add("transition", "duration-500");
    setTimeout(() => this.fadeOut(), 2000);
  }

  fadeOut() {
    this.element.classList.add("opacity-0");
    setTimeout(() => this.removeToast(), 5000);
  }

  removeToast() {
    this.element.remove();
  }
}
