import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['item']
  static values = { displayed: Boolean }

  connect() {
    this.displayed = this.displayedValue
  }

  toggle() {
    this.displayed = !this.displayed
    this.updateDOM()
  }

  updateDOM() {
    for (let index in this.itemTargets) {
      const itemTarget = this.itemTargets[index]
      this.toggleClass(itemTarget, 'hidden', '', !this.displayed)
    }
  }

  toggleClass(element, from, to, reverse) {
    if (reverse) [to, from] = [from, to]
    if (from !== '') element.classList.remove(from)
    if (to !== '') element.classList.add(to)
  }
};
