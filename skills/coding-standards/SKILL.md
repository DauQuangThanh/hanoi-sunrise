---
name: coding-standards
description: Generates comprehensive coding standards and conventions documentation covering UI naming (mandatory for frontend), code naming, file structure, API design, database conventions, testing, Git workflow, documentation standards, and code style guide. Use when creating product-level standards, establishing coding conventions, standardizing development practices, or when user mentions standards, conventions, style guide, naming conventions, or code quality guidelines.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
---

# Coding Standards Generation Skill

## Overview

This skill generates comprehensive coding standards and conventions documentation for an entire product. It creates a standards document (`docs/standards.md`) that covers all aspects of development: UI naming conventions (mandatory for frontend projects), code naming, file and directory structure, API design, database conventions, testing standards, Git workflow, documentation standards, and code style guide.

The skill performs best practices research specific to the project's technology stack and generates enforcement configurations (.editorconfig, linter configs) along with quick reference guides.

## When to Use

Activate this skill when:

- Creating product-level coding standards and conventions
- Establishing naming conventions for UI components, code, APIs, and databases
- Standardizing development practices across the team
- Defining file structure and project organization standards
- Setting up code quality and style guidelines
- Creating enforcement configurations for linters and formatters
- User mentions: "standards", "conventions", "style guide", "naming conventions", "code quality", "best practices"

**Timing**: Run this AFTER ground-rules and architecture are defined, but BEFORE creating feature implementation plans.

## Prerequisites

**Required Files:**

- `docs/ground-rules.md` - Project principles and constraints
- `docs/architecture.md` - Technology stack and architectural decisions (highly recommended)

**Optional Files:**

- `specs/*/spec.md` - Feature specifications for naming pattern analysis
- Existing `docs/standards.md` - For updates to existing standards

**Validation:**

Use the prerequisite checking scripts to verify required files exist:

**Bash (macOS/Linux):**

```bash
scripts/check-standards-prerequisites.sh
```

**PowerShell (Windows):**

```powershell
.\scripts\check-standards-prerequisites.ps1
```

**JSON Output (for parsing):**

```bash
scripts/check-standards-prerequisites.sh --json
.\scripts\check-standards-prerequisites.ps1 -Json
```

**What the scripts check:**

- Presence of `docs/ground-rules.md` (required)
- Presence of `docs/architecture.md` (recommended)
- Presence of feature specifications in `specs/`
- Existing `docs/standards.md` (for updates)

## Instructions

### Setup Phase

1. **Run prerequisite script** to detect required files:
   - Execute the appropriate script for your platform
   - Parse JSON output to get file paths
   - Verify `ground-rules.md` exists (required)
   - Note if `architecture.md` exists (highly recommended for tech stack context)

2. **Read context files** in order:
   - **MUST READ**: `docs/ground-rules.md` for project principles
   - **MUST READ IF EXISTS**: `docs/architecture.md` for technology stack
   - **READ ALL**: Feature specs from `specs/*/spec.md` for naming pattern analysis
   - **READ IF EXISTS**: Existing `docs/standards.md` for updates

3. **Create docs/ directory** if it doesn't exist:

   ```bash
   mkdir -p docs
   ```

4. **Prepare standards template** location: `docs/standards.md`

### Phase 0: Standards Analysis & Best Practices Research

**Goal**: Analyze project context and research technology-specific best practices.

1. **Analyze project context**:
   - Parse `architecture.md` to identify:
     - Programming languages (Python, Java, TypeScript, Go, etc.)
     - Backend frameworks (Django, Spring Boot, Express, etc.)
     - Frontend frameworks (React, Vue, Angular, Svelte, etc.)
     - Database systems (PostgreSQL, MongoDB, MySQL, etc.)
     - API protocols (REST, GraphQL, gRPC, etc.)
     - Testing frameworks (Jest, Pytest, JUnit, etc.)

2. **Detect UI layer presence** (critical for Phase 1):
   - **Check architecture.md** for frontend frameworks:
     - React, Vue, Angular, Svelte, Solid
     - React Native, Flutter, SwiftUI, Xamarin
     - HTML/CSS/JavaScript
   - **Check repository structure** for UI directories:
     - `src/components/`, `src/ui/`, `frontend/`, `client/`
     - `lib/widgets/`, `Views/`, `screens/`
   - **Check feature specs** for UI requirements:
     - UI mockups, wireframes, component specifications
     - User interface descriptions, screen flows
   - **Determine project type**:
     - ✅ **Frontend/UI project**: Has UI layer → Phase 1 is MANDATORY
     - ❌ **Backend-only**: No UI layer → Phase 1 documents "N/A"

3. **Research best practices** for each detected technology:
   - **For UI frameworks**: "{framework} component naming conventions best practices"
     - Example: "React component naming conventions", "Vue composable naming"
   - **For backend languages**: "{language} naming conventions style guide"
     - Example: "Python PEP 8 naming conventions", "Java naming conventions"
   - **For databases**: "{database} naming conventions best practices"
     - Example: "PostgreSQL table naming conventions", "MongoDB collection naming"
   - **For APIs**: "RESTful API naming conventions", "GraphQL schema naming"
   - **For design systems**: "{design system} naming conventions"
     - Example: "Material Design naming", "Bootstrap class naming"

4. **Research domain-specific conventions**:
   - Web applications: Component naming, CSS class naming, accessibility attributes
   - Mobile applications: Screen naming, view controller naming, navigation patterns
   - API services: Endpoint naming, HTTP methods, status codes, error formats
   - Desktop applications: Window naming, event handler naming, command patterns

**Output**:

- Section 1 (Introduction) drafted with project context
- Technology stack identified
- UI layer presence determined
- Best practices research completed for all technologies

### Phase 1: UI Naming Convention Standards

**Prerequisites:** Phase 0 complete, UI layer presence determined

**CRITICAL RULE**:

- ✅ **If frontend/UI project**: This phase is MANDATORY and must be comprehensive
- ❌ **If backend-only project**: Document "N/A - No UI layer" and skip to Phase 2

**Applicability Check**:

- ✅ REQUIRED: Web apps, mobile apps, desktop GUI apps, design systems, component libraries
- ✅ REQUIRED: Projects with HTML/CSS, React/Vue/Angular, iOS/Android UI, Electron/Tauri
- ✅ REQUIRED: Projects with UI mockups, wireframes, or design specifications
- ❌ SKIP: Pure REST APIs, CLI tools, background services, data pipelines, microservices without UI

**If UI project, document the following comprehensively:**

1. **Component/Widget naming conventions**:
   - Component names format (PascalCase, kebab-case, etc.)
     - Examples: `UserProfile.tsx`, `user-profile.vue`
   - Props/Attributes naming (camelCase, etc.)
     - Examples: `userName`, `isVisible`, `onClick`
   - Event handler naming (handle*, on*)
     - Examples: `handleSubmit`, `onUserClick`
   - State variable naming (descriptive, boolean prefixes)
     - Examples: `isLoading`, `userData`, `hasError`

2. **CSS/Styling naming conventions**:
   - CSS class naming methodology (BEM, utility-first, semantic, etc.)
     - BEM: `.block__element--modifier`
     - Utility: `.flex`, `.text-center`, `.bg-blue-500`
   - ID attribute naming rules (when to use, format)
   - CSS-in-JS naming (styled-components, emotion)
   - Style file naming (`.module.css`, `.styles.ts`)

3. **File naming for UI components**:
   - Component files: `ComponentName.tsx`, `component-name.vue`
   - Style files: `ComponentName.module.css`, `component-name.styles.ts`
   - Test files: `ComponentName.test.tsx`, `component-name.spec.ts`
   - Story files: `ComponentName.stories.tsx`

4. **Directory structure for UI code**:
   - Component directory patterns:

     ```
     src/components/
       UserProfile/
         UserProfile.tsx
         UserProfile.styles.ts
         UserProfile.test.tsx
         index.ts
     ```

   - Asset organization (images, icons, fonts)
   - Layout component patterns
   - Shared/common component organization

5. **Accessibility naming conventions**:
   - ARIA attribute naming (`aria-label`, `aria-describedby`)
   - Role naming (`role="navigation"`, `role="button"`)
   - Label associations (`htmlFor`, `id`)
   - Landmark naming (`<nav>`, `<main>`, `<aside>`)

6. **Framework-specific conventions**:
   - **React**: Hook naming (`use` prefix), Context naming, HOC naming
     - Examples: `useUserData`, `UserContext`, `withAuth`
   - **Vue**: Composable naming, Directive naming, Plugin naming
     - Examples: `useCounter`, `v-focus`, `myPlugin`
   - **Angular**: Service naming, Directive naming, Pipe naming
     - Examples: `UserService`, `HighlightDirective`, `DatePipe`
   - **Native mobile**: ViewController/Activity naming, View naming
     - Examples: `UserProfileViewController`, `MainActivity`

7. **Do's and Don'ts** with examples:
   - ✅ DO: `<UserProfile userId={123} />` (clear, descriptive)
   - ❌ DON'T: `<UP uid={123} />` (cryptic abbreviations)
   - ✅ DO: `.user-profile__avatar--large` (BEM structure)
   - ❌ DON'T: `.UP-av-lg` (unclear abbreviations)

8. **Common anti-patterns to avoid**:
   - Generic names: `Component1`, `thing`, `data`
   - Inconsistent casing: mixing PascalCase and kebab-case
   - Missing semantic meaning: `div1`, `container3`
   - Non-descriptive event handlers: `handle`, `onClick1`

**If backend-only project:**

- Document: "## 2. UI Naming Conventions\n\n**N/A** - This project has no UI layer. It is a backend-only service providing APIs without frontend components."

**Output**: Section 2 (UI Naming Conventions) - comprehensive for UI projects, or "N/A" for backend-only

### Phase 2: Code Naming Convention Standards

**Prerequisites:** Phase 1 complete

**Goal**: Define naming conventions for all code elements (variables, functions, classes, modules).

1. **Variable naming conventions**:
   - Local variables: `camelCase` or `snake_case` (language-dependent)
     - Examples: `userName`, `user_name`, `isValid`
   - Constants: `SCREAMING_SNAKE_CASE`
     - Examples: `MAX_RETRIES`, `API_BASE_URL`, `DEFAULT_TIMEOUT`
   - Global variables: When allowed, how named
   - Class/Instance variables: Prefix conventions (if any)
     - Examples: `_privateField`, `this.userName`

2. **Function/Method naming conventions**:
   - Function names: Verb-based, descriptive, `camelCase` or `snake_case`
     - Examples: `getUserData()`, `calculateTotal()`, `validate_email()`
   - Method names: Same as functions
   - Constructor names: Match class name (language-dependent)
   - Getter/Setter naming: `getProperty()`, `setProperty()` or property access
     - Examples: `getName()`, `setName()`, or `user.name`
   - Boolean function prefixes: `is`, `has`, `should`, `can`, `will`
     - Examples: `isValid()`, `hasPermission()`, `canEdit()`, `shouldRetry()`

3. **Class/Type naming conventions**:
   - Class names: `PascalCase`, noun-based
     - Examples: `UserProfile`, `PaymentProcessor`, `DataValidator`
   - Interface names: `PascalCase`, with or without 'I' prefix (language-dependent)
     - Examples: `IUserRepository`, `UserRepository`, `Drawable`
   - Enum names: `PascalCase`, singular or plural (language-dependent)
     - Examples: `UserRole`, `HttpMethod`, `OrderStatus`
   - Type alias names: `PascalCase`
     - Examples: `UserId`, `Timestamp`, `Coordinates`
   - Generic type parameter names: `T`, `TKey`, `TValue`, `TResult`
     - Examples: `List<T>`, `Map<TKey, TValue>`, `Result<TData, TError>`

4. **Module/Package naming conventions**:
   - Module names: `lowercase`, `snake_case`, or `kebab-case` (language-dependent)
     - Examples: `user_service`, `payment-processor`, `datavalidator`
   - Package names: Hierarchical, reverse domain (Java) or flat (Python)
     - Examples: `com.example.user`, `user.service`, `payment_processor`
   - Namespace conventions: PascalCase or lowercase (language-dependent)
   - Import alias conventions: Meaningful abbreviations
     - Examples: `import numpy as np`, `import pandas as pd`

**Output**: Section 3 (Code Naming Conventions) completed with language-specific examples

### Phase 3: File, Directory & Project Structure Standards

**Prerequisites:** Phase 2 complete

**Goal**: Define file naming and directory organization standards.

1. **File naming conventions**:
   - Source code files: Match class/module name, appropriate extension
     - Examples: `UserService.java`, `user_service.py`, `user-service.ts`
   - Test files: Suffix or prefix convention
     - Examples: `UserService.test.ts`, `test_user_service.py`, `UserServiceTest.java`
   - Configuration files: Lowercase, descriptive
     - Examples: `.eslintrc.js`, `jest.config.js`, `pytest.ini`
   - Documentation files: Uppercase or capitalized
     - Examples: `README.md`, `CONTRIBUTING.md`, `API.md`

2. **Directory structure standards**:
   - Source code organization (feature-based or layer-based):
     - **Feature-based**:

       ```
       src/
         features/
           user/
             UserService.ts
             UserRepository.ts
             user.test.ts
           payment/
             PaymentService.ts
             payment.test.ts
       ```

     - **Layer-based**:

       ```
       src/
         controllers/
           UserController.ts
         services/
           UserService.ts
         repositories/
           UserRepository.ts
         models/
           User.ts
       ```

   - Test directory structure: Mirror source structure or separate `tests/`
   - Asset directories: `assets/`, `public/`, `static/`
   - Configuration directories: `config/`, `.config/`
   - Documentation directories: `docs/`, `documentation/`

3. **Project structure patterns**:
   - Monorepo vs multi-repo decision criteria
   - Shared code organization: `common/`, `shared/`, `lib/`
   - Build output directories: `dist/`, `build/`, `out/`
   - Vendor/third-party code: `vendor/`, `third_party/`

**Output**: Section 4 (File and Directory Structure) completed with project-specific patterns

### Phase 4: API, Database & Integration Standards

**Prerequisites:** Phase 3 complete

**Goal**: Define API design and database naming standards.

1. **API design standards** (if REST):
   - Endpoint naming: Plural nouns, lowercase, hyphens
     - Examples: `/users`, `/orders/{id}`, `/user-profiles`
   - HTTP methods usage:
     - GET: Retrieve resources (idempotent)
     - POST: Create new resources
     - PUT: Full update of existing resource (idempotent)
     - PATCH: Partial update of existing resource
     - DELETE: Remove resource (idempotent)
   - Query parameter naming: `camelCase` or `snake_case`
     - Examples: `?sortBy=name&pageSize=20`, `?sort_by=name&page_size=20`
   - Request/Response body structure: JSON, consistent field naming
   - Error response format: Consistent structure with error codes

     ```json
     {
       "error": {
         "code": "INVALID_INPUT",
         "message": "Email format is invalid",
         "field": "email"
       }
     }
     ```

   - API versioning strategy: URL path (`/v1/users`) or header-based

2. **API design standards** (if GraphQL):
   - Type naming: `PascalCase`
     - Examples: `User`, `Order`, `PaymentMethod`
   - Field naming: `camelCase`
     - Examples: `firstName`, `createdAt`, `orderItems`
   - Query naming: Descriptive, verb-based
     - Examples: `getUser`, `listOrders`, `searchProducts`
   - Mutation naming: Verb + object
     - Examples: `createUser`, `updateOrder`, `deletePayment`
   - Input type naming: `{Type}Input`
     - Examples: `UserInput`, `OrderInput`, `PaymentInput`

3. **Database naming conventions**:
   - Table names: Plural, `snake_case` or `lowercase`
     - Examples: `users`, `order_items`, `payment_methods`
   - Column names: Singular, `snake_case` or `camelCase`
     - Examples: `user_id`, `first_name`, `created_at`
   - Primary key naming: `id` or `{table}_id`
     - Examples: `id`, `user_id`
   - Foreign key naming: `{referenced_table}_id`
     - Examples: `user_id`, `order_id`, `customer_id`
   - Index naming: `idx_{table}_{columns}`
     - Examples: `idx_users_email`, `idx_orders_user_id_created_at`
   - Constraint naming: `{type}_{table}_{columns}`
     - Examples: `fk_orders_user_id`, `uk_users_email`, `chk_orders_amount`
   - View naming: `v_{descriptive_name}` or same as tables
     - Examples: `v_active_users`, `v_monthly_sales`
   - Stored procedure naming: `sp_{action}_{entity}` or verb-based
     - Examples: `sp_get_user_orders`, `calculate_totals`

4. **Integration conventions**:
   - Message queue naming: `{service}.{entity}.{action}`
     - Examples: `user.profile.created`, `order.payment.processed`
   - Event naming: Past tense, `PascalCase` or `SCREAMING_SNAKE_CASE`
     - Examples: `UserCreated`, `OrderShipped`, `USER_PROFILE_UPDATED`
   - Webhook naming: `/webhooks/{service}/{event}`
     - Examples: `/webhooks/stripe/payment-success`, `/webhooks/github/push`

**Output**: Section 5 (API Design Standards) and Section 6 (Database Standards) completed

### Phase 5: Testing, Git & Documentation Standards

**Prerequisites:** Phase 4 complete

**Goal**: Define testing, Git workflow, and documentation standards.

1. **Testing standards**:
   - Test file naming: Suffix or prefix with test framework convention
     - Examples: `UserService.test.ts`, `test_user_service.py`, `UserServiceTest.java`
   - Test case naming: Descriptive, structure: `should_{expected}_when_{condition}`
     - Examples: `should_return_user_when_id_exists`, `should_throw_error_when_user_not_found`
   - Test suite naming: Match source file or feature
     - Examples: `describe('UserService', ...)`, `class TestUserService:`
   - Test data naming: Descriptive constants
     - Examples: `VALID_USER_DATA`, `INVALID_EMAIL`, `MOCK_API_RESPONSE`
   - Mock/Stub naming: Prefix with `mock` or `stub`
     - Examples: `mockUserRepository`, `stubPaymentGateway`
   - Fixture naming: Descriptive, in `fixtures/` directory
     - Examples: `user-data.json`, `sample-orders.csv`
   - Coverage requirements: Minimum percentage, critical path coverage
     - Examples: "80% overall, 100% for business logic"

2. **Git workflow standards**:
   - Branch naming conventions:
     - Feature branches: `feature/{ticket-id}-{description}` or `feat/{description}`
       - Examples: `feature/USER-123-add-profile-page`, `feat/user-authentication`
     - Bugfix branches: `bugfix/{ticket-id}-{description}` or `fix/{description}`
       - Examples: `bugfix/BUG-456-fix-login-error`, `fix/payment-validation`
     - Hotfix branches: `hotfix/{description}`
       - Examples: `hotfix/critical-security-patch`
     - Release branches: `release/{version}`
       - Examples: `release/1.2.0`, `release/v2.0.0-beta`

   - Commit message format (Conventional Commits):

     ```
     <type>(<scope>): <subject>
     
     <body>
     
     <footer>
     ```

     - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
     - Examples:
       - `feat(auth): add OAuth2 login support`
       - `fix(payment): resolve duplicate charge issue`
       - `docs(api): update endpoint documentation`

   - PR/MR naming: Match commit message format or ticket number
     - Examples: `feat: Add user profile page`, `[USER-123] Add profile page`

   - PR/MR description format: Template with sections

     ```markdown
     ## Description
     Brief description of changes
     
     ## Type of Change
     - [ ] Bug fix
     - [ ] New feature
     - [ ] Breaking change
     
     ## Testing
     How was this tested?
     
     ## Checklist
     - [ ] Tests added/updated
     - [ ] Documentation updated
     ```

   - Tag naming for releases: Semantic versioning
     - Examples: `v1.2.3`, `v2.0.0-beta.1`

3. **Documentation standards**:
   - Code comment conventions: When to comment, avoid obvious comments
     - Comment: Complex logic, non-obvious decisions, workarounds
     - Don't comment: Self-explanatory code, what code does (comment why)

   - Docstring/JSDoc format: Consistent structure with parameters and return values
     - **Python (docstring)**:

       ```python
       def get_user(user_id: int) -> User:
           """
           Retrieves a user by ID.
           
           Args:
               user_id: The unique identifier of the user.
           
           Returns:
               User object if found.
           
           Raises:
               UserNotFoundError: If user does not exist.
           """
       ```

     - **TypeScript (JSDoc)**:

       ```typescript
       /**
        * Retrieves a user by ID.
        * 
        * @param userId - The unique identifier of the user
        * @returns User object if found
        * @throws {UserNotFoundError} If user does not exist
        */
       function getUser(userId: number): User {
       ```

   - README structure: Standard sections

     ```markdown
     # Project Name
     Brief description
     
     ## Features
     ## Prerequisites
     ## Installation
     ## Usage
     ## Configuration
     ## Testing
     ## Contributing
     ## License
     ```

   - Inline documentation: Explain complex algorithms, business rules

   - API documentation format: OpenAPI/Swagger for REST, GraphQL schema for GraphQL

**Output**: Sections 7 (Testing Standards), 8 (Git Workflow), 9 (Documentation Standards) completed

### Phase 6: Code Quality & Style Guide

**Prerequisites:** Phase 5 complete

**Goal**: Define code formatting, quality standards, and enforcement tools.

1. **Code formatting standards**:
   - Indentation: Spaces or tabs, size (2 spaces, 4 spaces, etc.)
   - Line length limits: 80, 100, or 120 characters
   - Blank line usage: Between functions, classes, logical blocks
   - Brace style: K&R, Allman, or language-default
     - K&R: `function() {` (opening brace on same line)
     - Allman: `function()\n{` (opening brace on new line)
   - Import/Include ordering: Standard library, third-party, local
     - Example (Python):

       ```python
       # Standard library
       import os
       import sys
       
       # Third-party
       import requests
       import pandas as pd
       
       # Local
       from .models import User
       from .services import UserService
       ```

2. **Code quality standards**:
   - Complexity limits:
     - Cyclomatic complexity: < 10 (recommended), < 15 (maximum)
     - Cognitive complexity: < 15
   - Function/Method length limits: < 50 lines (recommended), < 100 lines (max)
   - File length limits: < 500 lines (recommended), < 1000 lines (max)
   - Duplication thresholds: < 3% duplicate code
   - Code smell detection: Enabled with specific rules
     - Long parameter lists (> 5 parameters)
     - Deep nesting (> 4 levels)
     - God classes (> 500 lines, > 20 methods)

3. **Linting and formatting tools**:
   - Linter configurations by language:
     - **JavaScript/TypeScript**: ESLint with config
       - `.eslintrc.js` with Airbnb, Standard, or custom ruleset
     - **Python**: Pylint, Flake8, or Ruff
       - `.pylintrc`, `.flake8`, or `ruff.toml`
     - **Java**: Checkstyle or SpotBugs
       - `checkstyle.xml`
     - **Go**: golint or staticcheck
     - **Ruby**: RuboCop
       - `.rubocop.yml`

   - Code formatter configurations:
     - **JavaScript/TypeScript**: Prettier
       - `.prettierrc.json`
     - **Python**: Black or autopep8
       - `pyproject.toml` with Black config
     - **Go**: gofmt or goimports (built-in)
     - **Java**: google-java-format or prettier-java
     - **Rust**: rustfmt
       - `rustfmt.toml`

   - Pre-commit hooks: Run linters and formatters before commit
     - Tools: Husky (JS), pre-commit (Python), lefthook
     - Example (Python with pre-commit):

       ```yaml
       # .pre-commit-config.yaml
       repos:
         - repo: https://github.com/psf/black
           rev: 23.1.0
           hooks:
             - id: black
         - repo: https://github.com/PyCQA/flake8
           rev: 6.0.0
           hooks:
             - id: flake8
       ```

**Output**: Section 10 (Code Style Guide) completed with language-specific configurations

### Phase 7: Finalization & Quick Reference Guides

**Prerequisites:** Phase 6 complete

**Goal**: Generate enforcement configurations, quick reference guides, and finalize standards document.

1. **Generate enforcement tool configurations**:

   - **`.editorconfig`** (cross-editor settings):

     ```ini
     root = true
     
     [*]
     charset = utf-8
     end_of_line = lf
     insert_final_newline = true
     trim_trailing_whitespace = true
     
     [*.{js,ts,jsx,tsx}]
     indent_style = space
     indent_size = 2
     
     [*.{py}]
     indent_style = space
     indent_size = 4
     
     [*.{yml,yaml}]
     indent_style = space
     indent_size = 2
     ```

   - **Linter configuration files** (language-specific):
     - Create `.eslintrc.js`, `.pylintrc`, etc. based on project languages
     - Include rules that enforce naming conventions and code style

   - **Formatter configuration files**:
     - Create `.prettierrc.json`, `pyproject.toml` (with Black), etc.
     - Configure line length, indentation, trailing commas

   - **Pre-commit hook scripts**:
     - Create `.husky/pre-commit` or `.pre-commit-config.yaml`
     - Run linters, formatters, and tests before commit

2. **Create quick reference guides**:

   - **`docs/standards-cheatsheet.md`**: One-page condensed reference

     ```markdown
     # Coding Standards Cheat Sheet
     
     ## Naming Conventions
     - Variables: `camelCase` / `snake_case`
     - Constants: `SCREAMING_SNAKE_CASE`
     - Functions: `verbNoun()` / `verb_noun()`
     - Classes: `PascalCase`
     - Files: `PascalCase.ext` / `kebab-case.ext`
     
     ## Code Style
     - Indentation: 2/4 spaces (language-dependent)
     - Line length: 100 characters max
     - Imports: stdlib, third-party, local
     
     ## Git Workflow
     - Branches: `feat/description`, `fix/description`
     - Commits: `type(scope): subject`
     - Tags: `v1.2.3`
     
     ## Testing
     - Coverage: 80% minimum
     - Naming: `should_{expected}_when_{condition}`
     ```

   - **`docs/ui-naming-quick-ref.md`** (if UI project): UI-specific quick reference

     ```markdown
     # UI Naming Quick Reference
     
     ## Components
     - Names: `PascalCase` (e.g., `UserProfile`)
     - Files: `ComponentName.tsx`
     - Props: `camelCase` (e.g., `userName`, `onClick`)
     
     ## CSS
     - Classes: BEM (`.block__element--modifier`)
     - IDs: Avoid except for unique elements
     
     ## Event Handlers
     - Format: `handle{Event}` (e.g., `handleSubmit`, `handleClick`)
     
     ## State
     - Booleans: `is*`, `has*`, `should*`
     - Data: Descriptive nouns
     ```

3. **Validate standards document**:
   - Ensure all sections are complete:
     - [ ] Introduction (with project context)
     - [ ] UI Naming Conventions (comprehensive if UI project, "N/A" if backend-only)
     - [ ] Code Naming Conventions
     - [ ] File and Directory Structure
     - [ ] API Design Standards
     - [ ] Database Standards
     - [ ] Testing Standards
     - [ ] Git Workflow
     - [ ] Documentation Standards
     - [ ] Code Style Guide
   - Check consistency with architecture.md and ground-rules.md
   - Verify all examples use project-specific technologies
   - Ensure UI naming conventions are detailed (MANDATORY for frontend/UI projects)

4. **Output file locations**:

   ```
   docs/
   ├── standards.md              # Main standards document
   ├── standards-cheatsheet.md   # One-page quick reference
   └── ui-naming-quick-ref.md    # UI naming quick reference (if UI project)
   
   # Root level configuration files
   .editorconfig                 # Editor configuration
   .eslintrc.js / .pylintrc      # Linter config (language-specific)
   .prettierrc / pyproject.toml  # Formatter config (language-specific)
   .husky/ or .pre-commit-config.yaml  # Pre-commit hooks
   ```

**Output**: Complete `docs/standards.md`, quick reference guides, enforcement configurations

## Success Criteria

The standards document is complete and ready when:

- [ ] **UI naming conventions** are comprehensive and detailed (MANDATORY for frontend/UI projects)
- [ ] For backend-only projects, Section 2 documents "N/A - No UI layer"
- [ ] All code elements have naming conventions defined with examples
- [ ] File and directory structure is documented with project-specific patterns
- [ ] API design standards are specified (if applicable)
- [ ] Database naming conventions are established (if applicable)
- [ ] Testing standards are documented with coverage requirements
- [ ] Git workflow and commit message conventions are defined
- [ ] Documentation standards are specified with templates
- [ ] Code style guide is complete with formatting rules
- [ ] All conventions have concrete, language-specific examples
- [ ] All examples use project-specific technologies (from architecture.md)
- [ ] Enforcement tool configurations are generated
- [ ] Quick reference guides are created
- [ ] Standards are consistent with architecture.md and ground-rules.md
- [ ] `docs/standards.md` is committed with "docs: add coding standards" message

## Error Handling

**Common Errors and Solutions:**

1. **Error**: `ground-rules.md not found`
   - **Cause**: Required ground-rules file missing
   - **Action**: Create `docs/ground-rules.md` with project principles first, or specify the correct path

2. **Error**: `architecture.md not found`
   - **Cause**: Recommended architecture file missing
   - **Action**: Create `docs/architecture.md` with technology stack, or proceed with limited context (will need manual tech stack input)

3. **Error**: UI naming section incomplete for frontend project
   - **Cause**: UI project detected but UI naming conventions not detailed
   - **Action**: Expand Section 2 with all required UI naming elements (components, props, CSS, files, accessibility, framework-specific)

4. **Error**: Naming conventions conflict with ground-rules
   - **Cause**: Proposed standards violate ground-rules constraints
   - **Action**: Review ground-rules.md and align standards, or update ground-rules if principle changed

5. **Error**: Examples don't match project tech stack
   - **Cause**: Used generic examples instead of project-specific technologies
   - **Action**: Re-read architecture.md, replace examples with actual project languages/frameworks

## Templates

Use the provided template for standards document generation:

**Template Location**: `templates/standards-document.md`

The template includes:

- Complete document structure with all sections
- Placeholder guidance for each section
- Example formats for naming conventions
- Research prompt suggestions
- Enforcement configuration templates

## Examples

For detailed examples including full-stack web applications, backend APIs, mobile apps, and microservices, see [`references/EXAMPLES.md`](references/EXAMPLES.md).

## Notes

- **Product-level standards**: This skill creates standards for the ENTIRE product, not individual features
- **Run timing**: Execute AFTER ground-rules and architecture, BEFORE feature design/implementation
- **UI naming is critical**: For frontend/UI projects, UI naming conventions MUST be comprehensive - this is non-negotiable
- **Backend-only exception**: Only skip detailed UI naming if project has NO UI layer (pure APIs, CLI, workers)
- **Technology-specific**: All examples and configurations must match the project's actual tech stack
- **Consistency**: Standards must align with ground-rules.md and architecture.md
- **Enforcement**: Standards should be enforced through automated tools (linters, formatters, pre-commit hooks)
- **Living document**: Update standards.md as the project evolves and new patterns emerge
- **Team review**: Consider having the team review and approve standards before full enforcement
- **Incremental adoption**: Can adopt standards gradually (start with naming, then add code style, then enforcement)

## Additional Resources

For more detailed guidance, see:

- `templates/standards-document.md` - Complete standards document template with all sections
- Agent Skills specification - For skill creation best practices
- Project ground-rules - For understanding project principles
- Project architecture - For technology stack context

## Version History

- **v1.0** (2026-01-26): Initial release
  - Complete 7-phase standards generation workflow
  - UI naming conventions (mandatory for frontend)
  - Code, file, API, database, testing, Git, documentation standards
  - Code quality and style guide
  - Enforcement configurations and quick reference guides
