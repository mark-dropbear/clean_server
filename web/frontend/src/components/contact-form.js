import { LitElement, html } from 'lit';
import componentStyles from './contact-form.css' with { type: 'css' };
import { getCsrfToken } from '../utils.js';

export class ContactForm extends LitElement {
  static properties = {
    _isSubmitting: { state: true },
    _success: { state: true },
    _error: { state: true },
  };

  static styles = [componentStyles];

  constructor() {
    super();
    this._isSubmitting = false;
    this._success = false;
    this._error = null;
  }

  render() {
    if (this._success) {
      return html`
        <div class="success-message">
          <h3>Thank you for your feedback!</h3>
          <p>We have received your message and will get back to you soon.</p>
          <button @click=${this._resetForm}>Send another message</button>
        </div>
      `;
    }

    return html`
      <form @submit=${this._handleSubmit}>
        <div class="form-group">
          <label for="name">Name</label>
          <input 
            type="text" 
            id="name" 
            name="name" 
            required 
            minlength="2" 
            maxlength="100"
            ?disabled=${this._isSubmitting}
          >
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <input 
            type="email" 
            id="email" 
            name="email" 
            required
            ?disabled=${this._isSubmitting}
          >
        </div>

        <div class="form-group">
          <label for="message">Message</label>
          <textarea 
            id="message" 
            name="message" 
            required 
            rows="5" 
            minlength="10" 
            maxlength="2000"
            ?disabled=${this._isSubmitting}
          ></textarea>
        </div>

        ${this._error ? html`<div class="error-message">${this._error}</div>` : ''}

        <button type="submit" ?disabled=${this._isSubmitting}>
          ${this._isSubmitting ? 'Submitting...' : 'Send Message'}
        </button>
      </form>
    `;
  }

  async _handleSubmit(e) {
    e.preventDefault();
    this._isSubmitting = true;
    this._error = null;

    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData.entries());
    const csrfToken = getCsrfToken();

    try {
      const response = await fetch('/api/feedback', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-xsrf-token': csrfToken || '',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const result = await response.json();
        throw new Error(result.error || 'Failed to submit feedback');
      }

      this._success = true;
      this.dispatchEvent(new CustomEvent('feedback-submitted', {
        detail: await response.json(),
        bubbles: true,
        composed: true
      }));
    } catch (err) {
      this._error = err.message;
    } finally {
      this._isSubmitting = false;
    }
  }

  _resetForm() {
    this._success = false;
    this._error = null;
  }
}

customElements.define('contact-form', ContactForm);
