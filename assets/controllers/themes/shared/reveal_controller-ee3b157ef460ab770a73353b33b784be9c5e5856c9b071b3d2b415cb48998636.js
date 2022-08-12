import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['content', 'icon']
  static values = { displayed: Boolean }

  connect() {
    this.displayed = this.displayedValue
  }

  toggle() {
    this.displayed = !this.displayed
    this.updateDOM()
  }

  updateDOM() {
    for (let index in this.contentTargets) {      
      const contentTarget = this.contentTargets[index]
      this.toggleClass(contentTarget, 'hidden', '', !this.displayed)
    }
    if (this.iconTarget) {
      const iconActiveClass = this.iconTarget.dataset.activeClass
      this.toggleClass(this.iconTarget, iconActiveClass, '', this.displayed)
    }    
  }

  toggleClass(element, from, to, reverse) {
    if (reverse) [to, from] = [from, to]
    if (from !== '') element.classList.remove(from)
    if (to !== '') element.classList.add(to)
  }
};
