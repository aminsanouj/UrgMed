// tags_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["results"];

  connect() {
    console.log('Tag controller Connected!');
  }

  filter(event) {
    const tagButton = event.target;
    const tag = tagButton.dataset.tag;

    // Toggle selection
    tagButton.classList.toggle('selected');

    // Get query_city and open_now from the URL
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';
    const openNow = urlParams.get('open_now') === 'true';

    console.log(`Tag clicked: ${tag}`);
    console.log(`Query city: ${queryCity}`);
    console.log(`Open now: ${openNow}`);

    // Get selected tags
    const selectedTags = Array.from(document.querySelectorAll('.tag.selected')).map(tagEl => tagEl.dataset.tag);

    // Create the new URL with parameters
    const newUrl = `/search?query_city=${encodeURIComponent(queryCity)}&tags=${encodeURIComponent(selectedTags.join(','))}&open_now=${openNow}`;

    // Update the browser URL
    window.history.pushState({}, '', newUrl);

    // Send AJAX request with selected tags and query_city
    fetch(newUrl, {
      method: 'GET',
      headers: {
        'Accept': 'text/javascript',
      },
    })
    .then(response => response.text())
    .then(data => {
      // Update the results part with the server response
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = data;
      } else {
        console.error('Tag Results target element is missing.');
      }
    })
    .catch(error => console.error('Error fetching search results:', error));
  }
}
