import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['primary', 'secondary']

  connect() {
    this.hideOptions()
  }

  update() {
    this.hideOptions()
    this.secondaryTarget.value = this.secondaryTarget.querySelector('option:not(.hidden)').value
  }

  hideOptions() {    
    const primaryValue = this.primaryTarget.value
    this.secondaryTarget.querySelectorAll('option').forEach(el => el.classList.remove('hidden'))
    this.secondaryTarget.querySelector(`option[value="${primaryValue}"]`).classList.add('hidden')
  }
};
