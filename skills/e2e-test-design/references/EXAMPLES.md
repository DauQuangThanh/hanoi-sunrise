# E2E Test Design Examples

This document provides detailed examples of E2E test plans generated for different types of applications.

## Example 1: E-commerce Web Application

**Input context:**

- `architecture.md` indicates: React frontend, Node.js API, PostgreSQL database, Stripe payment integration
- `ground-rules.md` requires: No production data in tests, PCI-DSS compliance
- `specs/` contains: User registration, product browsing, shopping cart, checkout

**Output E2E test plan includes:**

- **Test Strategy**: Playwright for UI, Supertest for API, Stripe test mode
- **User Journeys**: Guest checkout, registered user purchase, admin product management
- **Test Scenarios**: 15 P0 scenarios covering critical paths, 30 P1 scenarios for features
- **Test Data**: Fixtures for products, factory for users, Stripe test tokens
- **Execution**: Smoke tests on PR, full regression nightly, pre-release validation

### Detailed Test Scenarios (Sample)

**P0 Scenarios (Critical Paths):**

1. Guest user can browse products without authentication
2. User can register with email and password
3. Registered user can log in successfully
4. User can add product to cart
5. User can update cart quantities
6. User can remove items from cart
7. User can proceed to checkout
8. User can enter shipping address
9. User can select shipping method
10. User can enter payment information (Stripe test mode)
11. User can complete purchase and receive order confirmation
12. User can view order history
13. Admin can add new products
14. Admin can update product inventory
15. Admin can view all orders

**P1 Scenarios (Additional Features):**

1. User can search products by keyword
2. User can filter products by category
3. User can sort products by price
4. User can view product details
5. User can read and write product reviews
6. User can save items to wishlist
7. User can apply discount codes
8. User can track order shipment
9. User can request refunds
10. User can update profile information
... (and 20 more scenarios)

---

## Example 2: Mobile Banking App

**Input context:**

- `architecture.md` indicates: React Native mobile app, Java Spring Boot backend, Oracle database
- `ground-rules.md` requires: HIPAA compliance, biometric authentication required
- `specs/` contains: Account overview, fund transfer, bill payment, mobile deposit

**Output E2E test plan includes:**

- **Test Strategy**: Detox for mobile UI, REST Assured for API, secure test data handling
- **User Journeys**: Login with biometrics, transfer funds, pay bills, deposit check
- **Test Scenarios**: 20 P0 scenarios for core banking, 25 P1 for additional features
- **Test Data**: Synthetic account data, no real customer data, secure credential management
- **Execution**: Nightly on iOS and Android simulators, manual testing for biometrics

### Detailed Test Scenarios (Sample)

**P0 Scenarios (Critical Banking Operations):**

1. User can launch app and see login screen
2. User can authenticate with biometrics (Face ID/Touch ID)
3. User can view account balances on dashboard
4. User can view transaction history
5. User can initiate fund transfer between own accounts
6. User can transfer funds to external account
7. User can verify transfer with security code
8. User can view transfer confirmation
9. User can set up bill payment payee
10. User can pay bill to existing payee
11. User can schedule recurring bill payment
12. User can capture check image for mobile deposit
13. User can submit check for deposit
14. User can view pending deposits
15. User can receive push notifications for transactions
16. User can contact customer support from app
17. User can view account statements
18. User can locate nearby ATMs/branches
19. User can lock/unlock debit card
20. User can log out securely

**P1 Scenarios (Additional Banking Features):**

1. User can set up spending alerts
2. User can categorize transactions
3. User can export transaction data
4. User can set savings goals
5. User can view credit score
... (and 20 more scenarios)

### Security-Specific Test Cases

Due to HIPAA compliance requirements, the test plan includes:

- Data encryption verification tests
- Secure session management tests
- Biometric authentication failure handling
- Account lockout after failed attempts
- Secure data transmission validation
- Privacy policy compliance checks

---

## Example 3: SaaS Project Management Tool

**Input context:**

- `architecture.md` indicates: Angular frontend, .NET Core API, MongoDB database, Azure hosting
- `ground-rules.md` requires: Multi-tenant architecture, GDPR compliance
- `specs/` contains: Project creation, task management, team collaboration, reporting

**Output E2E test plan includes:**

- **Test Strategy**: Protractor/Playwright for Angular UI, xUnit for API tests, tenant isolation validation
- **User Journeys**: Create project, manage tasks, collaborate with team, generate reports
- **Test Scenarios**: 18 P0 scenarios for core PM features, 35 P1 scenarios for collaboration
- **Test Data**: Multi-tenant test data with proper isolation, GDPR-compliant user data handling
- **Execution**: Tenant isolation tests on every commit, full regression twice daily

---

## Common Patterns Across Examples

### Test Strategy Selection

- **Web apps**: Playwright/Cypress for UI, Supertest/REST Assured for APIs
- **Mobile apps**: Detox/Appium for UI, device-specific testing
- **Desktop apps**: Electron testing frameworks, cross-platform validation

### Test Data Management

- **Production-like data**: Synthetic data that mirrors production patterns
- **Privacy compliance**: Anonymized data, no real PII
- **Data factories**: Programmatic generation of test data
- **Fixtures**: Static data files for consistent test scenarios

### Execution Patterns

- **Smoke tests**: 5-10 critical scenarios on every PR
- **Regression tests**: Full suite nightly or twice daily
- **Pre-release**: Complete validation before production deployment
- **Platform-specific**: Separate runs for iOS/Android, browsers, etc.

### Integration Points Testing

Always test:

- Frontend ↔ Backend API communication
- Backend ↔ Database operations
- Backend ↔ External services (payment, email, SMS)
- Authentication and authorization flows
- Data synchronization between components

---

## Reference

For the complete template structure and detailed section guidance, see:

- [`templates/e2e-test-plan.md`](../templates/e2e-test-plan.md) - Complete template
- [`SKILL.md`](../SKILL.md) - Main skill instructions
