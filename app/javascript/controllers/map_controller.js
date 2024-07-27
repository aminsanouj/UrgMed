import { Controller } from "@hotwired/stimulus";
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    // Set Mapbox access token
    mapboxgl.accessToken = this.apiKeyValue;
    this.element.innerHTML = '';

    // Initialize the map
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    });

    // Initialize current popup tracker
    this.currentPopup = null;

    // Add markers to the map
    this.#addMarkersToMap();

    // Fit the map to the markers
    this.#fitMapToMarkers();
  }

  // Add markers to the map
  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
      const customMarker = this.#createCustomMarker(marker);

      const mapMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);

      popup.on('open', () => this.#handlePopupOpen(popup));
    });
  }

  // Create a custom marker element
  #createCustomMarker(marker) {
    const customMarker = document.createElement("div");
    customMarker.innerHTML = marker.marker_html;

    const professionalId = this.#getProfessionalId(marker.info_window_html);
    if (professionalId) {
      customMarker.setAttribute('data-professional-id', professionalId);
      customMarker.addEventListener('click', () => this.#handleMarkerClick(professionalId, marker));
    } else {
      console.error(`No professional ID found in marker info window HTML: ${marker.info_window_html}`);
    }

    return customMarker;
  }

  // Extract professional ID from info window HTML
  #getProfessionalId(infoWindowHtml) {
    const professionalIdMatch = infoWindowHtml.match(/data-professional-id="(\d+)"/);
    return professionalIdMatch ? professionalIdMatch[1] : null;
  }

  // Handle marker click event
  #handleMarkerClick(professionalId, marker) {
    console.log('Handling marker click for professionalId:', professionalId);

    if (this.#isCurrentPopup(marker)) return;

    this.#closeCurrentPopup();
    this.showProfessionalDetails(professionalId);

    const cardElement = document.getElementById(`professional-${professionalId}`);
    if (cardElement) {
      this.scrollToCard(cardElement);
    } else {
      console.error('No card found for professional ID:', professionalId);
    }
  }

  // Check if the current popup is the same as the clicked marker
  #isCurrentPopup(marker) {
    return this.currentPopup &&
           this.currentPopup.getLngLat().lng === marker.lng &&
           this.currentPopup.getLngLat().lat === marker.lat;
  }

  // Handle popup open event
  #handlePopupOpen(popup) {
    console.log('Popup opened:', popup);
    this.currentPopup = popup;
    this.#addPopupCloseButtonListener();

    setTimeout(() => {
      const closeButton = document.querySelector('.mapboxgl-popup-close-button');
      console.log('Checking for close button...');
      if (closeButton) {
        console.log('Adding close button listener');
        closeButton.disabled = true;
        setTimeout(() => {
          closeButton.disabled = false;
        }, 100);
      } else {
        console.error('Close button not found.');
      }
    }, 100); // Ajustez le délai si nécessaire
  }

  // Add event listener to popup close button
  #addPopupCloseButtonListener() {
    const closeButton = document.querySelector('.mapboxgl-popup-close-button');
    if (closeButton) {
      closeButton.addEventListener('click', () => this.#closeCurrentPopup());
    }
  }

  // Close the current popup
  #closeCurrentPopup() {
    if (this.currentPopup) {
      console.log('Closing current popup:', this.currentPopup);
      this.currentPopup.remove();
      this.currentPopup = null;

      // Attendre un court instant avant de déclencher la fermeture des détails
      setTimeout(() => {
        this.#triggerCloseDetailsInProfessionalController();
      }, 100);
    }
  }

  // Trigger close details in professional controller
  #triggerCloseDetailsInProfessionalController() {
    const closeButton = document.querySelector('.search-professional-card .close-button');
    if (closeButton) {
      closeButton.click();
    }
  }

  // Show professional details
  showProfessionalDetails(professionalId) {
    const button = document.querySelector(`.card[data-professional-id="${professionalId}"] .details`);
    if (button) {
      if (!this.isFromOpenMarker) {
        button.click();
      }
      this.isFromOpenMarker = false; // Reset the flag
    } else {
      console.error(`No button found for professional ID: ${professionalId}`);
    }
  }

  // Scroll to the card element
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

  // Fit the map to the markers
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

  // Open a marker by professional ID
  openMarker(professionalId) {
    console.log('openMarker called with professionalId:', professionalId);
    this.isFromOpenMarker = true; // Set the flag

    const markerElement = document.querySelector(`.mapboxgl-marker[data-professional-id="${professionalId}"]`);
    if (markerElement) {
      console.log('Marker found, triggering click event for professionalId:', professionalId);
      markerElement.click();
    } else {
      console.error('No marker found for professional ID:', professionalId);
    }
  }
}
