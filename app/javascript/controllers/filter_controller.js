import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["results"];

  connect() {
    console.log('Hello from filter controller');
  }

  filterOpenNow() {
    // Récupérer toutes les cartes dans le conteneur de résultats
    const cards = this.resultsTarget.querySelectorAll('.card');

    cards.forEach(card => {
      // Lire l'attribut data-open-now de la carte
      const openNow = card.getAttribute('data-open-now') === 'true';

      // Afficher ou masquer la carte en fonction de l'attribut
      if (openNow) {
        card.style.display = 'block'; // Afficher la carte
      } else {
        card.style.display = 'none';  // Masquer la carte
      }
    });
  }
}
