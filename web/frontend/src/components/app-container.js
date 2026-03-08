import { LitElement, html } from 'lit';
import globalStyles from './global-styles.css' with { type: 'css' };

export class AppContainer extends LitElement {
  connectedCallback() {
    super.connectedCallback();
    // Signal that JS is active by updating the body attribute
    document.body.setAttribute('data-js', 'true');
    document.adoptedStyleSheets.push(globalStyles);
  }

  render() {
    // This component acts as a global controller and doesn't render visual content for now
    return html`<slot></slot>`;
  }
}

customElements.define('app-container', AppContainer);
