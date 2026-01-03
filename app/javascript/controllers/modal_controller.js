import { Controller } from "@hotwired/stimulus"

export default class ModalController extends Controller {
  static targets = ['container', 'frame'];

  async open(event) {
    event.preventDefault();

    this.frameTarget.src = event.currentTarget.href;
    await this.frameTarget.loaded
    this.containerTarget.style.display = '';
  }

  close(event) {
    this.containerTarget.style.display = 'none';
  }
}
