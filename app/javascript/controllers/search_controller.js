// search_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "clear"];

  connect() {
    console.log('Search controller Connected!');

    const urlParams = new URLSearchParams(window.location.search);
    const openNow = urlParams.get('open_now') === 'true';
    if (this.hasInputTarget) {
      this.inputTarget.checked = openNow;
    }

    // Ajouter un écouteur d'événements pour surveiller les changements dans l'input
    this.inputTarget.addEventListener('input', this.toggleClearIcon.bind(this));

    // Appeler la méthode pour initialiser l'état de l'icône de croix
    this.toggleClearIcon();

    // Écouter l'événement 'submitFormRequested'
    document.addEventListener('submitFormRequested', this.submitForm);
  }

  disconnect() {
    // Nettoyer l'écouteur d'événements lorsque le contrôleur est déconnecté
    document.removeEventListener('submitFormRequested', this.submitForm);
  }

  clear() {
    if (this.hasInputTarget) {
      this.inputTarget.value = "";
    }
    this.toggleClearIcon();
  }

  toggleClearIcon() {
    if (this.hasInputTarget && this.hasClearTarget) {
      // Vérifiez si l'input a du texte
      this.clearTarget.style.display = this.inputTarget.value.trim() !== "" ? "block" : "none";
    }
  }

  submitForm = () => {
    const currentPath = window.location.pathname;

    if (currentPath === '/search') {
      this.searchEmptyQueryCity();
    } else {
      document.querySelector('form.search-container').submit();
    }
  }

  searchEmptyQueryCity() {
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = decodeURIComponent(urlParams.get('query_city') || '');

    if (queryCity === '') {
      console.log('queryCity is empty, queryCity:', queryCity);

      const openNow = urlParams.get('open_now') || 'false';
      const tags = decodeURIComponent(urlParams.get('tags') || '');
      const newQueryCity = document.getElementById('search-bar').value;

      const newUrl = `/search?query_city=${encodeURIComponent(newQueryCity)}&tags=${encodeURIComponent(tags)}&open_now=${encodeURIComponent(openNow)}`;
      console.log('newUrl', newUrl);

      window.history.pushState({}, '', newUrl);
      window.location.href = newUrl;
    } else {
      console.log('queryCity is not empty');
      document.querySelector('form.search-container').submit();
    }
  }
}
