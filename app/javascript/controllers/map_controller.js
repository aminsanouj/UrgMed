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
  }

  #addMarkersToMap() {
    this.markers = this.markersValue.map(({ id, lat, lng, marker_html, info_window_html }) => {
      const popup = new mapboxgl.Popup().setHTML(info_window_html);
      const customMarker = document.createElement("div");
      customMarker.innerHTML = marker_html;

      const mapMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([lng, lat])
        .setPopup(popup)
        .addTo(this.map);

      return { mapMarker, id, popup, info_window_html };
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(({ lat, lng }) => {
      if (lat && lng) bounds.extend([lng, lat]);
    });

    if (bounds.getNorthEast() && bounds.getSouthWest()) {
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    }
  }

  openMarkerById(professionalId) {
    const marker = this.markers.find(({ info_window_html }) =>
      info_window_html.includes(`data-professional-id="${professionalId}"`)
    );

    if (marker) {
      marker.mapMarker.togglePopup();
    } else {
      console.log(`Marker with ID ${professionalId} not found.`);
    }
  }

  closeMarkerById(professionalId) {
    const marker = this.markers.find(({ info_window_html }) =>
      info_window_html.includes(`data-professional-id="${professionalId}"`)
    );

    if (marker) {
      marker.popup.remove();
    } else {
      console.log(`Marker with ID ${professionalId} not found.`);
    }
  }
}
