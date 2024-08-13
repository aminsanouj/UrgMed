import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  connect() {
    console.log('OpenNow controller connected!');
    this.initializeAnnuaire();
  }

  getCurrentPage() {
    if (document.querySelector('.annuaire-wrapper')) {
      return 'annuaire';
    } else if (document.querySelector('.container-wrapper')) {
      return 'search';
    }
    return null;
  }

  initializeAnnuaire() {
    if (this.getCurrentPage() === 'annuaire') {
      const urlParams = new URLSearchParams(window.location.search);
      const openNowParam = urlParams.get('open_now') === 'true';

      if (openNowParam) {
        this.handleAnnuairePage(true);
        // Mettre à jour la case à cocher pour refléter l'état actuel
        this.inputTarget.checked = true;
      }

      // Retirer la classe 'hidden' après l'application de la logique
      document.querySelectorAll('.annuaire-professional-card.hidden, .annuaire-count.hidden').forEach(element => {
        element.classList.remove('hidden');
      });
    }
  }

  toggleFilter(event) {
    const openNow = event.target.checked;
    const currentPage = this.getCurrentPage();

    if (currentPage === 'search') {
      this.handleSearchPage(openNow);
    } else if (currentPage === 'annuaire') {
      this.handleAnnuairePage(openNow);
    }
  }

  handleSearchPage(openNow) {
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';
    const selectedTags = Array.from(document.querySelectorAll('.tag.selected')).map(tagEl => tagEl.dataset.tag);
    const url = `/search?query_city=${encodeURIComponent(queryCity)}&tags=${encodeURIComponent(selectedTags.join(','))}&open_now=${openNow}`;

    window.history.pushState({}, '', url);

    fetch(url, {
      method: 'GET',
      headers: { 'Accept': 'text/javascript' },
    })
    .then(response => response.json())
    .then(data => {
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = data.partials;
        const event = new CustomEvent('resultsUpdated', { detail: { markers: data.markers } });
        document.dispatchEvent(event);
      } else {
        console.error('Search Results target element is missing.');
      }
    })
    .catch(error => console.error('Error fetching search results:', error));
  }

  handleAnnuairePage(openNow) {
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';

    const url = `/professionals?query_city=${encodeURIComponent(queryCity)}&open_now=${openNow}`;

    window.history.pushState({}, '', url);

    // Itérer sur chaque catégorie
    document.querySelectorAll('.annuaire-professional-category').forEach(category => {
      const categoryName = category.getAttribute('data-speciality');
      const cards = category.querySelectorAll('.search-professional-card');
      const countSpan = category.querySelector('.annuaire-count');

      let visibleCount = 0;

      cards.forEach(card => {
        const isOpenNow = card.getAttribute('data-open-now') === 'true';
        if (openNow ? isOpenNow : true) {
            card.style.display = 'block';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
      });

      if (countSpan) {
        countSpan.textContent = visibleCount;
      }
    });
  }
}
