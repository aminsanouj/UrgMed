import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.initAutocomplete();
  }

  initAutocomplete() {
    const input = this.inputTarget;
    this.autocomplete = new google.maps.places.Autocomplete(input, {
      componentRestrictions: { country: 'fr' }
    });
    this.autocomplete.addListener("place_changed", () => this.onPlaceChanged(this.autocomplete));
  }

 handleSearch() {
    const input = this.inputTarget;
    const searchValue = input.value.trim();

    const placesService = new google.maps.places.AutocompleteService();
    placesService.getPlacePredictions({ input: searchValue, componentRestrictions: { country: 'fr' } }, (predictions, status) => {

        if (status === google.maps.places.PlacesServiceStatus.OK && predictions && predictions.length > 0) {
            const firstPrediction = predictions[0];
            input.value = firstPrediction.description;
            google.maps.event.trigger(this.autocomplete, 'place_changed');
        } else {
            this.onPlaceChanged("Predictions found:", this.autocomplete);
        }
    });
  }

  onPlaceChanged(autocomplete) {
    if (this.application.getControllerForElementAndIdentifier(this.element, "extract-city")) {
      this.application.getControllerForElementAndIdentifier(this.element, "extract-city").extractCityFromInput();
    } else {
      this.element.submit();
    }
  }
}
