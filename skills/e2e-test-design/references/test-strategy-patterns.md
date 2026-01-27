# E2E Test Strategy Patterns

This document provides comprehensive patterns and examples for E2E test strategy development.

## Test Strategy Components

### Risk-Based Testing Approach

**High-Priority Areas:**
- Authentication/Authorization flows (login, permissions, access control)
- Payment processing and financial transactions
- Data persistence and critical CRUD operations
- Third-party integrations (APIs, payment gateways, external services)
- Security vulnerabilities and edge cases

**Medium-Priority Areas:**
- Navigation and routing
- Form validations
- User workflows (multi-step processes)
- Error handling and user feedback

**Low-Priority Areas:**
- UI styling and cosmetic elements
- Non-critical content displays
- Optional features with low usage

### Test Coverage Strategies

**Critical Path Coverage (100% Required)**
- User registration → Login → Core feature usage → Logout
- Purchase flow: Browse → Add to cart → Checkout → Payment → Confirmation
- Data submission: Create → Read → Update → Delete (CRUD)

**Happy Path vs. Negative Path Balance**
- 70% happy paths (normal user behavior, expected inputs, successful outcomes)
- 30% negative paths (invalid inputs, error conditions, edge cases, security tests)

**Cross-Browser and Cross-Platform Strategy**
- **Essential browsers**: Chrome (latest), Firefox (latest), Safari (latest), Edge (latest)
- **Mobile browsers**: iOS Safari, Chrome Mobile (if mobile app)
- **Platforms**: Windows 10+, macOS (latest), Linux (if applicable), iOS, Android
- **Responsive testing**: Desktop (1920x1080), Tablet (768x1024), Mobile (375x667)

### Test Types Within E2E

**Functional Testing**
- Verify features work as specified
- Validate business logic and rules
- Check data integrity and consistency

**Integration Testing**
- Test communication between frontend and backend
- Verify API interactions
- Test third-party service integrations

**UI Testing**
- Validate UI elements render correctly
- Test user interactions (click, type, scroll)
- Check responsive design

**Performance Testing (Basic)**
- Measure page load times
- Check responsiveness under normal load
- Monitor resource usage

**Security Testing**
- Validate authentication and authorization
- Test input sanitization (XSS, SQL injection)
- Verify secure data transmission (HTTPS)

### Test Data Management Strategies

**Test Data Generation**
- **Static fixtures**: Predefined test data files (JSON, CSV) for consistent scenarios
- **Factory functions**: Programmatic data generation for flexible scenarios
- **Mocked APIs**: Simulate backend responses for isolated frontend testing
- **Seeded databases**: Pre-populate test databases with known data states

**Data Cleanup and Isolation**
- **Per-test isolation**: Each test has its own data set, no shared state
- **Setup and teardown**: Create data before test, delete after test
- **Database transactions**: Use rollback for data cleanup
- **Separate test databases**: Never use production or staging data

**Managing Sensitive Data**
- Use environment variables for credentials (never hardcode)
- Implement data masking for PII in test environments
- Use test-specific API keys and tokens
- Rotate test credentials regularly

### Test Environment Requirements

**Environment Types**

1. **Local Development Environment**
   - Purpose: Developer testing and debugging
   - Setup: Docker Compose or local services
   - Data: Small fixture datasets

2. **CI/CD Environment**
   - Purpose: Automated testing on each commit/PR
   - Setup: Containerized services, ephemeral databases
   - Data: Factory-generated or seeded data

3. **Staging Environment**
   - Purpose: Pre-production validation, integration testing
   - Setup: Mirrors production architecture
   - Data: Anonymized production-like data

4. **Production-like Environment (Optional)**
   - Purpose: Final smoke tests before deployment
   - Setup: Exact production configuration
   - Data: Synthetic data mimicking production volume

**Environment Configuration**
- Separate config files per environment (`.env.local`, `.env.ci`, `.env.staging`)
- Feature flags for environment-specific behavior
- Mock external services in lower environments (payment gateways, email services)

## Test Automation Framework Patterns

### Framework Selection Criteria

**For Web Applications:**
- **Playwright** (recommended): Cross-browser, fast, auto-wait, trace viewer
- **Cypress**: Developer-friendly, time-travel debugging, automatic retries
- **Selenium WebDriver**: Mature, multi-language, broad browser support

**For Mobile Applications:**
- **Appium**: Cross-platform (iOS/Android), WebDriver-based
- **Detox** (React Native): Fast, grey-box testing
- **Espresso** (Android native): Fast, reliable
- **XCUITest** (iOS native): Apple's official framework

**For API Testing:**
- **REST Assured** (Java): Fluent API for REST testing
- **SuperTest** (Node.js): HTTP assertion library
- **Postman/Newman**: GUI-based, CLI runner

### Framework Architecture Patterns

**Page Object Model (POM)**
```typescript
// pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}

  async navigate() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[name="email"]', email);
    await this.page.fill('[name="password"]', password);
    await this.page.click('button[type="submit"]');
  }

  async getErrorMessage() {
    return this.page.textContent('.error-message');
  }
}

// tests/login.spec.ts
test('should show error for invalid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.navigate();
  await loginPage.login('invalid@example.com', 'wrongpassword');
  const error = await loginPage.getErrorMessage();
  expect(error).toContain('Invalid credentials');
});
```

**App Actions Pattern (Cypress)**
```javascript
// cypress/support/app-actions.js
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/login');
  cy.get('[name="email"]').type(email);
  cy.get('[name="password"]').type(password);
  cy.get('button[type="submit"]').click();
  cy.url().should('include', '/dashboard');
});

// cypress/e2e/dashboard.cy.js
describe('Dashboard', () => {
  beforeEach(() => {
    cy.login('user@example.com', 'password123');
  });

  it('should display user profile', () => {
    cy.contains('Welcome, User');
  });
});
```

**Screenplay Pattern (Advanced)**
```typescript
// actors/User.ts
export class User {
  constructor(private page: Page) {}

  async attemptsTo(...tasks: Task[]) {
    for (const task of tasks) {
      await task.performAs(this.page);
    }
  }
}

// tasks/Login.ts
export class Login implements Task {
  constructor(private email: string, private password: string) {}

  async performAs(page: Page) {
    await page.fill('[name="email"]', this.email);
    await page.fill('[name="password"]', this.password);
    await page.click('button[type="submit"]');
  }
}

// tests/user-journey.spec.ts
test('User purchases a product', async ({ page }) => {
  const user = new User(page);
  await user.attemptsTo(
    new Navigate('/products'),
    new SelectProduct('Product A'),
    new AddToCart(),
    new Checkout(),
    new EnterPaymentDetails('4111111111111111')
  );
  await expect(page.locator('.order-confirmation')).toBeVisible();
});
```

### Test Organization Patterns

**By Feature**
```
tests/
├── authentication/
│   ├── login.spec.ts
│   ├── registration.spec.ts
│   └── password-reset.spec.ts
├── checkout/
│   ├── cart.spec.ts
│   ├── payment.spec.ts
│   └── order-confirmation.spec.ts
└── profile/
    ├── view-profile.spec.ts
    └── edit-profile.spec.ts
```

**By User Journey**
```
tests/
├── guest-user-journey.spec.ts
├── authenticated-user-journey.spec.ts
├── admin-user-journey.spec.ts
└── mobile-user-journey.spec.ts
```

**Hybrid Approach (Recommended)**
```
tests/
├── journeys/
│   ├── guest-checkout.spec.ts
│   └── registered-user-purchase.spec.ts
├── features/
│   ├── authentication/
│   ├── checkout/
│   └── profile/
└── smoke/
    └── critical-paths.spec.ts
```

## Test Execution Patterns

### Execution Strategy

**Parallel Execution**
- Run tests concurrently across multiple workers/threads
- Shard tests by file or suite for distributed execution
- Balance test duration across workers

**Test Prioritization**
1. **Smoke tests** (5-10 min): Critical paths, run on every commit
2. **Regression tests** (30-60 min): Full test suite, run on PR merge
3. **Full E2E suite** (2-4 hours): Comprehensive coverage, nightly or pre-release

### Retry and Flakiness Management

**Retry Strategies**
- Retry failed tests automatically (max 2-3 retries)
- Separate flaky tests into a "quarantine" suite
- Monitor retry rates to identify unstable tests

**Reducing Flakiness**
- Use explicit waits instead of hardcoded sleeps
- Implement proper test isolation (no shared state)
- Mock flaky external services
- Use stable selectors (data-testid attributes)

### CI/CD Integration

**Pipeline Stages**
1. **Build**: Compile application, install dependencies
2. **Unit Tests**: Fast feedback (1-5 min)
3. **E2E Smoke Tests**: Critical paths (5-10 min)
4. **Full E2E Suite**: Comprehensive tests (30-60 min, optional for non-critical branches)
5. **Deployment**: Deploy to staging/production if tests pass

**Failure Handling**
- Stop pipeline on smoke test failures (block merge)
- Allow merge with full E2E failures (investigate separately)
- Capture screenshots/videos on failure for debugging
- Send notifications (Slack, email) on test failures

## Reporting and Monitoring Patterns

### Test Reporting

**Essential Metrics**
- Test pass rate (target: >95%)
- Test execution time (track trends)
- Flaky test rate (target: <5%)
- Code coverage from E2E tests (informational)

**Report Formats**
- HTML reports for manual review (Playwright HTML Reporter, Allure)
- JSON reports for programmatic analysis
- JUnit XML for CI/CD integration
- Screenshots and videos for failed tests

### Monitoring and Alerting

**Test Health Monitoring**
- Dashboard showing test trends over time
- Alerts for test pass rate drops below threshold
- Notifications for new flaky tests
- Weekly/monthly test reports sent to team

**Production Monitoring (Synthetic Testing)**
- Run critical E2E tests against production periodically (every 15-60 min)
- Alert on failures (potential production issues)
- Track real user metrics alongside synthetic tests

## Best Practices

1. **Write tests that mimic real user behavior** (avoid testing implementation details)
2. **Keep tests independent and isolated** (no test should depend on another)
3. **Use data-testid attributes** for stable selectors
4. **Implement proper waiting strategies** (avoid hardcoded sleeps)
5. **Mock external dependencies** when possible (payment gateways, third-party APIs)
6. **Run smoke tests on every commit**, full suite nightly or on release branches
7. **Monitor and quarantine flaky tests** (don't let them block the pipeline)
8. **Keep test code maintainable** (apply coding standards, refactor regularly)
9. **Document test coverage** and critical user journeys
10. **Review and update tests** when features change
