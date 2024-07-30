// app/javascript/controllers/map_controller.js
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

      // Delay enabling the close button
      popup.on('open', () => {
        const closeButton = document.querySelector('.mapboxgl-popup-close-button');
        closeButton.disabled = true; // Disable the button initially
        setTimeout(() => {
          closeButton.disabled = false; // Enable it after a short delay
        }, 100); // Adjust the delay as needed
      })

      // Store the marker with its professional ID
      this.markersMap[marker.professional_id] = mapMarker;
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
}
