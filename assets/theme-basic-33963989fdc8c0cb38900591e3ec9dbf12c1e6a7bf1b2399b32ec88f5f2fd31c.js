import { Application } from "@hotwired/stimulus"
import StimulusTransition from "stimulus-transition"

const application = Application.start()
application.register("transition", StimulusTransition.default)

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom,  } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers/themes/shared", application)
eagerLoadControllersFrom("controllers/themes/basic", application);
