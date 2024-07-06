import { Controller } from "@hotwired/stimulus";

const professions = [
  "Médecin",
  "Pharmacie",
  "Dentiste",
  "Urgences"
];

const removeAccents = (str) => {
  return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
};

export default class extends Controller {
  static targets = ["input", "results", "clear"];

  connect() {
    this.inputTarget.addEventListener("click", this.handleClick.bind(this));
    this.inputTarget.addEventListener("input", this.handleInput.bind(this));
    if (this.hasResultsTarget) {
      this.resultsTarget.addEventListener("click", this.handleResultClick.bind(this));
    }
  }

  handleClick(event) {
    if (this.hasResultsTarget) {
      this.displaySuggestions(professions);
    }
  }

  handleInput(event) {
    if (this.hasResultsTarget) {
      const query = removeAccents(event.target.value);
      const filteredProfessions = professions.filter(profession => removeAccents(profession).startsWith(query));
      this.displaySuggestions(filteredProfessions);
    }
  }

  handleResultClick(event) {
    if (event.target.tagName === "LI") {
      this.inputTarget.value = event.target.innerText;
      this.submitForm();
    }
  }

  displaySuggestions(professions) {
    if (this.hasResultsTarget) {
      const resultsHTML = professions.map(profession => `<li class="list-group-item" role="option">${profession}</li>`).join("");
      this.resultsTarget.innerHTML = resultsHTML;
    }
  }

  clear() {
    this.inputTarget.value = "";
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = "";
    }
    this.submitForm(); // Ajouter cette ligne pour soumettre le formulaire après avoir vidé le champ
  }

  submitForm() {
    this.element.submit();
  }
}
