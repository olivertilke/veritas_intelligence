import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["badge", "label", "apiCounter", "dot"]

  connect() {
    this._modeChangedHandler = (e) => this._onExternalModeChange(e)
    window.addEventListener("veritas:mode-changed", this._modeChangedHandler)

    // Fetch initial state from server
    this._fetchMode()
  }

  disconnect() {
    window.removeEventListener("veritas:mode-changed", this._modeChangedHandler)
  }

  async toggle() {
    try {
      const response = await fetch("/api/mode/toggle", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content || ""
        }
      })

      const data = await response.json()

      if (!response.ok || data.error) {
        this._showToast(data.error || "Failed to toggle mode")
        // Still update UI with whatever mode the server says
        if (data.mode) this._applyMode(data.mode, data.api_calls_remaining)
        return
      }

      this._applyMode(data.mode, data.api_calls_remaining)

      // Notify other controllers (globe, search, etc.)
      window.dispatchEvent(new CustomEvent("veritas:mode-changed", {
        detail: { mode: data.mode, apiCallsRemaining: data.api_calls_remaining }
      }))
    } catch (err) {
      console.error("[ModeToggle] Toggle failed:", err)
      this._showToast("Failed to toggle mode — check connection")
    }
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  async _fetchMode() {
    try {
      const response = await fetch("/api/mode")
      const data = await response.json()
      this._applyMode(data.mode, data.api_calls_remaining)
    } catch (err) {
      // Default to demo appearance if fetch fails
      this._applyMode("demo", null)
    }
  }

  _applyMode(mode, apiCallsRemaining) {
    const isLive = mode === "live"

    if (this.hasBadgeTarget) {
      this.badgeTarget.classList.toggle("mode-live", isLive)
      this.badgeTarget.classList.toggle("mode-demo", !isLive)
    }

    if (this.hasLabelTarget) {
      this.labelTarget.textContent = isLive ? "LIVE" : "DEMO"
    }

    if (this.hasDotTarget) {
      this.dotTarget.classList.toggle("mode-dot-live", isLive)
      this.dotTarget.classList.toggle("mode-dot-demo", !isLive)
    }

    if (this.hasApiCounterTarget) {
      if (isLive && apiCallsRemaining != null) {
        this.apiCounterTarget.textContent = `API: ${apiCallsRemaining}/100`
        this.apiCounterTarget.classList.remove("d-none")
      } else {
        this.apiCounterTarget.classList.add("d-none")
      }
    }
  }

  _onExternalModeChange(event) {
    const { mode, apiCallsRemaining } = event.detail
    this._applyMode(mode, apiCallsRemaining)
  }

  _showToast(message) {
    // Create a transient toast notification
    const toast = document.createElement("div")
    toast.className = "veritas-mode-toast"
    toast.textContent = message
    document.body.appendChild(toast)

    // Trigger reflow then animate in
    requestAnimationFrame(() => toast.classList.add("is-visible"))

    setTimeout(() => {
      toast.classList.remove("is-visible")
      setTimeout(() => toast.remove(), 400)
    }, 4000)
  }
}
