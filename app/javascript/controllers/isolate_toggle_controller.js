import { Controller } from "@hotwired/stimulus"

// Dispatches veritas:isolateToggle which the globe controller listens for.
// When active, the globe hides points that have zero connected arcs.

export default class extends Controller {
  static targets = ["btn", "label"]

  connect() {
    this._active = false
    this._stateHandler = (e) => this._onState(e)
    window.addEventListener("veritas:isolateState", this._stateHandler)
  }

  disconnect() {
    window.removeEventListener("veritas:isolateState", this._stateHandler)
  }

  toggle() {
    window.dispatchEvent(new CustomEvent("veritas:isolateToggle"))
  }

  _onState(event) {
    this._active = event.detail.active
    if (this.hasBtnTarget) {
      this.btnTarget.classList.toggle("is-active", this._active)
    }
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = this._active ? "NETWORKS" : "ISOLATES"
    }
  }
}
