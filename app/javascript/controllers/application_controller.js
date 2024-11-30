import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="application"
export default class extends Controller {
  static targets = [ "themeController" ]
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
}
