import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "clear"];

  connect() {
    // Initialiser l'état du toggle en fonction de l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const openNow = urlParams.get('open_now') === 'true';
    if (this.hasInputTarget) {
      this.inputTarget.checked = openNow;
    }
  }

  clear() {
    if (this.hasInputTarget) {
      this.inputTarget.value = "";
    }
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = "";
    }
    this.submitForm(); // Soumettre le formulaire après avoir vidé le champ
  }

  submitForm() {
    this.element.submit();
  }

  // Méthode pour gérer l'événement de changement de la case à cocher
  toggleFilter(event) {
    // Obtenir la valeur de la case à cocher (vérifier si elle est cochée ou non)
    const openNow = event.target.checked;

    // Obtenir query_city de l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';

    // Créer l'URL avec les paramètres
    const url = `/search?query_city=${encodeURIComponent(queryCity)}&open_now=${encodeURIComponent(openNow)}`;

    // Envoyer une requête AJAX
    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'text/javascript',
      },
    })
    .then(response => response.text())
    .then(data => {
      // Mettre à jour la partie des résultats avec la réponse du serveur
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = data;
      } else {
        console.error('Search Results target element is missing.');
      }
    })
    .catch(error => console.error('Error fetching search results:', error));
  }
}
