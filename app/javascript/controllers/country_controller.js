import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "countryContainer", "loadingCountries" ];
  static values = { countryCode: String };

  countryList = {};

  async initialize() {
    await this.loadCountries();
    this.updateCountryContainer();
  }

  async loadCountries() {
    const response = await fetch("https://flagcdn.com/en/codes.json");

    if (response.ok) {
      this.countryList = await response.json();
    }

    this.loadingCountriesTarget.classList.toggle("hidden");
  }

  updateCountryContainer() {
    if (Object.keys(this.countryList).length > 0) {
      this.countryContainerTarget.innerHTML = this.countryList[this.countryCodeValue];
    } else {
      this.countryContainerTarget.innerHTML = this.countryCodeValue;
    }
    this.countryContainerTarget.classList.toggle("hidden");
  }
}
