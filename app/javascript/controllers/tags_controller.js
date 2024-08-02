import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["results"];

  connect() {
    console.log('Tag controller Connected!');
  }

  filter(event) {
    const tag = event.target.dataset.tag;
    // Obtenir query_city de l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';

    console.log(`Tag clicked: ${tag}`);
    console.log(`Query city: ${queryCity}`);

    // Envoyer une requête AJAX avec le tag et la query_city
    fetch(`/search?tags=${encodeURIComponent(tag)}&query_city=${encodeURIComponent(queryCity)}`, {
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
        console.error('Tag Results target element is missing.');
      }
    })
    .catch(error => console.error('Error fetching search results:', error));
  }
}
