import { Controller } from "@hotwired/stimulus";

let currentState = null; // Variable globale pour stocker l'état actuel

export default class extends Controller {
  static targets = ["details"];

  showDetails(event) {
    event.preventDefault();

    const url = event.currentTarget.href;
    const container = document.querySelector('.container-results');

    if (container) {
      currentState = container.innerHTML; // Stocker l'état actuel dans la variable globale

      fetch(url, { headers: { 'Accept': 'text/html' } })
        .then(response => response.text())
        .then(html => {
          container.innerHTML = html;
        })
        .catch(error => console.error('Erreur lors du fetch des détails:', error));
    }
  }

  closeDetails(event) {
    event.preventDefault();

    const container = document.querySelector('.container-results');

    if (currentState && container) { // Vérifier si la variable globale currentState contient un état valide
      container.innerHTML = currentState;
    }
  }
}
