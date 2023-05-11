import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["template", "container", "pendingRow"]
    connect() {
    }

    add() {
        let template = this.templateTarget.innerHTML;
        const now = Date.now()
        template = template.replace("$id", `${now}`)
        template = template.replace("$id", `${now}`)
        this.containerTarget.insertAdjacentHTML('beforeend', template)
    }

    remove(event) {
        event.preventDefault();
        event.target.closest('div.row').remove()
    }
}
