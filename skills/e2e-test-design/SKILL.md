---
name: e2e-test-design
description: Generates comprehensive end-to-end test plans and specifications covering test strategy, user journeys, test scenarios, test data management, test environments, test automation framework selection, and execution plans. Use when designing E2E tests, creating test specifications, planning test automation, or when user mentions end-to-end testing, E2E test plan, test scenarios, test automation, integration testing, or system testing.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
---

# E2E Test Design Skill

## Overview

This skill generates comprehensive end-to-end (E2E) test plans and specifications for an entire product. It creates a test document (`docs/e2e-test-plan.md`) that covers test strategy, scope, user journeys, test scenarios, test data management, test environment requirements, test automation framework selection, test architecture, execution plan, and reporting strategy.

The skill analyzes architecture and feature specifications to identify critical integration points and user workflows that require E2E testing coverage.

## When to Use

Activate this skill when:

- Creating comprehensive E2E test plans for the product
- Designing test automation strategy and framework
- Identifying critical user journeys and test scenarios
- Planning test data management and environment setup
- Defining test execution and reporting strategies
- User mentions: "E2E tests", "end-to-end testing", "test plan", "test scenarios", "test automation", "integration testing", "system testing", "acceptance testing"

**Timing**: Run this AFTER architecture is defined, preferably after feature specifications are complete.

## Prerequisites

**Required Files:**

- `docs/architecture.md` - System architecture and components (required)
- `docs/ground-rules.md` - Project principles and constraints (required)
- Feature specifications in `specs/*/spec.md` - For user journey extraction (highly recommended)

**Optional Files:**

- `docs/standards.md` - Coding standards (for test code standards)
- Existing `docs/e2e-test-plan.md` - For updates

**Validation:**

Use the prerequisite checking scripts to verify required files exist:

**Bash (macOS/Linux):**

```bash
scripts/check-e2e-prerequisites.sh
```

**PowerShell (Windows):**

```powershell
.\scripts\check-e2e-prerequisites.ps1
```

**JSON Output (for parsing):**

```bash
scripts/check-e2e-prerequisites.sh --json
.\scripts\check-e2e-prerequisites.ps1 -Json
```

**What the scripts check:**

- Presence of `docs/architecture.md` (required)
- Presence of `docs/ground-rules.md` (required)
- Presence of `docs/standards.md` (optional)
- Count of feature specifications in `specs/`
- Existing `docs/e2e-test-plan.md` (for updates)

## Instructions

### Setup Phase

1. **Run prerequisite script** to detect required files:
   - Execute the appropriate script for your platform
   - Parse JSON output to get file paths
   - Verify `architecture.md` and `ground-rules.md` exist (required)
   - Note count of feature specifications (needed for user journey extraction)

2. **Read context files** in order:
   - **MUST READ**: `docs/architecture.md` for system components and integration points
   - **MUST READ**: `docs/ground-rules.md` for testing constraints
   - **MUST READ IF EXISTS**: `docs/standards.md` for test code standards
   - **READ ALL**: Feature specs from `specs/*/spec.md` for user journey extraction
   - **READ IF EXISTS**: Existing `docs/e2e-test-plan.md` for updates

3. **Create docs/ directory** if it doesn't exist:

   ```bash
   mkdir -p docs
   ```

4. **Prepare E2E test plan template** location: `docs/e2e-test-plan.md`

### Phase 0: Test Strategy & Scope Definition

**Goal**: Analyze architecture and define E2E test strategy and scope.

1. **Analyze architecture and features**:
   - Parse `architecture.md` to understand:
     - System components (frontend, backend, database, external services)
     - Integration points between components
     - External dependencies (APIs, third-party services)
     - Technology stack (web, mobile, desktop)
     - Data flow and communication patterns

   - Parse all `specs/*/spec.md` files to identify:
     - User personas and roles
     - Critical business workflows
     - Feature dependencies and interactions
     - Data requirements

   - Review `ground-rules.md` for:
     - Testing constraints (no production data, specific tools required)
     - Security and privacy requirements
     - Compliance requirements (HIPAA, GDPR, PCI-DSS)

2. **Define E2E test scope**:
   - **IN SCOPE**: What will be tested E2E
     - Critical business workflows (authentication, payment, core features)
     - Integration points (UI ↔ API ↔ Database ↔ External Services)
     - Cross-component data flows
     - Security and authorization flows
     - Data integrity across system

   - **OUT OF SCOPE**: What won't be tested E2E
     - Unit-level logic (covered by unit tests)
     - Component-level functionality (covered by integration tests)
     - Performance testing (separate performance test suite)
     - Load/stress testing (separate suite)

   - **Testing Boundaries**: Define test coverage extent
     - UI-to-database validation
     - API-to-external-service integration
     - End-user-visible functionality only
     - System behavior under normal conditions

3. **Select test approach** based on system type:
   - **Web Applications**: UI-driven E2E tests
     - Tools: Cypress, Playwright, Selenium WebDriver
     - Covers: Browser interactions, UI state, visual validation

   - **API Services**: API-driven E2E tests
     - Tools: REST Assured, Supertest, Postman/Newman
     - Covers: API contracts, data validation, integration flows

   - **Mobile Applications**: Mobile E2E tests
     - Tools: Appium, Detox, Maestro
     - Covers: Mobile UI, gestures, native features

   - **Mixed Systems**: Combined approach
     - UI tests + API tests + Database validation
     - Multiple tool integration

4. **Determine test coverage goals**:
   - Critical paths: 100% coverage (P0 scenarios)
   - Important features: 80-90% coverage (P1 scenarios)
   - Secondary features: 50-70% coverage (P2 scenarios)
   - Edge cases: Best effort (P3 scenarios)

**Output**:

- Section 1 (Introduction) with project context
- Section 2 (Test Strategy) with approach justification
- Section 3 (Scope) with clear boundaries

### Phase 1: User Journey & Scenario Identification

**Prerequisites:** Phase 0 complete

**Goal**: Extract user journeys from features and design detailed test scenarios.

1. **Extract user journeys from feature specs**:
   - **Identify user personas**: Parse all specs for persona definitions
     - Examples: Admin, Customer, Guest, Manager, API Consumer

   - **Map happy path workflows** for each persona:
     - Start-to-finish business processes
     - Example: "Customer registers → browses products → adds to cart → checks out → receives confirmation"

   - **Identify alternative paths**:
     - Conditional flows (if logged in vs guest)
     - Different permission levels
     - Various data scenarios

   - **Document edge cases**:
     - Error conditions (invalid input, network failures)
     - Boundary conditions (empty cart, max items)
     - Unusual but valid paths

   - **Cross-feature user flows**:
     - Workflows spanning multiple features
     - Example: "User profile update → triggers email → updates dashboard → reflects in reports"

2. **Prioritize test scenarios** by business impact:
   - **Critical (P0)**: Must work for system to be viable
     - Authentication and authorization
     - Payment and transaction processing
     - Core business workflows
     - Data integrity operations
     - Security-critical paths

   - **High (P1)**: Important but not immediately critical
     - Major features with high usage
     - Data modification operations
     - Report generation
     - User management

   - **Medium (P2)**: Secondary features
     - Nice-to-have features
     - Less frequently used paths
     - Cosmetic features with data impact

   - **Low (P3)**: Edge cases and rare scenarios
     - Unusual edge cases
     - Deprecated features
     - Admin-only rarely-used features

3. **Design detailed test scenarios**:

   For each user journey, create test scenario with:

   **Scenario Structure:**

   ```markdown
   ### Test Scenario: [Descriptive Name]
   
   **Priority:** P0/P1/P2/P3
   **Type:** Happy Path / Alternative Path / Error Path / Boundary
   **User Journey:** [Related journey]
   
   **Preconditions:**
   - User is logged in as [role]
   - Database contains [test data]
   - System is in [state]
   
   **Test Steps:**
   1. Navigate to [page/endpoint]
   2. Enter [data] in [field]
   3. Click [button]
   4. Verify [expected behavior]
   5. ...
   
   **Expected Results:**
   - [Expected outcome 1]
   - [Expected outcome 2]
   - UI displays [expected state]
   - Database contains [expected data]
   - API returns [expected response]
   
   **Postconditions:**
   - User is redirected to [page]
   - Data is saved in database
   - Email is sent to user
   ```

   **Coverage Checklist:**
   - ✅ Positive scenarios (valid input, expected behavior)
   - ✅ Negative scenarios (invalid input, error handling)
   - ✅ Boundary conditions (min/max values, empty/full)
   - ✅ Integration points (UI → API → Database → External)
   - ✅ State transitions (before/after operation)

**Output**:

- Section 4 (User Journeys) with persona-based workflows
- Section 5 (Test Scenarios) with detailed scenario specifications

### Phase 2: Test Data & Environment Strategy

**Prerequisites:** Phase 1 complete

**Goal**: Design test data management and environment configuration strategies.

1. **Design test data management**:

   **Identify required test data types**:
   - User accounts (various roles and permissions)
   - Business entities (products, orders, customers)
   - Reference data (categories, settings, configurations)
   - Transaction data (orders, payments, logs)
   - File uploads (documents, images, videos)

   **Define test data generation approach**:
   - **Fixtures**: Static JSON/YAML files for predictable data

     ```javascript
     // fixtures/users.json
     {
       "adminUser": {
         "email": "admin@test.com",
         "password": "Test123!",
         "role": "admin"
       }
     }
     ```

   - **Factories**: Dynamic data generation with libraries

     ```javascript
     // Factory pattern
     const user = UserFactory.create({
       role: 'customer',
       verified: true
     })
     ```

   - **Database Seeding**: SQL scripts or ORM seeders

     ```sql
     INSERT INTO users (email, role, created_at)
     VALUES ('test@example.com', 'customer', NOW());
     ```

   - **API-based Generation**: Create data through API calls

     ```javascript
     await api.post('/users', userData)
     ```

   **Plan data cleanup and isolation**:
   - **Test Isolation Strategies**:
     - Separate test database per test run
     - Database transactions (rollback after each test)
     - Unique identifiers per test (UUIDs, timestamps)
     - Cleanup scripts (delete test data after run)

   - **Parallel Execution Support**:
     - Non-overlapping test data ranges
     - Namespace/prefix per test suite
     - Isolated database schemas

   **Document sensitive data handling**:
   - PII (Personally Identifiable Information): Use fake data generators
   - Passwords: Never hardcode, use environment variables
   - API keys: Store in secrets management, not in code
   - Payment data: Use test mode tokens, never real cards
   - Compliance: Follow GDPR, HIPAA, PCI-DSS requirements

2. **Define test environments**:

   **Environment configurations**:
   - **Local Environment**: Developer machines
     - Docker Compose setup for local services
     - Mock external dependencies
     - Fast feedback loop

   - **CI/CD Environment**: Automated test runs
     - Ephemeral environments per pipeline run
     - Parallelized test execution
     - Artifact storage for test results

   - **Staging/QA Environment**: Pre-production testing
     - Production-like configuration
     - Real external service connections (test mode)
     - Stable for manual testing

   - **Pre-production Environment**: Final validation
     - Identical to production
     - Limited access
     - Production-scale data (sanitized)

   **Infrastructure requirements**:
   - Database: PostgreSQL 15, MongoDB 6, etc.
   - Cache: Redis, Memcached
   - Message Queue: RabbitMQ, Kafka
   - Storage: S3-compatible object storage
   - Monitoring: Logs, metrics, traces

   **Service mocking/stubbing strategy**:
   - **When to mock**:
     - Expensive external APIs (payment gateways)
     - Unreliable third-party services
     - Services not available in test environment

   - **Mocking approaches**:
     - HTTP mocking (MSW, WireMock, Nock)
     - Service virtualization (Hoverfly, Mountebank)
     - Contract testing (Pact) for API contracts

   **Database seeding and reset procedures**:

   ```bash
   # Seed database before test run
   npm run db:seed:test
   
   # Reset database after test run
   npm run db:reset:test
   ```

3. **Design test isolation strategy**:
   - **Parallel execution**: Tests run concurrently without conflicts
   - **Data isolation**: Each test has unique data, no shared state
   - **State management**: Tests are independent, can run in any order
   - **Cleanup**: Automatic rollback or deletion after test completion

**Output**:

- Section 6 (Test Data Management) with generation and cleanup strategies
- Section 7 (Test Environments) with configuration and infrastructure requirements

### Phase 3: Test Automation Framework & Tools

**Prerequisites:** Phase 2 complete

**Goal**: Select testing framework, design test architecture, and define coding standards.

1. **Select testing framework and tools** based on tech stack:

   **UI Testing Frameworks:**
   - **Cypress**: Modern, developer-friendly, fast feedback
     - Pros: Excellent DX, automatic waiting, time-travel debugging
     - Cons: Chrome/Edge only (now Webkit too), no mobile
     - Use when: Web apps, fast iteration, modern stack

   - **Playwright**: Multi-browser, parallel, powerful
     - Pros: All browsers, mobile web, parallel by default, auto-wait
     - Cons: Steeper learning curve
     - Use when: Cross-browser testing, headless CI, mobile web

   - **Selenium WebDriver**: Industry standard, mature
     - Pros: All browsers, mobile (Appium), language flexibility
     - Cons: Manual waits, flaky tests, slower
     - Use when: Legacy systems, specific language requirement

   **API Testing Frameworks:**
   - **Supertest** (Node.js): Express/Node.js API testing
   - **REST Assured** (Java): Java/Spring Boot API testing
   - **Postman/Newman**: Collection-based API testing
   - **Playwright** (API mode): API testing with Playwright

   **Mobile Testing Frameworks:**
   - **Appium**: Cross-platform mobile (iOS + Android)
   - **Detox**: React Native E2E testing
   - **Maestro**: Simple mobile testing with YAML
   - **XCUITest / Espresso**: Native iOS / Android testing

   **Visual Testing:**
   - **Percy**: Visual regression testing
   - **Applitools**: AI-powered visual testing
   - **BackstopJS**: Screenshot comparison

   **Performance Testing:**
   - **k6**: Modern load testing (JavaScript)
   - **JMeter**: Traditional load testing
   - **Gatling**: Scala-based load testing

   **Justification Example:**

   ```markdown
   **Selected Tools:**
   - UI: Playwright (multi-browser support required, parallel execution)
   - API: Supertest (Node.js stack, integrated with UI tests)
   - Mobile: Detox (React Native app)
   - Visual: Percy (CI integration, team familiarity)
   
   **Rationale:**
   - Playwright supports all browsers required by business (Chrome, Firefox, Safari)
   - Supertest allows API testing in same language as UI tests (TypeScript)
   - Detox is official React Native testing framework with good community support
   ```

2. **Design test architecture**:

   **Test Organization Pattern - Page Object Model (POM):**

   ```
   tests/e2e/
   ├── pages/                    # Page objects
   │   ├── BasePage.ts
   │   ├── LoginPage.ts
   │   ├── DashboardPage.ts
   │   └── CheckoutPage.ts
   ├── fixtures/                 # Test data
   │   ├── users.json
   │   ├── products.json
   │   └── orders.json
   ├── helpers/                  # Test utilities
   │   ├── api.ts
   │   ├── database.ts
   │   └── assertions.ts
   ├── scenarios/                # Test scenarios
   │   ├── authentication/
   │   │   ├── login.spec.ts
   │   │   └── logout.spec.ts
   │   ├── checkout/
   │   │   └── complete-order.spec.ts
   │   └── admin/
   │       └── user-management.spec.ts
   └── playwright.config.ts
   ```

   **Test Utility Functions:**
   - Database helpers (seed, reset, query)
   - API helpers (authenticate, CRUD operations)
   - Assertion helpers (custom matchers)
   - Wait helpers (waitForElement, waitForAPI)

   **Custom Assertions:**

   ```typescript
   // helpers/assertions.ts
   export async function expectDatabaseToContain(table, data) {
     const result = await db.query(`SELECT * FROM ${table} WHERE ...`)
     expect(result).toContainEqual(expect.objectContaining(data))
   }
   ```

   **Reporting and Logging:**
   - Test reporters: HTML, JSON, JUnit XML
   - Screenshot on failure
   - Video recording for debugging
   - Detailed logs with timestamps
   - Test execution metrics (duration, pass/fail rate)

   **CI/CD Integration:**
   - Run tests on PR creation
   - Parallel execution across multiple machines
   - Artifact upload (screenshots, videos, reports)
   - Failure notifications (Slack, email)

3. **Define coding standards for tests**:

   **Test Naming Conventions:**
   - Descriptive test names: `should allow user to complete checkout successfully`
   - File naming: `{feature}.spec.ts` or `{feature}.test.ts`
   - Page object naming: `{PageName}Page.ts`

   **Test Structure (AAA Pattern):**

   ```typescript
   test('should display error for invalid email', async ({ page }) => {
     // Arrange - Set up test data and initial state
     await page.goto('/login')
     const invalidEmail = 'not-an-email'
     
     // Act - Perform the action being tested
     await page.fill('#email', invalidEmail)
     await page.click('#submit')
     
     // Assert - Verify expected behavior
     await expect(page.locator('.error')).toContainText('Invalid email')
   })
   ```

   **Code Reusability Patterns:**
   - Extract common actions into page objects
   - Create helper functions for repeated operations
   - Use fixtures for test data management
   - Utilize test hooks (beforeEach, afterEach) for setup/teardown

   **Documentation Requirements:**
   - Comment complex test logic
   - Document test data requirements
   - Explain non-obvious waits or workarounds
   - Provide README for running tests locally

**Output**:

- Section 8 (Test Framework) with tool selection and justification
- Section 9 (Test Architecture) with patterns and code organization

### Phase 4: Execution Plan & Reporting

**Prerequisites:** Phase 3 complete

**Goal**: Create test execution plan, reporting strategy, and maintenance guidelines.

1. **Create test execution plan**:

   **Execution Schedule:**
   - **Nightly Builds**: Full regression suite
     - All P0, P1, P2 scenarios
     - Runs overnight, results ready by morning
     - Blocks release if critical tests fail

   - **Pre-Release**: Smoke + critical tests
     - P0 scenarios only
     - Runs before each release candidate
     - Must pass 100% to proceed

   - **On-Demand**: Developer-triggered
     - Run specific test suites
     - Quick feedback during development
     - Optional, doesn't block commits

   **Execution Triggers:**
   - **CI/CD Pipeline**:
     - PR creation: Smoke tests (P0)
     - Merge to main: Full regression (P0, P1)
     - Release branch: Full suite (P0, P1, P2)

   - **Scheduled**:
     - Nightly: Full regression
     - Weekly: Extended suite including P3

   - **Manual**:
     - Developer-triggered for debugging
     - QA-triggered for validation

   **Test Suite Organization:**
   - **Smoke Suite**: Critical paths only (5-10 min)
   - **Regression Suite**: All scenarios (30-60 min)
   - **Full Suite**: Including edge cases (1-2 hours)
   - **Feature-specific**: Tests for specific feature

   **Execution Sequence:**
   - Authentication tests first (setup for other tests)
   - Independent tests in parallel
   - Dependent tests sequentially
   - Cleanup tests last

2. **Design reporting strategy**:

   **Test Result Reporting:**
   - **HTML Report**: Human-readable, with screenshots

     ```
     test-results/
     ├── index.html               # Overview
     ├── passed/                  # Passed test details
     ├── failed/                  # Failed test details
     │   ├── screenshot-1.png
     │   ├── video-1.webm
     │   └── trace-1.zip
     └── skipped/                 # Skipped tests
     ```

   - **JSON Report**: Machine-readable for CI integration
   - **JUnit XML**: For Jenkins/Azure DevOps integration

   **Dashboard and Visualization:**
   - **Allure Report**: Comprehensive test reporting with history
   - **ReportPortal**: Centralized test automation reporting
   - **Custom Dashboard**: Grafana + InfluxDB for metrics

   **Failure Notification:**
   - Slack: Post to #qa-alerts channel on failure
   - Email: Send summary to team on regression failure
   - GitHub: Comment on PR with test results

   **Metrics Tracking:**
   - **Pass Rate**: % of tests passing
   - **Execution Time**: Total and per-test duration
   - **Flakiness Rate**: Tests that fail intermittently
   - **Coverage**: % of user journeys covered
   - **Trends**: Pass rate over time, flakiness trends

3. **Plan maintenance and updates**:

   **Test Suite Maintenance Schedule:**
   - Weekly: Review failed tests, fix flaky tests
   - Monthly: Update test data, remove obsolete tests
   - Quarterly: Refactor test architecture, update dependencies

   **Flaky Test Identification:**
   - Track tests that fail <5% of time
   - Investigate root cause (timing, race conditions, test data)
   - Fix or skip until fixed
   - Monitor flakiness metrics

   **Test Refactoring Guidelines:**
   - Keep tests DRY (Don't Repeat Yourself)
   - Extract common actions into helpers
   - Update page objects when UI changes
   - Consolidate similar test scenarios

   **Update Process for New Features:**
   1. Feature spec created → identify test scenarios
   2. Implement feature → write E2E tests
   3. Add tests to appropriate suite (smoke/regression)
   4. Update test data and fixtures
   5. Update documentation

**Output**:

- Section 10 (Execution Plan) with schedule and triggers
- Section 11 (Reporting) with dashboard and metrics strategy
- Section 12 (Maintenance) with update process

### Phase 5: Finalization & Supplementary Documents

**Prerequisites:** Phase 4 complete

**Goal**: Create detailed test scenarios, generate supplementary documents, and validate completeness.

1. **Document test scenarios in detail**:
   - Expand each test scenario with step-by-step instructions
   - Include expected results at each step
   - Add Mermaid diagrams for complex flows
   - Document test data samples
   - List prerequisite setup steps

2. **Generate supplementary documents** (optional but recommended):

   **docs/e2e-test-scenarios.md**: Catalog of all test scenarios

   ```markdown
   # E2E Test Scenario Catalog
   
   ## Authentication
   ### TC-001: User Login - Happy Path
   - Priority: P0
   - Steps: ...
   - Expected: ...
   
   ### TC-002: User Login - Invalid Credentials
   - Priority: P0
   - Steps: ...
   - Expected: ...
   ```

   **docs/test-data-guide.md**: Test data management guide

   ```markdown
   # Test Data Management Guide
   
   ## Fixtures
   Location: `tests/e2e/fixtures/`
   Usage: Load with `import users from '../fixtures/users.json'`
   
   ## Database Seeding
   Command: `npm run db:seed:test`
   ```

   **docs/e2e-test-setup.md**: Environment setup instructions

   ```markdown
   # E2E Test Setup Guide
   
   ## Prerequisites
   - Node.js 18+
   - Docker Desktop
   
   ## Setup Steps
   1. Clone repository
   2. Install dependencies: `npm install`
   3. Start services: `docker-compose up -d`
   4. Seed database: `npm run db:seed:test`
   5. Run tests: `npm run test:e2e`
   ```

   **tests/e2e/README.md**: Quick start for developers

   ```markdown
   # E2E Tests - Quick Start
   
   ## Running Tests
   ```bash
   npm run test:e2e              # Run all tests
   npm run test:e2e:ui           # Run with UI
   npm run test:e2e:smoke        # Run smoke tests only
   ```

3. **Validate E2E test plan**:
   - [ ] All critical user journeys have test scenarios
   - [ ] Test scenarios cover all integration points from architecture
   - [ ] Test data strategy addresses privacy and security
   - [ ] Test framework selection is justified
   - [ ] Test environment requirements are specified
   - [ ] Execution plan includes CI/CD integration
   - [ ] Reporting strategy is comprehensive
   - [ ] Ground-rules constraints are respected (no production data, etc.)
   - [ ] Architecture alignment is verified
   - [ ] Standards alignment is checked (if standards.md exists)

4. **Output file locations**:

   ```
   docs/
   ├── e2e-test-plan.md         # Main E2E test document
   ├── e2e-test-scenarios.md    # Optional: Detailed scenario catalog
   ├── test-data-guide.md       # Optional: Test data management
   └── e2e-test-setup.md        # Optional: Setup instructions
   
   tests/e2e/
   ├── README.md                # Quick start guide
   ├── fixtures/                # Test data
   ├── helpers/                 # Test utilities
   ├── pages/                   # Page objects (if UI testing)
   └── scenarios/               # Test implementations
   ```

**Output**: Complete `docs/e2e-test-plan.md`, supplementary documents, test directory structure

## Success Criteria

The E2E test plan is complete and ready when:

- [ ] Test strategy clearly defines scope and boundaries
- [ ] All critical user journeys are identified and prioritized
- [ ] Test scenarios cover all major integration points from architecture
- [ ] Test data management strategy addresses privacy, security, and compliance
- [ ] Test environment requirements are specified with infrastructure details
- [ ] Testing framework and tools are selected with clear justification
- [ ] Test automation architecture is designed with code organization
- [ ] Execution plan includes scheduling, triggers, and CI/CD integration
- [ ] Reporting strategy includes dashboards, notifications, and metrics
- [ ] Maintenance plan includes flaky test handling and update process
- [ ] Test scenarios are detailed enough to implement
- [ ] Ground-rules constraints are respected
- [ ] Architecture alignment is verified
- [ ] `docs/e2e-test-plan.md` is committed with "test: add E2E test plan" message

## Error Handling

**Common Errors and Solutions:**

1. **Error**: `architecture.md not found`
   - **Cause**: Required architecture file missing
   - **Action**: Create `docs/architecture.md` with system architecture first, or specify the correct path

2. **Error**: `ground-rules.md not found`
   - **Cause**: Required ground-rules file missing
   - **Action**: Create `docs/ground-rules.md` with project principles first

3. **Error**: No feature specifications found
   - **Cause**: `specs/` directory empty or doesn't exist
   - **Action**: Proceed with architecture-based test design, or create feature specifications first for better user journey extraction

4. **Error**: Test scenarios don't cover integration points
   - **Cause**: Insufficient analysis of architecture integration points
   - **Action**: Re-read architecture.md, map all component interactions, ensure test scenarios validate each integration

5. **Error**: Test framework selection conflicts with ground-rules
   - **Cause**: Selected tools violate constraints (e.g., "MUST use Python" but selected JavaScript framework)
   - **Action**: Review ground-rules.md, select tools that align with constraints

## Templates

Use the provided template for E2E test plan generation:

**Template Location**: `templates/e2e-test-plan.md`

The template includes:

- Complete document structure with all sections
- Test scenario formats and examples
- Test data strategy templates
- Execution plan templates
- Mermaid diagram examples

## Examples

For detailed examples including e-commerce applications, mobile banking apps, and SaaS tools, see [`references/EXAMPLES.md`](references/EXAMPLES.md).

## Notes

- **Product-level E2E test plan**: This skill creates plans for the ENTIRE product, not individual features
- **Run timing**: Execute AFTER architecture is defined, preferably after feature specifications
- **Focus on integration**: E2E tests should focus on integration points, not implementation details
- **User-visible behavior**: Test what users see and interact with, not internal logic
- **Maintainability**: Balance coverage with maintenance cost - prioritize critical paths
- **Living document**: Update e2e-test-plan.md as new features are added
- **Complement other testing**: E2E tests complement unit and integration tests, don't replace them
- **Flakiness management**: Plan for flaky test handling from the start
- **CI/CD integration**: E2E tests should be automated and run in CI/CD pipeline

## Additional Resources

For more detailed guidance, see:

- `templates/e2e-test-plan.md` - Complete E2E test plan template
- Agent Skills specification - For skill creation best practices
- Project ground-rules - For understanding testing constraints
- Project architecture - For system components and integration points
- Project standards - For test code standards (if exists)

## Version History

- **v1.0** (2026-01-26): Initial release
  - Complete 5-phase E2E test design workflow
  - Test strategy, user journeys, test scenarios
  - Test data management and environment strategy
  - Test framework selection and architecture design
  - Execution plan and reporting strategy
  - Supplementary document generation
