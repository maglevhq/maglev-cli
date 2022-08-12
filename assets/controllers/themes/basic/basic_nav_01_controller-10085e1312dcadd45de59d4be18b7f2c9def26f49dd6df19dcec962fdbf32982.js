import { Controller } from "@hotwired/stimulus"
import { toggle } from '../../../helpers/transition'

export default class extends Controller {
  static targets = ['mobileMenu', 'overlay']
  
  connect() {
    console.log('Hello BasicNav01 controller')
  }

  toggleMenu() {
    // console.log('toggle!!!', this.mobileMenuTarget.classList)
    // this.mobileMenuTarget.classList.toggle('hidden')
    // this.overlayTarget.classList.toggle('hidden')
    toggle(this.mobileMenuTarget)
    toggle(this.overlayTarget)
  }
}
;
