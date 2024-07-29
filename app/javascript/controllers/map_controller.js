// Map JS
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    // Ensure the container is empty before initializing the map
    this.element.innerHTML = ''

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      // Create a HTML element for your custom marker
      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      // Pass the element as an argument to the new marker
      const mapMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)

      // Listen for the 'open' event on the popup
      popup.on('open', () => {
        this.#onMarkerOpen(marker);
        const closeButton = document.querySelector('.mapboxgl-popup-close-button');
        closeButton.disabled = true; // Disable the button initially
        setTimeout(() => {
          closeButton.disabled = false; // Enable it after a short delay
        }, 100); // Adjust the delay as needed
      })

      // Listen for the 'close' event on the popup
      popup.on('close', () => {
        this.#onMarkerClose(marker);
      })
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => {
      if (marker.lng && marker.lat) {
        bounds.extend([marker.lng, marker.lat])
      }
    })
    if (bounds.getNorthEast() && bounds.getSouthWest()) {
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
    }
  }

  #onMarkerOpen(marker) {
    const professionalId = marker.info_window_html.match(/data-professional-id="(\d+)"/)?.[1];
    console.log('Marker opened:', marker);
    console.log('Professional ID:', professionalId);

    // Find the "Voir Détails" link for the corresponding professional
    const detailsLink = document.querySelector(`#professional-${professionalId} .details`);
    if (detailsLink) {
      // Trigger a click event on the link to show details
      detailsLink.click();

      // Center the card in the container results
      const cardElement = document.querySelector(`#professional-${professionalId}`);
      if (cardElement) {
        this.#scrollToCard(cardElement);
      }
    } else {
      console.error('Details link not found for professional ID:', professionalId);
    }
  }

  #onMarkerClose(marker) {
    const professionalId = marker.info_window_html.match(/data-professional-id="(\d+)"/)?.[1];
    if (professionalId) {
      const closeButton = document.querySelector(`#professional-${professionalId} .close-button`);
      if (closeButton) {
        closeButton.click();
      }
    }
  }

  #scrollToCard(cardElement) {
    const container = document.querySelector('.container-results');
    const containerRect = container.getBoundingClientRect();
    const cardRect = cardElement.getBoundingClientRect();

    const scrollTop = container.scrollTop + cardRect.top - containerRect.top - (containerRect.height - cardRect.height) / 2;

    container.scrollTo({
      top: scrollTop,
      behavior: 'smooth'
    });
  }
}
