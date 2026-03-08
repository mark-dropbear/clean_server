/**
 * Retrieves the CSRF token from the page level meta tag.
 * @returns {string|null|undefined} The CSRF token value.
 */
export function getCsrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
}
