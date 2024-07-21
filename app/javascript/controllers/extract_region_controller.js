import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  extractRegionFromInput() {
    const address = this.inputTarget.value;
    console.log('Input:', this.inputTarget.value);
    this.extractRegion(address);
  }

  extractRegion(address) {
    console.log('Extracting region from address:', address);
    const geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': address }, (results, status) => {
      if (status === 'OK' && results[0]) {
        const regionComponent = results[0].address_components.find(component => component.types.includes('administrative_area_level_1'));
        if (regionComponent) {
          const region = regionComponent.long_name;
          this.inputTarget.value = region;
          console.log('Geocode was successful and found region: ' + region);
        } else {
          console.log('Region component not found.');
        }
      } else {
        console.log('Geocode was not successful for the following reason: ' + status);
      }
    });
  }
}
