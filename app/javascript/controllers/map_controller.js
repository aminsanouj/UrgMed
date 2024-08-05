// map_controller.js
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

    this.markersMap = {}; // Initialize the markers map

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    // Listen for the custom event
    document.addEventListener('resultsUpdated', this.#updateMarkers.bind(this));
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

      // Store the marker with its professional ID
      this.markersMap[marker.professional_id] = mapMarker;

      // Listen for the popup open event
      mapMarker.getElement().addEventListener('click', () => {
        this.#onMarkerOpen(marker.professional_id);
      });

      popup.on('open', () => {
        console.log('Popup opened');
        const closeButton = document.querySelector('.mapboxgl-popup-close-button');
        closeButton.disabled = true; // Disable the button initially
        setTimeout(() => {
          closeButton.disabled = false; // Enable it after a short delay
        }, 50); // Adjust the delay as needed

        // Add event listener to the close button for manual close action
        closeButton.addEventListener('click', () => {
          this.#onMarkerClose(marker.professional_id);
        }, { once: true }); // Ensure it runs only once
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

  #updateMarkers(event) {
    const newMarkers = event.detail.markers;

    // Remove existing markers
    Object.values(this.markersMap).forEach(marker => marker.remove());
    this.markersMap = {};

    // Add new markers
    this.markersValue = newMarkers;
    this.#addMarkersToMap();
  }

  openMarkerPopup(professionalId) {
    const marker = this.markersMap[professionalId];
    if (marker) {
      marker.togglePopup();
    } else {
      console.error(`Marker with professional ID ${professionalId} not found.`);
    }
  }

  closeMarkerPopup(professionalId) {
    const marker = this.markersMap[professionalId];
    if (marker) {
      marker.getPopup().remove(); // Remove the popup from the marker
    } else {
      console.error(`Marker with professional ID ${professionalId} not found.`);
    }
  }

  #onMarkerOpen(professionalId) {
    // Trigger the showDetails method on the associated card
    const card = document.querySelector(`.search-professional-card[data-professional-id='${professionalId}']`);
    if (card) {
      const detailsLink = card.querySelector('.details');
      if (detailsLink) {
        detailsLink.click();
      } else {
        console.error(`Details link not found for professional ID ${professionalId}.`);
      }
      // Scroll to the card
      this.#scrollToCard(card);
    } else {
      console.error(`Card not found for professional ID ${professionalId}.`);
    }
  }

  #onMarkerClose(professionalId) {
    // Trigger the closeDetails method on the associated card
    const card = document.querySelector(`.search-professional-card[data-professional-id='${professionalId}']`);
    if (card) {
      const closeButton = card.querySelector('.close-button');
      if (closeButton) {
        closeButton.click();
      } else {
        console.error(`Close button not found for professional ID ${professionalId}.`);
      }
    } else {
      console.error(`Card not found for professional ID ${professionalId}.`);
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
