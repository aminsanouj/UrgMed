import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["details"]

  connect() {

  }

  showDetails(event) {
    event.preventDefault();

    const url = event.target.href;
    const container = document.querySelector('.container-results');

    // Stockez l'état actuel de la vue
    const currentState = container.innerHTML;

    fetch(url, { headers: { 'Accept': 'text/html' } })
      .then(response => response.text())
      .then(html => {
        container.innerHTML = html;

        // Ajoutez l'état actuel de la vue à l'objet this du contrôleur
        this.currentState = currentState;
      });
  }

  closeDetails(event) {
    event.preventDefault();
    const container = document.querySelector('.container-results');

    // Vérifiez si this.currentState est défini
    if (this.currentState) {
      container.innerHTML = this.currentState;
    } else {
      // Redirigez l'utilisateur vers la page de recherche si this.currentState n'est pas défini
      window.location.href = '/search'; // Ajustez l'URL en fonction de votre application
    }
  }
}
