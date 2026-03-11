# Plan: Implement E2E Testing with Playwright

## Objective
Integrate Playwright into the project to enable full multi-page user flow testing of the Dart server and Lit frontend components.

## Key Files & Context
- **web/frontend/package.json**: Add Playwright dependencies and scripts.
- **web/frontend/playwright.config.js**: Configure Playwright to manage the browser environment and automatically start the Dart server.
- **web/frontend/tests/e2e/**: New directory for end-to-end test files.

## Implementation Steps

### 1. Dependency Management
- Add @playwright/test to devDependencies in web/frontend/package.json.
- Add a test:e2e script: playwright test.

### 2. Configuration
Create web/frontend/playwright.config.js:
- Set use.baseURL to http://localhost:8080.
- Configure webServer to run dart run ../../bin/clean_server.dart.
- Set up browsers (Chromium, Firefox, WebKit).
- Enable Trace Viewer for failed tests.

### 3. Sample E2E Test
Create web/frontend/tests/e2e/navigation.spec.js:
- Test navigation between Home, Demo, and Contact pages.
- Verify CSRF tokens and CSP headers are present in the browser context.
- Verify Lit components (like task-list on the demo page) render correctly.

### 4. Verification
- Run npm install in web/frontend.
- Run npm run test:e2e.

## Verification & Testing
- Automated execution via the new script.
- Manual verification of the Trace Viewer output.
