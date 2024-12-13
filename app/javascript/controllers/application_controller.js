import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "themeController", "togglerSwap", "mainDrawerToggle" ]

  initialize() {
    let theme = localStorage.getItem('theme')
    if (theme) {
      this.themeControllerTarget.checked = true
    }
  }

  saveTheme(event) {
    if (event.target.checked) {
      localStorage.setItem('theme', event.target.value)
    } else {
      localStorage.removeItem('theme')
    }
  }

  toggleSidebar() {
    this.togglerSwapTarget.checked = !this.togglerSwapTarget.checked  
    this.mainDrawerToggleTarget.checked = !this.mainDrawerToggleTarget.checked
  }
}
