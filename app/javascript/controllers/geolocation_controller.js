import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  loaderTimeout = null;
  loaderDelay = 500; // Afficher l'indicateur de chargement après 500ms
  locationPermissionDenied = false; // Ajouter un drapeau pour vérifier si l'accès à la position a été refusé

  connect() {
    this.element.querySelector('.location-icon').addEventListener("click", this.handleLocationClick.bind(this));
  }

  handleLocationClick() {
    if (navigator.geolocation) {
      if (this.locationPermissionDenied) {
        alert("Vous avez refusé l'accès à votre position. Veuillez autoriser l'accès pour utiliser cette fonctionnalité.");
        return;
      }

      this.loaderTimeout = setTimeout(() => this.showLoaderIfEmpty(), this.loaderDelay);

      navigator.geolocation.getCurrentPosition(
        (position) => {
          clearTimeout(this.loaderTimeout);
          this.showPosition(position);
        },
        (error) => {
          clearTimeout(this.loaderTimeout);
          this.hideLoader();
          this.handleGeolocationError(error);
        },
        { timeout: 10000 } // Définir un délai d'expiration de 10 secondes
      );
    } else {
      alert("La géolocalisation n'est pas prise en charge par ce navigateur.");
    }
  }

  handleGeolocationError(error) {
    if (error.code === error.PERMISSION_DENIED) {
      this.locationPermissionDenied = true;
      alert("Vous avez refusé l'accès à votre position. Veuillez autoriser l'accès pour utiliser cette fonctionnalité.");
    } else {
      console.error("Erreur de géolocalisation : ", error);
    }
  }

  showLoaderIfEmpty() {
    const addressInput = document.querySelector('#search-bar');
    if (addressInput.value.trim() === '') {
      this.showLoader();
    }
  }

  showLoader() {
    document.querySelector('#loader').style.display = 'block';
  }

  hideLoader() {
    document.querySelector('#loader').style.display = 'none';
  }

  showPosition(position) {
    const lat = position.coords.latitude;
    const lon = position.coords.longitude;

    const geocoder = new google.maps.Geocoder();
    const latlng = new google.maps.LatLng(lat, lon);

    geocoder.geocode({ 'latLng': latlng }, (results, status) => {
      this.hideLoader();

      if (status === 'OK' && results[0]) {
        const address = results[0].formatted_address;
        const addressInput = document.querySelector('#search-bar');
        addressInput.value = address; // Mettre à jour le champ de recherche avec l'adresse complète

        // Appeler onPlaceChanged pour gérer le changement
        this.onPlaceChanged(addressInput);
      } else {
        const errorMessage = status === 'OK' ? 'Aucun résultat trouvé pour ces coordonnées.' : `Échec du géocodage inverse : ${status}`;
        console.error(errorMessage);
        alert(errorMessage);
      }
    });
  }

  onPlaceChanged(element) {
    const extractCityController = this.application.getControllerForElementAndIdentifier(document.querySelector('.search-container'), "extract-city");
    const extractRegionController = this.application.getControllerForElementAndIdentifier(document.querySelector('.search-container'), "extract-region");

    if (extractCityController) {
      extractCityController.extractCityFromInput();
    }

    if (extractRegionController) {
      extractRegionController.extractRegionFromInput();
    }

    if (!extractCityController && !extractRegionController) {
      element.form.submit();
    }
  }
}
