import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["details"]

  connect() {

  }

  showDetails(event) {
    event.preventDefault()

    const url = event.target.href

    fetch(url, { headers: { 'Accept': 'text/html' } })
      .then(response => response.text())
      .then(html => {
        const container = document.querySelector('.container-results')
        container.innerHTML = html
      })
  }
}
