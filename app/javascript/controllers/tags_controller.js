// tags_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["results"];

  connect() {
    console.log('Tag controller Connected!');
    this.updateTagSelection();
  }

  updateTagSelection() {
    // Définir tous les tags disponibles
    const allTags = ['Médecin', 'Pharmacie', 'Dentiste', 'Urgences'];

    // Récupérer les paramètres de l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const tagsParam = urlParams.get('tags');

    if (tagsParam) {
      const tags = tagsParam.split(',').map(tag => tag.trim());

      // Vérifier si tous les tags sont présents
      const allTagsInUrl = allTags.every(tag => tags.includes(tag));

      // Cocher ou décocher les tags en fonction des paramètres
      this.element.querySelectorAll('.tag').forEach(tagButton => {
        if (allTagsInUrl) {
          tagButton.classList.remove('selected');
        } else if (tags.includes(tagButton.dataset.tag)) {
          tagButton.classList.add('selected');
        } else {
          tagButton.classList.remove('selected');
        }
      });
    }
  }

  filter(event) {
    const tagButton = event.target;
    const tag = tagButton.dataset.tag;

    // Toggle selection
    tagButton.classList.toggle('selected');

    // Récupérer les paramètres de l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';
    const openNow = urlParams.get('open_now') === 'true';

    // Obtenir les tags sélectionnés
    const selectedTags = Array.from(document.querySelectorAll('.tag.selected')).map(tagEl => tagEl.dataset.tag);

    // Créer la nouvelle URL avec les paramètres
    const newUrl = `/search?query_city=${encodeURIComponent(queryCity)}&tags=${encodeURIComponent(selectedTags.join(','))}&open_now=${openNow}`;

    // Mettre à jour l'URL du navigateur
    window.history.pushState({}, '', newUrl);

    // Envoyer la requête AJAX avec les tags sélectionnés et la query_city
    fetch(newUrl, {
      method: 'GET',
      headers: {
        'Accept': 'text/javascript',
      },
    })
    .then(response => response.json())
    .then(data => {
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = data.partials;

        // Émettre un événement personnalisé pour mettre à jour la carte
        const event = new CustomEvent('resultsUpdated', { detail: { markers: data.markers } });
        document.dispatchEvent(event);
      } else {
        console.error('Tag Results target element is missing.');
      }
    })
    .catch(error => console.error('Error fetching search results:', error));
  }
}
