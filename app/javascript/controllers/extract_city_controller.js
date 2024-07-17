import { Controller } from "@hotwired/stimulus";

const cityRegex = /([^\s,]+)\s*,\s*France$/;

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.extractCityFromInput(); // Appeler la méthode lors de la connexion
  }

  extractCityFromInput() {
    const address = this.inputTarget.value;
    const city = this.extractCity(address);
    if (city) {
      this.inputTarget.value = city;
      this.submitForm(); // Soumettre le formulaire avec la ville extraite
    }
  }

  extractCity(address) {
    const match = address.match(cityRegex);
    return match ? match[1] : null;
  }

  submitForm() {
    this.element.submit();
  }
}
