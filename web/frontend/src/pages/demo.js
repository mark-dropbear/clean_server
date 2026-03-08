import { LitElement, html } from 'lit';
import '../components/task-item.js';
import '../components/task-list.js';

export class DemoPage extends LitElement {
  connectedCallback() {
    super.connectedCallback();
    console.log('Demo page loaded');
  }

  render() {
    // This component acts as a page level container
    return html`<slot></slot>`;
  }
}

customElements.define('demo-page', DemoPage);
