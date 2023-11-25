import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remote-modal"
export default class extends Controller {
  hideBeforeRender(event) {
    if (this.element.classList.contains('is-active')) {
      event.preventDefault()
      this.closeModalWithFade()
    }
  }

  closeModalWithFade() {
    this.element.classList.add('fade-out');
    this.element.addEventListener('animationend', () => {
      this.element.classList.remove('is-active', 'fade-out')
      Turbo.visit(document.location, { action: 'replace' })
    }, { once: true });
  }

  close(event) {
    event.preventDefault();
    this.element.classList.remove('is-active')
  }
}
