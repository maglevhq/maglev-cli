import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['dot', 'input']
  static values = { checked: Boolean }

  connect() {
    this.enabled = this.checkedValue
    this.updateDOM()
  }

  toggle() {
    this.enabled = !this.enabled
    this.inputTarget.value = this.enabled ? '1' : '0'
    this.updateDOM()
  }

  updateDOM() {
    this.toggleClass(this.element, 'bg-blue-500', 'bg-gray-200', this.enabled)
    this.toggleClass(this.dotTarget, 'translate-x-5', 'translate-x-0', this.enabled)
  }

  toggleClass(element, from, to, reverse) {
    if (reverse) [to, from] = [from, to]
    element.classList.remove(from)
    element.classList.add(to)
  }
};
