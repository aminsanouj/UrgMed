import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  loaderTimeout = null;
  loaderDelay = 500; // Afficher l'indicateur de chargement après 500ms
  locationPermissionDenied = false; // Ajouter un drapeau pour vérifier si l'accès à la position a été refusé

  connect() {
    document.querySelector('.location-icon').addEventListener("click", this.handleLocationClick.bind(this));
  }

  handleLocationClick() {
    if (navigator.geolocation) {
      if (this.locationPermissionDenied) {
        alert("Vous avez refusé l'accès à votre position. Veuillez autoriser l'accès pour utiliser cette fonctionnalité.");
        return;
      }

      navigator.geolocation.getCurrentPosition(
        () => this.getLocation(),
        (error) => this.handleGeolocationError(error),
        { timeout: 10000 } // Définir un délai d'expiration de 10 secondes pour la géolocalisation
      );
    } else {
      alert("La géolocalisation n'est pas prise en charge par ce navigateur.");
    }
  }

  handleGeolocationError(error) {
    if (error.code === error.PERMISSION_DENIED) {
      if (!this.locationPermissionDenied) {
        this.locationPermissionDenied = true;
        alert("Vous avez refusé l'accès à votre position. Veuillez autoriser l'accès pour utiliser cette fonctionnalité.");
      }
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

  getLocation() {
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
      { timeout: 10000 } // Définir un délai d'expiration de 10 secondes pour la géolocalisation
    );
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
          const address = results[0].formatted_address;
          const addressInput = document.querySelector('#search-bar');
          addressInput.value = address; // Mettre à jour le champ de recherche avec l'adresse complète
          addressInput.dispatchEvent(new Event('change')); // Déclencher l'événement change pour ExtractCity

          // Soumettre le formulaire de recherche
          addressInput.form.submit();
        } else {
          alert('Aucun résultat trouvé pour ces coordonnées.');
        }
      } else {
        alert('Échec du géocodage inverse : ' + status);
      }
    });
  }
}
