---
name: e2e-test-design
description: Generates comprehensive end-to-end test plans and specifications covering test strategy, user journeys, test scenarios, test data management, test environments, test automation framework selection, and execution plans. Use when designing E2E tests, creating test specifications, planning test automation, or when user mentions end-to-end testing, E2E test plan, test scenarios, test automation, integration testing, or system testing.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
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
- At least one feature specification in `specs/*/spec.md` - For user journey extraction (required)
- Design documents in `docs/design.md` or `specs/*/design.md` - For implementation details (required)

**Optional Files:**

- `docs/standards.md` - Coding standards (for test code standards)
- Existing `docs/e2e-test-plan.md` - For updates

**Important**: This skill MUST NOT proceed without specifications and design documents. E2E tests require understanding of user journeys, workflows, and implementation details that come from specs and design.

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
- Count of feature specifications in `specs/` (at least 1 required)
- Presence of design documents in `docs/design.md` or `specs/*/design.md` (required)
- Existing `docs/e2e-test-plan.md` (for updates)

## Instructions

### Setup Phase

1. **Run prerequisite script** to detect required files:
   - Execute the appropriate script for your platform
   - Parse JSON output to get file paths
   - **STOP AND ASK USER** if any of these are missing:
     - `docs/architecture.md` (required)
     - `docs/ground-rules.md` (required)
     - At least one specification file in `specs/*/spec.md` (required)
     - Design documents in `docs/design.md` or `specs/*/design.md` (required)
   - If required files are missing, inform user: "E2E test design requires specifications and design documents. Please create them first using the requirements-specification and technical-design skills."
   - DO NOT PROCEED without these files

2. **Read context files** in order:
   - **MUST READ**: `docs/architecture.md` for system components and integration points
   - **MUST READ**: `docs/ground-rules.md` for testing constraints
   - **MUST READ**: All feature specs from `specs/*/spec.md` for user journey extraction
   - **MUST READ**: Design documents (`docs/design.md` or `specs/*/design.md`) for implementation details
   - **MUST READ IF EXISTS**: `docs/standards.md` for test code standards
   - **READ IF EXISTS**: Existing `docs/e2e-test-plan.md` for updates

3. **Create docs/ directory** if it doesn't exist:

   ```bash
   mkdir -p docs
   ```

4. **Prepare E2E test plan template** location: `docs/e2e-test-plan.md`

### Phase 0: Test Strategy & Scope Definition

**Goal**: Analyze architecture and define E2E test strategy and scope.

1. **Analyze architecture and features** - Parse `architecture.md` for system components, integration points, external dependencies, technology stack, and data flow. Review specs for user personas, critical workflows, feature dependencies. Check `ground-rules.md` for testing constraints and compliance requirements.

2. **Define E2E test scope**:
   - **IN SCOPE**: Critical business workflows, integration points, cross-component data flows, security/authorization flows, data integrity
   - **OUT OF SCOPE**: Unit-level logic, component functionality, performance/load testing (separate suites)
   - **Testing Boundaries**: UI-to-database validation, API-to-external-service integration, end-user-visible functionality

3. **Select test approach** based on system type: Web (Cypress/Playwright), API (REST Assured/Supertest), Mobile (Appium/Detox), or Mixed (combined)

4. **Determine test coverage goals**: Critical paths 100% (P0), Important features 80-90% (P1), Secondary 50-70% (P2), Edge cases best effort (P3)

**For detailed test strategy patterns, see:** [`references/test-strategy-patterns.md`](references/test-strategy-patterns.md)

**Output**: Section 1 (Introduction), Section 2 (Test Strategy), Section 3 (Scope)

### Phase 1: User Journey & Scenario Identification

**Prerequisites:** Phase 0 complete

**Goal**: Extract user journeys from features and design detailed test scenarios.

1. **Extract user journeys from feature specs** - Identify user personas, map happy path workflows, identify alternative paths, document edge cases, and cross-feature user flows from spec files

2. **Prioritize test scenarios** by business impact: Critical/P0 (authentication, payments, core workflows), High/P1 (major features), Medium/P2 (secondary features), Low/P3 (edge cases)

3. **Design detailed test scenarios** with structure: Priority, Type, User Journey, Preconditions, Test Steps, Expected Results, Postconditions. Include coverage for positive, negative, boundary conditions, integration points, and state transitions.

**For comprehensive test scenario examples and patterns, see:** [`references/test-scenario-examples.md`](references/test-scenario-examples.md)

**Output**: Section 4 (User Journeys), Section 5 (Test Scenarios)

### Phase 2: Test Data & Environment Strategy

**Prerequisites:** Phase 1 complete

**Goal**: Design test data management and environment configuration strategies.
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
1. **Design test data management** - Identify required test data types (user accounts, business entities, reference data), define generation approach (static fixtures, factory functions, mocked APIs, seeded databases), plan data cleanup and isolation (per-test isolation, setup/teardown, database transactions), manage sensitive data (environment variables, data masking, test-specific credentials)

2. **Define test environments** - Configure environments (Local/Docker, CI/CD/ephemeral, Staging/production-like, Pre-production), define infrastructure requirements (database, cache, message queue, storage, monitoring), establish service mocking strategy (HTTP mocking, service virtualization, contract testing), design database seeding and reset procedures

3. **Design test isolation strategy** - Parallel execution, data isolation, state management, automatic cleanup

**For comprehensive test data and environment patterns, see:** [`references/test-strategy-patterns.md`](references/test-strategy-patterns.md) (sections: Test Data Management Strategies, Test Environment Requirements)

**Output**: Section 6 (Test Data Management), Section 7 (Test Environments)

### Phase 3: Test Automation Framework & Tools

**Prerequisites:** Phase 2 complete

**Goal**: Select testing framework, design test architecture, and define coding standards.

1. **Select testing framework and tools** based on tech stack:
   - UI Testing: Cypress (web apps, modern stack), Playwright (cross-browser, parallel), Selenium WebDriver (legacy, language flexibility)
   - API Testing: Supertest (Node.js), REST Assured (Java), Postman/Newman (collection-based)
   - Mobile Testing: Appium (cross-platform), Detox (React Native), XCUITest/Espresso (native)
   - Visual Testing: Percy, Applitools, BackstopJS
   - Performance: k6, JMeter, Gatling

2. **Design test architecture** - Use Page Object Model (POM), organize by pages/fixtures/helpers/scenarios, create utility functions (database, API, assertions, waits), implement custom assertions, set up reporting/logging (HTML, JSON, JUnit XML, screenshots, videos), configure CI/CD integration (PR runs, parallel execution, artifacts, notifications)

3. **Define coding standards for tests** - Naming conventions (descriptive test names, file naming patterns), test structure (AAA pattern: Arrange-Act-Assert), code reusability patterns (page objects, helper functions, fixtures, test hooks), documentation requirements (comments, data requirements, README)

**For framework patterns, architecture examples, and implementation details, see:** [`references/test-strategy-patterns.md`](references/test-strategy-patterns.md) (sections: Test Automation Framework Patterns, Test Organization Patterns)

**Output**: Section 8 (Test Framework), Section 9 (Test Architecture)

### Phase 4: Execution Plan & Reporting

**Prerequisites:** Phase 3 complete

**Goal**: Create test execution plan, reporting strategy, and maintenance guidelines.
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

1. **Create test execution plan** - Define execution schedule (nightly builds, pre-release, on-demand), establish triggers (CI/CD pipeline: PR/merge/release, Scheduled: nightly/weekly, Manual: developer/QA), organize test suites (Smoke 5-10min, Regression 30-60min, Full 1-2hr, Feature-specific), set execution sequence (authentication first, parallel for independent, sequential for dependent)

2. **Design reporting strategy** - Configure test result reporting (HTML with screenshots, JSON for CI, JUnit XML for CI/CD tools), set up dashboards and visualization (Allure Report, ReportPortal, Grafana), define metrics tracking (pass rate >95%, execution time trends, flaky test rate <5%), establish notifications and alerts (Slack/email on failures, test health monitoring)

3. **Plan maintenance and updates** - Set maintenance schedule (weekly: fix flaky tests, monthly: update data/remove obsolete, quarterly: refactor architecture/update deps), implement flaky test identification and tracking, define refactoring guidelines (DRY, extract helpers, update page objects), establish update process for new features

**For execution patterns, reporting, and monitoring strategies, see:** [`references/test-strategy-patterns.md`](references/test-strategy-patterns.md) (sections: Test Execution Patterns, Reporting and Monitoring Patterns)

**Output**: Section 10 (Execution Plan), Section 11 (Reporting), Section 12 (Maintenance)

### Phase 5: Finalization & Supplementary Documents

**Prerequisites:** Phase 4 complete

**Goal**: Create detailed test scenarios, generate supplementary documents, and validate completeness.

1. **Document test scenarios in detail** - Expand each scenario with step-by-step instructions, expected results at each step, Mermaid diagrams for complex flows, test data samples, prerequisite setup steps

2. **Generate supplementary documents** (optional but recommended) - `docs/e2e-test-scenarios.md` (scenario catalog), `docs/test-data-guide.md` (data management guide), `docs/e2e-test-setup.md` (environment setup), `tests/e2e/README.md` (developer quick start)

3. **Validate E2E test plan** - Verify critical user journeys have scenarios, test scenarios cover all integration points, data strategy addresses privacy/security, framework selection is justified, environment requirements specified, execution plan includes CI/CD, reporting is comprehensive, ground-rules constraints respected, architecture/standards alignment checked

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
