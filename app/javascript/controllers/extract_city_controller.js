import { Controller } from "@hotwired/stimulus";

const cityRegex = /([^\s,]+)\s*,\s*France$/;

export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("Controller connected");
  }

  extractCityFromInput() {
    const address = this.inputTarget.value;
    console.log("Extracting city from address:", address);

    const city = this.extractCity(address);
    console.log("Extracted city:", city);

    if (city) {
      this.inputTarget.value = city;
      console.log("Updated input value with city:", this.inputTarget.value);
    } else {
      console.log("No city extracted");
    }
  }

  extractCity(address) {
    console.log("Matching address with regex:", address);

    const match = address.match(cityRegex);
    console.log("Regex match result:", match);

    return match ? match[1] : null;
  }
}
