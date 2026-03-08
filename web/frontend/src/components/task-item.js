import { LitElement, html } from 'lit';
import componentStyles from './task-item.css' with { type: 'css' };

export class TaskItem extends LitElement {
  static properties = {
    name: { type: String },
    description: { type: String },
    status: { type: String },
  };

  static styles = [componentStyles];

  render() {
    const isCompleted = this.status?.includes('CompletedActionStatus');
    return html`
      <div class="task">
        <div class="task-header">
          <strong>${this.name}</strong>
          <span class="status ${isCompleted ? 'completed' : 'active'}">
            ${isCompleted ? '✓ Completed' : '○ Active'}
          </span>
        </div>
        <p>${this.description}</p>
      </div>
    `;
  }
}
customElements.define('task-item', TaskItem);
