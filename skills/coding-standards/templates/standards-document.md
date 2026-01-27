# Coding Standards and Conventions

**Project:** [Project Name]  
**Version:** [Version Number]  
**Last Updated:** [YYYY-MM-DD]  
**Author:** [Team/Organization Name]

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [UI Naming Conventions](#2-ui-naming-conventions)
3. [Code Naming Conventions](#3-code-naming-conventions)
4. [File and Directory Structure](#4-file-and-directory-structure)
5. [API Design Standards](#5-api-design-standards)
6. [Database Standards](#6-database-standards)
7. [Testing Standards](#7-testing-standards)
8. [Git Workflow](#8-git-workflow)
9. [Documentation Standards](#9-documentation-standards)
10. [Code Style Guide](#10-code-style-guide)

---

## 1. Introduction

### Purpose

This document establishes comprehensive coding standards and conventions for [Project Name]. These standards ensure consistency, maintainability, and quality across the entire codebase.

### Scope

These standards apply to:

- All source code in the project
- Configuration files
- Documentation
- Test code
- Build scripts

### Technology Stack

**Programming Languages:**

- [List primary languages: Python 3.11, TypeScript 5.x, etc.]

**Frontend Frameworks:**

- [List if applicable: React 18, Vue 3, Angular 16, etc.]
- [Or state: N/A - Backend-only project]

**Backend Frameworks:**

- [List: Django 4.x, Express.js, Spring Boot, etc.]

**Databases:**

- [List: PostgreSQL 15, MongoDB 6, Redis, etc.]

**API Protocols:**

- [List: REST, GraphQL, gRPC, etc.]

**Testing Frameworks:**

- [List: Jest, Pytest, JUnit, etc.]

### Ground Rules Alignment

This standards document respects and enforces the following ground rules from `docs/ground-rules.md`:

- [List key ground rules that affect standards]
- [Example: "MUST use TypeScript for type safety"]
- [Example: "MUST achieve 80% test coverage"]
- [Example: "MUST follow REST API best practices"]

### Architecture Alignment

This standards document aligns with architectural decisions in `docs/architecture.md`:

- [Reference key architectural decisions]
- [Example: "Layered architecture pattern (Controller → Service → Repository)"]
- [Example: "Microservices architecture with API Gateway"]
- [Example: "Event-driven architecture with message queues"]

---

## 2. UI Naming Conventions

**Project Type:** [Frontend / Full-Stack / Backend-Only]  
**UI Frameworks:** [React, Vue, Angular, React Native, Flutter, etc. OR "N/A"]

### Applicability

**[IF FRONTEND/UI PROJECT]:**

This section is MANDATORY for this project as it contains UI components.

**[IF BACKEND-ONLY PROJECT]:**

**N/A** - This project has no UI layer. It is a backend-only service providing APIs without frontend components.

---

**[FOR FRONTEND/UI PROJECTS, INCLUDE ALL SECTIONS BELOW]:**

### 2.1 Component/Widget Naming

#### Component Names

**Format:** [PascalCase / kebab-case / etc.]

**Rules:**

- Use descriptive, noun-based names
- Avoid abbreviations unless widely understood
- Name should describe what the component is, not what it does

**Examples:**

✅ **Good:**

```typescript
UserProfile.tsx
NavigationBar.tsx
ProductCard.tsx
SearchInput.tsx
```

❌ **Bad:**

```typescript
UP.tsx           // Too abbreviated
component1.tsx   // Not descriptive
Thing.tsx        // Too generic
```

#### Props/Attributes Naming

**Format:** [camelCase]

**Rules:**

- Use descriptive names
- Boolean props should start with `is`, `has`, `should`, `can`
- Event handler props should start with `on`
- Avoid redundant prefixes like `prop` or `data`

**Examples:**

✅ **Good:**

```typescript
<UserProfile 
  userName="John Doe"
  isActive={true}
  hasPermission={false}
  onUserClick={handleClick}
  maxItems={10}
/>
```

❌ **Bad:**

```typescript
<UserProfile 
  UserName="John"        // Wrong casing
  active={true}          // Missing 'is' prefix
  click={handleClick}    // Missing 'on' prefix
  propMaxItems={10}      // Redundant prefix
/>
```

#### Event Handler Naming

**Format:** `handle{Event}` or `on{Event}`

**Rules:**

- Internal handlers (in component): `handle{Event}`
- Props for external handlers: `on{Event}`
- Use descriptive event names
- Include target if multiple similar handlers exist

**Examples:**

✅ **Good:**

```typescript
const handleSubmit = () => { ... }
const handleUserClick = () => { ... }
const handleFormChange = () => { ... }
const handleModalClose = () => { ... }

<Button onClick={handleSubmit} />
<UserCard onUserClick={handleUserClick} />
```

❌ **Bad:**

```typescript
const submit = () => { ... }      // Missing 'handle'
const click1 = () => { ... }      // Not descriptive
const doStuff = () => { ... }     // Too generic
```

#### State Variable Naming

**Format:** [camelCase]

**Rules:**

- Boolean state: Use `is`, `has`, `should`, `can` prefixes
- Data state: Use descriptive nouns
- Loading state: Use `isLoading`, `loading`, or `{entity}Loading`
- Error state: Use `error`, `{entity}Error`, or `hasError`

**Examples:**

✅ **Good:**

```typescript
const [isLoading, setIsLoading] = useState(false)
const [hasError, setHasError] = useState(false)
const [userData, setUserData] = useState(null)
const [selectedItems, setSelectedItems] = useState([])
const [isModalOpen, setIsModalOpen] = useState(false)
```

❌ **Bad:**

```typescript
const [loading, setLoading] = useState(false)    // Use 'isLoading'
const [data, setData] = useState(null)           // Too generic
const [flag, setFlag] = useState(false)          // Not descriptive
const [temp, setTemp] = useState([])             // Too generic
```

### 2.2 CSS/Styling Naming

#### CSS Class Naming

**Methodology:** [BEM / Utility-First / Semantic / Custom]

**[IF BEM]:**

**Format:** `.block__element--modifier`

**Rules:**

- Block: Standalone component (`.user-card`)
- Element: Part of block (`.user-card__title`)
- Modifier: Variation or state (`.user-card--featured`)
- Use lowercase and hyphens

**Examples:**

✅ **Good:**

```css
.user-profile { }
.user-profile__avatar { }
.user-profile__name { }
.user-profile__bio { }
.user-profile--featured { }
.user-profile__avatar--large { }
```

❌ **Bad:**

```css
.UserProfile { }              // Wrong casing
.user_profile { }             // Use hyphens, not underscores
.user-profile-avatar { }      // Missing double underscore
.featured-user-profile { }    // Modifier should be at end
```

**[IF UTILITY-FIRST (Tailwind, etc.)]:**

**Format:** Utility classes following framework conventions

**Rules:**

- Use framework-provided utility classes
- Create custom utilities for repeated patterns
- Use component classes for complex components

**Examples:**

✅ **Good:**

```jsx
<div className="flex items-center justify-between p-4 bg-blue-500">
<div className="card-container"> {/* Custom component class */}
```

**[IF SEMANTIC/CUSTOM]:**

**Format:** [Describe your custom convention]

**Examples:**

```css
[Provide examples]
```

#### ID Attribute Naming

**Format:** [camelCase / kebab-case]

**Rules:**

- Use sparingly - prefer classes for styling
- Use for unique elements that need JavaScript access
- Use for form label associations
- Descriptive and unique across the page

**Examples:**

✅ **Good:**

```html
<form id="loginForm">
<input id="userEmailInput" />
<label htmlFor="userEmailInput">Email</label>
<div id="errorMessage">
```

❌ **Bad:**

```html
<div id="div1">       // Not descriptive
<div id="container">  // Too generic, likely duplicated
```

#### CSS-in-JS / Styled Components

**[IF USING STYLED-COMPONENTS, EMOTION, ETC.]:**

**Rules:**

- Styled component names: PascalCase
- Theme variable names: camelCase
- Follow component naming conventions

**Examples:**

✅ **Good:**

```typescript
const UserCard = styled.div`
  padding: ${props => props.theme.spacingMedium};
`

const PrimaryButton = styled.button`
  color: ${props => props.theme.colorPrimary};
`
```

### 2.3 File Naming for UI Components

#### Component Files

**Format:** [PascalCase.tsx / kebab-case.vue / ComponentName.jsx]

**Examples:**

✅ **Good:**

```
UserProfile.tsx
NavigationBar.tsx
SearchInput.vue
product-card.vue
```

#### Style Files

**Format:** [ComponentName.module.css / component-name.styles.ts / ComponentName.css]

**Examples:**

✅ **Good:**

```
UserProfile.module.css
NavigationBar.styles.ts
user-profile.scss
SearchInput.css
```

#### Test Files

**Format:** [ComponentName.test.tsx / ComponentName.spec.ts]

**Examples:**

✅ **Good:**

```
UserProfile.test.tsx
NavigationBar.spec.ts
user-profile.test.js
```

#### Story Files (Storybook)

**Format:** [ComponentName.stories.tsx]

**Examples:**

✅ **Good:**

```
UserProfile.stories.tsx
Button.stories.ts
```

### 2.4 Directory Structure for UI Code

**Recommended Structure:**

```
src/
├── components/              # Reusable UI components
│   ├── UserProfile/
│   │   ├── UserProfile.tsx
│   │   ├── UserProfile.module.css
│   │   ├── UserProfile.test.tsx
│   │   ├── UserProfile.stories.tsx
│   │   └── index.ts         # Re-export
│   ├── Button/
│   │   └── ...
│   └── index.ts             # Barrel export (optional)
│
├── pages/                   # Page-level components (if using routing)
│   ├── HomePage/
│   ├── UserPage/
│   └── ...
│
├── layouts/                 # Layout components
│   ├── MainLayout/
│   ├── AuthLayout/
│   └── ...
│
├── assets/                  # Static assets
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── styles/              # Global styles
│
├── hooks/                   # Custom React hooks (if React)
│   ├── useAuth.ts
│   ├── useAPI.ts
│   └── ...
│
├── contexts/                # React Context providers (if React)
│   ├── AuthContext.tsx
│   └── ...
│
└── utils/                   # UI utilities
    ├── formatters.ts
    └── validators.ts
```

**Alternative: Flat Structure (for smaller projects):**

```
src/
├── components/
│   ├── UserProfile.tsx
│   ├── UserProfile.module.css
│   ├── UserProfile.test.tsx
│   └── ...
└── ...
```

### 2.5 Accessibility Naming

#### ARIA Attributes

**Rules:**

- Use semantic HTML first, ARIA second
- Descriptive `aria-label` values
- Meaningful `aria-describedby` references

**Examples:**

✅ **Good:**

```jsx
<button aria-label="Close modal">×</button>
<input aria-describedby="emailHelp" />
<div role="alert" aria-live="polite">Error message</div>
<nav aria-label="Main navigation">
```

❌ **Bad:**

```jsx
<div aria-label="x">×</div>        // Not descriptive
<input aria-describedby="desc">    // Generic ID
```

#### Role Naming

**Rules:**

- Use semantic HTML elements when possible
- Add ARIA roles when semantic HTML is insufficient
- Standard role values: `button`, `navigation`, `alert`, `dialog`, etc.

**Examples:**

✅ **Good:**

```jsx
<button>Submit</button>              // Semantic, no role needed
<div role="button" tabIndex={0}>    // Non-button element as button
<nav role="navigation">              // Explicit navigation role
<div role="alert">Error!</div>      // Alert notification
```

#### Label Associations

**Rules:**

- Always associate labels with inputs
- Use `htmlFor` (React) or `for` (HTML) with matching `id`
- Descriptive label text

**Examples:**

✅ **Good:**

```jsx
<label htmlFor="userEmail">Email Address</label>
<input id="userEmail" type="email" />
```

#### Landmark Naming

**Rules:**

- Use semantic HTML5 elements: `<nav>`, `<main>`, `<aside>`, `<footer>`
- Add `aria-label` to multiple landmarks of same type
- One `<main>` per page

**Examples:**

✅ **Good:**

```jsx
<nav aria-label="Main navigation">...</nav>
<nav aria-label="Footer navigation">...</nav>
<main>...</main>
<aside aria-label="Related articles">...</aside>
<footer>...</footer>
```

### 2.6 Framework-Specific Conventions

**[IF REACT]:**

#### Hook Naming

**Format:** `use{DescriptiveName}`

**Examples:**

✅ **Good:**

```typescript
useUserData()
useAuth()
useLocalStorage()
useFetchAPI()
```

❌ **Bad:**

```typescript
getUserData()    // Missing 'use' prefix
useData()        // Too generic
hookAuth()       // Wrong prefix
```

#### Context Naming

**Format:** `{Entity}Context`

**Examples:**

✅ **Good:**

```typescript
UserContext
AuthContext
ThemeContext
```

#### Higher-Order Component (HOC) Naming

**Format:** `with{Capability}`

**Examples:**

✅ **Good:**

```typescript
withAuth()
withLogging()
withErrorBoundary()
```

**[IF VUE]:**

#### Composable Naming

**Format:** `use{DescriptiveName}`

**Examples:**

✅ **Good:**

```typescript
useCounter()
useMouse()
useFetch()
```

#### Directive Naming

**Format:** `v-{name}`

**Examples:**

✅ **Good:**

```typescript
v-focus
v-tooltip
v-click-outside
```

#### Plugin Naming

**Format:** Descriptive, exported as object

**Examples:**

✅ **Good:**

```typescript
export const myPlugin = { ... }
```

**[IF ANGULAR]:**

#### Service Naming

**Format:** `{Entity}Service`

**Examples:**

✅ **Good:**

```typescript
UserService
AuthService
DataService
```

#### Directive Naming

**Format:** `{Descriptive}Directive`

**Examples:**

✅ **Good:**

```typescript
HighlightDirective
TooltipDirective
```

#### Pipe Naming

**Format:** `{Transform}Pipe`

**Examples:**

✅ **Good:**

```typescript
DatePipe
CurrencyPipe
CustomFormatPipe
```

### 2.7 Do's and Don'ts

#### ✅ DO

- Use descriptive, meaningful names
- Follow consistent casing conventions
- Name components by what they ARE, not what they DO
- Use established framework conventions
- Consider accessibility in naming (aria-labels, roles)
- Keep component names concise but clear
- Use consistent prefixes for boolean props (`is`, `has`, `should`)

**Examples:**

```typescript
// ✅ Good
<UserProfile userId={123} isActive={true} />
<Button variant="primary" onClick={handleSubmit}>Submit</Button>
const [isLoading, setIsLoading] = useState(false)
```

#### ❌ DON'T

- Use cryptic abbreviations
- Mix casing conventions inconsistently
- Use generic names (Component1, data, thing)
- Include type information in names (userObj, nameStr)
- Use redundant prefixes (propsUserName, stateIsActive)
- Create overly long names (UserProfileComponentWithAuthenticationAndPermissions)

**Examples:**

```typescript
// ❌ Bad
<UP uid={123} act={true} />  // Cryptic abbreviations
<button onclick={submit}>    // Wrong casing
const [data, setData] = useState(null)  // Too generic
const userDataObj = { ... }  // Redundant type suffix
```

### 2.8 Common Anti-Patterns to Avoid

1. **Generic Component Names**
   - ❌ `Component1`, `Thing`, `Item`, `Data`
   - ✅ `UserProfile`, `ProductCard`, `NavigationMenu`

2. **Inconsistent Casing**
   - ❌ Mixing `UserProfile` and `user-card` in same codebase
   - ✅ Consistent PascalCase for all React components

3. **Non-Descriptive Event Handlers**
   - ❌ `handle`, `onClick1`, `doStuff`
   - ✅ `handleSubmit`, `handleUserClick`, `handleFormValidation`

4. **Missing Semantic Meaning**
   - ❌ `<div id="div1">`, `<div className="container3">`
   - ✅ `<div id="userProfileSection">`, `<div className="product-grid">`

5. **Overuse of Abbreviations**
   - ❌ `usrProf`, `NavBar`, `ProdCrd`
   - ✅ `userProfile`, `NavigationBar`, `ProductCard`

6. **Boolean Props Without Prefixes**
   - ❌ `<Modal visible={true} loading={false}>`
   - ✅ `<Modal isVisible={true} isLoading={false}>`

---

## 3. Code Naming Conventions

### 3.1 Variable Naming

#### Local Variables

**Format:** [camelCase / snake_case]

**Rules:**

- Descriptive and meaningful
- Avoid single-letter names except for loop counters
- Use full words, avoid abbreviations

**Examples:**

✅ **Good:**

```typescript
const userName = "John Doe"
const totalPrice = 100
const isValid = true
const userList = []
```

```python
user_name = "John Doe"
total_price = 100
is_valid = True
user_list = []
```

❌ **Bad:**

```typescript
const x = "John"        // Not descriptive
const n = "John Doe"    // Single letter
const usrNm = "John"    // Abbreviation
```

#### Constants

**Format:** SCREAMING_SNAKE_CASE

**Rules:**

- All uppercase with underscores
- Represent truly constant values
- Placed at module/file top

**Examples:**

✅ **Good:**

```typescript
const MAX_RETRIES = 3
const API_BASE_URL = "https://api.example.com"
const DEFAULT_TIMEOUT = 5000
const HTTP_STATUS_OK = 200
```

```python
MAX_RETRIES = 3
API_BASE_URL = "https://api.example.com"
DEFAULT_TIMEOUT = 5000
```

#### Global Variables

**[IF ALLOWED]:**

**Format:** [Specify convention]

**Rules:**

- Minimize use of global variables
- Clearly indicate global scope
- Document purpose and usage

#### Class/Instance Variables

**Format:** [camelCase / snake_case / with prefix]

**Rules:**

- Private variables: Prefix with `_` or `#` (language-dependent)
- Public variables: Standard naming convention
- Descriptive names

**Examples:**

✅ **Good:**

```typescript
class User {
  private _password: string     // Private with underscore
  public userName: string       // Public
  #email: string                // Private with #
}
```

```python
class User:
    def __init__(self):
        self._password = ""       # Private with underscore
        self.user_name = ""       # Public
```

### 3.2 Function/Method Naming

#### Function Names

**Format:** [camelCase / snake_case]

**Rules:**

- Start with a verb (action-based)
- Descriptive and intention-revealing
- Boolean-returning functions: `is`, `has`, `should`, `can` prefix

**Examples:**

✅ **Good:**

```typescript
function getUserData(userId: number) { ... }
function calculateTotal(items: Item[]) { ... }
function validateEmail(email: string): boolean { ... }
function isValid(value: string): boolean { ... }
function hasPermission(user: User): boolean { ... }
```

```python
def get_user_data(user_id: int):
def calculate_total(items: list):
def validate_email(email: str) -> bool:
def is_valid(value: str) -> bool:
def has_permission(user: User) -> bool:
```

❌ **Bad:**

```typescript
function data(id) { ... }         // Not a verb
function get() { ... }            // Too generic
function valid(email) { ... }     // Should be 'isValid' or 'validate'
```

#### Method Names

**Format:** Same as functions

**Examples:**

✅ **Good:**

```typescript
class UserService {
  getUserById(id: number) { ... }
  createUser(data: UserData) { ... }
  updateUser(id: number, data: UserData) { ... }
  deleteUser(id: number) { ... }
}
```

#### Constructor Names

**Format:** [Match class name / **init** / constructor keyword]

**Examples:**

✅ **Good:**

```typescript
class User {
  constructor(name: string, email: string) { ... }
}
```

```python
class User:
    def __init__(self, name: str, email: str):
```

```java
public class User {
    public User(String name, String email) { ... }
}
```

#### Getter/Setter Naming

**Format:** `get{Property}` / `set{Property}` OR property access

**Examples:**

✅ **Good:**

```typescript
class User {
  getName(): string { return this._name }
  setName(name: string) { this._name = name }
  
  // Or property access
  get name(): string { return this._name }
  set name(value: string) { this._name = value }
}
```

```python
class User:
    @property
    def name(self):
        return self._name
    
    @name.setter
    def name(self, value):
        self._name = value
```

#### Boolean Function Prefixes

**Format:** `is`, `has`, `should`, `can`, `will`

**Examples:**

✅ **Good:**

```typescript
function isValid(value: string): boolean
function hasPermission(user: User): boolean
function shouldRetry(error: Error): boolean
function canEdit(user: User, document: Doc): boolean
function willExpire(date: Date): boolean
```

### 3.3 Class/Type Naming

#### Class Names

**Format:** PascalCase

**Rules:**

- Noun-based names
- Descriptive and specific
- Avoid generic names

**Examples:**

✅ **Good:**

```typescript
class UserProfile { }
class PaymentProcessor { }
class DataValidator { }
class EmailService { }
```

```python
class UserProfile:
class PaymentProcessor:
class DataValidator:
```

❌ **Bad:**

```typescript
class user { }              // Wrong casing
class Manager { }           // Too generic
class Data { }              // Too vague
```

#### Interface Names

**Format:** PascalCase [with or without 'I' prefix]

**Rules:**

- [Specify project convention: Use 'I' prefix OR no prefix]
- Descriptive names
- Often adjectives ending in '-able' or '-ible'

**Examples:**

**[IF USING 'I' PREFIX]:**

```typescript
interface IUserRepository { }
interface IPaymentGateway { }
interface ISerializable { }
```

**[IF NO PREFIX]:**

```typescript
interface UserRepository { }
interface PaymentGateway { }
interface Serializable { }
interface Drawable { }
```

#### Enum Names

**Format:** PascalCase [singular or plural]

**Rules:**

- Enum name: Singular (represents a type)
- Enum values: SCREAMING_SNAKE_CASE or PascalCase

**Examples:**

✅ **Good:**

```typescript
enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
  GUEST = 'guest'
}

enum HttpMethod {
  GET = 'GET',
  POST = 'POST',
  PUT = 'PUT',
  DELETE = 'DELETE'
}
```

```python
from enum import Enum

class UserRole(Enum):
    ADMIN = 'admin'
    USER = 'user'
    GUEST = 'guest'
```

#### Type Alias Names

**Format:** PascalCase

**Examples:**

✅ **Good:**

```typescript
type UserId = string
type Timestamp = number
type Coordinates = [number, number]
type HttpHeaders = Record<string, string>
```

#### Generic Type Parameter Names

**Format:** Single uppercase letter OR descriptive PascalCase

**Rules:**

- `T` for single type parameter
- `TKey`, `TValue` for key-value pairs
- `TResult`, `TError` for results
- Descriptive names for complex generics

**Examples:**

✅ **Good:**

```typescript
class List<T> { }
class Map<TKey, TValue> { }
function fetchData<TData, TError>(): Result<TData, TError>
class Repository<TEntity> { }
```

### 3.4 Module/Package Naming

#### Module Names

**Format:** [lowercase / snake_case / kebab-case]

**Rules:**

- Descriptive file/module names
- Match primary export (class, function)
- Avoid special characters

**Examples:**

✅ **Good:**

```
user_service.py
payment-processor.ts
datavalidator.js
email_sender.py
```

❌ **Bad:**

```
UserService.py        // Wrong casing for Python
user.service.ts       // Avoid dots in module names
us.py                 // Too abbreviated
```

#### Package Names

**Format:** [Hierarchical / Flat / Reverse domain]

**Examples:**

**Java (reverse domain):**

```
com.example.user
com.example.payment
com.example.data.validator
```

**Python (flat or hierarchical):**

```
user
payment
data_validator
```

**Node.js (kebab-case):**

```
user-service
payment-processor
data-validator
```

#### Namespace Conventions

**Format:** [PascalCase / lowercase]

**Examples:**

**TypeScript:**

```typescript
namespace UserManagement {
  export class UserService { }
}
```

**C#:**

```csharp
namespace Example.UserManagement {
  public class UserService { }
}
```

#### Import Alias Conventions

**Format:** Meaningful abbreviations, commonly accepted

**Examples:**

✅ **Good:**

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime as dt
```

```typescript
import * as fs from 'fs'
import * as path from 'path'
```

❌ **Bad:**

```python
import numpy as n       // Too short
import pandas as p      // Ambiguous
```

---

## 4. File and Directory Structure

### 4.1 File Naming Conventions

#### Source Code Files

**Format:** [Match class/module name with appropriate extension]

**Rules:**

- One primary class per file (for OOP languages)
- File name matches class/module name
- Appropriate extension (.ts, .py, .java, etc.)

**Examples:**

✅ **Good:**

```
UserService.java
UserService.ts
user_service.py
PaymentProcessor.java
payment_processor.py
```

#### Test Files

**Format:** [Suffix or prefix with test framework convention]

**Examples:**

**JavaScript/TypeScript:**

```
UserService.test.ts
UserService.spec.ts
__tests__/UserService.ts
```

**Python:**

```
test_user_service.py
user_service_test.py
```

**Java:**

```
UserServiceTest.java
```

#### Configuration Files

**Format:** Lowercase, descriptive, appropriate extension

**Examples:**

✅ **Good:**

```
.eslintrc.js
jest.config.js
tsconfig.json
pytest.ini
.env
.gitignore
```

#### Documentation Files

**Format:** Uppercase or capitalized markdown

**Examples:**

✅ **Good:**

```
README.md
CONTRIBUTING.md
API.md
CHANGELOG.md
LICENSE
```

### 4.2 Directory Structure Standards

**Project Structure:** [Feature-based / Layer-based / Hybrid]

#### Option 1: Feature-Based Structure (Recommended for Large Projects)

```
src/
├── features/
│   ├── user/
│   │   ├── UserService.ts
│   │   ├── UserRepository.ts
│   │   ├── UserController.ts
│   │   ├── User.model.ts
│   │   ├── user.test.ts
│   │   └── index.ts
│   ├── payment/
│   │   ├── PaymentService.ts
│   │   ├── PaymentRepository.ts
│   │   ├── PaymentController.ts
│   │   ├── Payment.model.ts
│   │   └── index.ts
│   └── order/
│       └── ...
├── shared/
│   ├── utils/
│   ├── types/
│   └── constants/
├── config/
├── tests/
└── index.ts
```

#### Option 2: Layer-Based Structure (Recommended for Smaller Projects)

```
src/
├── controllers/
│   ├── UserController.ts
│   ├── PaymentController.ts
│   └── OrderController.ts
├── services/
│   ├── UserService.ts
│   ├── PaymentService.ts
│   └── OrderService.ts
├── repositories/
│   ├── UserRepository.ts
│   ├── PaymentRepository.ts
│   └── OrderRepository.ts
├── models/
│   ├── User.ts
│   ├── Payment.ts
│   └── Order.ts
├── utils/
├── config/
├── tests/
└── index.ts
```

#### Test Directory Structure

**Option 1: Mirror Source Structure**

```
src/
  user/
    UserService.ts
    UserService.test.ts
```

**Option 2: Separate tests/ Directory**

```
src/
  user/
    UserService.ts

tests/
  user/
    UserService.test.ts
```

#### Asset Directories

```
assets/            # OR public/ OR static/
├── images/
│   ├── icons/
│   ├── logos/
│   └── backgrounds/
├── fonts/
├── videos/
└── data/
```

#### Configuration Directories

```
config/            # OR .config/
├── database.ts
├── api.ts
└── environment.ts
```

#### Documentation Directories

```
docs/
├── api/
│   ├── endpoints.md
│   └── schemas.md
├── architecture/
│   └── architecture.md
├── guides/
│   ├── setup.md
│   └── deployment.md
└── README.md
```

### 4.3 Project Structure Patterns

#### Monorepo Structure

**[IF MONOREPO]:**

```
project-root/
├── packages/
│   ├── frontend/
│   │   ├── package.json
│   │   └── src/
│   ├── backend/
│   │   ├── package.json
│   │   └── src/
│   └── shared/
│       ├── package.json
│       └── src/
├── package.json
└── README.md
```

#### Multi-Repo Structure

**[IF MULTI-REPO]:**

- Separate repositories for frontend, backend, shared libraries
- Clear ownership and deployment boundaries
- Inter-repo dependencies via npm/pip packages

#### Shared Code Organization

```
src/
├── common/        # OR shared/ OR lib/
│   ├── utils/
│   │   ├── string-utils.ts
│   │   ├── date-utils.ts
│   │   └── validation.ts
│   ├── types/
│   │   ├── index.ts
│   │   └── common.types.ts
│   ├── constants/
│   │   └── index.ts
│   └── errors/
│       ├── AppError.ts
│       └── ErrorCodes.ts
```

#### Build Output Directories

```
dist/              # OR build/ OR out/
├── index.js
├── index.js.map
└── ...
```

**Rules:**

- Never commit build output (add to .gitignore)
- Consistent naming across projects
- Clean before rebuild

#### Vendor/Third-Party Code

```
vendor/            # OR third_party/
├── legacy-lib/
└── custom-patches/
```

**Rules:**

- Clearly separate from project code
- Document why vendored (license, modifications, etc.)
- Prefer package managers when possible

---

## 5. API Design Standards

**API Protocol:** [REST / GraphQL / gRPC / Other]

### 5.1 REST API Standards

**[IF REST]:**

#### Endpoint Naming

**Format:** Plural nouns, lowercase, hyphens for multi-word

**Rules:**

- Use plural resource names
- Lowercase with hyphens
- Avoid verbs (use HTTP methods instead)
- Nested resources for relationships

**Examples:**

✅ **Good:**

```
GET    /users
GET    /users/{id}
POST   /users
PUT    /users/{id}
DELETE /users/{id}
GET    /users/{id}/orders
GET    /user-profiles
```

❌ **Bad:**

```
GET /getUsers             // Verb in URL
GET /user                 // Singular
GET /Users                // Uppercase
GET /user_profiles        // Underscores
```

#### HTTP Methods Usage

| Method | Purpose | Idempotent | Request Body | Response Body |
|--------|---------|------------|--------------|---------------|
| GET | Retrieve resources | ✅ Yes | ❌ No | ✅ Yes |
| POST | Create new resource | ❌ No | ✅ Yes | ✅ Yes (created resource) |
| PUT | Full update of existing resource | ✅ Yes | ✅ Yes | ✅ Yes (updated resource) |
| PATCH | Partial update of existing resource | ❌ No | ✅ Yes (partial data) | ✅ Yes (updated resource) |
| DELETE | Remove resource | ✅ Yes | ❌ No | ✅ Optional |

**Examples:**

```
GET    /users              # List all users
GET    /users/{id}         # Get single user
POST   /users              # Create new user
PUT    /users/{id}         # Full update (replace entire user)
PATCH  /users/{id}         # Partial update (update specific fields)
DELETE /users/{id}         # Delete user
```

#### Query Parameter Naming

**Format:** [camelCase / snake_case]

**Common Parameters:**

- Pagination: `page`, `pageSize`, `limit`, `offset`
- Sorting: `sortBy`, `orderBy`, `sort`, `order`
- Filtering: `filter`, `{field}` (e.g., `status`, `category`)
- Search: `q`, `search`, `query`

**Examples:**

✅ **Good:**

```
GET /users?page=1&pageSize=20
GET /users?sortBy=name&order=asc
GET /users?status=active
GET /products?search=laptop&category=electronics
```

```
GET /users?page=1&page_size=20       # snake_case variant
GET /users?sort_by=name&order=asc
```

#### Request/Response Body Structure

**Format:** JSON with consistent field naming

**Rules:**

- Use camelCase or snake_case (consistent with query params)
- Descriptive field names
- Include metadata for lists

**Examples:**

**Request Body (POST /users):**

```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "roles": ["user"]
}
```

**Response Body (GET /users/{id}):**

```json
{
  "id": "123",
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "createdAt": "2026-01-26T10:00:00Z",
  "updatedAt": "2026-01-26T10:00:00Z"
}
```

**Response Body (GET /users - List):**

```json
{
  "data": [
    { "id": "123", "firstName": "John", ... },
    { "id": "456", "firstName": "Jane", ... }
  ],
  "meta": {
    "page": 1,
    "pageSize": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

#### Error Response Format

**Format:** Consistent structure with error codes

**Standard Error Response:**

```json
{
  "error": {
    "code": "INVALID_INPUT",
    "message": "Email format is invalid",
    "field": "email",
    "timestamp": "2026-01-26T10:00:00Z",
    "requestId": "req-123-456"
  }
}
```

**Error Codes (Examples):**

- `INVALID_INPUT` - Validation error
- `UNAUTHORIZED` - Authentication required
- `FORBIDDEN` - Insufficient permissions
- `NOT_FOUND` - Resource not found
- `CONFLICT` - Resource already exists
- `INTERNAL_ERROR` - Server error

#### HTTP Status Codes

| Status Code | Meaning | Usage |
|-------------|---------|-------|
| 200 OK | Success | GET, PUT, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success, no body | DELETE successful |
| 400 Bad Request | Client error | Invalid input |
| 401 Unauthorized | Authentication required | Missing/invalid credentials |
| 403 Forbidden | Insufficient permissions | User doesn't have access |
| 404 Not Found | Resource not found | Invalid ID |
| 409 Conflict | Resource conflict | Duplicate resource |
| 422 Unprocessable Entity | Validation error | Semantic errors |
| 500 Internal Server Error | Server error | Unexpected error |

#### API Versioning Strategy

**Option 1: URL Path Versioning (Recommended)**

```
/v1/users
/v2/users
```

**Option 2: Header-Based Versioning**

```
GET /users
Header: Accept: application/vnd.example.v1+json
```

**Option 3: Query Parameter Versioning**

```
/users?version=1
```

**Recommendation:** [Choose and document project's strategy]

### 5.2 GraphQL API Standards

**[IF GRAPHQL]:**

#### Type Naming

**Format:** PascalCase

**Examples:**

✅ **Good:**

```graphql
type User {
  id: ID!
  firstName: String!
  lastName: String!
  email: String!
}

type Order {
  id: ID!
  user: User!
  items: [OrderItem!]!
}
```

#### Field Naming

**Format:** camelCase

**Examples:**

✅ **Good:**

```graphql
type User {
  firstName: String!
  lastName: String!
  createdAt: DateTime!
  phoneNumber: String
}
```

#### Query Naming

**Format:** Descriptive, verb-based

**Examples:**

✅ **Good:**

```graphql
type Query {
  getUser(id: ID!): User
  listUsers(page: Int, pageSize: Int): UserConnection
  searchUsers(query: String!): [User!]!
}
```

#### Mutation Naming

**Format:** Verb + object

**Examples:**

✅ **Good:**

```graphql
type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}
```

#### Input Type Naming

**Format:** `{Type}Input`

**Examples:**

✅ **Good:**

```graphql
input CreateUserInput {
  firstName: String!
  lastName: String!
  email: String!
}

input UpdateUserInput {
  firstName: String
  lastName: String
  email: String
}
```

---

## 6. Database Standards

**Database System:** [PostgreSQL / MongoDB / MySQL / etc.]

### 6.1 Table/Collection Naming

**Format:** [Plural, snake_case / lowercase]

**Rules:**

- Use plural nouns
- Lowercase with underscores (for SQL databases)
- Descriptive names

**Examples:**

✅ **Good:**

```sql
users
orders
order_items
payment_methods
user_profiles
```

❌ **Bad:**

```sql
User              // Singular, uppercase
tbl_users         // Redundant prefix
Users_Table       // Redundant suffix, mixed case
```

### 6.2 Column/Field Naming

**Format:** [Singular, snake_case / camelCase]

**Rules:**

- Descriptive field names
- Avoid abbreviations
- Consistent casing

**Examples (SQL - snake_case):**

✅ **Good:**

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Examples (MongoDB - camelCase):**

✅ **Good:**

```javascript
{
  _id: ObjectId(...),
  firstName: "John",
  lastName: "Doe",
  email: "john@example.com",
  createdAt: ISODate(...),
  updatedAt: ISODate(...)
}
```

### 6.3 Primary Key Naming

**Format:** [id / {table}_id]

**Examples:**

**Option 1: Simple 'id' (Recommended)**

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  ...
);
```

**Option 2: Prefixed with table name**

```sql
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  ...
);
```

**Recommendation:** [Choose and document project's strategy]

### 6.4 Foreign Key Naming

**Format:** `{referenced_table}_id`

**Examples:**

✅ **Good:**

```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  customer_id INT,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

### 6.5 Index Naming

**Format:** `idx_{table}_{columns}`

**Examples:**

✅ **Good:**

```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_user_id_created_at ON orders(user_id, created_at);
```

### 6.6 Constraint Naming

**Format:** `{type}_{table}_{columns}`

**Types:**

- `pk_` - Primary key
- `fk_` - Foreign key
- `uk_` - Unique key
- `chk_` - Check constraint

**Examples:**

✅ **Good:**

```sql
ALTER TABLE users 
  ADD CONSTRAINT pk_users PRIMARY KEY (id);

ALTER TABLE orders
  ADD CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE users
  ADD CONSTRAINT uk_users_email UNIQUE (email);

ALTER TABLE orders
  ADD CONSTRAINT chk_orders_amount CHECK (amount >= 0);
```

### 6.7 View Naming

**Format:** `v_{descriptive_name}` OR same as tables

**Examples:**

**Option 1: Prefix with 'v_'**

```sql
CREATE VIEW v_active_users AS ...
CREATE VIEW v_monthly_sales AS ...
```

**Option 2: No prefix (same as tables)**

```sql
CREATE VIEW active_users AS ...
CREATE VIEW monthly_sales AS ...
```

### 6.8 Stored Procedure Naming

**Format:** `sp_{action}_{entity}` OR verb-based

**Examples:**

**Option 1: Prefix with 'sp_'**

```sql
CREATE PROCEDURE sp_get_user_orders(user_id INT) ...
CREATE PROCEDURE sp_calculate_totals() ...
```

**Option 2: Verb-based (no prefix)**

```sql
CREATE PROCEDURE get_user_orders(user_id INT) ...
CREATE PROCEDURE calculate_totals() ...
```

---

## 7. Testing Standards

### 7.1 Test File Naming

**Format:** [Suffix or prefix with test framework convention]

**Examples:**

**JavaScript/TypeScript:**

```
UserService.test.ts       # Jest, Vitest
UserService.spec.ts       # Jasmine, Angular
__tests__/UserService.ts  # Jest __tests__ folder convention
```

**Python:**

```
test_user_service.py      # Pytest prefix
user_service_test.py      # Alternative suffix
```

**Java:**

```
UserServiceTest.java      # JUnit suffix
```

### 7.2 Test Case Naming

**Format:** `should_{expected}_when_{condition}` OR `test_{scenario}`

**Examples:**

**JavaScript/TypeScript (Jest/Mocha):**

```typescript
describe('UserService', () => {
  it('should return user when ID exists', () => { ... })
  it('should throw error when user not found', () => { ... })
  it('should create user with valid data', () => { ... })
})
```

**Python (Pytest):**

```python
class TestUserService:
    def test_should_return_user_when_id_exists(self):
        ...
    
    def test_should_throw_error_when_user_not_found(self):
        ...
```

**Java (JUnit):**

```java
@Test
public void shouldReturnUser_WhenIdExists() { ... }

@Test
public void shouldThrowException_WhenUserNotFound() { ... }
```

### 7.3 Test Suite Naming

**Format:** Match source file or feature

**Examples:**

```typescript
describe('UserService', () => { ... })
describe('UserService.getUserById', () => { ... })
describe('Authentication', () => { ... })
```

```python
class TestUserService:
class TestUserServiceGetUserById:
```

### 7.4 Test Data Naming

**Format:** Descriptive constants, SCREAMING_SNAKE_CASE

**Examples:**

✅ **Good:**

```typescript
const VALID_USER_DATA = {
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com'
}

const INVALID_EMAIL = 'not-an-email'
const MOCK_API_RESPONSE = { ... }
```

### 7.5 Mock/Stub Naming

**Format:** Prefix with `mock` or `stub`

**Examples:**

✅ **Good:**

```typescript
const mockUserRepository = {
  findById: jest.fn()
}

const stubPaymentGateway = {
  processPayment: () => Promise.resolve({ success: true })
}
```

### 7.6 Fixture Naming

**Format:** Descriptive names in fixtures/ directory

**Examples:**

```
tests/fixtures/
├── user-data.json
├── sample-orders.csv
├── test-database.sql
└── mock-api-responses.json
```

### 7.7 Coverage Requirements

**Minimum Coverage:** [Specify: e.g., 80% overall]

**Critical Path Coverage:** [Specify: e.g., 100% for business logic]

**Coverage by Type:**

- Unit tests: [e.g., 80% line coverage]
- Integration tests: [e.g., Critical paths covered]
- E2E tests: [e.g., Main user flows covered]

**Examples:**

```
Overall:               80% lines
Business Logic:       100% lines
Controllers:           70% lines
Utilities:             90% lines
```

---

## 8. Git Workflow

### 8.1 Branch Naming Conventions

**Format:** `{type}/{ticket-id}-{description}` OR `{type}/{description}`

#### Branch Types

- **feature/** - New features
- **fix/** OR **bugfix/** - Bug fixes
- **hotfix/** - Urgent production fixes
- **release/** - Release preparation
- **docs/** - Documentation only
- **refactor/** - Code refactoring
- **test/** - Test additions/fixes
- **chore/** - Build, dependencies, etc.

**Examples:**

✅ **Good:**

```
feature/USER-123-add-profile-page
feature/user-authentication
fix/BUG-456-payment-error
fix/login-validation
hotfix/critical-security-patch
release/1.2.0
release/v2.0.0-beta
docs/update-api-documentation
refactor/user-service-cleanup
```

❌ **Bad:**

```
john-branch                 // Not descriptive
new-feature                 // Too generic
Feature/AddProfile          // Wrong casing
add_profile                 // Use hyphens, not underscores
```

### 8.2 Commit Message Format

**Format:** Conventional Commits

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Commit Types

- **feat:** New feature
- **fix:** Bug fix
- **docs:** Documentation only
- **style:** Code style (formatting, no logic change)
- **refactor:** Code refactoring (no feature/fix)
- **test:** Adding/updating tests
- **chore:** Build, dependencies, config

#### Rules

- **Subject:** Imperative mood, lowercase, no period, max 50 chars
- **Body:** Optional, explain what and why (not how), wrap at 72 chars
- **Footer:** Optional, breaking changes, issue references

**Examples:**

✅ **Good:**

```
feat(auth): add OAuth2 login support

Implemented OAuth2 authentication flow with Google and GitHub providers.
Users can now log in using their existing accounts.

Closes #123
```

```
fix(payment): resolve duplicate charge issue

Fixed race condition in payment processing that caused duplicate charges
when users clicked submit multiple times.

Fixes #456
```

```
docs(api): update endpoint documentation

- Added examples for new endpoints
- Updated request/response schemas
- Fixed typos in authentication section
```

```
refactor(user): simplify user validation logic

Extracted validation rules into separate functions for better testability.
No functional changes.
```

❌ **Bad:**

```
Fixed bug                  // Not descriptive
Add feature                // Missing type
feat: Added new feature.   // Not imperative, has period
FEAT(AUTH): LOGIN          // Wrong casing
```

### 8.3 PR/MR Naming

**Format:** Same as commit message format OR `[TICKET-ID] Description`

**Examples:**

✅ **Good:**

```
feat(auth): add OAuth2 login support
[USER-123] Add user profile page
fix: resolve payment validation error
```

### 8.4 PR/MR Description Format

**Template:**

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?
Describe the tests you ran and how to reproduce them.

## Checklist
- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Screenshots (if applicable)
[Add screenshots here]

## Related Issues
Closes #123
Relates to #456
```

### 8.5 Tag Naming for Releases

**Format:** Semantic Versioning: `v{major}.{minor}.{patch}[-{prerelease}]`

**Rules:**

- **Major:** Breaking changes
- **Minor:** New features (backwards-compatible)
- **Patch:** Bug fixes (backwards-compatible)
- **Prerelease:** alpha, beta, rc.1, etc.

**Examples:**

✅ **Good:**

```
v1.0.0
v1.2.3
v2.0.0-alpha.1
v2.0.0-beta.2
v2.0.0-rc.1
v3.1.4
```

❌ **Bad:**

```
1.0.0              // Missing 'v' prefix
v1.0               // Missing patch version
release-1.0.0      // Wrong prefix
```

---

## 9. Documentation Standards

### 9.1 Code Comment Conventions

**When to Comment:**

- Complex algorithms and logic
- Non-obvious decisions or workarounds
- Business rules and constraints
- Public API methods/classes
- Deprecation warnings

**When NOT to Comment:**

- Self-explanatory code
- What code does (comment WHY, not WHAT)
- Obvious getter/setter methods
- Redundant information

**Examples:**

✅ **Good:**

```typescript
// Calculate tax using 2026 federal tax brackets
// NOTE: This will need updating annually
function calculateTax(income: number): number {
  ...
}

// WORKAROUND: API doesn't support batch delete, so we delete one by one
// TODO: Remove this when API v2 is released
for (const item of items) {
  await deleteItem(item.id)
}
```

❌ **Bad:**

```typescript
// This function adds two numbers
function add(a: number, b: number): number {
  return a + b  // Returns the sum
}
```

### 9.2 Docstring/JSDoc Format

**Format:** Consistent structure with parameters, return values, and examples

#### TypeScript/JavaScript (JSDoc)

```typescript
/**
 * Retrieves a user by their unique identifier.
 * 
 * @param userId - The unique identifier of the user
 * @returns The user object if found
 * @throws {UserNotFoundError} If the user does not exist
 * @throws {DatabaseError} If database connection fails
 * 
 * @example
 * ```typescript
 * const user = await getUser(123)
 * console.log(user.name)
 * ```
 */
async function getUser(userId: number): Promise<User> {
  ...
}
```

#### Python (Docstring)

```python
def get_user(user_id: int) -> User:
    """
    Retrieves a user by their unique identifier.
    
    Args:
        user_id: The unique identifier of the user.
    
    Returns:
        User object if found.
    
    Raises:
        UserNotFoundError: If the user does not exist.
        DatabaseError: If database connection fails.
    
    Example:
        >>> user = get_user(123)
        >>> print(user.name)
        'John Doe'
    """
    ...
```

#### Java (Javadoc)

```java
/**
 * Retrieves a user by their unique identifier.
 *
 * @param userId the unique identifier of the user
 * @return the User object if found
 * @throws UserNotFoundException if the user does not exist
 * @throws DatabaseException if database connection fails
 */
public User getUser(int userId) throws UserNotFoundException {
    ...
}
```

### 9.3 README Structure

**Standard Sections:**

```markdown
# Project Name
Brief description of what the project does.

## Features
- Feature 1
- Feature 2
- Feature 3

## Prerequisites
- Node.js 18+
- PostgreSQL 15+
- etc.

## Installation
\```bash
npm install
\```

## Configuration
\```bash
cp .env.example .env
# Edit .env with your settings
\```

## Usage
\```bash
npm start
\```

## Testing
\```bash
npm test
\```

## API Documentation
See [API.md](docs/API.md) for endpoint documentation.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License
[MIT](LICENSE)
```

### 9.4 Inline Documentation

**Guidelines:**

- Explain complex algorithms step-by-step
- Document business rules and constraints
- Clarify non-obvious decisions
- Explain workarounds and their reasons
- Add TODO/FIXME/HACK comments with context

**Examples:**

✅ **Good:**

```typescript
// Business Rule: Users must be 18+ to create account
if (age < 18) {
  throw new ValidationError('Must be 18 or older')
}

// HACK: API returns timestamps as strings, convert to Date
// TODO: Remove this when API v2 returns proper Date objects
const date = new Date(response.timestamp)

// Algorithm: Binary search for efficient lookup
// Time complexity: O(log n)
let left = 0
let right = array.length - 1
...
```

### 9.5 API Documentation Format

**For REST APIs:** OpenAPI/Swagger specification

**For GraphQL APIs:** GraphQL schema with descriptions

**Example (OpenAPI excerpt):**

```yaml
/users/{id}:
  get:
    summary: Get a user by ID
    description: Retrieves detailed information about a user
    parameters:
      - name: id
        in: path
        required: true
        schema:
          type: integer
    responses:
      '200':
        description: User found
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/User'
      '404':
        description: User not found
```

---

## 10. Code Style Guide

### 10.1 Code Formatting Standards

#### Indentation

**Format:** [2 spaces / 4 spaces / tabs]

**Rules:**

- Consistent across entire codebase
- Never mix spaces and tabs
- Configure editor to insert spaces

**By Language:**

- JavaScript/TypeScript: [2 spaces / 4 spaces]
- Python: 4 spaces (PEP 8)
- Java: [2 spaces / 4 spaces]
- Go: Tabs (gofmt default)

**Example (.editorconfig):**

```ini
[*.{js,ts,jsx,tsx}]
indent_style = space
indent_size = 2

[*.py]
indent_style = space
indent_size = 4
```

#### Line Length Limits

**Maximum Line Length:** [80 / 100 / 120 characters]

**Rules:**

- Break long lines at logical points
- Indent continuation lines
- Prefer readability over strict length

**Examples:**

✅ **Good:**

```typescript
const result = calculateComplexValue(
  parameter1,
  parameter2,
  parameter3
)
```

#### Blank Line Usage

**Rules:**

- One blank line between functions/methods
- One blank line between logical code blocks
- Two blank lines between classes (Python)
- No blank lines at start/end of blocks

**Examples:**

✅ **Good:**

```typescript
function getUserData() {
  // Function implementation
}

function getOrderData() {
  // Function implementation
}
```

#### Brace Style

**Format:** [K&R / Allman / Other]

**K&R (Opening brace on same line):**

```typescript
function example() {
  if (condition) {
    doSomething()
  } else {
    doOtherThing()
  }
}
```

**Allman (Opening brace on new line):**

```csharp
function example()
{
  if (condition)
  {
    doSomething()
  }
  else
  {
    doOtherThing()
  }
}
```

**Recommendation:** [Specify project convention]

#### Import/Include Ordering

**Order:**

1. Standard library imports
2. Third-party library imports
3. Local/project imports

**Rules:**

- Alphabetize within each group
- Blank line between groups
- Absolute imports before relative

**Examples:**

**TypeScript:**

```typescript
// Standard library
import * as fs from 'fs'
import * as path from 'path'

// Third-party
import express from 'express'
import { Router } from 'express'

// Local
import { UserService } from './services/UserService'
import { config } from './config'
```

**Python:**

```python
# Standard library
import os
import sys

# Third-party
import requests
import pandas as pd

# Local
from .services import UserService
from .config import config
```

### 10.2 Code Quality Standards

#### Complexity Limits

**Cyclomatic Complexity:**

- Recommended: < 10
- Maximum: < 15

**Cognitive Complexity:**

- Recommended: < 15

**What to do if exceeded:**

- Refactor into smaller functions
- Extract complex conditionals into named functions
- Simplify nested logic

#### Function/Method Length Limits

**Recommended:** < 50 lines  
**Maximum:** < 100 lines

**What to do if exceeded:**

- Extract helper methods
- Break into logical sub-functions
- Consider if function is doing too much

#### File Length Limits

**Recommended:** < 500 lines  
**Maximum:** < 1000 lines

**What to do if exceeded:**

- Split into multiple files by responsibility
- Extract classes/functions into separate modules

#### Duplication Thresholds

**Maximum:** < 3% duplicate code

**What to do:**

- Extract common code into functions/modules
- Use inheritance or composition
- Create shared utilities

#### Code Smell Detection

**Enabled Checks:**

- Long parameter lists (> 5 parameters)
- Deep nesting (> 4 levels)
- God classes (> 500 lines, > 20 methods)
- Large classes (> 1000 lines)
- Switch statements (consider polymorphism)
- Temporary fields
- Feature envy

### 10.3 Linting and Formatting Tools

#### JavaScript/TypeScript: ESLint + Prettier

**Configuration (.eslintrc.js):**

```javascript
module.exports = {
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'prettier'
  ],
  rules: {
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-unused-vars': 'error',
    // Add project-specific rules
  }
}
```

**Configuration (.prettierrc.json):**

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "printWidth": 100,
  "trailingComma": "es5"
}
```

#### Python: Pylint/Flake8 + Black

**Configuration (.pylintrc):**

```ini
[MASTER]
max-line-length=100

[MESSAGES CONTROL]
disable=C0111  # missing-docstring

[BASIC]
good-names=i,j,k,_
```

**Configuration (pyproject.toml for Black):**

```toml
[tool.black]
line-length = 100
target-version = ['py311']
```

#### Pre-Commit Hooks

**JavaScript/TypeScript (Husky + lint-staged):**

**package.json:**

```json
{
  "lint-staged": {
    "*.{js,ts,jsx,tsx}": [
      "eslint --fix",
      "prettier --write"
    ]
  }
}
```

**.husky/pre-commit:**

```bash
#!/bin/sh
npx lint-staged
npm test
```

**Python (pre-commit framework):**

**.pre-commit-config.yaml:**

```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.1.0
    hooks:
      - id: black
  
  - repo: https://github.com/PyCQA/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
  
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
```

---

## Appendix A: Quick Reference Cheat Sheet

See [standards-cheatsheet.md](standards-cheatsheet.md) for a condensed one-page reference.

## Appendix B: Configuration Files

### Generated Configuration Files

The following configuration files enforce these standards:

- `.editorconfig` - Cross-editor configuration
- `.eslintrc.js` / `.pylintrc` - Linter configuration
- `.prettierrc.json` / `pyproject.toml` - Formatter configuration
- `.husky/pre-commit` / `.pre-commit-config.yaml` - Pre-commit hooks

See the project root directory for these files.

## Appendix C: References

**External Standards Referenced:**

- [List relevant style guides: PEP 8, Airbnb Style Guide, Google Java Style, etc.]
- [Framework-specific conventions: React, Vue, Angular docs]
- [API design: REST API best practices, GraphQL spec]
- [Database: PostgreSQL naming conventions, MongoDB best practices]

**Internal Documents:**

- [docs/ground-rules.md](../docs/ground-rules.md) - Project ground rules
- [docs/architecture.md](architecture.md) - System architecture
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines

---

**Document Version:** [Version Number]  
**Last Updated:** [YYYY-MM-DD]  
**Maintained By:** [Team/Organization Name]  
**Questions?** Contact [team-email@example.com]
