# E2E Test Plan

> Comprehensive end-to-end test plan for [Project Name]

---

## Document Information

**Version:** 1.0  
**Last Updated:** [Date]  
**Status:** Draft | Under Review | Approved  
**Author:** [Your Name]

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Test Strategy](#2-test-strategy)
3. [Scope](#3-scope)
4. [User Journeys](#4-user-journeys)
5. [Test Scenarios](#5-test-scenarios)
6. [Test Data Management](#6-test-data-management)
7. [Test Environments](#7-test-environments)
8. [Test Framework](#8-test-framework)
9. [Test Architecture](#9-test-architecture)
10. [Execution Plan](#10-execution-plan)
11. [Reporting](#11-reporting)
12. [Maintenance](#12-maintenance)
13. [Appendices](#13-appendices)

---

## 1. Introduction

### 1.1 Project Context

**Project Name:** [Name]

**Project Description:**
[Provide 2-3 sentence overview of what the system does, who uses it, and its primary purpose]

**System Overview:**
[Based on architecture.md - describe the major components]

- **Frontend:** [Technology, e.g., React, Angular, Vue.js]
- **Backend:** [Technology, e.g., Node.js, Spring Boot, Django]
- **Database:** [Database type, e.g., PostgreSQL, MongoDB, MySQL]
- **External Services:** [Third-party integrations, e.g., Stripe, SendGrid, Auth0]
- **Platform:** [Deployment platform, e.g., Web, Mobile (iOS/Android), Desktop]

**Business Context:**
[What business problem does this solve? Who are the stakeholders?]

### 1.2 Purpose of E2E Testing

This document defines the comprehensive end-to-end testing strategy for [Project Name]. The purpose of E2E testing is to:

- **Validate Integration Points**: Ensure all system components work together correctly
- **Verify User Workflows**: Confirm critical business processes function end-to-end
- **Ensure Data Integrity**: Validate data flows correctly through all system layers
- **Catch Regression Issues**: Detect defects introduced by code changes
- **Build Confidence**: Provide stakeholders with confidence in system reliability

### 1.3 Intended Audience

This document is intended for:

- QA Engineers: Implementing and executing E2E tests
- Developers: Understanding test coverage and requirements
- Product Managers: Verifying business requirements are tested
- DevOps Engineers: Setting up CI/CD test execution
- Stakeholders: Reviewing test coverage and risk assessment

### 1.4 Document Structure

This document is organized into 12 main sections covering test strategy, user journeys, test scenarios, test data management, test environments, test framework selection, test architecture, execution plan, reporting, and maintenance.

---

## 2. Test Strategy

### 2.1 Testing Approach

**Overall Strategy:**
[Describe the high-level approach to E2E testing for this system]

We will adopt a [UI-driven | API-driven | Mixed] E2E testing approach, focusing on:

- **Critical Business Workflows**: Testing end-to-end user journeys that represent core business value
- **Integration Validation**: Verifying all integration points between system components
- **Data Flow Testing**: Ensuring data integrity across UI → API → Database → External Services
- **User-Visible Behavior**: Testing from the user's perspective, not implementation details

**Justification:**
[Explain why this approach is appropriate for your system type]

Example: "We selected a UI-driven approach using Playwright because our system is a web application where most business logic is triggered through UI interactions. This allows us to test the complete user experience including visual feedback and browser behavior."

### 2.2 Test Levels Coverage

**E2E Tests in Context:**

```mermaid
graph TD
    A[Unit Tests] -->|Component Logic| B[Integration Tests]
    B -->|Component Interaction| C[E2E Tests]
    C -->|System Behavior| D[User Acceptance Tests]
    
    style A fill:#90EE90
    style B fill:#FFD700
    style C fill:#FF6347
    style D fill:#87CEEB
```

- **Unit Tests**: Individual function/method logic *(not covered here)*
- **Integration Tests**: Component interactions *(not covered here)*
- **E2E Tests**: Full system workflows from UI to database *(this document)*
- **Performance Tests**: Load, stress, scalability *(separate test suite)*

### 2.3 Test Coverage Goals

**Coverage Targets:**

| Priority | Coverage Goal | Description | Examples |
|----------|---------------|-------------|----------|
| P0 (Critical) | 100% | Must work for system viability | Authentication, Payment, Core Workflows |
| P1 (High) | 80-90% | Important but not critical | Major Features, Data Modification |
| P2 (Medium) | 50-70% | Secondary features | Nice-to-Have Features, Less Used Paths |
| P3 (Low) | Best Effort | Edge cases and rare scenarios | Unusual Edge Cases, Deprecated Features |

**Rationale:**
[Explain why these coverage goals are appropriate for your project]

### 2.4 Test Pyramid Alignment

```mermaid
graph TB
    subgraph "Test Pyramid"
        E2E[E2E Tests<br/>Few, Slow, Expensive<br/>~10-20 tests]
        INT[Integration Tests<br/>More, Faster<br/>~100-200 tests]
        UNIT[Unit Tests<br/>Many, Fast, Cheap<br/>~1000+ tests]
    end
    
    E2E --> INT
    INT --> UNIT
    
    style E2E fill:#FF6347,stroke:#333,stroke-width:2px
    style INT fill:#FFD700,stroke:#333,stroke-width:2px
    style UNIT fill:#90EE90,stroke:#333,stroke-width:2px
```

**E2E Test Philosophy:**

- Focus on critical paths, not exhaustive coverage
- Complement, don't replace, unit and integration tests
- Keep E2E test count manageable (target: 50-100 scenarios for medium projects)
- Prioritize maintainability over coverage percentage

---

## 3. Scope

### 3.1 In Scope

**What will be tested end-to-end:**

#### 3.1.1 Critical Business Workflows

[List the essential business processes that MUST work]

- [ ] User authentication and authorization
- [ ] [Core workflow 1, e.g., "Create and submit order"]
- [ ] [Core workflow 2, e.g., "Process payment and generate receipt"]
- [ ] [Core workflow 3, e.g., "Generate monthly report"]
- [ ] Data integrity across all layers

#### 3.1.2 Integration Points

[List all component integration points to validate]

- [ ] UI ↔ API: User interactions trigger correct API calls
- [ ] API ↔ Database: Data persistence and retrieval
- [ ] API ↔ External Services: Third-party integrations (payment, email, etc.)
- [ ] Frontend ↔ Authentication: Login, session management, token refresh
- [ ] [Add system-specific integration points]

#### 3.1.3 Cross-Component Data Flow

[List data flows spanning multiple components]

- [ ] User registration → Database storage → Email confirmation → Account activation
- [ ] [Workflow 1, e.g., "Order placement → Payment processing → Inventory update → Email notification"]
- [ ] [Workflow 2, e.g., "Data import → Validation → Transformation → Storage → Report generation"]
- [ ] [Add system-specific data flows]

#### 3.1.4 Security and Authorization

[List security-critical flows to test]

- [ ] Authentication workflows (login, logout, session timeout)
- [ ] Role-based access control (RBAC) enforcement
- [ ] Data access permissions validation
- [ ] Secure data transmission (HTTPS validation)
- [ ] [Add system-specific security requirements]

#### 3.1.5 User-Facing Features

[List all features users directly interact with]

- [ ] [Feature 1, e.g., "Product search and filtering"]
- [ ] [Feature 2, e.g., "Shopping cart management"]
- [ ] [Feature 3, e.g., "User profile management"]
- [ ] [Feature 4, e.g., "Report generation and export"]
- [ ] [Add all user-facing features from specs]

### 3.2 Out of Scope

**What will NOT be tested in E2E suite:**

#### 3.2.1 Unit-Level Logic

- Individual function implementations
- Internal algorithms and calculations
- Component-level validation logic
- *Covered by: Unit tests*

#### 3.2.2 Component-Level Functionality

- Individual component behavior
- Component state management
- Component rendering logic
- *Covered by: Integration tests*

#### 3.2.3 Performance Testing

- Load testing (high concurrent users)
- Stress testing (system limits)
- Scalability testing
- Response time benchmarking
- *Covered by: Separate performance test suite using k6/JMeter*

#### 3.2.4 Security Penetration Testing

- SQL injection attacks
- XSS vulnerability scanning
- CSRF attack simulation
- Penetration testing
- *Covered by: Security testing team / separate security tools*

#### 3.2.5 Browser Compatibility (if limited)

[If not doing extensive cross-browser testing]

- Legacy browser support (IE11, etc.)
- Minor browser versions
- *Focus on: Latest stable versions of Chrome, Firefox, Safari, Edge*

#### 3.2.6 Non-Functional Requirements

- Accessibility testing (WCAG compliance)
- Internationalization (i18n) / Localization (l10n)
- Mobile responsiveness (if not core feature)
- *Covered by: Separate specialized test suites*

### 3.3 Testing Boundaries

**Boundaries define how far tests will reach:**

| Boundary | Description | Example |
|----------|-------------|---------|
| **UI-to-Database** | Tests start from UI, validate data in database | User submits form → verify database record |
| **API-to-External Service** | Tests call API, verify external service interaction | API calls payment gateway → verify transaction status |
| **End-User Perspective** | Tests validate only user-visible behavior | Test that error message appears, not internal logs |
| **Normal Conditions** | Tests run under expected conditions, not chaos | Stable network, normal load, services available |

**What We Validate:**

- ✅ User inputs data in UI → API receives correct data
- ✅ API processes data → Database stores correct data
- ✅ API calls external service → External service responds correctly
- ✅ User sees correct response in UI

**What We Don't Validate in E2E:**

- ❌ Internal API implementation details
- ❌ Database query performance
- ❌ External service implementation
- ❌ Low-level network protocols

### 3.4 Constraints and Limitations

**Testing Constraints:**
[From ground-rules.md and practical considerations]

- **No Production Data**: MUST use synthetic test data only
- **Test Environment Only**: Cannot test against production systems
- **Limited External Services**: Some third-party services unavailable in test environment (will be mocked)
- **Time Constraints**: E2E suite must complete within [X minutes] for CI/CD integration
- **Resource Constraints**: [e.g., "Limited cloud resources for parallel execution"]
- **Compliance Requirements**: [e.g., "Must follow GDPR/HIPAA/PCI-DSS data handling"]

**Known Limitations:**

- [Limitation 1, e.g., "Cannot test actual email delivery, will verify email API calls only"]
- [Limitation 2, e.g., "Mobile app testing limited to simulators, not physical devices"]
- [Limitation 3, e.g., "Third-party payment processing tested in sandbox mode only"]

---

## 4. User Journeys

### 4.1 User Personas

**Identified Personas:**
[Extract from feature specifications and architecture]

#### 4.1.1 Persona: [Name, e.g., "Customer"]

- **Role:** [Description]
- **Goals:** [What they want to achieve]
- **System Access:** [What parts of system they use]
- **Permissions:** [What they can do]

**Example Persona:**

#### Persona: Registered Customer

- **Role:** End user who purchases products
- **Goals:** Browse products, make purchases, track orders
- **System Access:** Public website, customer dashboard
- **Permissions:** View products, create orders, view own orders only

#### 4.1.2 Persona: [Admin/Manager]

[Repeat structure for each persona]

### 4.2 Happy Path User Journeys

**Critical Happy Paths:**
[These represent the ideal, successful user workflows]

#### 4.2.1 Journey: [Name, e.g., "Customer Purchase Flow"]

**Persona:** [Who performs this journey]

**Goal:** [What the user wants to accomplish]

**Journey Map:**

```mermaid
sequenceDiagram
    actor User
    participant UI as Web UI
    participant API as Backend API
    participant DB as Database
    participant Ext as External Service
    
    User->>UI: Browse products
    UI->>API: GET /api/products
    API->>DB: Query products
    DB-->>API: Product list
    API-->>UI: JSON response
    UI-->>User: Display products
    
    User->>UI: Add to cart
    UI->>API: POST /api/cart
    API->>DB: Save cart item
    DB-->>API: Success
    API-->>UI: Cart updated
    
    User->>UI: Checkout
    UI->>API: POST /api/orders
    API->>Ext: Process payment
    Ext-->>API: Payment success
    API->>DB: Save order
    DB-->>API: Order created
    API-->>UI: Order confirmation
    UI-->>User: Thank you page
```

**Steps:**

1. User navigates to homepage
2. User browses product catalog
3. User adds items to shopping cart
4. User proceeds to checkout
5. User enters shipping information
6. User enters payment information
7. User confirms order
8. System processes payment
9. System creates order in database
10. System sends confirmation email
11. User sees order confirmation page

**Success Criteria:**

- ✅ User can complete purchase without errors
- ✅ Payment is processed successfully
- ✅ Order is saved in database
- ✅ Confirmation email is sent
- ✅ User sees order confirmation

#### 4.2.2 Journey: [Second Journey]

[Repeat structure for each critical journey]

### 4.3 Alternative Path User Journeys

**Alternative Paths:**
[Variations of happy paths, conditional flows]

#### 4.3.1 Journey: [Name, e.g., "Guest Checkout (No Account)"]

**Persona:** Guest User (not logged in)

**Goal:** Purchase product without creating account

**Journey Variation:**
[Describe how this differs from happy path]

This journey follows the same flow as "Customer Purchase Flow" but:

- User is NOT logged in
- System prompts for guest checkout
- User provides email for order confirmation
- No account is created

**Steps:**

1. User navigates to product page
2. User adds item to cart
3. User proceeds to checkout
4. System offers "Guest Checkout" option
5. User selects guest checkout
6. User enters email, shipping, and payment info
7. [Continue with payment and order creation...]

**Success Criteria:**

- ✅ Guest can complete purchase without account
- ✅ Order confirmation sent to provided email
- ✅ User can access order status via email link

#### 4.3.2 Journey: [Third Journey]

[Add more alternative paths as needed]

### 4.4 Error Path User Journeys

**Error Handling Flows:**
[How system handles errors and user recovers]

#### 4.4.1 Journey: [Name, e.g., "Payment Failure Recovery"]

**Persona:** Customer

**Trigger:** Payment processing fails (declined card, insufficient funds, etc.)

**Error Flow:**

```mermaid
graph TD
    A[User submits order] --> B{Payment Gateway}
    B -->|Success| C[Order Created]
    B -->|Failure| D[Payment Error]
    D --> E[Display Error Message]
    E --> F[User Updates Payment]
    F --> B
    
    style D fill:#FF6347
    style C fill:#90EE90
```

**Steps:**

1. User completes checkout form
2. User submits order
3. System attempts payment processing
4. Payment gateway returns error (declined card)
5. System displays user-friendly error message
6. User remains on checkout page (cart preserved)
7. User updates payment information
8. User retries submission
9. Payment succeeds
10. Order is created

**Success Criteria:**

- ✅ System displays clear error message
- ✅ Cart contents are preserved
- ✅ User can retry without re-entering all information
- ✅ Successful retry creates order

#### 4.4.2 Journey: [Second Error Flow]

[Add more error scenarios as needed]

### 4.5 Edge Case User Journeys

**Boundary Conditions and Unusual Paths:**
[Rare but valid scenarios]

#### 4.5.1 Journey: [Name, e.g., "Empty Cart Checkout Attempt"]

**Persona:** Customer

**Scenario:** User attempts to checkout with empty cart

**Expected Behavior:**

- System detects empty cart
- System displays message: "Your cart is empty"
- System disables checkout button
- User is redirected to product catalog

#### 4.5.2 Journey: [Second Edge Case]

[Add more edge cases as needed]

### 4.6 Cross-Feature User Journeys

**Workflows Spanning Multiple Features:**
[Journeys that involve multiple system features]

#### 4.6.1 Journey: [Name, e.g., "Profile Update Reflected in Order History"]

**Persona:** Registered Customer

**Goal:** Update profile information and see it reflected in order history

**Cross-Feature Flow:**

1. User logs in
2. User navigates to profile settings
3. User updates shipping address
4. User saves changes (triggers database update)
5. User navigates to order history
6. User views past orders
7. System displays updated shipping address in order history

**Features Involved:**

- User authentication
- Profile management
- Order history
- Database consistency

**Success Criteria:**

- ✅ Profile update saves correctly
- ✅ Updated information appears in order history
- ✅ Data is consistent across features

#### 4.6.2 Journey: [Second Cross-Feature Flow]

[Add more cross-feature journeys as needed]

---

## 5. Test Scenarios

### 5.1 Test Scenario Prioritization

**Priority Levels:**

| Priority | Description | Coverage | Example |
|----------|-------------|----------|---------|
| **P0** | Critical - System unusable if fails | 100% | Authentication, Payment, Core Workflows |
| **P1** | High - Major feature broken | 80-90% | Data Modification, Report Generation |
| **P2** | Medium - Secondary feature impacted | 50-70% | Less-Used Features, UI Enhancements |
| **P3** | Low - Edge case or minor issue | Best Effort | Rare Edge Cases, Deprecated Features |

### 5.2 Critical Scenarios (P0)

#### 5.2.1 Authentication & Authorization

##### Test Scenario: TC-001 - User Login (Happy Path)

**Priority:** P0  
**Type:** Happy Path  
**User Journey:** User Authentication  
**Estimated Duration:** 30 seconds

**Preconditions:**

- User account exists in database
  - Email: `test@example.com`
  - Password: `Test123!`
  - Status: Active
- User is not currently logged in
- Browser is on login page

**Test Steps:**

1. Navigate to `/login`
2. Enter email: `test@example.com`
3. Enter password: `Test123!`
4. Click "Login" button
5. Verify user is redirected to dashboard
6. Verify user name displays in header
7. Verify authentication token is stored in localStorage

**Expected Results:**

- ✅ User is redirected to `/dashboard` within 2 seconds
- ✅ User name "Test User" appears in header
- ✅ Authentication token is present in localStorage: `localStorage.getItem('authToken')`
- ✅ No error messages displayed
- ✅ Database: User `last_login` timestamp is updated
- ✅ Session record created in `sessions` table

**Postconditions:**

- User is authenticated
- User has valid session
- Logout functionality available

**Test Data:**

```json
{
  "email": "test@example.com",
  "password": "Test123!",
  "expectedUserId": "123e4567-e89b-12d3-a456-426614174000",
  "expectedUserName": "Test User"
}
```

**Validation Points:**

- UI: Dashboard visible, user name in header
- API: `POST /api/auth/login` returns 200 status
- Database: `SELECT last_login FROM users WHERE email = 'test@example.com'` updated
- Session: Token stored and valid

---

##### Test Scenario: TC-002 - User Login (Invalid Credentials)

**Priority:** P0  
**Type:** Error Path  
**User Journey:** User Authentication  
**Estimated Duration:** 20 seconds

**Preconditions:**

- User account exists in database
- User is not logged in
- Browser is on login page

**Test Steps:**

1. Navigate to `/login`
2. Enter email: `test@example.com`
3. Enter password: `WrongPassword123!`
4. Click "Login" button
5. Verify error message displays
6. Verify user remains on login page
7. Verify form fields are cleared

**Expected Results:**

- ✅ Error message displays: "Invalid email or password"
- ✅ Error message has red background
- ✅ User remains on `/login` page
- ✅ Email field value is preserved
- ✅ Password field is cleared
- ✅ No authentication token in localStorage
- ✅ Database: `failed_login_attempts` incremented for user
- ✅ Database: No session created

**Postconditions:**

- User is not authenticated
- Failed login attempt recorded
- Account not locked (unless attempt limit reached)

---

##### Test Scenario: TC-003 - User Logout

**Priority:** P0  
**Type:** Happy Path  
**User Journey:** User Authentication  
**Estimated Duration:** 15 seconds

**Preconditions:**

- User is logged in with valid session
- Browser is on any authenticated page

**Test Steps:**

1. Navigate to any authenticated page (e.g., `/dashboard`)
2. Click "Logout" button in header
3. Verify user is redirected to login page
4. Verify authentication token is removed
5. Attempt to navigate back to `/dashboard`
6. Verify user is redirected to `/login`

**Expected Results:**

- ✅ User is redirected to `/login` page immediately
- ✅ Authentication token removed from localStorage
- ✅ Database: Session marked as `terminated`
- ✅ Attempting to access `/dashboard` redirects to `/login`
- ✅ Browser back button does not restore authenticated session

**Postconditions:**

- User is not authenticated
- Session is terminated
- Cannot access protected routes

---

#### 5.2.2 Core Business Workflows

##### Test Scenario: TC-010 - Complete Purchase (Happy Path)

**Priority:** P0  
**Type:** Happy Path  
**User Journey:** Customer Purchase Flow  
**Estimated Duration:** 2 minutes

**Preconditions:**

- User is logged in as customer
- At least 5 products exist in database
- Payment gateway is available (test mode)
- User has empty cart
- User credit card: `4242 4242 4242 4242` (test card)

**Test Steps:**

1. Navigate to `/products`
2. Search for "Widget Pro"
3. Click on first product in results
4. Verify product detail page loads
5. Click "Add to Cart" button
6. Verify cart badge updates to "1"
7. Click cart icon in header
8. Verify cart shows 1 item with correct product
9. Click "Proceed to Checkout"
10. Verify checkout page loads with cart summary
11. Fill shipping information:
    - Name: "John Doe"
    - Address: "123 Test St"
    - City: "Test City"
    - ZIP: "12345"
    - Country: "US"
12. Click "Continue to Payment"
13. Fill payment information:
    - Card Number: `4242 4242 4242 4242`
    - Expiry: `12/25`
    - CVC: `123`
14. Click "Place Order"
15. Wait for order processing (loading indicator)
16. Verify order confirmation page displays
17. Verify order number is shown
18. Verify order total is correct
19. Check database for order record
20. Check database for payment record

**Expected Results:**

- ✅ Product search returns results with "Widget Pro"
- ✅ Product detail page shows correct information
- ✅ Cart updates immediately with visual feedback
- ✅ Cart page displays correct product and price
- ✅ Checkout page calculates total correctly (subtotal + shipping + tax)
- ✅ Payment processing completes within 5 seconds
- ✅ Order confirmation page displays:
  - Order number (e.g., "ORD-2024-00123")
  - Order date
  - Shipping address
  - Payment method (last 4 digits)
  - Order total
- ✅ Database: Order record exists with status "confirmed"

  ```sql
  SELECT * FROM orders WHERE order_number = 'ORD-2024-00123'
  ```

- ✅ Database: Payment record exists with status "completed"

  ```sql
  SELECT * FROM payments WHERE order_id = [order_id]
  ```

- ✅ Database: Inventory decreased by 1 for purchased product
- ✅ Email sent to user (verify via API call to email service)

**Postconditions:**

- Order is created in database
- Payment is processed
- Inventory is updated
- User cart is cleared
- Confirmation email is queued

**Test Data:**

```json
{
  "product": {
    "name": "Widget Pro",
    "sku": "WGT-PRO-001",
    "price": 29.99
  },
  "customer": {
    "email": "test@example.com",
    "name": "John Doe"
  },
  "shipping": {
    "address": "123 Test St",
    "city": "Test City",
    "zip": "12345",
    "country": "US"
  },
  "payment": {
    "cardNumber": "4242424242424242",
    "expiry": "12/25",
    "cvc": "123"
  },
  "expectedTotal": 35.49
}
```

---

##### Test Scenario: TC-011 - Purchase with Payment Failure

**Priority:** P0  
**Type:** Error Path  
**User Journey:** Customer Purchase Flow  
**Estimated Duration:** 90 seconds

**Preconditions:**

- User is logged in
- User has item in cart
- User is on checkout page
- Payment gateway is available (test mode)

**Test Steps:**

1. Navigate to checkout page
2. Fill shipping information (valid data)
3. Fill payment information with declined test card:
   - Card Number: `4000 0000 0000 0002` (declined card)
4. Click "Place Order"
5. Verify error message displays
6. Verify cart is NOT cleared
7. Verify order is NOT created in database
8. Update payment information with valid card: `4242 4242 4242 4242`
9. Click "Place Order" again
10. Verify order processes successfully

**Expected Results:**

- ✅ Payment processing fails with error message
- ✅ Error message displays: "Payment declined. Please check your card details."
- ✅ User remains on checkout page
- ✅ Cart contents are preserved
- ✅ Shipping information is preserved
- ✅ Database: No order created for failed payment
- ✅ Database: Failed payment recorded in `payment_attempts` table
- ✅ Retry with valid card succeeds
- ✅ Order created successfully after retry

**Postconditions:**

- Failed payment recorded
- User can retry payment
- Successful retry creates order

---

### 5.3 High Priority Scenarios (P1)

#### 5.3.1 User Management

##### Test Scenario: TC-020 - User Registration

**Priority:** P1  
**Type:** Happy Path  
**User Journey:** User Registration  
**Estimated Duration:** 45 seconds

**Preconditions:**

- User is not logged in
- Email `newuser@example.com` does not exist in database
- Browser is on registration page

**Test Steps:**

1. Navigate to `/register`
2. Fill registration form:
   - Name: "Jane Smith"
   - Email: "<newuser@example.com>"
   - Password: "SecurePass123!"
   - Confirm Password: "SecurePass123!"
3. Check "I agree to Terms of Service" checkbox
4. Click "Register" button
5. Verify success message displays
6. Verify user is redirected to email verification page
7. Check database for new user record
8. Verify verification email is sent

**Expected Results:**

- ✅ Form submission succeeds
- ✅ Success message: "Registration successful! Please check your email."
- ✅ User redirected to `/verify-email`
- ✅ Database: User record created

  ```sql
  SELECT * FROM users WHERE email = 'newuser@example.com'
  ```

- ✅ User status is "pending_verification"
- ✅ Password is hashed (not plaintext)
- ✅ Verification email sent via email API

**Postconditions:**

- User account created
- User cannot login until email verified
- Verification email sent

---

##### Test Scenario: TC-021 - User Registration (Duplicate Email)

**Priority:** P1  
**Type:** Error Path  
**User Journey:** User Registration  
**Estimated Duration:** 30 seconds

**Preconditions:**

- Existing user with email `existing@example.com`
- Browser is on registration page

**Test Steps:**

1. Navigate to `/register`
2. Fill form with existing email: `existing@example.com`
3. Click "Register" button
4. Verify error message displays

**Expected Results:**

- ✅ Error message: "Email already registered"
- ✅ User remains on registration page
- ✅ No new user created in database
- ✅ No email sent

---

#### 5.3.2 Data Modification Operations

##### Test Scenario: TC-030 - Update User Profile

**Priority:** P1  
**Type:** Happy Path  
**User Journey:** Profile Management  
**Estimated Duration:** 60 seconds

**Preconditions:**

- User is logged in
- Current user name is "Old Name"
- Current user phone is "555-1234"

**Test Steps:**

1. Navigate to `/profile`
2. Verify current name displays: "Old Name"
3. Update name field to "New Name"
4. Update phone field to "555-9999"
5. Click "Save Changes" button
6. Verify success message
7. Reload page
8. Verify updated name displays: "New Name"
9. Check database for updated values

**Expected Results:**

- ✅ Success message: "Profile updated successfully"
- ✅ Form fields update immediately
- ✅ Database: User record updated

  ```sql
  SELECT name, phone FROM users WHERE id = [user_id]
  ```

- ✅ Updated name appears in header
- ✅ Updated phone appears in profile
- ✅ Audit log records profile change

**Postconditions:**

- User profile updated
- Changes reflected across system
- Audit trail created

---

### 5.4 Medium Priority Scenarios (P2)

#### 5.4.1 Secondary Features

##### Test Scenario: TC-040 - Product Search with Filters

**Priority:** P2  
**Type:** Happy Path  
**User Journey:** Product Discovery  
**Estimated Duration:** 45 seconds

[Continue with similar detailed structure...]

---

### 5.5 Low Priority Scenarios (P3)

#### 5.5.1 Edge Cases

##### Test Scenario: TC-050 - Empty Search Query

**Priority:** P3  
**Type:** Edge Case  
**User Journey:** Product Discovery  
**Estimated Duration:** 20 seconds

[Continue with similar structure...]

---

### 5.6 Test Scenario Summary

**Total Scenarios by Priority:**

| Priority | Count | Coverage |
|----------|-------|----------|
| P0 | [X] | 100% |
| P1 | [X] | 85% |
| P2 | [X] | 60% |
| P3 | [X] | Best Effort |
| **Total** | **[X]** | **N/A** |

**Test Scenario Matrix:**

| Feature | P0 | P1 | P2 | P3 | Total |
|---------|----|----|----|----|-------|
| Authentication | 5 | 3 | 2 | 1 | 11 |
| Purchase Flow | 4 | 2 | 1 | 0 | 7 |
| User Management | 2 | 4 | 2 | 1 | 9 |
| Product Catalog | 1 | 3 | 3 | 2 | 9 |
| Admin Operations | 0 | 2 | 3 | 2 | 7 |
| **Total** | **12** | **14** | **11** | **6** | **43** |

---

## 6. Test Data Management

### 6.1 Test Data Requirements

**Data Categories:**

#### 6.1.1 User Account Data

- **Admin Users**: 2-3 accounts with full permissions
- **Regular Users**: 10-15 accounts with varying roles
- **Guest Users**: Ephemeral, created per-test
- **Inactive Users**: 2-3 accounts for testing inactive/disabled states

**Example User Data:**

```json
{
  "adminUser": {
    "id": "admin-001",
    "email": "admin@test.com",
    "password": "Admin123!",
    "role": "admin",
    "permissions": ["*"]
  },
  "regularUser": {
    "id": "user-001",
    "email": "user@test.com",
    "password": "User123!",
    "role": "customer",
    "permissions": ["view_products", "create_orders"]
  }
}
```

#### 6.1.2 Business Entity Data

- **Products**: 50-100 test products across categories
- **Orders**: 20-30 sample orders in various states
- **Categories**: 5-10 product categories
- **Inventory**: Stock levels for all test products

#### 6.1.3 Reference Data

- **Countries**: List of countries for shipping
- **Tax Rates**: Tax rates per region
- **Shipping Rates**: Shipping costs per zone
- **Configurations**: System settings and constants

#### 6.1.4 Transaction Data

- **Payments**: Test payment records linked to orders
- **Invoices**: Generated invoices for completed orders
- **Refunds**: Sample refund transactions
- **Logs**: Activity logs for audit trail

### 6.2 Test Data Generation Strategies

**Approach 1: Static Fixtures (JSON/YAML)**

Use for predictable, reusable test data.

**Example: fixtures/users.json**

```json
{
  "users": [
    {
      "id": "user-001",
      "name": "Test Customer",
      "email": "customer@test.com",
      "password": "Test123!",
      "role": "customer"
    },
    {
      "id": "user-002",
      "name": "Test Admin",
      "email": "admin@test.com",
      "password": "Admin123!",
      "role": "admin"
    }
  ]
}
```

**Usage in Tests:**

```typescript
import users from '../fixtures/users.json'

const customer = users.users.find(u => u.role === 'customer')
await loginAs(customer)
```

---

**Approach 2: Data Factories (Dynamic Generation)**

Use for varied test data with randomization.

**Example: factories/UserFactory.ts**

```typescript
import { faker } from '@faker-js/faker'

export class UserFactory {
  static create(overrides = {}) {
    return {
      id: faker.string.uuid(),
      name: faker.person.fullName(),
      email: faker.internet.email(),
      password: 'Test123!',
      role: 'customer',
      createdAt: new Date(),
      ...overrides
    }
  }
  
  static createMany(count, overrides = {}) {
    return Array.from({ length: count }, () => this.create(overrides))
  }
}
```

**Usage in Tests:**

```typescript
const newUser = UserFactory.create({ role: 'admin' })
await api.post('/users', newUser)
```

---

**Approach 3: Database Seeding (SQL/ORM)**

Use for populating database with baseline data.

**Example: seeds/001_users.sql**

```sql
INSERT INTO users (id, name, email, password_hash, role, created_at)
VALUES
  ('user-001', 'Test Customer', 'customer@test.com', '$2b$10$...', 'customer', NOW()),
  ('user-002', 'Test Admin', 'admin@test.com', '$2b$10$...', 'admin', NOW());
  
INSERT INTO products (id, name, sku, price, stock_quantity, created_at)
VALUES
  ('prod-001', 'Widget Pro', 'WGT-PRO-001', 29.99, 100, NOW()),
  ('prod-002', 'Gadget Plus', 'GDG-PLS-002', 49.99, 50, NOW());
```

**Run Seeds:**

```bash
npm run db:seed:test
```

---

**Approach 4: API-Based Generation**

Use for creating data through application APIs.

**Example: helpers/data-setup.ts**

```typescript
export async function createTestUser(userData) {
  const response = await api.post('/api/users', userData)
  return response.data
}

export async function createTestProduct(productData) {
  const response = await api.post('/api/products', productData)
  return response.data
}
```

**Usage in Tests:**

```typescript
const user = await createTestUser({ email: 'test@example.com' })
const product = await createTestProduct({ name: 'Test Widget' })
```

### 6.3 Test Data Isolation

**Isolation Strategies:**

#### 6.3.1 Separate Test Database

- Dedicated database instance for testing
- Completely isolated from development/production
- Reset between test runs

**Configuration:**

```javascript
// playwright.config.ts
export default {
  use: {
    baseURL: 'http://localhost:3000',
    extraHTTPHeaders: {
      'X-Test-Database': 'e2e_test_db'
    }
  }
}
```

#### 6.3.2 Database Transactions (Rollback)

- Wrap each test in a transaction
- Rollback after test completes
- Fast isolation, no cleanup scripts needed

**Example:**

```typescript
test('create user', async () => {
  await db.beginTransaction()
  
  try {
    // Test code that modifies database
    const user = await db.users.create({ ... })
    expect(user).toBeDefined()
  } finally {
    await db.rollback()
  }
})
```

#### 6.3.3 Unique Identifiers

- Use UUIDs or timestamps for test data
- Prevents conflicts in parallel execution

**Example:**

```typescript
const uniqueEmail = `test-${Date.now()}@example.com`
const user = await createUser({ email: uniqueEmail })
```

#### 6.3.4 Cleanup Scripts

- Automated cleanup after test run
- Delete test data based on markers

**Example: cleanup.ts**

```typescript
export async function cleanupTestData() {
  // Delete users created during tests
  await db.users.deleteMany({
    email: { contains: '@test.com' }
  })
  
  // Delete orders from test period
  await db.orders.deleteMany({
    createdAt: { gte: testStartTime }
  })
}
```

### 6.4 Sensitive Data Handling

**Security Requirements:**
[Based on ground-rules.md compliance requirements]

#### 6.4.1 PII (Personally Identifiable Information)

- ❌ NEVER use real customer data
- ✅ Generate fake names, addresses, emails with Faker.js
- ✅ Use consistent test patterns (e.g., all test emails end with `@test.com`)

**Example:**

```typescript
import { faker } from '@faker-js/faker'

const testUser = {
  name: faker.person.fullName(),        // "Jane Doe"
  email: faker.internet.email({ provider: 'test.com' }), // "jane.doe@test.com"
  phone: faker.phone.number(),          // "555-1234"
  address: faker.location.streetAddress() // "123 Test St"
}
```

#### 6.4.2 Passwords

- ❌ NEVER hardcode production passwords
- ✅ Use secure test passwords stored in environment variables
- ✅ Hash passwords same way as production

**Example:**

```typescript
// .env.test
TEST_USER_PASSWORD=Test123!SecurePassword

// Test code
const password = process.env.TEST_USER_PASSWORD
```

#### 6.4.3 API Keys and Secrets

- ❌ NEVER commit API keys to version control
- ✅ Store in secrets management (e.g., GitHub Secrets, AWS Secrets Manager)
- ✅ Use test mode keys for third-party services

**Example:**

```yaml
# .github/workflows/e2e-tests.yml
env:
  STRIPE_TEST_KEY: ${{ secrets.STRIPE_TEST_KEY }}
  SENDGRID_TEST_KEY: ${{ secrets.SENDGRID_TEST_KEY }}
```

#### 6.4.4 Payment Data

- ❌ NEVER use real credit cards
- ✅ Use test card numbers provided by payment gateway
- ✅ Stripe test cards: `4242 4242 4242 4242` (success), `4000 0000 0000 0002` (declined)

**Example:**

```typescript
const testPaymentData = {
  cardNumber: '4242424242424242', // Stripe test card
  expiry: '12/25',
  cvc: '123',
  amount: 1000 // cents
}
```

#### 6.4.5 Compliance (GDPR, HIPAA, PCI-DSS)

- ✅ Follow data retention policies (delete test data regularly)
- ✅ Encrypt sensitive test data at rest
- ✅ Log access to sensitive test data
- ✅ Document compliance adherence in test reports

**Example Compliance Checklist:**

- [ ] Test data contains no real PII
- [ ] Test data is isolated from production
- [ ] Sensitive test data is encrypted
- [ ] Test data is deleted after [X] days
- [ ] Access to test environment is logged
- [ ] Compliance requirements from ground-rules.md are met

### 6.5 Test Data Maintenance

**Maintenance Schedule:**

- **Daily**: Cleanup temporary test data
- **Weekly**: Review and update test fixtures
- **Monthly**: Refresh large datasets (products, reference data)
- **Quarterly**: Audit test data for compliance

**Maintenance Scripts:**

```bash
# Daily cleanup (automated via cron/CI)
npm run test:cleanup

# Weekly fixture update
npm run test:fixtures:update

# Monthly data refresh
npm run test:data:refresh
```

**Data Version Control:**

Track test data changes in version control:

```
tests/e2e/
├── fixtures/
│   ├── users.json          # Track changes
│   ├── products.json       # Track changes
│   └── README.md           # Document data structure
├── seeds/
│   ├── 001_users.sql       # Track SQL seeds
│   └── 002_products.sql
└── factories/
    ├── UserFactory.ts      # Track factory code
    └── ProductFactory.ts
```

---

## 7. Test Environments

### 7.1 Environment Configurations

#### 7.1.1 Local Development Environment

**Purpose:** Developer machines for local test development and debugging

**Configuration:**

- **Platform:** macOS, Linux, Windows
- **Execution:** Docker Compose for local services
- **Database:** PostgreSQL 15 in Docker container
- **Cache:** Redis 7 in Docker container
- **Message Queue:** RabbitMQ 3 in Docker container (if needed)
- **External Services:** Mocked via MSW (Mock Service Worker)
- **Frontend:** `http://localhost:3000`
- **Backend API:** `http://localhost:4000`

**Setup:**

```bash
# docker-compose.yml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: e2e_test_db
      POSTGRES_USER: test_user
      POSTGRES_PASSWORD: test_pass
    ports:
      - "5432:5432"
  
  redis:
    image: redis:7
    ports:
      - "6379:6379"
  
  backend:
    build: ./backend
    environment:
      DATABASE_URL: postgresql://test_user:test_pass@postgres:5432/e2e_test_db
      REDIS_URL: redis://redis:6379
    ports:
      - "4000:4000"
  
  frontend:
    build: ./frontend
    environment:
      REACT_APP_API_URL: http://localhost:4000
    ports:
      - "3000:3000"
```

**Run Locally:**

```bash
docker-compose up -d
npm run db:seed:test
npm run test:e2e
```

**Advantages:**

- Fast feedback loop
- Easy debugging with browser DevTools
- Full control over environment
- No internet dependency (mocked services)

**Limitations:**

- May not match production exactly
- Resource-intensive (multiple Docker containers)
- Manual setup required

---

#### 7.1.2 CI/CD Environment

**Purpose:** Automated test execution in continuous integration pipeline

**Configuration:**

- **Platform:** GitHub Actions / Azure Pipelines / Jenkins
- **Execution:** Ephemeral environments (created per pipeline run)
- **Database:** PostgreSQL in Docker container (fresh per run)
- **Cache:** Redis in Docker container
- **Parallelization:** 4-8 parallel workers
- **Browser:** Chromium headless (Playwright)
- **Artifacts:** Screenshots, videos, HTML reports uploaded

**GitHub Actions Example:**

```yaml
# .github/workflows/e2e-tests.yml
name: E2E Tests

on:
  pull_request:
  push:
    branches: [main]

jobs:
  e2e-tests:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: e2e_test_db
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_pass
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7
        ports:
          - 6379:6379
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright browsers
        run: npx playwright install --with-deps chromium
      
      - name: Seed test database
        run: npm run db:seed:test
      
      - name: Run E2E tests
        run: npm run test:e2e
        env:
          DATABASE_URL: postgresql://test_user:test_pass@localhost:5432/e2e_test_db
          STRIPE_TEST_KEY: ${{ secrets.STRIPE_TEST_KEY }}
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: e2e-test-results
          path: test-results/
      
      - name: Upload Playwright report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

**Parallel Execution:**

```typescript
// playwright.config.ts
export default {
  workers: process.env.CI ? 4 : 2,
  retries: process.env.CI ? 2 : 0,
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  }
}
```

**Advantages:**

- Automated execution on every PR
- Parallel execution for speed
- Consistent environment
- Artifact storage for debugging

**Limitations:**

- Slower than local (CI startup time)
- Limited debugging capabilities
- Resource constraints (CI runner limits)

---

#### 7.1.3 Staging/QA Environment

**Purpose:** Pre-production environment for manual testing and extended E2E suites

**Configuration:**

- **Platform:** AWS / Azure / GCP
- **Frontend:** `https://staging.example.com`
- **Backend API:** `https://api-staging.example.com`
- **Database:** PostgreSQL RDS / Azure Database (dedicated instance)
- **Cache:** Redis ElastiCache / Azure Cache
- **Message Queue:** AWS SQS / Azure Service Bus
- **External Services:** Real third-party services in test mode
- **Infrastructure:** Production-like setup (load balancers, CDN, etc.)

**Deployment:**

- Deployed automatically from `develop` branch
- Database migrations applied automatically
- Seed data refreshed nightly

**Test Execution:**

```bash
npm run test:e2e:staging
```

**Configuration:**

```typescript
// playwright.config.ts (staging)
export default {
  use: {
    baseURL: 'https://staging.example.com',
    extraHTTPHeaders: {
      'Authorization': `Bearer ${process.env.STAGING_API_KEY}`
    }
  }
}
```

**Advantages:**

- Production-like environment
- Real external service integrations
- Stable for manual testing
- Long-running test suites acceptable

**Limitations:**

- Shared environment (potential conflicts)
- Slower deployment cycle
- Costs for infrastructure

---

#### 7.1.4 Pre-Production Environment

**Purpose:** Final validation before production release

**Configuration:**

- **Identical to Production**: Same infrastructure, services, versions
- **Data:** Production-scale data (sanitized, no real PII)
- **Access:** Restricted to QA and release managers
- **Deployment:** Manual deployment from release candidate branches

**Test Execution:**

- Critical P0 scenarios only
- Smoke tests before production deployment
- Manual exploratory testing

**Advantages:**

- Exact production replica
- High confidence validation
- Production-scale performance testing

**Limitations:**

- Expensive to maintain
- Limited availability
- Requires careful data management

### 7.2 Infrastructure Requirements

**Computing Resources:**

| Environment | Frontend | Backend | Database | Workers |
|-------------|----------|---------|----------|---------|
| Local | 1 container | 1 container | 1 container | 1 (developer machine) |
| CI/CD | N/A (built) | N/A (built) | 1 container | 4-8 parallel |
| Staging | 2 instances | 4 instances | 1 RDS instance | N/A |
| Pre-Prod | 4 instances | 8 instances | 1 RDS instance | N/A |

**Database Specifications:**

- **Type:** PostgreSQL 15
- **Size (Staging):** db.t3.medium (2 vCPU, 4 GB RAM)
- **Size (Pre-Prod):** db.m5.large (2 vCPU, 8 GB RAM)
- **Storage:** 50 GB SSD
- **Backup:** Daily automated backups

**Cache Specifications:**

- **Type:** Redis 7
- **Size:** cache.t3.micro (0.5 GB memory)
- **Eviction Policy:** LRU (Least Recently Used)

**Network Requirements:**

- HTTPS/TLS for all environments
- VPN access for staging/pre-prod (optional)
- Load balancer for staging/pre-prod
- CDN for static assets

### 7.3 Service Mocking Strategy

**When to Mock:**

✅ **Mock these services:**

- Expensive third-party APIs (payment gateways in CI)
- Unreliable external services
- Services not available in test environment
- Slow external services (impacting test speed)

❌ **Don't mock these services:**

- Internal system components (test real integration)
- Database (use real test database)
- Message queues (use real instance or test mode)
- Services available in staging/pre-prod

**Mocking Approaches:**

#### 7.3.1 HTTP Mocking (MSW - Mock Service Worker)

**Use for:** Mocking REST APIs, third-party HTTP services

**Example: Mocking Stripe Payment API**

```typescript
// mocks/stripe-handler.ts
import { rest } from 'msw'

export const stripeHandlers = [
  // Mock successful payment intent creation
  rest.post('https://api.stripe.com/v1/payment_intents', (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json({
        id: 'pi_test_1234567890',
        object: 'payment_intent',
        amount: 2999,
        currency: 'usd',
        status: 'succeeded'
      })
    )
  }),
  
  // Mock payment failure
  rest.post('https://api.stripe.com/v1/payment_intents/:id/confirm', (req, res, ctx) => {
    return res(
      ctx.status(402),
      ctx.json({
        error: {
          type: 'card_error',
          code: 'card_declined',
          message: 'Your card was declined.'
        }
      })
    )
  })
]
```

**Setup:**

```typescript
// tests/setup.ts
import { setupServer } from 'msw/node'
import { stripeHandlers } from './mocks/stripe-handler'

const server = setupServer(...stripeHandlers)

// Start server before all tests
beforeAll(() => server.listen())

// Reset handlers after each test
afterEach(() => server.resetHandlers())

// Clean up after all tests
afterAll(() => server.close())
```

#### 7.3.2 Service Virtualization (WireMock)

**Use for:** Complex API mocking with state management

**Example: Docker-based WireMock**

```yaml
# docker-compose.yml
services:
  wiremock:
    image: wiremock/wiremock:latest
    ports:
      - "8080:8080"
    volumes:
      - ./wiremock/mappings:/home/wiremock/mappings
      - ./wiremock/files:/home/wiremock/__files
```

**Stub Configuration:**

```json
// wiremock/mappings/get-user.json
{
  "request": {
    "method": "GET",
    "urlPattern": "/api/users/(.*)"
  },
  "response": {
    "status": 200,
    "jsonBody": {
      "id": "{{request.pathSegments.[2]}}",
      "name": "Test User",
      "email": "test@example.com"
    },
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

#### 7.3.3 Contract Testing (Pact)

**Use for:** Ensuring API contracts between consumer and provider

**Example: Consumer Test (Frontend)**

```typescript
// tests/contract/user-api.pact.ts
import { PactV3 } from '@pact-foundation/pact'

const provider = new PactV3({
  consumer: 'Frontend',
  provider: 'UserAPI'
})

test('get user by ID', async () => {
  await provider
    .given('user with ID 123 exists')
    .uponReceiving('a request for user 123')
    .withRequest({
      method: 'GET',
      path: '/api/users/123'
    })
    .willRespondWith({
      status: 200,
      headers: { 'Content-Type': 'application/json' },
      body: {
        id: '123',
        name: 'John Doe',
        email: 'john@example.com'
      }
    })
    .executeTest(async (mockServer) => {
      const response = await fetch(`${mockServer.url}/api/users/123`)
      const user = await response.json()
      expect(user.id).toBe('123')
    })
})
```

### 7.4 Database Seeding and Reset

**Seeding Process:**

**1. SQL-based Seeding (for PostgreSQL):**

```sql
-- seeds/001_users.sql
TRUNCATE TABLE users CASCADE;

INSERT INTO users (id, name, email, password_hash, role, created_at)
VALUES
  ('user-001', 'Test Customer', 'customer@test.com', '$2b$10$...', 'customer', NOW()),
  ('user-002', 'Test Admin', 'admin@test.com', '$2b$10$...', 'admin', NOW());
```

**Run Seeds:**

```bash
psql -U test_user -d e2e_test_db -f seeds/001_users.sql
```

**2. ORM-based Seeding (TypeORM example):**

```typescript
// seeds/UserSeeder.ts
import { Factory, Seeder } from 'typeorm-seeding'
import { User } from '../entities/User'

export default class UserSeeder implements Seeder {
  public async run(factory: Factory): Promise<void> {
    await factory(User)().createMany(10)
  }
}
```

**Run Seeds:**

```bash
npm run seed:run
```

**3. API-based Seeding:**

```typescript
// helpers/seed.ts
export async function seedDatabase() {
  // Create admin user
  await api.post('/api/users', {
    email: 'admin@test.com',
    password: 'Admin123!',
    role: 'admin'
  })
  
  // Create test products
  const products = ProductFactory.createMany(50)
  await Promise.all(
    products.map(p => api.post('/api/products', p))
  )
}
```

**Database Reset:**

```typescript
// helpers/database.ts
export async function resetDatabase() {
  await db.query('TRUNCATE TABLE users CASCADE')
  await db.query('TRUNCATE TABLE products CASCADE')
  await db.query('TRUNCATE TABLE orders CASCADE')
}

// Use in tests
beforeEach(async () => {
  await resetDatabase()
  await seedDatabase()
})
```

**Automated Reset in CI:**

```yaml
# .github/workflows/e2e-tests.yml
- name: Reset and seed database
  run: |
    npm run db:reset
    npm run db:seed:test
```

---

## 8. Test Framework

### 8.1 Framework Selection

**Selected Testing Framework:**

[Choose based on your tech stack]

#### Option 1: Playwright (Recommended for Web Applications)

**Justification:**

- ✅ Multi-browser support (Chromium, Firefox, WebKit)
- ✅ Built-in auto-waiting (reduces flakiness)
- ✅ Parallel execution by default
- ✅ Excellent debugging tools (trace viewer, time-travel debugging)
- ✅ API testing support (REST, GraphQL)
- ✅ Mobile web testing (device emulation)
- ✅ Modern, actively maintained by Microsoft
- ✅ Fast execution speed

**Use when:**

- Web applications (React, Vue, Angular, etc.)
- Need cross-browser testing
- Want fast, reliable E2E tests

**Example Installation:**

```bash
npm init playwright@latest
```

**Example Test:**

```typescript
import { test, expect } from '@playwright/test'

test('user can login successfully', async ({ page }) => {
  await page.goto('/login')
  await page.fill('#email', 'test@example.com')
  await page.fill('#password', 'Test123!')
  await page.click('button[type="submit"]')
  
  await expect(page).toHaveURL('/dashboard')
  await expect(page.locator('h1')).toContainText('Welcome')
})
```

---

#### Option 2: Cypress (Alternative for Web Applications)

**Justification:**

- ✅ Excellent developer experience
- ✅ Time-travel debugging
- ✅ Automatic screenshot/video on failure
- ✅ Great documentation and community
- ✅ Interceptable network requests (cy.intercept)
- ❌ Limited browser support (Chromium, Firefox, Edge - no Safari in free tier)
- ❌ No native mobile support
- ❌ Parallel execution requires paid plan

**Use when:**

- Web applications with focus on Chrome/Firefox
- Developer experience is priority
- Budget for Cypress Cloud (for parallelization)

**Example Test:**

```typescript
describe('User Login', () => {
  it('should login successfully', () => {
    cy.visit('/login')
    cy.get('#email').type('test@example.com')
    cy.get('#password').type('Test123!')
    cy.get('button[type="submit"]').click()
    
    cy.url().should('include', '/dashboard')
    cy.get('h1').should('contain', 'Welcome')
  })
})
```

---

#### Option 3: Selenium WebDriver (Legacy/Enterprise)

**Justification:**

- ✅ Industry standard, mature ecosystem
- ✅ All browser support
- ✅ Language flexibility (Java, Python, C#, JavaScript)
- ✅ Appium integration for mobile
- ❌ Manual waits required (explicit/implicit)
- ❌ Flaky tests common
- ❌ Slower execution
- ❌ Verbose syntax

**Use when:**

- Legacy systems requiring Selenium
- Enterprise requirements mandate Selenium
- Non-JavaScript tech stack (Java, Python, C#)

**Example Test (Java):**

```java
@Test
public void testUserLogin() {
    driver.get("http://example.com/login");
    driver.findElement(By.id("email")).sendKeys("test@example.com");
    driver.findElement(By.id("password")).sendKeys("Test123!");
    driver.findElement(By.cssSelector("button[type='submit']")).click();
    
    WebDriverWait wait = new WebDriverWait(driver, 10);
    wait.until(ExpectedConditions.urlContains("/dashboard"));
    
    Assert.assertTrue(driver.findElement(By.tagName("h1")).getText().contains("Welcome"));
}
```

---

#### Option 4: Appium (Mobile Applications)

**Justification:**

- ✅ Cross-platform mobile (iOS + Android)
- ✅ Native, hybrid, and mobile web support
- ✅ WebDriver protocol compatible
- ❌ Complex setup (Xcode, Android SDK, Appium server)
- ❌ Slower execution than web tests
- ❌ Emulator/simulator limitations

**Use when:**

- Mobile applications (iOS, Android)
- Need native mobile testing
- Cross-platform mobile coverage required

**Example Test:**

```typescript
const driver = await wdio.remote({
  capabilities: {
    platformName: 'iOS',
    'appium:deviceName': 'iPhone 14',
    'appium:app': '/path/to/app.ipa',
    'appium:automationName': 'XCUITest'
  }
})

await driver.$('~login-email').setValue('test@example.com')
await driver.$('~login-password').setValue('Test123!')
await driver.$('~login-button').click()

const welcomeText = await driver.$('~welcome-message').getText()
expect(welcomeText).toContain('Welcome')
```

---

### 8.2 Supporting Tools

**API Testing:**

- **Supertest** (Node.js): HTTP assertions for Express APIs

  ```typescript
  import request from 'supertest'
  import app from '../app'
  
  test('GET /api/users returns user list', async () => {
    const response = await request(app)
      .get('/api/users')
      .expect(200)
      .expect('Content-Type', /json/)
    
    expect(response.body).toHaveLength(10)
  })
  ```

- **REST Assured** (Java): Fluent API for REST testing

  ```java
  given()
    .auth().oauth2(token)
  .when()
    .get("/api/users")
  .then()
    .statusCode(200)
    .body("size()", greaterThan(0));
  ```

**Visual Testing:**

- **Percy** (Recommended): Visual regression testing with CI integration

  ```typescript
  import percySnapshot from '@percy/playwright'
  
  test('homepage visual test', async ({ page }) => {
    await page.goto('/')
    await percySnapshot(page, 'Homepage')
  })
  ```

- **Applitools**: AI-powered visual testing
- **BackstopJS**: Open-source screenshot comparison

**Performance Testing:**

- **k6**: Modern load testing (JavaScript)

  ```javascript
  import http from 'k6/http'
  import { check } from 'k6'
  
  export default function () {
    const res = http.get('https://example.com')
    check(res, {
      'status is 200': (r) => r.status === 200,
      'response time < 500ms': (r) => r.timings.duration < 500
    })
  }
  ```

**Test Data Generation:**

- **Faker.js**: Realistic fake data generation

  ```typescript
  import { faker } from '@faker-js/faker'
  
  const user = {
    name: faker.person.fullName(),
    email: faker.internet.email(),
    address: faker.location.streetAddress()
  }
  ```

### 8.3 Final Selection for This Project

**Primary Framework:** [YOUR SELECTION HERE]

**Justification:**
[Explain why this framework was chosen based on:

- Project tech stack
- Team familiarity
- Browser/platform requirements
- Budget constraints
- Performance needs
- CI/CD integration requirements
- Ground-rules constraints]

**Example:**

**Primary Framework:** Playwright

**Justification:**

- Project uses React frontend requiring cross-browser testing
- Team has JavaScript/TypeScript expertise
- Need Safari support for iOS users (30% of user base)
- Budget constraints prevent paid Cypress Cloud
- Fast execution required for CI/CD (<15 minutes for full suite)
- Auto-waiting reduces flakiness
- Trace viewer provides excellent debugging

**Supporting Tools:**

- API Testing: Supertest (Node.js backend)
- Visual Testing: Percy (critical UI pages)
- Test Data: Faker.js
- Mocking: MSW (Mock Service Worker)

---

## 9. Test Architecture

### 9.1 Test Code Organization

**Directory Structure:**

```
tests/e2e/
├── fixtures/                 # Static test data
│   ├── users.json
│   ├── products.json
│   └── orders.json
├── helpers/                  # Test utilities
│   ├── api.ts               # API helper functions
│   ├── database.ts          # Database utilities
│   ├── assertions.ts        # Custom assertions
│   └── waits.ts             # Custom wait functions
├── mocks/                    # Service mocks (MSW handlers)
│   ├── stripe-handler.ts
│   ├── sendgrid-handler.ts
│   └── index.ts
├── factories/                # Data factories
│   ├── UserFactory.ts
│   ├── ProductFactory.ts
│   └── OrderFactory.ts
├── pages/                    # Page Object Model (if UI testing)
│   ├── BasePage.ts
│   ├── LoginPage.ts
│   ├── DashboardPage.ts
│   ├── ProductPage.ts
│   └── CheckoutPage.ts
├── scenarios/                # Test scenarios (organized by feature)
│   ├── authentication/
│   │   ├── login.spec.ts
│   │   ├── logout.spec.ts
│   │   └── password-reset.spec.ts
│   ├── checkout/
│   │   ├── guest-checkout.spec.ts
│   │   ├── complete-order.spec.ts
│   │   └── payment-failure.spec.ts
│   ├── admin/
│   │   ├── user-management.spec.ts
│   │   └── product-management.spec.ts
│   └── api/
│       ├── users-api.spec.ts
│       └── products-api.spec.ts
├── setup/                    # Test setup and teardown
│   ├── global-setup.ts
│   ├── global-teardown.ts
│   └── test-hooks.ts
├── playwright.config.ts      # Playwright configuration
├── tsconfig.json             # TypeScript configuration
└── README.md                 # Quick start guide
```

### 9.2 Design Patterns

#### 9.2.1 Page Object Model (POM)

**Purpose:** Encapsulate page interactions, reduce duplication, improve maintainability

**Example: BasePage.ts**

```typescript
// pages/BasePage.ts
import { Page, Locator } from '@playwright/test'

export class BasePage {
  readonly page: Page
  
  constructor(page: Page) {
    this.page = page
  }
  
  async goto(path: string) {
    await this.page.goto(path)
  }
  
  async waitForPageLoad() {
    await this.page.waitForLoadState('networkidle')
  }
  
  async takeScreenshot(name: string) {
    await this.page.screenshot({ path: `screenshots/${name}.png` })
  }
}
```

**Example: LoginPage.ts**

```typescript
// pages/LoginPage.ts
import { Page, Locator, expect } from '@playwright/test'
import { BasePage } from './BasePage'

export class LoginPage extends BasePage {
  readonly emailInput: Locator
  readonly passwordInput: Locator
  readonly loginButton: Locator
  readonly errorMessage: Locator
  
  constructor(page: Page) {
    super(page)
    this.emailInput = page.locator('#email')
    this.passwordInput = page.locator('#password')
    this.loginButton = page.locator('button[type="submit"]')
    this.errorMessage = page.locator('.error-message')
  }
  
  async navigate() {
    await this.goto('/login')
  }
  
  async login(email: string, password: string) {
    await this.emailInput.fill(email)
    await this.passwordInput.fill(password)
    await this.loginButton.click()
  }
  
  async expectErrorMessage(message: string) {
    await expect(this.errorMessage).toContainText(message)
  }
}
```

**Usage in Test:**

```typescript
// scenarios/authentication/login.spec.ts
import { test, expect } from '@playwright/test'
import { LoginPage } from '../../pages/LoginPage'

test('user can login successfully', async ({ page }) => {
  const loginPage = new LoginPage(page)
  
  await loginPage.navigate()
  await loginPage.login('test@example.com', 'Test123!')
  
  await expect(page).toHaveURL('/dashboard')
})
```

#### 9.2.2 Builder Pattern for Test Data

**Purpose:** Create complex test objects fluently

**Example: UserBuilder.ts**

```typescript
// factories/UserBuilder.ts
export class UserBuilder {
  private user: any = {
    name: 'Default User',
    email: 'default@test.com',
    password: 'Test123!',
    role: 'customer'
  }
  
  withName(name: string): UserBuilder {
    this.user.name = name
    return this
  }
  
  withEmail(email: string): UserBuilder {
    this.user.email = email
    return this
  }
  
  withRole(role: string): UserBuilder {
    this.user.role = role
    return this
  }
  
  build() {
    return this.user
  }
}

// Usage
const adminUser = new UserBuilder()
  .withName('Admin User')
  .withEmail('admin@test.com')
  .withRole('admin')
  .build()
```

#### 9.2.3 AAA Pattern (Arrange-Act-Assert)

**Purpose:** Structure tests consistently for readability

**Example:**

```typescript
test('user can update profile', async ({ page }) => {
  // Arrange - Set up test data and initial state
  const user = await createTestUser({ name: 'Old Name' })
  await loginAs(page, user)
  await page.goto('/profile')
  
  // Act - Perform the action being tested
  await page.fill('#name', 'New Name')
  await page.click('button[type="submit"]')
  
  // Assert - Verify expected behavior
  await expect(page.locator('.success-message')).toBeVisible()
  const updatedUser = await getUser(user.id)
  expect(updatedUser.name).toBe('New Name')
})
```

### 9.3 Test Utilities and Helpers

#### 9.3.1 API Helpers

```typescript
// helpers/api.ts
import axios from 'axios'

const api = axios.create({
  baseURL: process.env.API_BASE_URL || 'http://localhost:4000'
})

export async function createUser(userData: any) {
  const response = await api.post('/api/users', userData)
  return response.data
}

export async function getUser(userId: string) {
  const response = await api.get(`/api/users/${userId}`)
  return response.data
}

export async function deleteUser(userId: string) {
  await api.delete(`/api/users/${userId}`)
}

export async function authenticateUser(email: string, password: string) {
  const response = await api.post('/api/auth/login', { email, password })
  return response.data.token
}
```

#### 9.3.2 Database Helpers

```typescript
// helpers/database.ts
import { Pool } from 'pg'

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
})

export async function queryDatabase(sql: string, params: any[] = []) {
  const client = await pool.connect()
  try {
    const result = await client.query(sql, params)
    return result.rows
  } finally {
    client.release()
  }
}

export async function getUserFromDatabase(email: string) {
  const rows = await queryDatabase(
    'SELECT * FROM users WHERE email = $1',
    [email]
  )
  return rows[0]
}

export async function resetDatabase() {
  await queryDatabase('TRUNCATE TABLE users CASCADE')
  await queryDatabase('TRUNCATE TABLE products CASCADE')
  await queryDatabase('TRUNCATE TABLE orders CASCADE')
}
```

#### 9.3.3 Custom Assertions

```typescript
// helpers/assertions.ts
import { expect } from '@playwright/test'

export async function expectDatabaseToContain(table: string, data: any) {
  const rows = await queryDatabase(`SELECT * FROM ${table} WHERE id = $1`, [data.id])
  expect(rows.length).toBeGreaterThan(0)
  expect(rows[0]).toMatchObject(data)
}

export async function expectEmailToBeSent(to: string, subject: string) {
  // Verify via email API or mock
  const emails = await getQueuedEmails()
  const email = emails.find(e => e.to === to && e.subject === subject)
  expect(email).toBeDefined()
}
```

### 9.4 Test Hooks and Setup

**Global Setup (runs once before all tests):**

```typescript
// setup/global-setup.ts
import { FullConfig } from '@playwright/test'

async function globalSetup(config: FullConfig) {
  console.log('Running global setup...')
  
  // Start services
  await startDatabase()
  await startBackend()
  await startMockServices()
  
  // Seed database with baseline data
  await seedDatabase()
  
  console.log('Global setup complete')
}

export default globalSetup
```

**Global Teardown (runs once after all tests):**

```typescript
// setup/global-teardown.ts
async function globalTeardown() {
  console.log('Running global teardown...')
  
  // Cleanup
  await cleanupDatabase()
  await stopServices()
  
  console.log('Global teardown complete')
}

export default globalTeardown
```

**Test Hooks (runs before/after each test):**

```typescript
// setup/test-hooks.ts
import { test as base } from '@playwright/test'

export const test = base.extend({
  // Automatic login for authenticated tests
  authenticatedPage: async ({ page }, use) => {
    await page.goto('/login')
    await page.fill('#email', 'test@example.com')
    await page.fill('#password', 'Test123!')
    await page.click('button[type="submit"]')
    await page.waitForURL('/dashboard')
    
    await use(page)
    
    // Cleanup after test
    await page.click('#logout')
  }
})

// Usage
test('authenticated user can view dashboard', async ({ authenticatedPage }) => {
  await expect(authenticatedPage.locator('h1')).toContainText('Dashboard')
})
```

### 9.5 Reporting and Logging

**Playwright HTML Reporter (built-in):**

```typescript
// playwright.config.ts
export default {
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['list'] // Console output
  ]
}
```

**Custom Logger:**

```typescript
// helpers/logger.ts
import winston from 'winston'

export const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'test-results/test.log' }),
    new winston.transports.Console({ format: winston.format.simple() })
  ]
})

// Usage in tests
logger.info('Starting test: user login')
logger.error('Test failed', { error: err.message })
```

**Screenshot and Video on Failure:**

```typescript
// playwright.config.ts
export default {
  use: {
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure'
  }
}
```

### 9.6 CI/CD Integration

**Playwright Configuration for CI:**

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test'

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 4 : 2,
  reporter: process.env.CI
    ? [['html'], ['junit', { outputFile: 'test-results/junit.xml' }]]
    : [['html'], ['list']],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] }
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] }
    }
  ]
})
```

### 9.7 Coding Standards for Tests

**Test Naming Conventions:**

- Descriptive test names: `should allow user to complete checkout successfully`
- File naming: `{feature}.spec.ts` (e.g., `login.spec.ts`, `checkout.spec.ts`)
- Page object naming: `{PageName}Page.ts` (e.g., `LoginPage.ts`, `DashboardPage.ts`)

**Code Style:**

- Use TypeScript for type safety
- Follow ESLint/Prettier configuration
- Max 100 lines per test file (split large files)
- Extract reusable logic into helpers/utilities

**Documentation:**

- Comment complex test logic
- Document test data requirements
- Explain non-obvious waits or workarounds

**Example Test with Documentation:**

```typescript
/**
 * Test Suite: User Authentication
 * 
 * This suite tests critical authentication flows including:
 * - Successful login with valid credentials
 * - Failed login with invalid credentials
 * - Account lockout after multiple failed attempts
 * - Password reset flow
 * 
 * Prerequisites:
 * - Test users created in database (via seedDatabase())
 * - Email service mocked (via MSW)
 * 
 * Test Data:
 * - Valid user: test@example.com / Test123!
 * - Invalid user: invalid@example.com / WrongPassword
 */

import { test, expect } from '@playwright/test'
import { LoginPage } from '../../pages/LoginPage'

test.describe('User Authentication', () => {
  test('should login successfully with valid credentials', async ({ page }) => {
    const loginPage = new LoginPage(page)
    
    await loginPage.navigate()
    await loginPage.login('test@example.com', 'Test123!')
    
    await expect(page).toHaveURL('/dashboard')
    await expect(page.locator('h1')).toContainText('Welcome')
  })
  
  // More tests...
})
```

---

## 10. Execution Plan

### 10.1 Test Suite Organization

**Test Suites:**

| Suite Name | Priority | Scenarios | Est. Duration | Purpose |
|------------|----------|-----------|---------------|---------|
| **Smoke** | P0 only | 10-15 | 5-10 min | Critical path validation |
| **Regression** | P0 + P1 | 40-60 | 30-45 min | Full feature coverage |
| **Full** | P0 + P1 + P2 | 80-120 | 60-90 min | Comprehensive validation |
| **Extended** | All (P0-P3) | 150+ | 2-3 hours | Complete coverage with edge cases |

**Suite Definitions:**

```typescript
// playwright.config.ts
export default {
  projects: [
    {
      name: 'smoke',
      testMatch: '**/*.spec.ts',
      grep: /@smoke/,
      retries: 0
    },
    {
      name: 'regression',
      testMatch: '**/*.spec.ts',
      grep: /@(smoke|regression)/,
      retries: 1
    },
    {
      name: 'full',
      testMatch: '**/*.spec.ts',
      grep: /@(smoke|regression|extended)/,
      retries: 2
    }
  ]
}
```

**Tag Tests for Suites:**

```typescript
test('@smoke should login successfully', async ({ page }) => {
  // Critical test
})

test('@regression should update user profile', async ({ page }) => {
  // Important test
})

test('@extended should handle edge case', async ({ page }) => {
  // Edge case test
})
```

### 10.2 Execution Schedule

#### 10.2.1 Nightly Builds (Automated)

**Schedule:** Every night at 2:00 AM

**Suite:** Regression (P0 + P1)

**Configuration:**

- **Platform:** CI/CD (GitHub Actions / Jenkins)
- **Browsers:** Chromium, Firefox, WebKit
- **Parallelization:** 8 workers
- **Timeout:** 60 minutes
- **Retry:** 2 retries on failure
- **Notification:** Slack alert on failure

**GitHub Actions Example:**

```yaml
# .github/workflows/nightly-e2e.yml
name: Nightly E2E Tests

on:
  schedule:
    - cron: '0 2 * * *'  # 2:00 AM daily
  workflow_dispatch:       # Manual trigger

jobs:
  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright browsers
        run: npx playwright install --with-deps
      
      - name: Seed database
        run: npm run db:seed:test
      
      - name: Run regression suite
        run: npm run test:e2e:regression
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: nightly-test-results
          path: playwright-report/
      
      - name: Notify on failure
        if: failure()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "❌ Nightly E2E tests failed! Check workflow run for details."
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

#### 10.2.2 Pull Request Checks (Automated)

**Trigger:** On every pull request creation/update

**Suite:** Smoke (P0 only)

**Configuration:**

- **Platform:** CI/CD (GitHub Actions)
- **Browsers:** Chromium only (for speed)
- **Parallelization:** 4 workers
- **Timeout:** 15 minutes
- **Retry:** 1 retry on failure
- **Blocking:** PR cannot merge if smoke tests fail

**GitHub Actions Example:**

```yaml
# .github/workflows/pr-e2e.yml
name: PR E2E Tests

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  smoke-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright Chromium
        run: npx playwright install --with-deps chromium
      
      - name: Seed database
        run: npm run db:seed:test
      
      - name: Run smoke tests
        run: npm run test:e2e:smoke
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: pr-smoke-results
          path: playwright-report/
      
      - name: Comment on PR
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '❌ Smoke tests failed! Please review the test results and fix any issues before merging.'
            })
```

#### 10.2.3 Pre-Release Validation (Automated)

**Trigger:** On release branch creation

**Suite:** Full (P0 + P1 + P2)

**Configuration:**

- **Platform:** CI/CD + Staging Environment
- **Browsers:** All (Chromium, Firefox, WebKit)
- **Parallelization:** 8 workers
- **Timeout:** 90 minutes
- **Retry:** 2 retries on failure
- **Blocking:** Release cannot proceed if full suite fails

#### 10.2.4 On-Demand Execution (Manual)

**Trigger:** Developer/QA manually triggers test run

**Suite:** Any suite (configurable)

**Use Cases:**

- Debug specific test failures
- Validate bug fixes
- Test new feature implementation
- Run subset of tests for specific feature

**Commands:**

```bash
# Run all tests
npm run test:e2e

# Run specific suite
npm run test:e2e:smoke
npm run test:e2e:regression
npm run test:e2e:full

# Run specific test file
npm run test:e2e -- tests/e2e/scenarios/authentication/login.spec.ts

# Run tests with UI mode (for debugging)
npm run test:e2e:ui

# Run tests in specific browser
npm run test:e2e -- --project=firefox
```

### 10.3 Execution Triggers

**Trigger Matrix:**

| Trigger | Suite | Browsers | Blocking | Notification |
|---------|-------|----------|----------|--------------|
| **PR Created** | Smoke | Chromium | Yes (merge blocked) | PR comment on failure |
| **PR Updated** | Smoke | Chromium | Yes (merge blocked) | PR comment on failure |
| **Merge to Main** | Regression | All | No (alert only) | Slack on failure |
| **Nightly Build** | Regression | All | No (alert only) | Slack on failure |
| **Release Branch** | Full | All | Yes (release blocked) | Email + Slack on failure |
| **Manual Trigger** | Configurable | Configurable | No | N/A |
| **Weekly Schedule** | Extended | All | No (alert only) | Email report |

### 10.4 Parallel Execution Strategy

**Parallelization Configuration:**

```typescript
// playwright.config.ts
export default {
  workers: process.env.CI ? 8 : 2,
  fullyParallel: true,
  
  // Retry failed tests
  retries: process.env.CI ? 2 : 0,
  
  // Shard tests across multiple machines
  shard: process.env.SHARD
    ? { current: parseInt(process.env.SHARD_INDEX), total: parseInt(process.env.SHARD_TOTAL) }
    : undefined
}
```

**GitHub Actions Matrix Strategy:**

```yaml
# .github/workflows/parallel-e2e.yml
name: Parallel E2E Tests

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        shard: [1, 2, 3, 4]  # 4 parallel jobs
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Run tests (shard ${{ matrix.shard }}/4)
        run: npm run test:e2e -- --shard=${{ matrix.shard }}/4
        env:
          SHARD_INDEX: ${{ matrix.shard }}
          SHARD_TOTAL: 4
```

**Benefits of Parallelization:**

- Reduces total execution time (60 min suite → 15 min with 4 workers)
- Faster feedback loop for developers
- More efficient use of CI resources

### 10.5 Test Execution Sequence

**Execution Order:**

1. **Setup Phase** (runs once before all tests)
   - Start database
   - Start backend service
   - Start mock services
   - Seed baseline data

2. **Authentication Tests** (run first, can be used by other tests)
   - Login/logout tests
   - Create authenticated sessions for reuse

3. **Independent Tests** (run in parallel)
   - Tests with no dependencies on each other
   - Majority of test suite

4. **Dependent Tests** (run sequentially if needed)
   - Tests that require specific state from previous tests
   - Avoid when possible (prefer independent tests)

5. **Teardown Phase** (runs once after all tests)
   - Cleanup database
   - Stop services
   - Archive test results

**Example Test Dependencies:**

```typescript
// Use test.serial for sequential execution (avoid when possible)
test.serial('create product', async ({ page }) => {
  // Creates product that next test uses
})

test.serial('edit product', async ({ page }) => {
  // Depends on product created in previous test
})

// BETTER: Make tests independent
test('create and edit product', async ({ page }) => {
  // Create product
  const product = await createTestProduct()
  
  // Edit product (same test, no dependency)
  await editProduct(product.id)
})
```

---

## 11. Reporting

### 11.1 Test Result Reports

#### 11.1.1 HTML Report (Playwright built-in)

**Features:**

- ✅ Overview of test results (passed/failed/skipped)
- ✅ Individual test details
- ✅ Screenshots on failure
- ✅ Video recordings on failure
- ✅ Trace viewer for debugging

**Configuration:**

```typescript
// playwright.config.ts
export default {
  reporter: [
    ['html', { 
      outputFolder: 'playwright-report', 
      open: 'never' // Don't auto-open in CI
    }]
  ]
}
```

**View Report:**

```bash
npx playwright show-report
```

**Report Structure:**

```
playwright-report/
├── index.html           # Main report
├── data/
│   ├── screenshots/
│   ├── videos/
│   └── traces/
└── assets/
```

#### 11.1.2 JSON Report (for CI integration)

**Configuration:**

```typescript
reporter: [
  ['json', { outputFile: 'test-results/results.json' }]
]
```

**Sample JSON Output:**

```json
{
  "stats": {
    "total": 50,
    "passed": 45,
    "failed": 3,
    "skipped": 2,
    "duration": 120000
  },
  "suites": [
    {
      "title": "Authentication",
      "tests": [
        {
          "title": "should login successfully",
          "status": "passed",
          "duration": 2500
        },
        {
          "title": "should show error for invalid credentials",
          "status": "failed",
          "error": "Expected error message not displayed",
          "screenshot": "screenshots/auth-login-fail-1.png"
        }
      ]
    }
  ]
}
```

#### 11.1.3 JUnit XML Report (for Jenkins/Azure DevOps)

**Configuration:**

```typescript
reporter: [
  ['junit', { outputFile: 'test-results/junit.xml' }]
]
```

**Sample XML Output:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites tests="50" failures="3" time="120.5">
  <testsuite name="Authentication" tests="10" failures="1" time="25.3">
    <testcase name="should login successfully" classname="authentication.login" time="2.5"/>
    <testcase name="should show error for invalid credentials" classname="authentication.login" time="3.1">
      <failure message="Expected error message not displayed">
        Expected: "Invalid email or password"
        Received: ""
      </failure>
    </testcase>
  </testsuite>
</testsuites>
```

### 11.2 Dashboard and Visualization

#### 11.2.1 Allure Report (Recommended)

**Installation:**

```bash
npm install --save-dev allure-playwright
```

**Configuration:**

```typescript
// playwright.config.ts
reporter: [
  ['allure-playwright', { 
    outputFolder: 'allure-results',
    detail: true,
    suiteTitle: true
  }]
]
```

**Generate and View:**

```bash
npm run test:e2e
npx allure generate allure-results -o allure-report --clean
npx allure open allure-report
```

**Features:**

- ✅ Test history trends
- ✅ Test duration trends
- ✅ Flakiness detection
- ✅ Category-wise breakdown
- ✅ Screenshots and logs integrated
- ✅ Test case documentation

**Screenshot Example:**

```
┌─────────────────────────────────────┐
│ Allure Report Dashboard             │
├─────────────────────────────────────┤
│ Total: 50    Passed: 45   Failed: 3 │
│ Skipped: 2   Flaky: 1                │
│                                      │
│ Pass Rate: 90%  Duration: 2m 15s    │
│                                      │
│ Trend (last 7 days):                 │
│ ████████░░ 90% pass rate             │
└─────────────────────────────────────┘
```

#### 11.2.2 ReportPortal (Enterprise)

**Purpose:** Centralized test automation reporting and analysis

**Features:**

- ✅ Multi-project support
- ✅ Real-time test execution tracking
- ✅ ML-powered failure analysis
- ✅ Defect triage and tracking
- ✅ Integration with Jira, Slack

**Setup:**

```bash
npm install --save-dev @reportportal/agent-js-playwright
```

**Configuration:**

```typescript
// playwright.config.ts
reporter: [
  ['@reportportal/agent-js-playwright', {
    apiKey: process.env.REPORTPORTAL_API_KEY,
    endpoint: 'https://reportportal.example.com',
    project: 'e2e-tests',
    launch: 'E2E Test Run',
    description: 'Automated E2E test execution'
  }]
]
```

#### 11.2.3 Custom Dashboard (Grafana + InfluxDB)

**Purpose:** Real-time metrics and trends visualization

**Metrics to Track:**

- Pass/fail rate over time
- Test execution duration
- Flakiness rate
- Coverage by priority (P0/P1/P2/P3)
- Browser-specific failures

**Setup InfluxDB:**

```typescript
// helpers/metrics.ts
import { InfluxDB, Point } from '@influxdata/influxdb-client'

const influx = new InfluxDB({ url: process.env.INFLUX_URL, token: process.env.INFLUX_TOKEN })
const writeApi = influx.getWriteApi('myorg', 'mybucket')

export function logTestResult(test: any) {
  const point = new Point('test_result')
    .tag('test_name', test.name)
    .tag('status', test.status)
    .tag('priority', test.priority)
    .floatField('duration', test.duration)
  
  writeApi.writePoint(point)
}
```

**Grafana Dashboard:**

- Line chart: Pass rate trend (last 30 days)
- Bar chart: Test duration by suite
- Heatmap: Flaky tests
- Gauge: Current pass rate

### 11.3 Failure Notifications

#### 11.3.1 Slack Notifications

**Configuration:**

```yaml
# .github/workflows/e2e-tests.yml
- name: Notify Slack on failure
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "❌ E2E Tests Failed",
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*E2E Test Failure*\n\nWorkflow: ${{ github.workflow }}\nBranch: ${{ github.ref }}\nCommit: ${{ github.sha }}\n\n<${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}|View Details>"
            }
          }
        ]
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

**Example Slack Message:**

```
❌ E2E Tests Failed

Workflow: Nightly E2E Tests
Branch: main
Commit: abc1234

3 tests failed:
- authentication/login.spec.ts: should handle invalid credentials
- checkout/payment.spec.ts: should process payment successfully
- admin/user-management.spec.ts: should delete user

View Details: [Link to GitHub Actions run]
```

#### 11.3.2 Email Notifications

**Configuration:**

```yaml
- name: Send email on failure
  if: failure()
  uses: dawidd6/action-send-mail@v3
  with:
    server_address: smtp.gmail.com
    server_port: 465
    username: ${{ secrets.EMAIL_USERNAME }}
    password: ${{ secrets.EMAIL_PASSWORD }}
    subject: "❌ E2E Tests Failed - ${{ github.ref }}"
    to: qa-team@example.com
    from: ci@example.com
    body: |
      E2E test suite has failed.
      
      Workflow: ${{ github.workflow }}
      Branch: ${{ github.ref }}
      Commit: ${{ github.sha }}
      
      Please review the test results and take necessary action.
      
      View full report: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
    attachments: test-results/junit.xml
```

#### 11.3.3 GitHub PR Comments

**Configuration:**

```yaml
- name: Comment on PR with test results
  if: always() && github.event_name == 'pull_request'
  uses: actions/github-script@v6
  with:
    script: |
      const fs = require('fs')
      const results = JSON.parse(fs.readFileSync('test-results/results.json', 'utf8'))
      
      const passed = results.stats.passed
      const failed = results.stats.failed
      const total = results.stats.total
      const passRate = ((passed / total) * 100).toFixed(1)
      
      const status = failed === 0 ? '✅' : '❌'
      const comment = `
      ${status} **E2E Test Results**
      
      - Total: ${total}
      - Passed: ${passed}
      - Failed: ${failed}
      - Pass Rate: ${passRate}%
      
      ${failed > 0 ? `
      **Failed Tests:**
      ${results.suites.flatMap(s => s.tests.filter(t => t.status === 'failed').map(t => `- ${s.title} / ${t.title}`)).join('\n')}
      ` : ''}
      
      [View Full Report](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})
      `
      
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: comment
      })
```

### 11.4 Metrics Tracking

**Key Metrics:**

| Metric | Description | Target | Tracking Method |
|--------|-------------|--------|-----------------|
| **Pass Rate** | % of tests passing | >95% for P0, >90% for P1 | Daily trend in dashboard |
| **Execution Time** | Total test suite duration | <60 min for regression | Monitor spikes |
| **Flakiness Rate** | % of tests that fail intermittently | <5% | Track over 7 days |
| **Coverage** | % of user journeys covered | 100% for P0 | Manual audit quarterly |
| **Mean Time to Detect (MTTD)** | Time from bug introduction to detection | <24 hours | Measure from commit to test failure |
| **Mean Time to Repair (MTTR)** | Time from test failure to fix | <4 hours for P0 | Track ticket resolution time |

**Tracking Tools:**

- **InfluxDB + Grafana**: Real-time metrics dashboards
- **Allure Report**: Historical trends
- **Custom Scripts**: Flakiness detection and reporting

**Example Metrics Dashboard:**

```
┌──────────────────────────────────────────────────────────┐
│ E2E Test Metrics Dashboard                               │
├──────────────────────────────────────────────────────────┤
│                                                           │
│ Pass Rate Trend (Last 30 Days)                           │
│ ████████████████████░░░ 95%                              │
│                                                           │
│ Execution Time (Regression Suite)                        │
│ Average: 35 minutes                                      │
│ Last run: 38 minutes (+3 min)                            │
│                                                           │
│ Flakiness Rate                                            │
│ Current: 3.2% (2/62 tests)                               │
│ Flaky tests: login.spec.ts, payment.spec.ts              │
│                                                           │
│ Coverage by Priority                                      │
│ P0: 100% (12/12 scenarios)                               │
│ P1: 92% (24/26 scenarios)                                │
│ P2: 65% (13/20 scenarios)                                │
│                                                           │
│ MTTD: 18 hours                                            │
│ MTTR (P0): 2.5 hours                                      │
└──────────────────────────────────────────────────────────┘
```

---

## 12. Maintenance

### 12.1 Test Suite Maintenance Schedule

**Maintenance Activities:**

| Activity | Frequency | Owner | Purpose |
|----------|-----------|-------|---------|
| **Flaky Test Review** | Weekly | QA Lead | Identify and fix intermittent failures |
| **Test Data Refresh** | Weekly | QA Engineer | Update fixtures and seed data |
| **Obsolete Test Removal** | Monthly | QA Team | Remove tests for deprecated features |
| **Test Refactoring** | Monthly | QA Engineer | Improve test code quality |
| **Dependency Updates** | Quarterly | DevOps | Update test framework and libraries |
| **Full Audit** | Quarterly | QA Lead | Review coverage, gaps, redundancy |

### 12.2 Flaky Test Management

**Flaky Test Definition:**
A test that fails intermittently without code changes (passes sometimes, fails other times)

**Common Causes:**

- Timing issues (race conditions, insufficient waits)
- Test data conflicts (non-unique identifiers)
- Network instability
- External service flakiness
- Resource contention (parallel execution conflicts)

**Identification Process:**

1. **Automated Detection:**

   ```typescript
   // Track test failures in InfluxDB
   export function trackTestRun(test: Test) {
     const point = new Point('test_execution')
       .tag('test_name', test.name)
       .tag('status', test.status)
       .tag('run_id', process.env.CI_RUN_ID)
       .intField('retry_count', test.retries)
     
     writeApi.writePoint(point)
   }
   
   // Query for flaky tests (>5% failure rate over 7 days)
   SELECT 
     test_name,
     COUNT(*) as total_runs,
     SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) as failures,
     (failures / total_runs) * 100 as failure_rate
   FROM test_execution
   WHERE time > NOW() - 7d
   GROUP BY test_name
   HAVING failure_rate > 5 AND failure_rate < 100
   ```

2. **Manual Review:**
   - Review test results daily
   - Look for tests that fail inconsistently
   - Check CI logs for retry patterns

**Resolution Process:**

1. **Investigate Root Cause:**
   - Run test locally multiple times
   - Review screenshots/videos of failures
   - Check timing logs
   - Inspect test data

2. **Fix Common Issues:**

   **Problem: Race Condition**

   ```typescript
   // ❌ BAD: No explicit wait
   await page.click('button')
   await expect(page.locator('.result')).toBeVisible()
   
   // ✅ GOOD: Wait for network idle
   await page.click('button')
   await page.waitForLoadState('networkidle')
   await expect(page.locator('.result')).toBeVisible()
   ```

   **Problem: Non-Unique Test Data**

   ```typescript
   // ❌ BAD: Static email (conflicts in parallel runs)
   const email = 'test@example.com'
   
   // ✅ GOOD: Unique email per test
   const email = `test-${Date.now()}-${Math.random()}@example.com`
   ```

   **Problem: External Service Timeout**

   ```typescript
   // ❌ BAD: Real API call (unreliable)
   await api.post('https://external-service.com/api')
   
   // ✅ GOOD: Mock external service
   await page.route('**/external-service.com/api', route => {
     route.fulfill({ status: 200, body: '{"success": true}' })
   })
   ```

3. **Quarantine If Needed:**

   ```typescript
   // Temporarily skip flaky test while fixing
   test.skip('flaky test - investigating', async ({ page }) => {
     // Test code
   })
   ```

4. **Document Fix:**

   ```typescript
   // Document why fix was needed
   test('user can login successfully', async ({ page }) => {
     // FIX: Added waitForLoadState to prevent race condition
     // where dashboard loaded before authentication token was set
     await loginPage.login('test@example.com', 'Test123!')
     await page.waitForLoadState('networkidle')
     await expect(page).toHaveURL('/dashboard')
   })
   ```

### 12.3 Test Refactoring

**When to Refactor:**

- Tests are difficult to understand
- High code duplication across tests
- Tests are slow or flaky
- Tests are brittle (break on minor UI changes)
- New patterns emerge that improve maintainability

**Refactoring Techniques:**

**1. Extract Page Objects:**

```typescript
// BEFORE: Inline selectors
test('user can login', async ({ page }) => {
  await page.locator('#email').fill('test@example.com')
  await page.locator('#password').fill('Test123!')
  await page.locator('button[type="submit"]').click()
})

// AFTER: Page object
const loginPage = new LoginPage(page)
await loginPage.login('test@example.com', 'Test123!')
```

**2. Extract Common Setup:**

```typescript
// BEFORE: Repeated setup
test('test 1', async ({ page }) => {
  const user = await createUser()
  await loginAs(page, user)
  await page.goto('/dashboard')
  // Test code
})

test('test 2', async ({ page }) => {
  const user = await createUser()
  await loginAs(page, user)
  await page.goto('/dashboard')
  // Test code
})

// AFTER: Test fixture
test.extend({
  authenticatedPage: async ({ page }, use) => {
    const user = await createUser()
    await loginAs(page, user)
    await page.goto('/dashboard')
    await use(page)
  }
})

test('test 1', async ({ authenticatedPage }) => {
  // Test code
})

test('test 2', async ({ authenticatedPage }) => {
  // Test code
})
```

**3. Consolidate Similar Tests:**

```typescript
// BEFORE: Separate tests for similar scenarios
test('login with email lowercase', async ({ page }) => {
  await login('user@example.com', 'Test123!')
})

test('login with email uppercase', async ({ page }) => {
  await login('USER@EXAMPLE.COM', 'Test123!')
})

test('login with email mixed case', async ({ page }) => {
  await login('User@Example.com', 'Test123!')
})

// AFTER: Parameterized test
const emails = ['user@example.com', 'USER@EXAMPLE.COM', 'User@Example.com']

for (const email of emails) {
  test(`login with email: ${email}`, async ({ page }) => {
    await login(email, 'Test123!')
  })
}
```

### 12.4 Update Process for New Features

**Workflow:**

1. **Feature Specification Created:**
   - QA reviews spec and identifies test scenarios
   - QA creates test plan for feature (if needed)

2. **Feature Development Starts:**
   - Developer implements feature
   - Developer writes unit/integration tests

3. **Feature Ready for E2E Tests:**
   - QA writes E2E test scenarios based on spec
   - QA implements tests in test suite
   - QA updates test data fixtures if needed

4. **Tests Integrated:**
   - Add tests to appropriate suite (smoke/regression)
   - Tag tests with priority (@smoke, @regression, etc.)
   - Run tests locally to verify

5. **PR Review:**
   - Code review includes E2E test review
   - Verify test coverage matches spec
   - Ensure tests follow coding standards

6. **Merge and Monitor:**
   - Merge feature + tests together
   - Monitor CI for any flakiness
   - Update documentation if needed

**Example Feature Update:**

```typescript
// Feature: User profile picture upload

// 1. QA identifies test scenarios:
// - Upload valid image (happy path)
// - Upload invalid file type (error path)
// - Upload oversized file (error path)

// 2. QA implements E2E tests:
test('@regression user can upload profile picture', async ({ page }) => {
  const profilePage = new ProfilePage(page)
  await profilePage.navigate()
  await profilePage.uploadProfilePicture('fixtures/test-avatar.jpg')
  
  await expect(profilePage.profileImage).toHaveAttribute('src', /uploads\//)
})

test('@regression upload invalid file shows error', async ({ page }) => {
  const profilePage = new ProfilePage(page)
  await profilePage.navigate()
  await profilePage.uploadProfilePicture('fixtures/test-document.pdf')
  
  await expect(profilePage.errorMessage).toContainText('Invalid file type')
})

// 3. Update fixtures:
// - Add fixtures/test-avatar.jpg
// - Add fixtures/test-document.pdf
// - Add fixtures/test-large-image.jpg

// 4. Update ProfilePage page object:
export class ProfilePage extends BasePage {
  readonly uploadButton: Locator
  readonly profileImage: Locator
  readonly errorMessage: Locator
  
  async uploadProfilePicture(filePath: string) {
    await this.uploadButton.setInputFiles(filePath)
    await this.page.waitForLoadState('networkidle')
  }
}

// 5. Add tests to regression suite (already tagged with @regression)

// 6. Update docs/e2e-test-plan.md with new scenarios
```

### 12.5 Dependency Management

**Regular Updates:**

**1. Weekly Security Updates:**

```bash
npm audit
npm audit fix
```

**2. Monthly Dependency Updates:**

```bash
npm outdated
npm update
```

**3. Quarterly Major Updates:**

```bash
# Update Playwright
npm install --save-dev @playwright/test@latest

# Update other testing dependencies
npm install --save-dev @faker-js/faker@latest
```

**Version Pinning:**

```json
// package.json
{
  "devDependencies": {
    "@playwright/test": "1.40.0",  // Pin exact version
    "@faker-js/faker": "^8.0.0"    // Allow patch updates
  }
}
```

**Update Process:**

1. Create feature branch
2. Update dependencies
3. Run full test suite
4. Fix any breaking changes
5. Create PR with change summary
6. Merge after review

### 12.6 Documentation Updates

**Update When:**

- New features added
- Test architecture changes
- New tools integrated
- Best practices evolve

**Documents to Update:**

- `docs/e2e-test-plan.md` - This document
- `tests/e2e/README.md` - Quick start guide
- Test scenario catalog (if separate)
- Test data guide (if separate)

**Review Schedule:**

- Monthly: Quick review for outdated information
- Quarterly: Full audit and update

---

## 13. Appendices

### 13.1 Glossary

**E2E Testing:** End-to-end testing validates the complete user workflow from UI to database, including all integration points.

**Smoke Test:** A minimal set of critical tests to verify system viability (typically P0 scenarios only).

**Regression Test:** A comprehensive test suite to verify no existing functionality broke (typically P0 + P1 scenarios).

**Flaky Test:** A test that fails intermittently without code changes, often due to timing issues or external dependencies.

**Page Object Model (POM):** Design pattern that encapsulates page interactions into reusable objects.

**Test Fixture:** Predefined test data or setup code reused across multiple tests.

**Test Factory:** Programmatic generation of test data using libraries like Faker.js.

**Mocking:** Simulating external service behavior for testing purposes (e.g., payment gateway, email service).

**Parallel Execution:** Running multiple tests simultaneously to reduce total execution time.

**Shard:** Splitting test suite into multiple parts to run on separate machines/workers.

### 13.2 References

**Documentation:**

- [Playwright Documentation](https://playwright.dev)
- [Cypress Documentation](https://docs.cypress.io)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Appium Documentation](http://appium.io/docs/en/)

**Project Documents:**

- `docs/architecture.md` - System architecture
- `docs/ground-rules.md` - Project principles
- `docs/standards.md` - Coding standards
- Feature specifications in `specs/*/spec.md`

**Tools:**

- [Faker.js](https://fakerjs.dev) - Test data generation
- [MSW](https://mswjs.io) - API mocking
- [Allure Report](https://docs.qameta.io/allure/) - Test reporting
- [Percy](https://percy.io) - Visual testing

### 13.3 Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Author] | Initial E2E test plan created |
| 1.1 | [Date] | [Author] | Added mobile testing scenarios |
| 1.2 | [Date] | [Author] | Updated test data strategy |

### 13.4 Approval

**Document Status:** [Draft | Under Review | Approved]

**Approvers:**

| Name | Role | Signature | Date |
|------|------|-----------|------|
| [Name] | QA Lead | | |
| [Name] | Engineering Manager | | |
| [Name] | Product Manager | | |

---

**End of E2E Test Plan**
