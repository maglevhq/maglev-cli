import { Application } from "@hotwired/stimulus"
import StimulusTransition from "stimulus-transition"

const application = Application.start()
application.register("transition", StimulusTransition.default)

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application };
