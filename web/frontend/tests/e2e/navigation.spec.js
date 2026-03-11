import { test, expect } from '@playwright/test';

test.describe('Navigation and Security', () => {
  test('should navigate between pages and have security headers', async ({ page }) => {
    // 1. Check Home Page
    const response = await page.goto('/');
    await expect(page).toHaveTitle(/Hello World/);
    
    // Check for CSP Report-Only header
    const headers = response.headers();
    expect(headers['content-security-policy-report-only']).toContain("script-src 'nonce-");
    expect(headers['reporting-endpoints']).toContain('default="/_reports/default"');

    // 2. Navigate to Demo Page
    await page.goto('/demo');
    await expect(page).toHaveTitle(/Lit Component Demo/);
    
    // Verify Lit component (task-list) is present
    const taskList = page.locator('task-list');
    await expect(taskList).toBeVisible();

    // 3. Navigate to Contact Page
    await page.goto('/contact');
    await expect(page).toHaveTitle(/Contact Us/);
    
    // Verify CSRF meta tag is present
    const csrfMeta = page.locator('meta[name="csrf-token"]');
    await expect(csrfMeta).toHaveAttribute('content', /.+/);
  });
});

test.describe('Demo Page Functionality', () => {
  test('should render task list from JSON-LD', async ({ page }) => {
    await page.goto('/demo');
    
    // Wait for the task-list to be ready (Lit components are async)
    const taskItems = page.locator('task-item');
    // The dummy list has 3 tasks
    await expect(taskItems).toHaveCount(3);
    
    await expect(taskItems.first()).toContainText('Learn Lit');
  });
});
