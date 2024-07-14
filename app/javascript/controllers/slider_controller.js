import { Controller } from "@hotwired/stimulus"

export default class SliderController extends Controller {
  static targets = ['handle', 'field'];
  static values = {
    min: Number,
    max: Number
  }

  initialize() {
    // Listener functions bound to this context
    this.startListener = this.startDrag.bind(this);
    this.endListener = this.endDrag.bind(this);
    this.moveListener = this.move.bind(this);

    // Values set at drag start
    this.initialMouseY = null;
    this.initialHandleY = null;
    this.sliderDistance = null;
    this.handleHeight = null;

    // Current values during dragging
    this.currentY = null;
    this.currentValue = null;
  }

  handleTargetConnected() {
    this.handleHeight = this.handleTarget.offsetHeight;
    this.sliderDistance = this.element.offsetHeight - this.handleHeight;
    this.updateHandlePosition();

    this.handleTarget.addEventListener('mousedown', this.startListener);
    this.handleTarget.addEventListener('touchstart', this.startListener);
  }

  disconnect() {
    this.handleTarget.removeEventListener('mousedown', this.startListener);
    this.handleTarget.removeEventListener('touchstart', this.startListener);
  }

  startDrag(event) {
    event.preventDefault();

    this.initialHandleY = this.handleTarget.offsetTop;
    this.initialMouseY = (event.clientY || event.touches[0].clientY);

    document.addEventListener('mousemove', this.moveListener);
    document.addEventListener('touchmove', this.moveListener);
    document.addEventListener('mouseup', this.endListener);
    document.addEventListener('touchend', this.endListener);
  }

  endDrag(_event) {
    this.currentY = null;
    this.currentValue = null;

    document.removeEventListener('mousemove', this.moveListener);
    document.removeEventListener('touchmove', this.moveListener);
    document.removeEventListener('mouseup', this.endListener);
    document.removeEventListener('touchend', this.endListener);
  }

  move(event) {
    const dy = (event.clientY || event.touches[0].clientY) - this.initialMouseY;
    const y = this.calculateYPosition(dy);
    if (this.currentY === y) { return }
    this.currentY = y;

    this.handleTarget.style.top = y + 'px';

    const value = this.calculateValue(y);
    if (this.currentValue === value) { return }
    this.currentValue = value;

    this.fieldTarget.value = value;
    this.fieldTarget.dispatchEvent(new Event('input'));
  }

  updateFromField(event) {
    // Ignore updates if we're currently dragging
    if (this.currentY !== null ) { return; }

    this.updateHandlePosition();
  }

  updateHandlePosition() {
    this.handleTarget.style.top = (this.sliderDistance - Math.round((Number(this.fieldTarget.value) / this.maxValue * this.sliderDistance))) + 'px';
  }

  calculateYPosition(dy) {
    let y = this.initialHandleY + dy
    if (y < 0) { y = 0 }
    if (y > this.sliderDistance) { y = this.sliderDistance }
    return y;
  }

  calculateValue(y) {
    const position = (this.sliderDistance - y) / this.sliderDistance;
    return Math.round(this.maxValue * position);
  }
}
