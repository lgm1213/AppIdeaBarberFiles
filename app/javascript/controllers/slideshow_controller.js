import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "counter"]

  connect() {
    this.index = 0
    this.updateSlides()
  }

  prev() {
    this.index = (this.index - 1 + this.slideTargets.length) % this.slideTargets.length
    this.updateSlides()
  }

  next() {
    this.index = (this.index + 1) % this.slideTargets.length
    this.updateSlides()
  }

  updateSlides() {
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("hidden", i !== this.index)
    })
    if (this.hasCounterTarget) {
      this.counterTarget.textContent = `${this.index + 1} / ${this.slideTargets.length}`
    }
  }
}
