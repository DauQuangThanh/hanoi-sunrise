# File Structure and API Patterns

This document provides detailed patterns for file structure, API design, and database conventions.

## File Naming Conventions

### Source Code Files
**Match class/module name with appropriate extension**

**Java**:
```
UserService.java
PaymentProcessor.java
DataValidator.java
```

**Python**:
```
user_service.py
payment_processor.py
data_validator.py
```

**TypeScript**:
```
user-service.ts
UserService.ts
payment-processor.ts
```

**Go**:
```
user_service.go
payment_processor.go
data_validator.go
```

### Test Files
**Suffix or prefix convention**

**Jest/TypeScript**:
```
UserService.test.ts
UserService.spec.ts
user-service.test.ts
```

**Python (pytest)**:
```
test_user_service.py
user_service_test.py
```

**Java (JUnit)**:
```
UserServiceTest.java
PaymentProcessorTest.java
```

**Go**:
```
user_service_test.go
payment_processor_test.go
```

### Configuration Files
**Lowercase, descriptive**

```
.eslintrc.js
.prettierrc.json
jest.config.js
webpack.config.js
tsconfig.json
pyproject.toml
pytest.ini
Cargo.toml
go.mod
```

### Documentation Files
**Uppercase or capitalized**

```
README.md
CONTRIBUTING.md
CHANGELOG.md
LICENSE
API.md
ARCHITECTURE.md
```

## Directory Structure Standards

### Feature-Based Organization
```
src/
  features/
    user/
      components/
        UserProfile.tsx
        UserCard.tsx
      services/
        UserService.ts
      repositories/
        UserRepository.ts
      types/
        User.ts
      hooks/
        useUser.ts
      __tests__/
        UserService.test.ts
      index.ts
    
    payment/
      components/
        PaymentForm.tsx
      services/
        PaymentService.ts
      types/
        Payment.ts
      __tests__/
        PaymentService.test.ts
      index.ts
```

### Layer-Based Organization
```
src/
  controllers/
    UserController.ts
    PaymentController.ts
  
  services/
    UserService.ts
    PaymentService.ts
  
  repositories/
    UserRepository.ts
    PaymentRepository.ts
  
  models/
    User.ts
    Payment.ts
  
  middleware/
    authMiddleware.ts
    errorHandler.ts
  
  utils/
    logger.ts
    validator.ts
  
  __tests__/
    controllers/
    services/
    repositories/
```

### Monorepo Structure
```
packages/
  @myorg/ui/
    src/
    package.json
  
  @myorg/api/
    src/
    package.json
  
  @myorg/shared/
    src/
    package.json

apps/
  web/
    src/
    package.json
  
  mobile/
    src/
    package.json
```

## REST API Design Standards

### Endpoint Naming
**Plural nouns, lowercase, hyphens**

```
GET    /users
GET    /users/{id}
POST   /users
PUT    /users/{id}
PATCH  /users/{id}
DELETE /users/{id}

GET    /user-profiles
GET    /user-profiles/{id}
POST   /user-profiles

GET    /orders
GET    /orders/{id}/items
POST   /orders/{id}/items
```

### HTTP Methods Usage

**GET**: Retrieve resources (idempotent, no side effects)
```
GET /users           # List all users
GET /users/{id}      # Get specific user
GET /users?page=1&limit=20
```

**POST**: Create new resources (not idempotent)
```
POST /users          # Create new user
POST /orders/{id}/items  # Add item to order
```

**PUT**: Full replacement (idempotent)
```
PUT /users/{id}      # Replace entire user
```

**PATCH**: Partial update (may not be idempotent)
```
PATCH /users/{id}    # Update specific fields
```

**DELETE**: Remove resource (idempotent)
```
DELETE /users/{id}   # Delete user
DELETE /orders/{id}/items/{itemId}
```

### Query Parameters
**camelCase or snake_case**

```
GET /users?sortBy=name&order=asc&page=1&pageSize=20
GET /users?sort_by=name&order=asc&page=1&page_size=20

GET /products?category=electronics&minPrice=100&maxPrice=500
GET /orders?status=pending&createdAfter=2024-01-01
```

### Request/Response Body Structure

**Request Body (JSON)**:
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "age": 30,
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zipCode": "10001"
  }
}
```

**Response Body (Success)**:
```json
{
  "id": "user_123",
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

**Response Body (List)**:
```json
{
  "data": [
    { "id": "user_123", "name": "John Doe" },
    { "id": "user_456", "name": "Jane Smith" }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalPages": 5,
    "totalCount": 100
  }
}
```

### Error Response Format
**Consistent structure**

```json
{
  "error": {
    "code": "INVALID_INPUT",
    "message": "Email format is invalid",
    "field": "email",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "User with ID 'user_123' not found",
    "resourceType": "user",
    "resourceId": "user_123"
  }
}
```

```json
{
  "errors": [
    {
      "code": "REQUIRED_FIELD",
      "message": "First name is required",
      "field": "firstName"
    },
    {
      "code": "INVALID_FORMAT",
      "message": "Email format is invalid",
      "field": "email"
    }
  ]
}
```

### API Versioning
**URL path versioning**
```
/v1/users
/v1/orders
/v2/users
```

**Header-based versioning**
```
GET /users
Accept: application/vnd.myapi.v1+json
```

**Query parameter versioning**
```
GET /users?version=1
```

## GraphQL Design Standards

### Type Naming
**PascalCase**

```graphql
type User {
  id: ID!
  firstName: String!
  lastName: String!
  email: String!
  createdAt: DateTime!
}

type Order {
  id: ID!
  user: User!
  items: [OrderItem!]!
  totalAmount: Float!
  status: OrderStatus!
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}
```

### Field Naming
**camelCase**

```graphql
type User {
  firstName: String!
  lastName: String!
  emailAddress: String!
  phoneNumber: String
  createdAt: DateTime!
  updatedAt: DateTime!
}
```

### Query Naming
**Descriptive, verb-based**

```graphql
type Query {
  getUser(id: ID!): User
  listUsers(limit: Int, offset: Int): [User!]!
  searchUsers(query: String!): [User!]!
  
  getOrder(id: ID!): Order
  listOrders(userId: ID!, status: OrderStatus): [Order!]!
}
```

### Mutation Naming
**Verb + Object**

```graphql
type Mutation {
  createUser(input: UserInput!): User!
  updateUser(id: ID!, input: UserInput!): User!
  deleteUser(id: ID!): Boolean!
  
  createOrder(input: OrderInput!): Order!
  updateOrderStatus(id: ID!, status: OrderStatus!): Order!
  cancelOrder(id: ID!): Order!
}
```

### Input Type Naming
**{Type}Input**

```graphql
input UserInput {
  firstName: String!
  lastName: String!
  email: String!
  phoneNumber: String
}

input OrderInput {
  userId: ID!
  items: [OrderItemInput!]!
}

input OrderItemInput {
  productId: ID!
  quantity: Int!
}
```

## Database Naming Conventions

### Table Names
**Plural, snake_case or lowercase**

```sql
-- PostgreSQL/MySQL
users
user_profiles
order_items
payment_methods
shipping_addresses

-- MongoDB
users
userProfiles
orderItems
paymentMethods
```

### Column Names
**Singular, snake_case or camelCase**

```sql
-- PostgreSQL/MySQL (snake_case)
id
user_id
first_name
last_name
email_address
created_at
updated_at

-- MongoDB (camelCase)
_id
userId
firstName
lastName
emailAddress
createdAt
updatedAt
```

### Primary Key Naming
**`id` or `{table}_id`**

```sql
-- Simple ID
CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  ...
);

-- Table-prefixed ID
CREATE TABLE users (
  user_id BIGINT PRIMARY KEY,
  ...
);
```

### Foreign Key Naming
**`{referenced_table}_id`**

```sql
CREATE TABLE orders (
  id BIGINT PRIMARY KEY,
  user_id BIGINT REFERENCES users(id),
  payment_method_id BIGINT REFERENCES payment_methods(id),
  ...
);
```

### Index Naming
**`idx_{table}_{columns}`**

```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_user_id_status ON orders(user_id, status);
```

### Constraint Naming
**`{type}_{table}_{columns}`**

```sql
-- Unique constraints
ALTER TABLE users ADD CONSTRAINT uq_users_email UNIQUE (email);

-- Check constraints
ALTER TABLE users ADD CONSTRAINT chk_users_age CHECK (age >= 18);

-- Foreign key constraints
ALTER TABLE orders ADD CONSTRAINT fk_orders_user_id 
  FOREIGN KEY (user_id) REFERENCES users(id);
```

### View Naming
**`v_{descriptive_name}` or `{descriptive_name}_view`**

```sql
CREATE VIEW v_active_users AS ...;
CREATE VIEW user_orders_summary AS ...;
CREATE VIEW monthly_sales_report AS ...;
```

### Stored Procedure Naming
**`sp_{verb}_{object}` or `{verb}_{object}`**

```sql
-- Prefix style
CREATE PROCEDURE sp_get_user_orders(...) ...;
CREATE PROCEDURE sp_calculate_order_total(...) ...;

-- No prefix style
CREATE PROCEDURE get_user_orders(...) ...;
CREATE PROCEDURE calculate_order_total(...) ...;
```

### MongoDB Collection Naming
**camelCase or snake_case, plural**

```javascript
// camelCase (more common in Node.js)
db.users
db.userProfiles
db.orderItems

// snake_case
db.users
db.user_profiles
db.order_items
```

## Project Structure Patterns

### Monorepo vs Multi-Repo

**Use Monorepo when:**
- Shared code between projects
- Coordinated releases
- Consistent tooling and dependencies
- Strong team collaboration

**Use Multi-Repo when:**
- Independent deployment schedules
- Different technology stacks
- Clear ownership boundaries
- Minimal shared code

### Shared Code Organization

```
common/
  utils/
    logger.ts
    validator.ts
  types/
    common.ts
  constants/
    errors.ts

shared/
  components/
    Button.tsx
    Input.tsx
  hooks/
    useAuth.ts

lib/
  database/
    connection.ts
  messaging/
    queue.ts
```

### Build Output Directories

```
dist/           # TypeScript/JavaScript builds
build/          # React/general builds
out/            # Next.js builds
target/         # Java/Maven builds
bin/            # Go binaries
.next/          # Next.js cache
.cache/         # General cache
```

### Vendor/Third-Party Code

```
vendor/         # Go vendor directory
third_party/    # General third-party code
node_modules/   # NPM dependencies
venv/           # Python virtual environment
```

## Asset Organization

```
public/
  images/
    icons/
      user.svg
      settings.svg
    logos/
      logo.png
      logo-dark.png
  fonts/
    Inter-Regular.woff2
  documents/
    terms.pdf

assets/
  styles/
    variables.css
    reset.css
  scripts/
    analytics.js

static/
  css/
  js/
  images/
```
