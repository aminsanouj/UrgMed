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

    // Get query_city from the URL
    const urlParams = new URLSearchParams(window.location.search);
    const queryCity = urlParams.get('query_city') || '';

    console.log(`Tag clicked: ${tag}`);
    console.log(`Query city: ${queryCity}`);

    // Get selected tags
    const selectedTags = Array.from(document.querySelectorAll('.tag.selected')).map(tagEl => tagEl.dataset.tag);

    // Send AJAX request with selected tags and query_city
    fetch(`/search?tags=${encodeURIComponent(selectedTags.join(','))}&query_city=${encodeURIComponent(queryCity)}`, {
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
