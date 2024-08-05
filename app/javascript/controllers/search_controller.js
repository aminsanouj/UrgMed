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

    // Ajouter un écouteur d'événements pour surveiller les changements dans l'input
    this.inputTarget.addEventListener('input', this.toggleClearIcon.bind(this));

    // Appeler la méthode pour initialiser l'état de l'icône de croix
    this.toggleClearIcon();
  }

  clear() {
    if (this.hasInputTarget) {
      this.inputTarget.value = "";
    }
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = "";
    }
    this.toggleClearIcon();
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

    // Obtenir les tags sélectionnés
    const selectedTags = Array.from(document.querySelectorAll('.tag.selected')).map(tagEl => tagEl.dataset.tag);

    // Créer l'URL avec les paramètres
    const url = `/search?query_city=${encodeURIComponent(queryCity)}&tags=${encodeURIComponent(selectedTags.join(','))}&open_now=${openNow}`;

    // Mettre à jour l'URL du navigateur
    window.history.pushState({}, '', url);

    // Envoyer une requête AJAX
    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'text/javascript',
      },
    })
    .then(response => response.json())
    .then(data => {
      // Mettre à jour la partie des résultats avec la réponse du serveur
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = data.partials;

        // Emettre un événement personnalisé pour mettre à jour la carte
        const event = new CustomEvent('resultsUpdated', { detail: { markers: data.markers } });
        document.dispatchEvent(event);
      } else {
        console.error('Search Results target element is missing.');
      }
    })
    .catch(error => console.error('Error fetching search results:', error));
  }

  // Méthode pour afficher ou masquer l'icône de croix en fonction de la valeur de l'input
  toggleClearIcon() {
    if (this.hasClearTarget) {
      this.clearTarget.style.display = this.inputTarget.value.trim() ? 'block' : 'none';
    }
  }
}
