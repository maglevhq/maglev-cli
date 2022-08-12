import { Controller } from "@hotwired/stimulus"

const POPUP_WIDTH = 800
const POPUP_HEIGHT = 600

export default class extends Controller {
  static values = { waitingMessage: String, url: String }

  connect() {
    this.originalMessage = this.element.innerHTML
  }

  open(event) {
    event.stopPropagation() & event.preventDefault()

    this.disableButton()

    const top = POPUP_HEIGHT > window.innerHeight ? 0 : (window.innerHeight - POPUP_HEIGHT) / 2
    const left = POPUP_WIDTH > window.innerWidth ? 0 : (window.innerWidth - POPUP_WIDTH) / 2
    
    this.popup = window.open(
      this.urlValue, 
      'popup', 
      `width=${POPUP_WIDTH},height=${POPUP_HEIGHT},top=${top},left=${left},status=no,location=no,toolbar=no,menubar=no`
    )

    this.popupLifeLine = setInterval(() => {
      if (this.popup.closed) {
        this.enableButton()
        clearInterval(this.popupLifeLine)
      }
    }, 3000)
  }

  disableButton() {
    this.element.setAttribute('disabled', 'disabled')
    this.element.innerHTML = this.waitingMessageValue
  }

  enableButton() {
    this.element.innerHTML = this.originalMessage
    this.element.removeAttribute('disabled')
  }
};
