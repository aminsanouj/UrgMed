import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  connect() {
    console.log('OpenNow controller connected!');
  }

  toggleFilter(event) {
    const isSearchPage = document.querySelector('.container-wrapper');
    const isAnnuairePage = document.querySelector('.annuaire-wrapper');
    const openNow = event.target.checked;

    if (isSearchPage) {
      this.handleSearchPage(openNow);
    } else if (isAnnuairePage) {
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

    document.querySelectorAll('.search-professional-card').forEach(card => {
      const isOpenNow = card.getAttribute('data-open-now') === 'true';
      card.style.display = openNow ? (isOpenNow ? 'block' : 'none') : 'block';
    });
  }
}
