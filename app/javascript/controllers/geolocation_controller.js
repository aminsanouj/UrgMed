// geolocation_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  loaderTimeout = null;
  loaderDelay = 500; // Afficher l'indicateur de chargement après 500ms

  connect() {
    document.querySelector('.location-icon').addEventListener("click", this.getLocation.bind(this));
  }

  showLoader() {
    document.querySelector('#loader').style.display = 'block';
  }

  hideLoader() {
    document.querySelector('#loader').style.display = 'none';
  }

  getLocation() {
    if (navigator.geolocation) {
      this.loaderTimeout = setTimeout(() => {
        this.showLoader();
      }, this.loaderDelay);

      navigator.geolocation.getCurrentPosition(
        (position) => {
          clearTimeout(this.loaderTimeout);
          this.showPosition(position);
        },
        (error) => {
          clearTimeout(this.loaderTimeout);
          this.hideLoader();
          console.error("Erreur de géolocalisation : ", error);
        },
        { timeout: 10000 } // Définir un délai d'expiration de 10 secondes pour la géolocalisation
      );
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
      this.hideLoader();

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
