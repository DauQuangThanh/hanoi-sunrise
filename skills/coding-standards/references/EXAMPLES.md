# Coding Standards Examples

This document provides detailed examples of coding standards generated for different technology stacks and project types.

## Example 1: Full-stack Web Application (React + Node.js + PostgreSQL)

**Input context:**

- `architecture.md` indicates: React frontend, Node.js/Express backend, PostgreSQL database, REST API
- `ground-rules.md` requires: TypeScript for type safety, 80% test coverage

**Output standards include:**

### UI Naming Conventions

- **Components**: PascalCase (`UserProfile`, `ProductCard`, `NavigationBar`)
- **Hooks**: `use` prefix + camelCase (`useAuth`, `useFetchData`, `useLocalStorage`)
- **Props**: camelCase (`userName`, `onSubmit`, `isLoading`)
- **CSS Modules**: `.module.css` suffix (`UserProfile.module.css`)
- **Event Handlers**: `handle` or `on` prefix (`handleClick`, `onSubmit`)

### Code Naming Conventions

- **Classes**: PascalCase (`UserService`, `DatabaseConnection`)
- **Interfaces/Types**: PascalCase with `I` prefix optional (`IUser` or `User`)
- **Variables**: camelCase (`userName`, `productList`, `isAuthenticated`)
- **Functions**: camelCase (`fetchUserData`, `calculateTotal`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_ATTEMPTS`, `API_BASE_URL`)
- **Private members**: underscore prefix (`_privateMethod`, `_internalState`)

### API Design Standards

- **Endpoints**: REST with plural resource names
  - `GET /users` - List users
  - `GET /users/:id` - Get user by ID
  - `POST /users` - Create user
  - `PUT /users/:id` - Update user
  - `DELETE /users/:id` - Delete user
- **Query parameters**: camelCase (`?sortBy=name&pageSize=20`)
- **Request/Response**: JSON with camelCase fields

### Database Conventions

- **Tables**: snake_case, plural (`users`, `product_orders`)
- **Columns**: snake_case (`first_name`, `created_at`, `is_active`)
- **Primary keys**: `id` (auto-increment integer or UUID)
- **Foreign keys**: `{table}_id` (`user_id`, `product_id`)
- **Indexes**: `idx_{table}_{column}` (`idx_users_email`)
- **Timestamps**: `created_at`, `updated_at` (automatically managed)

### Testing Standards

- **Framework**: Jest with 80% coverage requirement
- **Test files**: `.test.ts` or `.spec.ts` suffix
- **Structure**: `describe`/`it` blocks
- **Naming**: Descriptive test names ("should return user when valid ID is provided")
- **Coverage**: Minimum 80% line coverage, 70% branch coverage

### File Structure

```
src/
├── components/           # React components
│   ├── common/          # Shared components
│   └── features/        # Feature-specific components
├── hooks/               # Custom React hooks
├── services/            # API services
├── utils/               # Utility functions
├── types/               # TypeScript type definitions
└── styles/              # Global styles and CSS modules
```

---

## Example 2: Backend-only API Service (Python + MongoDB)

**Input context:**

- `architecture.md` indicates: Python FastAPI backend, MongoDB database, GraphQL API
- No UI components detected

**Output standards include:**

### UI Naming Conventions

**N/A** - No UI layer. This is a backend-only API service.

### Code Naming Conventions

- **Modules/Files**: snake_case (`user_service.py`, `database_connection.py`)
- **Classes**: PascalCase (`UserService`, `OrderProcessor`)
- **Functions**: snake_case (`get_user_by_id`, `process_payment`)
- **Variables**: snake_case (`user_data`, `total_amount`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_CONNECTIONS`, `DEFAULT_TIMEOUT`)
- **Private methods**: single underscore prefix (`_validate_input`, `_internal_process`)

Follows **PEP 8** style guide strictly.

### API Design Standards

- **GraphQL Types**: PascalCase (`User`, `Product`, `Order`)
- **GraphQL Fields**: camelCase (`firstName`, `createdAt`, `orderItems`)
- **Queries**: Descriptive names (`getUser`, `listProducts`, `searchOrders`)
- **Mutations**: Action-based names (`createUser`, `updateProduct`, `deleteOrder`)
- **Input types**: `{Type}Input` pattern (`UserInput`, `ProductInput`)

### Database Conventions

- **Collections**: snake_case, plural (`users`, `products`, `order_items`)
- **Fields**: snake_case (`first_name`, `email_address`, `created_at`)
- **IDs**: MongoDB ObjectId (default `_id` field)
- **Timestamps**: `created_at`, `updated_at` (ISO 8601 format)
- **Indexes**: Defined for frequently queried fields

### Testing Standards

- **Framework**: Pytest
- **Test files**: `test_{module}.py` prefix
- **Fixtures**: In `conftest.py`
- **Naming**: Descriptive test functions (`test_get_user_returns_user_when_exists`)
- **Coverage**: Aim for 85%+ coverage

### File Structure

```
app/
├── api/                 # API endpoints (GraphQL resolvers)
├── models/              # Data models (Pydantic)
├── services/            # Business logic
├── repositories/        # Database access layer
├── utils/               # Helper functions
└── tests/               # Test files
```

---

## Example 3: Mobile Application (React Native + Firebase)

**Input context:**

- `architecture.md` indicates: React Native mobile app, Firebase backend
- `ground-rules.md` requires: Accessibility compliance

**Output standards include:**

### UI Naming Conventions

- **Screens**: PascalCase with `Screen` suffix (`HomeScreen`, `LoginScreen`, `ProfileScreen`)
- **Components**: PascalCase (`Button`, `Card`, `UserAvatar`)
- **Navigation**: `{Feature}Navigator` (`AuthNavigator`, `MainNavigator`)
- **Styles**: `styles` constant in same file or StyleSheet
- **Accessibility labels**: `accessibilityLabel` prop for all interactive elements
- **Test IDs**: `testID` prop for testing (`testID="login-button"`)

### Code Naming Conventions

- **TypeScript conventions**: PascalCase classes, camelCase variables/functions
- **React hooks**: `use` prefix (`useAuth`, `useFirebase`, `useNavigation`)
- **Context**: `{Feature}Context` (`AuthContext`, `ThemeContext`)
- **Props interfaces**: `{Component}Props` (`ButtonProps`, `CardProps`)

### API Design Standards

- **Firebase Firestore**: camelCase collection and field names
- **Cloud Functions**: camelCase function names (`createUser`, `sendNotification`)
- **Real-time Database**: camelCase paths

### Database Conventions (Firebase Firestore)

- **Collections**: camelCase, plural (`users`, `posts`, `comments`)
- **Documents**: Auto-generated IDs or meaningful keys
- **Fields**: camelCase (`firstName`, `emailAddress`, `createdAt`)
- **Timestamps**: Firebase `serverTimestamp()`
- **Security Rules**: Strict validation in Firestore rules

### Testing Standards

- **Framework**: React Native Testing Library, Jest
- **Test files**: `.test.tsx` suffix
- **Accessibility testing**: Use `accessibilityLabel` in assertions
- **Snapshot tests**: For UI components
- **Integration tests**: For navigation flows

### File Structure

```
src/
├── screens/             # Screen components
├── components/          # Reusable components
├── navigation/          # Navigation configuration
├── contexts/            # React contexts
├── hooks/               # Custom hooks
├── services/            # Firebase services
├── utils/               # Helper functions
└── __tests__/           # Test files
```

### Accessibility Requirements

- All interactive elements must have `accessibilityLabel`
- Support screen readers (TalkBack on Android, VoiceOver on iOS)
- Minimum touch target size: 44x44 dp
- Color contrast ratio: WCAG AA compliance (4.5:1)
- Keyboard navigation support where applicable

---

## Example 4: Microservices Architecture (Java Spring Boot)

**Input context:**

- `architecture.md` indicates: Multiple Spring Boot services, MySQL databases, Kafka messaging
- `ground-rules.md` requires: Domain-driven design, service autonomy

**Output standards include:**

### Code Naming Conventions

- **Packages**: lowercase, hierarchical (`com.company.service.domain`, `com.company.service.api`)
- **Classes**: PascalCase (`UserController`, `OrderService`, `PaymentRepository`)
- **Interfaces**: PascalCase, descriptive (`UserRepository`, `PaymentGateway`)
- **Methods**: camelCase (`findUserById`, `processPayment`)
- **Variables**: camelCase (`orderTotal`, `userEmail`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_ATTEMPTS`, `DEFAULT_TIMEOUT`)

### API Design Standards

- **REST Endpoints**: Hyphenated kebab-case for URIs (`/order-items`, `/payment-methods`)
- **HTTP Methods**: Semantic usage (GET, POST, PUT, DELETE, PATCH)
- **Versioning**: URI versioning (`/api/v1/users`)
- **Response format**: JSON with camelCase fields
- **Error responses**: RFC 7807 Problem Details

### Database Conventions

- **Tables**: snake_case, plural (`users`, `order_items`, `payment_transactions`)
- **Columns**: snake_case (`first_name`, `order_date`, `total_amount`)
- **Primary keys**: `id` (BIGINT auto-increment)
- **Foreign keys**: `{table}_id` (`user_id`, `order_id`)
- **Indexes**: Named with purpose (`idx_users_email_active`)

### Service Communication

- **REST**: Synchronous HTTP calls for queries
- **Kafka**: Asynchronous events for state changes
- **Event naming**: PascalCase with past tense (`OrderCreated`, `PaymentProcessed`)
- **Topic naming**: kebab-case (`order-events`, `payment-notifications`)

---

## Common Patterns Across All Examples

### General Principles

1. **Consistency**: Same convention throughout the entire codebase
2. **Clarity**: Names should be self-documenting
3. **Context**: Avoid abbreviations unless widely understood
4. **Searchability**: Use unique, searchable names
5. **Pronunciation**: Names should be easy to say in discussions

### Testing Conventions

- Test files alongside source or in dedicated `__tests__` directory
- Descriptive test names that read like sentences
- AAA pattern: Arrange, Act, Assert
- Mock external dependencies
- Focus on behavior, not implementation

### Git Commit Standards

All examples follow Conventional Commits:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Build/tooling changes

### Code Review Checklist

- Naming conventions followed
- No magic numbers (use constants)
- Error handling present
- Tests included
- Documentation updated
- No commented-out code
- Performance considerations addressed

---

## Technology-Specific Notes

### Frontend Frameworks

- **React**: Functional components with hooks, avoid class components
- **Vue**: Composition API preferred over Options API
- **Angular**: Follow Angular style guide strictly

### Backend Frameworks

- **Node.js/Express**: Async/await over callbacks, middleware pattern
- **Django**: Follow Django's conventions (models, views, templates)
- **Spring Boot**: Dependency injection, layered architecture

### Databases

- **Relational (SQL)**: Normalized schema, foreign key constraints
- **Document (NoSQL)**: Denormalization acceptable, embed vs reference decisions
- **Graph**: Relationship-first design

---

## Enforcement Tools

### Linters and Formatters

- **JavaScript/TypeScript**: ESLint + Prettier
- **Python**: Pylint + Black
- **Java**: Checkstyle + Google Java Format
- **Go**: golint + gofmt (built-in)

### Pre-commit Hooks

Use tools like Husky (JavaScript) or pre-commit (Python) to enforce standards before commits.

### CI/CD Integration

Run linters and formatters in CI pipeline, fail builds on violations.

---

## Reference

For the complete standards template and detailed section guidance, see:

- [`templates/standards-document.md`](../templates/standards-document.md) - Complete template
- [`SKILL.md`](../SKILL.md) - Main skill instructions
