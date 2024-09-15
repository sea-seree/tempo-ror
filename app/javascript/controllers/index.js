// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import DatePickerController from "./date_picker_controller";

application.register("date-picker", DatePickerController);
eagerLoadControllersFrom("controllers", application)
