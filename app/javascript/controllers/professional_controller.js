import { Controller } from "@hotwired/stimulus";

let currentState = null; // Variable globale pour stocker l'état actuel

export default class extends Controller {
  static targets = ["details"];

  showDetails(event) {
    event.preventDefault();

    const url = event.currentTarget.href;

    const container = event.currentTarget.closest('.annuaire-professional-card, .professional-card') || document.querySelector('.annuaire-results-container, .container-results');

    if (container) {
        // Enregistrer le contenu de la card ou du container avant de le remplacer
        if (event.currentTarget.closest('.professional-card')) {
            container.setAttribute('data-card-content', container.innerHTML);
        } else {
            currentState = container.innerHTML;
        }

        fetch(url, { headers: { 'Accept': 'text/html' } })
            .then(response => response.text())
            .then(html => {
                container.innerHTML = html;
            })
            .catch(error => {
                console.error('Erreur lors du fetch des détails:', error);
                console.log('Erreur:', error);
            });
    } else {
        console.log('Aucun conteneur trouvé.');
    }
  }


  closeDetails(event) {
    event.preventDefault();
    const container = event.currentTarget.closest('.annuaire-professional-card, .professional-card') || document.querySelector('.annuaire-results-container, .container-results');

    if (container) {
      const cardContent = container.getAttribute('data-card-content');

      if (cardContent) {
        container.innerHTML = cardContent;
        container.removeAttribute('data-card-content');
      } else if (currentState) {
        container.innerHTML = currentState;
      }
    }
  }

}
