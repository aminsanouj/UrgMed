import { Controller } from "@hotwired/stimulus";
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    this.element.innerHTML = '';

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    });

    this.#addMarkersToMap();
    this.#fitMapToMarkers();

    this.currentPopup = null; // Track the currently open popup
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);

      const customMarker = document.createElement("div");
      customMarker.innerHTML = marker.marker_html;

      const professionalIdMatch = marker.info_window_html.match(/data-professional-id="(\d+)"/);
      if (professionalIdMatch) {
        const professionalId = professionalIdMatch[1];
        customMarker.setAttribute('data-professional-id', professionalId);

        customMarker.addEventListener('click', () => {
          if (this.currentPopup) {
            this.#closeCurrentPopup();
          }

          this.showProfessionalDetails(professionalId);

          const cardElement = document.getElementById(`professional-${professionalId}`);

          if (cardElement) {
            this.scrollToCard(cardElement);
          }
        });
      } else {
        console.error('No professional ID found in marker info window HTML:', marker.info_window_html);
      }

      const mapMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);

      popup.on('open', () => {
        this.currentPopup = popup;
        this.#addPopupCloseButtonListener();

        // Delay enabling the close button
        const closeButton = document.querySelector('.mapboxgl-popup-close-button');
        closeButton.disabled = true; // Disable the button initially
        setTimeout(() => {
          closeButton.disabled = false; // Enable it after a short delay
        }, 100); // Adjust the delay as needed
      });
    });
  }

  #addPopupCloseButtonListener() {
    const closeButton = document.querySelector('.mapboxgl-popup-close-button');
    if (closeButton) {
      closeButton.addEventListener('click', () => {
        this.#closeCurrentPopup();
      });
    }
  }

  #closeCurrentPopup() {
    if (this.currentPopup) {
      this.currentPopup.remove(); // Close the popup
      this.currentPopup = null;
      this.#triggerCloseDetailsInProfessionalController();
    }
  }

  #triggerCloseDetailsInProfessionalController() {
    const closeButton = document.querySelector('.search-professional-card .close-button');
    if (closeButton) {
      closeButton.click(); // Trigger close details in professional controller
    }
  }

  showProfessionalDetails(professionalId) {
    const button = document.querySelector(`.card[data-professional-id="${professionalId}"] .details`);

    if (button) {
      button.click();
    } else {
      console.error(`No button found for professional ID: ${professionalId}`);
    }
  }

  scrollToCard(cardElement) {
    const container = document.querySelector('.container-results');
    const containerRect = container.getBoundingClientRect();
    const cardRect = cardElement.getBoundingClientRect();

    const scrollTop = container.scrollTop + cardRect.top - containerRect.top - (containerRect.height - cardRect.height) / 2;

    container.scrollTo({
      top: scrollTop,
      behavior: 'smooth'
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => {
      if (marker.lng && marker.lat) {
        bounds.extend([marker.lng, marker.lat]);
      }
    });
    if (bounds.getNorthEast() && bounds.getSouthWest()) {
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    }
  }
}
