// app/javascript/controllers/date_picker_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dateField"];

  connect() {
    this.setDefaultDate();
    this.setMaxDate();
  }

  setDefaultDate() {
    if (!this.dateFieldTarget.value) {
      const currentYear = new Date().getFullYear();
      const buddhistYear = currentYear + 543 - 18;
      const formattedDate = this.formatDate(buddhistYear);
      this.dateFieldTarget.value = formattedDate;
    }
  }

  setMaxDate() {
    const maxDate = new Date();
    maxDate.setFullYear(maxDate.getFullYear() - 18);
    const buddhistMaxYear = maxDate.getFullYear() + 543;
    const formattedMaxDate = this.formatDate(buddhistMaxYear, maxDate);
    this.dateFieldTarget.max = formattedMaxDate;
  }

  formatDate(buddhistYear, date = new Date()) {
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${buddhistYear}-${month}-${day}`;
  }

  handleTodayButton() {
    const today = new Date().getFullYear();
    const clickToday = today + 543 - 18;
    const formattedDate = this.formatDate(clickToday);
    this.dateFieldTarget.value = formattedDate;
  }
}
