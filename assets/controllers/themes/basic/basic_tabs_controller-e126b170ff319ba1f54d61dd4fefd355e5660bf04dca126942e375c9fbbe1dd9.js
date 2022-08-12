import { Controller } from "@hotwired/stimulus"
import { toggle } from '../../../helpers/transition'

export default class extends Controller {
  static targets = ['tab', 'pane']
  
  select(event) {
    event.preventDefault()
    const navElement = event.target.closest('[data-tab-id]')
    if (!navElement) throw '[BasicTabs] missing [data-tab-id] element'
    const selectedIndex = parseInt(navElement.dataset.tabId)
    this.makeActive(selectedIndex)
  }

  makeActive(selectedIndex) {
    const tabElement = this.tabTargets[selectedIndex] 
    const activeClass = tabElement.dataset.activeClass

    tabElement.classList.add(activeClass)

    this.paneTargets.forEach((paneElement, index) => {
      if (index === selectedIndex)
        paneElement.classList.remove('hidden')
      else {
        paneElement.classList.add('hidden')
        this.tabTargets[index].classList.remove(activeClass)
      }
    })
  }
};
