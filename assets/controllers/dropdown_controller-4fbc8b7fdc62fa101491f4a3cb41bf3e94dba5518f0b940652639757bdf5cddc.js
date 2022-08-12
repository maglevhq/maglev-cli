import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ['modal']

  connect() {
    useClickOutside(this)
  }

  toggle() {
    this.modalTarget.classList.toggle('hidden')
  }

  clickOutside(event) {
    this.modalTarget.classList.add('hidden')
  }
};
