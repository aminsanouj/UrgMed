import { Controller } from "@hotwired/stimulus";

const professions = [
  "Médecin",
  "Pharmacie",
  "Dentiste",
  "Urgences"
];

export default class extends Controller {
  static targets = ["input", "results", "clear"];

  connect() {
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener("click", this.handleClick.bind(this));
    }
    if (this.hasResultsTarget) {
      this.resultsTarget.addEventListener("click", this.handleResultClick.bind(this));
    }

    // Initialiser l'état du toggle en fonction de l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const openNow = urlParams.get('open_now') === 'true';
    if (this.hasInputTarget) {
      this.inputTarget.checked = openNow;
    }
  }

  handleClick(event) {
    this.displaySuggestions(professions);
  }

  handleResultClick(event) {
    if (event.target.tagName === "LI") {
      this.inputTarget.value = event.target.innerText;
      this.submitForm();
    }
  }

  displaySuggestions(professions) {
    if (this.hasResultsTarget) {
      const resultsHTML = professions.map(profession =>
        `<li class="list-group-item" role="option">${profession}</li>`
      ).join("");
      this.resultsTarget.innerHTML = resultsHTML;
    }
  }


  clear() {
    if (this.hasInputTarget) {
      this.inputTarget.value = "";
    }
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = "";
    }
    this.submitForm(); // Soumettre le formulaire après avoir vidé le champ
  }

  submitForm() {
    this.element.submit();
  }

  // Méthode pour gérer l'événement de changement de la case à cocher
  toggleFilter(event) {
    const isOpenNow = event.target.checked;
    const form = this.element;

    // Ajouter ou supprimer le paramètre open_now dans le formulaire
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'open_now';
    input.value = isOpenNow;

    // Assurez-vous de supprimer l'ancien champ hidden si présent
    const existingInput = form.querySelector('input[name="open_now"]');
    if (existingInput) {
      form.removeChild(existingInput);
    }

    form.appendChild(input);
    this.submitForm(); // Soumettre le formulaire après avoir ajouté ou supprimé le champ
  }
}
