import { Controller } from "@hotwired/stimulus"

export default class FormThrottlerController extends Controller {
  initialize() {
    this.submitRunning = false;
    this.submitEnqueued = false;
    this.submitEndListener = this.submitEnd.bind(this);
  }

  connect() {
    this.element.addEventListener('turbo:submit-end', this.submitEndListener);
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-end', this.submitEndListener);
  }

  submit() {
    if (this.submitRunning) {
      this.submitEnqueued = true;
      return
    }

    this.submitRunning = true;
    this.element.requestSubmit();
  }

  submitEnd() {
    if (this.submitEnqueued) {
      this.submitEnqueued = false;
      this.element.requestSubmit();
      return;
    }

    this.submitRunning = false;
  }
}
