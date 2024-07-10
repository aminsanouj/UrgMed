// geolocation_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.querySelector('.location-icon').addEventListener("click", this.getLocation.bind(this));
  }

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(this.showPosition.bind(this)); // Ajoutez bind(this) ici
    } else {
      alert("La géolocalisation n'est pas prise en charge par ce navigateur.");
    }
  }

  showPosition(position) {
    const lat = position.coords.latitude;
    const lon = position.coords.longitude;

    const geocoder = new google.maps.Geocoder();
    const latlng = new google.maps.LatLng(lat, lon);

    geocoder.geocode({ 'latLng': latlng }, (results, status) => {
      if (status === 'OK') {
        if (results[0]) {
          // Remplir le champ de saisie avec l'adresse correspondante
          const addressInput = document.querySelector('#search-bar');
          addressInput.value = results[0].formatted_address;
          // Soumettre le formulaire de recherche
          const searchForm = document.querySelector('.search-container');
          searchForm.submit();
        } else {
          alert('Aucun résultat trouvé pour ces coordonnées.');
        }
      } else {
        alert('Échec du géocodage inverse : ' + status);
      }
    });
  }
}
