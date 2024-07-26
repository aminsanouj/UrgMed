import { Controller } from "@hotwired/stimulus";

let currentState = null;

export default class extends Controller {
  static targets = ["details"];

  showDetails(event) {
    event.preventDefault();

    const url = event.currentTarget.href;
    const professionalId = event.currentTarget.dataset.professionalId;

    const container = event.currentTarget.closest('.search-professional-card');

    if (container) {
      currentState = container.innerHTML;
      container.setAttribute('data-card-content', currentState);

      fetch(url, { headers: { 'Accept': 'text/html' } })
        .then(response => response.text())
        .then(html => {
          container.innerHTML = html;
        })
        .catch(error => {
          console.error('Erreur lors du fetch des détails:', error);
        });
    } else {
      console.log('Aucun conteneur trouvé.');
    }
  }

  closeDetails(event) {
    event.preventDefault();
    const container = event.currentTarget.closest('.annuaire-professional-card, .search-professional-card') || document.querySelector('.annuaire-results-container, .container-results');

    if (container) {
      const cardContent = container.getAttribute('data-card-content');

      if (cardContent) {
        container.innerHTML = cardContent;
        container.removeAttribute('data-card-content');
      } else if (currentState) {
        container.innerHTML = currentState;
      }
    }

    this.#triggerClosePopupInMapController();
  }

  #triggerClosePopupInMapController() {
    const closeButton = document.querySelector('.mapboxgl-popup-close-button');
    if (closeButton) {
      closeButton.click(); // Trigger close popup in map controller
    }
  }
}
