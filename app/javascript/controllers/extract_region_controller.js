import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "department", "region"];

  extractRegionFromInput() {
    const address = this.inputTarget.value;
    this.extractRegion(address);
  }

  extractRegion(address) {
    const geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': address }, (results, status) => {
      if (status === 'OK' && results[0]) {
        const addressComponents = results[0].address_components;

        const regionComponent = addressComponents.find(component => component.types.includes('administrative_area_level_1'));
        const departmentComponent = addressComponents.find(component => component.types.includes('administrative_area_level_2'));

        if (regionComponent) {
          const region = regionComponent.long_name;
          this.regionTarget.value = region;
          console.log('Geocode was successful and found region: ' + region);
        } else {
          console.log('Region component not found.');
        }

        if (departmentComponent) {
          const department = departmentComponent.long_name;
          this.inputTarget.value = department;
          this.departmentTarget.value = department;
          console.log('Geocode was successful and found department: ' + department);
          // Vous pouvez également mettre à jour un autre champ d'entrée si nécessaire
          // document.querySelector('#department-input').value = department;

        } else {
          console.log('Department component not found.');
        }

        // Soumettre le formulaire après avoir mis à jour la valeur de la région
        this.element.requestSubmit();
      } else {
        console.log('Geocode was not successful for the following reason: ' + status);
      }
    });
  }
}
