# E2E Test Scenario Examples

This document provides comprehensive examples of E2E test scenarios and user journeys.

## User Journey Examples

### E-commerce Application

**Guest User Purchase Journey**
1. User lands on homepage
2. Browses product catalog (filters by category, price)
3. Views product details
4. Adds product to cart
5. Proceeds to checkout (guest checkout)
6. Enters shipping information
7. Selects shipping method
8. Enters payment information
9. Reviews order summary
10. Confirms purchase
11. Receives order confirmation (email sent)

**Registered User Journey**
1. User logs in with email/password
2. Dashboard displays personalized recommendations
3. Browses products (filters, search)
4. Adds multiple products to cart
5. Applies discount code
6. Proceeds to checkout (saved address and payment)
7. Completes purchase with one-click
8. Views order history
9. Logs out

**Admin User Journey**
1. Admin logs in with admin credentials
2. Accesses admin dashboard
3. Views sales analytics and reports
4. Manages product inventory (add/edit/delete products)
5. Reviews pending orders
6. Processes refund for customer
7. Sends notification email to users
8. Logs out

### SaaS Application

**Free Trial Signup Journey**
1. User visits pricing page
2. Clicks "Start Free Trial"
3. Fills registration form (name, email, password)
4. Verifies email address (clicks link in email)
5. Completes onboarding wizard (profile setup, preferences)
6. Explores dashboard (tooltips guide user)
7. Creates first project
8. Invites team member
9. Performs core action (e.g., creates a task, uploads a file)
10. Views usage statistics

**Subscription Upgrade Journey**
1. User logs in
2. Navigates to account settings
3. Views current plan and usage
4. Clicks "Upgrade Plan"
5. Selects higher-tier plan
6. Enters payment information (credit card)
7. Confirms upgrade
8. Receives confirmation and access to premium features
9. Tests premium feature (e.g., advanced analytics)

**Collaboration Journey**
1. Team owner creates a workspace
2. Invites team members (sends email invitations)
3. Team member receives email and joins workspace
4. Owner creates a shared project
5. Team member collaborates (adds comments, edits content)
6. Owner reviews changes and approves
7. System sends notification to team
8. Both users view updated project

### Social Media Application

**User Onboarding Journey**
1. New user signs up with email/Google/Facebook
2. Fills out profile information (name, bio, avatar)
3. Connects accounts (import contacts from email)
4. Follows suggested users
5. Creates first post (text, image, video)
6. Receives likes and comments from followers
7. Responds to comments
8. Explores feed (scrolls, likes, shares)

**Content Creation Journey**
1. User logs in
2. Clicks "Create Post"
3. Writes post content (text, hashtags)
4. Uploads media (image, video)
5. Tags friends in post
6. Selects audience (public, friends, private)
7. Schedules post for later or publishes immediately
8. Post appears in followers' feeds
9. Receives notifications on interactions

## Test Scenario Examples by Feature

### Authentication

**Login Scenarios**
- **Happy Path**: Valid email and password → Redirects to dashboard
- **Invalid Email**: Non-existent email → Shows "User not found" error
- **Invalid Password**: Correct email, wrong password → Shows "Invalid password" error
- **Empty Fields**: Submit empty form → Shows validation errors
- **SQL Injection**: Enter `' OR '1'='1` → Sanitizes input, shows error
- **Rate Limiting**: 5 failed attempts → Account temporarily locked, shows warning
- **Remember Me**: Check "Remember Me" → Session persists after browser close
- **Social Login**: Login with Google/Facebook → Authenticates via OAuth, redirects to dashboard

**Registration Scenarios**
- **Happy Path**: Valid details → Creates account, sends verification email
- **Duplicate Email**: Already registered email → Shows "Email already in use" error
- **Weak Password**: Password "123" → Shows "Password too weak" error
- **Password Mismatch**: Passwords don't match → Shows validation error
- **Email Verification**: Click link in email → Account activated
- **Resend Verification**: Request new verification email → Email sent again

**Password Reset Scenarios**
- **Request Reset**: Enter email → Sends reset link via email
- **Reset with Valid Token**: Click link, enter new password → Password updated
- **Reset with Expired Token**: Use old link → Shows "Token expired" error
- **Reset with Used Token**: Reuse token → Shows "Token already used" error

### E-commerce Checkout

**Cart Management Scenarios**
- **Add to Cart**: Click "Add to Cart" → Product added, cart count updates
- **Update Quantity**: Change quantity to 3 → Cart updates, total recalculated
- **Remove Item**: Click "Remove" → Item removed from cart
- **Empty Cart**: Remove all items → Shows "Your cart is empty" message
- **Cart Persistence**: Add items, close browser, reopen → Cart items persist (for logged-in users)

**Checkout Scenarios**
- **Happy Path**: Complete all steps → Order placed, confirmation email sent
- **Invalid Shipping Address**: Enter invalid zip code → Shows validation error
- **Expired Credit Card**: Enter expired card → Payment fails, shows error
- **Insufficient Funds**: Card declined → Shows "Payment failed" error
- **Apply Coupon**: Enter valid coupon code → Discount applied, total updated
- **Apply Invalid Coupon**: Enter expired coupon → Shows "Coupon invalid" error
- **Guest Checkout**: Complete purchase without account → Order placed, optional account creation prompt
- **Saved Payment**: Use saved payment method → One-click checkout

### Form Submissions

**Contact Form Scenarios**
- **Happy Path**: Fill all required fields → Form submitted, confirmation message
- **Missing Required Fields**: Leave name empty → Shows "Name is required" error
- **Invalid Email Format**: Enter "notanemail" → Shows "Invalid email" error
- **CAPTCHA**: Complete CAPTCHA → Form submission allowed
- **CAPTCHA Failure**: Fail CAPTCHA → Shows "CAPTCHA failed" error
- **File Upload**: Attach file (< 5MB) → File uploaded successfully
- **Large File Upload**: Attach 20MB file → Shows "File too large" error

### Search and Filtering

**Search Scenarios**
- **Keyword Search**: Search "laptop" → Returns relevant results
- **No Results**: Search "xyz123" → Shows "No results found" message
- **Autocomplete**: Type "lap" → Suggests "laptop", "lap desk"
- **Filter by Category**: Select "Electronics" → Shows only electronics
- **Filter by Price Range**: Set $100-$500 → Shows products in range
- **Multiple Filters**: Category + Price + Brand → Shows narrowed results
- **Sort by Price**: Sort ascending → Products sorted low to high
- **Pagination**: Click "Next Page" → Loads page 2 of results

### User Profile

**Profile Management Scenarios**
- **View Profile**: Click "Profile" → Displays user information
- **Edit Profile**: Update name, bio → Changes saved, confirmation message
- **Upload Avatar**: Upload new profile picture → Image updated
- **Change Password**: Enter old and new passwords → Password updated
- **Invalid Old Password**: Enter wrong old password → Shows "Incorrect password" error
- **Change Email**: Enter new email → Verification email sent
- **Verify New Email**: Click verification link → Email updated
- **Delete Account**: Confirm account deletion → Account deleted, logged out

## Test Data Examples

### User Data

**Valid User**
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePassword123!",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1234567890",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zip": "10001",
    "country": "USA"
  }
}
```

**Invalid User (Missing Fields)**
```json
{
  "email": "invalid-user",
  "password": "123"
}
```

**Malicious Input (XSS Attempt)**
```json
{
  "name": "<script>alert('XSS')</script>",
  "bio": "<img src=x onerror=alert('XSS')>"
}
```

### Product Data

**Valid Product**
```json
{
  "id": "prod-001",
  "name": "Laptop Pro 15",
  "description": "High-performance laptop for professionals",
  "price": 1299.99,
  "currency": "USD",
  "category": "Electronics",
  "stock": 50,
  "images": ["laptop-1.jpg", "laptop-2.jpg"],
  "specifications": {
    "processor": "Intel i7",
    "ram": "16GB",
    "storage": "512GB SSD"
  }
}
```

### Order Data

**Valid Order**
```json
{
  "orderId": "ORD-2023-001",
  "userId": "user-123",
  "items": [
    {
      "productId": "prod-001",
      "quantity": 1,
      "price": 1299.99
    }
  ],
  "shippingAddress": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zip": "10001"
  },
  "paymentMethod": {
    "type": "credit_card",
    "last4": "1234"
  },
  "total": 1299.99,
  "status": "pending"
}
```

## API Response Examples

### Successful Response

**GET /api/products**
```json
{
  "status": "success",
  "data": {
    "products": [
      {
        "id": "prod-001",
        "name": "Laptop Pro 15",
        "price": 1299.99
      }
    ],
    "pagination": {
      "page": 1,
      "totalPages": 10,
      "totalItems": 100
    }
  }
}
```

### Error Response

**POST /api/orders (Invalid Data)**
```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": [
    {
      "field": "items",
      "message": "At least one item is required"
    },
    {
      "field": "shippingAddress.zip",
      "message": "Invalid ZIP code"
    }
  ]
}
```

### Authentication Error

**GET /api/profile (Unauthorized)**
```json
{
  "status": "error",
  "message": "Unauthorized",
  "code": 401
}
```

## Edge Cases and Negative Scenarios

### Concurrency Issues
- **Simultaneous Purchase**: Two users buy the last item → Only one succeeds, other sees "Out of stock"
- **Double Click Submit**: User clicks "Submit" twice rapidly → Only one form submission processes
- **Session Expiry During Action**: Session expires while filling form → Redirect to login, preserve form data

### Network Issues
- **Slow Connection**: Simulate 3G connection → Page loads gracefully, shows loading indicators
- **Connection Loss**: Disconnect network mid-action → Shows "Connection lost" message, retries when reconnected
- **API Timeout**: API takes >30s to respond → Shows timeout error, option to retry

### Browser Compatibility
- **Old Browser**: Test in IE11 (if supported) → Polyfills work, core functionality available
- **Disabled JavaScript**: Turn off JS → Shows message "JavaScript required" or graceful degradation
- **Disabled Cookies**: Block cookies → Authentication fails, shows warning

### Security Testing
- **XSS Attack**: Enter `<script>alert('XSS')</script>` → Input sanitized, script not executed
- **SQL Injection**: Enter `' OR '1'='1' --` → Input sanitized, no database breach
- **CSRF Token**: Submit form without CSRF token → Request rejected
- **Brute Force**: 100 rapid login attempts → Account locked, IP blocked

### Data Integrity
- **Duplicate Submission**: Submit same form twice → Only one record created
- **Transaction Rollback**: Payment fails mid-checkout → Cart restored, no partial order created
- **Data Consistency**: Update user profile → Changes reflected across all pages immediately

## Test Naming Conventions

**Pattern**: `should_{expected_outcome}_when_{condition}`

**Examples:**
- `should_display_dashboard_when_user_logs_in_successfully`
- `should_show_error_message_when_login_with_invalid_credentials`
- `should_add_product_to_cart_when_user_clicks_add_to_cart_button`
- `should_calculate_correct_total_when_applying_discount_coupon`
- `should_prevent_checkout_when_cart_is_empty`
- `should_send_verification_email_when_user_registers`
- `should_redirect_to_login_when_accessing_protected_route_unauthorized`

**Descriptive Names (Alternative):**
- `test_successful_user_registration_with_email_verification`
- `test_cart_quantity_update_and_total_recalculation`
- `test_checkout_with_saved_payment_method`
- `test_admin_can_manage_product_inventory`
