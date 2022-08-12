import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--custom-domain"
export default class extends Controller {
  static targets = ['input', 'defaultHints', 'cnameHints', 'apexHints']

  connect() {
    this.change()
  }

  change() {    
    this.hideHints()
    this.showHint()    
  }

  showHint() {
    const tlds = (this.inputTarget.value || '').split('.').length
    switch (tlds) {
    case 0:
    case 1:
      this.defaultHintsTarget.classList.remove('hidden')
      break
    case 2:
      this.apexHintsTarget.classList.remove('hidden')
      break
    default:
      this.cnameHintsTarget.classList.remove('hidden')
    }
  }

  hideHints() {
    const hints = [this.defaultHintsTarget, this.cnameHintsTarget, this.apexHintsTarget]
    hints.forEach(foo => foo.classList.add('hidden'))
  }
};
