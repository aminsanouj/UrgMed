import { Controller } from "@hotwired/stimulus";

let currentState = null; // Variable pour stocker l'état actuel

export default class extends Controller {
  static targets = ["details"];

  showDetails(event) {
    event.preventDefault();

    const url = event.currentTarget.href;
    const container = event.currentTarget.closest('.search-professional-card');

    if (!container) {
      console.log('Aucun conteneur trouvé.');
      return;
    }

    const professionalId = container.dataset.professionalId;
    console.log('Professional ID:', professionalId);

    currentState = container.innerHTML;

    fetch(url, { headers: { 'Accept': 'text/html' } })
      .then(response => response.text())
      .then(html => {
        container.innerHTML = html;
        this.openMapMarker(professionalId);
      })
      .catch(error => {
        console.error('Erreur lors du fetch des détails:', error);
      });
  }

  closeDetails(event) {
    event.preventDefault();

    const container = event.currentTarget.closest('.search-professional-card') ||
                      document.querySelector('.annuaire-results-container, .container-results');

    if (!container) {
      console.log('Aucun conteneur trouvé.');
      return;
    }

    const professionalId = container.dataset.professionalId;
    console.log('Professional ID:', professionalId);

    this.closeMapMarker(professionalId);

    const cardContent = container.getAttribute('data-card-content');

    if (cardContent) {
      container.innerHTML = cardContent;
      container.removeAttribute('data-card-content');
    } else if (currentState) {
      container.innerHTML = currentState;
    }
  }

  openMapMarker(professionalId) {
    const mapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller="map"]'),
      'map'
    );
    if (mapController) {
      mapController.openMarkerById(professionalId);
    } else {
      console.error('Map controller not found.');
    }
  }

  closeMapMarker(professionalId) {
    const mapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller="map"]'),
      'map'
    );
    if (mapController) {
      mapController.closeMarkerById(professionalId);
    } else {
      console.error('Map controller not found.');
    }
  }
}
