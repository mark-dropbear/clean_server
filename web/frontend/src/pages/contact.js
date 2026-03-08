import { LitElement, html } from 'lit';
import '../components/contact-form.js';

export class ContactPage extends LitElement {
  connectedCallback() {
    super.connectedCallback();
    console.log('Contact page loaded');
    this.addEventListener('feedback-submitted', (e) => {
      console.log('Feedback submitted successfully:', e.detail);
    });
  }

  render() {
    // This component acts as a page level container
    return html`<slot></slot>`;
  }
}

customElements.define('contact-page', ContactPage);
