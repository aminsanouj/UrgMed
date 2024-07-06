import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  clear() {
    this.inputTarget.value = ""; // Efface le champ de recherche
    this.submitForm(); // Déclenche une nouvelle recherche
  }

  submitForm() {
    this.element.submit(); // Soumet le formulaire
  }
}
