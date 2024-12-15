import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "themeController", "togglerSwap", "mainDrawerToggle", "body" ]

  initialize() {
    if (this.themeControllerTarget.value === this.bodyTarget.dataset.theme) {
      this.themeControllerTarget.checked = true
    }
  }

  async saveTheme(event) {
    if (event.target.checked) {
      this.bodyTarget.dataset.theme = 'night'
    } else {
      this.bodyTarget.dataset.theme = 'light'
    }

    await fetch('/account/settings', {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "X-CSRF-Token": this.getMetaValue("csrf-token")
      },
      body: JSON.stringify({setting: { theme: this.bodyTarget.dataset.theme }})
    })
  }

  toggleSidebar() {
    this.togglerSwapTarget.checked = !this.togglerSwapTarget.checked  
    this.mainDrawerToggleTarget.checked = !this.mainDrawerToggleTarget.checked
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }
}
