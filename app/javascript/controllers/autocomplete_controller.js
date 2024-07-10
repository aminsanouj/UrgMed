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
      this.inputTarget.value = place.formatted_address;
      this.submitForm();
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
