import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.initAutocomplete();
  }

  initAutocomplete() {
      const input = this.inputTarget;

      this.autocomplete = new google.maps.places.Autocomplete(input, {
        componentRestrictions: { country: 'fr' }
      });
      console.log("Autocomplete initialized with restrictions:", this.autocomplete);

      // Créer une référence à la fonction onPlaceChanged pour pouvoir l'ajouter et la retirer facilement
      this.boundOnPlaceChanged = this.onPlaceChanged.bind(this);

      // Écoute l'événement place_changed pour mettre à jour le champ de saisie, mais ne déclenche pas handleSearch
      this.autocomplete.addListener("place_changed", this.boundOnPlaceChanged);

      // Ajoute un écouteur pour détecter la touche Entrée
      input.addEventListener("keydown", (event) => {
          if (event.key === "Enter") {
              event.preventDefault();
              // Désactiver temporairement l'écouteur d'événements place_changed
              google.maps.event.clearListeners(this.autocomplete, 'place_changed');
              this.handleSearch();
              // Réactiver l'écouteur d'événements place_changed après un délai
              setTimeout(() => {
                  this.autocomplete.addListener("place_changed", this.boundOnPlaceChanged);
              }, 10000);
          }
      });
  }

  handleSearch() {
    const input = this.inputTarget;
    const searchValue = input.value.trim();
    console.log("Search value:", searchValue);

    const placesService = new google.maps.places.AutocompleteService();
    console.log("Places service initialized:", placesService);

    placesService.getPlacePredictions({ input: searchValue, componentRestrictions: { country: 'fr' } }, (predictions, status) => {
        console.log("Predictions callback:", predictions, "Status:", status);

        if (status === google.maps.places.PlacesServiceStatus.OK && predictions && predictions.length > 0) {
            const firstPrediction = predictions[0];
            console.log("First prediction:", firstPrediction);

            input.value = firstPrediction.description;
            console.log("Input value set to first prediction description:", input.value);
            this.onPlaceChanged(); // Appel de onPlaceChanged ici
        } else {
            console.log("No predictions found or status not OK");
        }
    });
  }

  onPlaceChanged() {
    const extractCityController = this.application.getControllerForElementAndIdentifier(this.element, "extract-city");
    const extractRegionController = this.application.getControllerForElementAndIdentifier(this.element, "extract-region");

    if (extractCityController) {
        extractCityController.extractCityFromInput();
        console.log("extractCityController found.");
    } else {
        console.log("extractCityController not found.");
    }

    if (extractRegionController) {
        extractRegionController.extractRegionFromInput();
        console.log("extractRegionController found.");
    } else {
        console.log("extractRegionController not found.");
    }

    // Vérifiez si les deux contrôleurs n'existent pas avant de soumettre le formulaire
    if (!extractCityController && !extractRegionController) {
        console.log("No controllers found. Submitting the form.");
        this.element.submit();
    }
  }
}
