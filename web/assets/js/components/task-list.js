import { LitElement, html, css } from 'lit';
import './task-item.js';

export class TaskList extends LitElement {
  static properties = {
    _items: { state: true },
  };

  static styles = css`
    :host {
      display: block;
      max-width: 800px;
      margin: 0 auto;
      padding: 1rem;
    }
    .list-header {
      margin-bottom: 2rem;
      border-bottom: 2px solid #eee;
      padding-bottom: 1rem;
    }
    h2 {
      margin: 0;
      color: #2d3748;
    }
    .description {
      color: #718096;
      margin-top: 0.5rem;
    }
  `;

  constructor() {
    super();
    this._items = [];
    this._listInfo = { name: '', description: '' };
  }

  firstUpdated() {
    const slot = this.shadowRoot.querySelector('slot');
    const assignedNodes = slot.assignedNodes();
    const scriptTag = assignedNodes.find(
      n => n.tagName === 'SCRIPT' && n.type === 'application/ld+json'
    );
    
    if (scriptTag) {
      try {
        const data = JSON.parse(scriptTag.textContent);
        this._listInfo = {
          name: data.name || 'Task List',
          description: data.description || '',
        };
        this._items = data.itemListElement?.map(element => element.item) || [];
        this.requestUpdate();
      } catch (e) {
        console.error('Failed to parse JSON-LD', e);
      }
    }
  }

  render() {
    return html`
      <div class="container">
        <slot style="display:none"></slot>
        <div class="list-header">
          <h2>${this._listInfo.name}</h2>
          ${this._listInfo.description ? 
            html`<p class="description">${this._listInfo.description}</p>` : ''}
        </div>
        <div class="tasks">
          ${this._items.map(item => html`
            <task-item 
              .name=${item.name} 
              .description=${item.description} 
              .status=${item.actionStatus}
            ></task-item>
          `)}
        </div>
      </div>
    `;
  }
}
customElements.define('task-list', TaskList);
