import { LitElement, html } from 'lit';
import componentStyles from './task-list.css' with { type: 'css' };
import './task-item.js';

export class TaskList extends LitElement {
  static properties = {
    _items: { state: true },
  };

  static styles = [componentStyles];

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
        <slot></slot>
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
