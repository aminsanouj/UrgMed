import { Controller } from "@hotwired/stimulus";

let currentState = null;

export default class extends Controller {
  static targets = ["details"];

  // Méthode pour afficher les détails d'un professionnel
  showDetails(event) {
    event.preventDefault();

    const url = event.currentTarget.href;
    const professionalId = event.currentTarget.dataset.professionalId;
    const container = event.currentTarget.closest('.search-professional-card');

    console.log('Showing details for professionalId:', professionalId);

    if (container) {
      this.#saveCurrentState(container);
      this.#fetchAndDisplayDetails(url, container);
    } else {
      console.log('Aucun conteneur trouvé.');
    }

    this.#openMarkerOnMap(professionalId);
  }


  // Méthode pour fermer les détails d'un professionnel
  closeDetails(event) {
    event.preventDefault();
    const container = this.#findContainer(event);

    if (container) {
      this.#restoreContainerContent(container);
    }

    this.#triggerClosePopupInMapController();
  }

  // Méthode privée pour sauvegarder l'état actuel du conteneur
  #saveCurrentState(container) {
    currentState = container.innerHTML;
    container.setAttribute('data-card-content', currentState);
  }

  // Méthode privée pour récupérer et afficher les détails
  #fetchAndDisplayDetails(url, container) {
    fetch(url, { headers: { 'Accept': 'text/html' } })
      .then(response => response.text())
      .then(html => {
        container.innerHTML = html;
      })
      .catch(error => {
        console.error('Erreur lors du fetch des détails:', error);
      });
  }

  // Méthode privée pour ouvrir le marqueur sur la carte
  #openMarkerOnMap(professionalId) {
    const mapController = this.application.getControllerForElementAndIdentifier(document.querySelector('[data-controller="map"]'), 'map');
    if (mapController) {
      console.log('Opening marker for professionalId:', professionalId);
      mapController.openMarker(professionalId);
    } else {
      console.error('Map controller not found');
    }
  }


  // Méthode privée pour trouver le conteneur
  #findContainer(event) {
    return event.currentTarget.closest('.annuaire-professional-card, .search-professional-card') ||
           document.querySelector('.annuaire-results-container, .container-results');
  }

  // Méthode privée pour restaurer le contenu du conteneur
  #restoreContainerContent(container) {
    const cardContent = container.getAttribute('data-card-content');

    if (cardContent) {
      container.innerHTML = cardContent;
      container.removeAttribute('data-card-content');
    } else if (currentState) {
      container.innerHTML = currentState;
    }
  }

  // Méthode privée pour déclencher la fermeture du popup dans le contrôleur de la carte
  #triggerClosePopupInMapController() {
    const closeButton = document.querySelector('.mapboxgl-popup-close-button');
    if (closeButton) {
      closeButton.click(); // Trigger close popup in map controller
    } else {
      console.error('No close button found to trigger.');
    }
  }


}
