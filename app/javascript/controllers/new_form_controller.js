import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  guard(event) {
    const frame = document.getElementById("new_form");
    const form = frame.querySelector("form");

    if (form) {
      event.preventDefault();

      frame.scrollIntoView({ behavior: "smooth" });
      form.classList.add("transition", "duration-500", "ring", "shadow-lg");

      setTimeout(() => {
        form.classList.remove("ring", "shadow-lg");
      }, 1000);
    }
  }
}
