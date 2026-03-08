import { LitElement, html } from 'lit';

export class HomePage extends LitElement {
  connectedCallback() {
    super.connectedCallback();
    console.log('Home page loaded');
  }

  firstUpdated(){
    const timeElement = document.getElementById('time');
    if (timeElement) {
      timeElement.textContent = this.#formatTime(new Date());
      setInterval(() => {
        timeElement.textContent = this.#formatTime(new Date());
      }, 1000);
    }
  }

  render() {
    // This component acts as a page level container
    return html`<slot></slot>`;
  }

  #formatTime(date) {
    return date.toLocaleTimeString();
  }
}

customElements.define('home-page', HomePage);
