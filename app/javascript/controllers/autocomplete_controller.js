import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.initAutocomplete();
  }

  initAutocomplete() {
    const input = this.inputTarget;
    const autocomplete = new google.maps.places.Autocomplete(input, {
      componentRestrictions: { country: 'fr' }
    });
    autocomplete.addListener("place_changed", () => this.onPlaceChanged(autocomplete));
  }

  onPlaceChanged(autocomplete) {
    const place = autocomplete.getPlace();
    if (place.formatted_address) {
        this.inputTarget.value = place.formatted_address; // Mettre à jour le champ de recherche avec l'adresse complète

        // Vérifier si le data-controller extract-city est connecté
        const extractCityController = this.application.getControllerForElementAndIdentifier(this.element, 'extract-city');
        if (extractCityController) {
            this.inputTarget.dispatchEvent(new Event('change')); // Déclencher l'événement change pour ExtractCity
        } else {
            this.element.submit(); // Envoyer le formulaire avec l'adresse complète
        }
    }
  }

  handleSearch() {
    this.submitForm();
  }

  submitForm() {
    this.element.submit();
  }

  checkSubmit(event) {
    if (event.key === "Enter") {
      this.submitForm();
    }
  }
}
