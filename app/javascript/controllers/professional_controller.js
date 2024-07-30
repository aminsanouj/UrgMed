import { Controller } from "@hotwired/stimulus";

let cardStates = {}; // Objet pour stocker les états des cartes

export default class extends Controller {
  static targets = ["details"];

  showDetails(event) {
    event.preventDefault();

    const url = event.currentTarget.href;

    // Cibler spécifiquement le conteneur 'search-professional-card'
    const container = event.currentTarget.closest('.search-professional-card');

    if (container) {
      const professionalId = container.getAttribute('data-professional-id');

      // Fermer toutes les autres cartes ouvertes
      this.closeAllDetails();

      // Ouvrir la pop-up du marker associé
      const mapController = this.application.getControllerForElementAndIdentifier(document.querySelector("[data-controller='map']"), "map");
      mapController.openMarkerPopup(professionalId);

      // Enregistrer le contenu de la carte ou du conteneur avant de le remplacer
      cardStates[professionalId] = container.innerHTML;

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
      const professionalId = container.getAttribute('data-professional-id');

      // Appeler la méthode closeMarkerPopup
      const mapController = this.application.getControllerForElementAndIdentifier(document.querySelector("[data-controller='map']"), "map");
      if (professionalId) {
        mapController.closeMarkerPopup(professionalId);
      }

      if (professionalId && cardStates[professionalId]) {
        container.innerHTML = cardStates[professionalId];
        delete cardStates[professionalId]; // Supprimer l'état après restauration
      }
    }
  }

  closeAllDetails() {
    // Fermer toutes les cartes de détails ouvertes
    document.querySelectorAll('.search-professional-card').forEach(card => {
      const professionalId = card.getAttribute('data-professional-id');
      if (professionalId && cardStates[professionalId]) {
        card.innerHTML = cardStates[professionalId];
        delete cardStates[professionalId]; // Supprimer l'état après restauration
      }
    });

    // Fermer tous les popups ouverts
    const mapController = this.application.getControllerForElementAndIdentifier(document.querySelector("[data-controller='map']"), "map");
    if (mapController) {
      Object.keys(mapController.markersMap).forEach(professionalId => {
        mapController.closeMarkerPopup(professionalId);
      });
    }
  }
}
