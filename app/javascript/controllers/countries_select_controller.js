import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "selector" ];
  static values = { current: String };

  countryList = {};

  connect() {
    console.log("Connected");
  }

  async initialize() {
    await this.loadCountries();
    this.createOptions();
  }

  async loadCountries() {
    const response = await fetch("https://flagcdn.com/en/codes.json");

    if (response.ok) {
      this.countryList = await response.json();
    }
  }

  createOptions() {
    for (const code in this.countryList) {
      const option = document.createElement("option");
      option.value = code;
      option.text = this.countryList[code];
      if (this.currentValue === code) {
        option.selected = true;
      }
      this.selectorTarget.appendChild(option);
    }
  }
}
