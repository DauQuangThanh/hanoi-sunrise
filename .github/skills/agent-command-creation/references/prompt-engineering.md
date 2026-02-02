# Prompt Engineering Patterns

Advanced techniques for writing effective agent command instructions.

## Core Principles

### 1. Chain-of-Thought Prompting

Encourage step-by-step reasoning to improve accuracy and transparency.

**Pattern:**
```markdown
## Instructions

Think through this process step by step:

1. **First**, [initial action]
2. **Then**, [next action]
3. **Next**, [following action]
4. **After that**, [subsequent action]
5. **Finally**, [concluding action]

Explain your reasoning as you work through each step.
```

**Example:**
```markdown
## Code Review Process

Perform a thorough review by thinking through each aspect:

1. **First**, read the entire code to understand overall structure
2. **Then**, analyze each function for correctness and efficiency
3. **Next**, check for security vulnerabilities (SQL injection, XSS, etc.)
4. **After that**, evaluate performance implications
5. **Finally**, provide consolidated recommendations

Think out loud as you work through each step.
```

### 2. Role-Based Prompting

Assign specific expertise to improve response quality.

**Pattern:**
```markdown
You are a [specific role] with [X years] of experience in [domain].

Your expertise includes:
- [Area 1]
- [Area 2]
- [Area 3]

When [performing task]:
1. [Approach from expert perspective]
2. [Apply domain knowledge]
3. [Provide authoritative guidance]
```

**Example:**
```markdown
You are a senior security engineer with 15 years of experience in application security.

Your expertise includes:
- OWASP Top 10 vulnerabilities
- Secure coding practices
- Cryptography and data protection
- Authentication and authorization systems

When reviewing code:
1. Think like an attacker trying to exploit vulnerabilities
2. Consider both technical and business impact
3. Provide specific, actionable remediation steps
4. Reference relevant security standards (OWASP, CWE)
```

### 3. Few-Shot Learning

Provide concrete examples to demonstrate expected format.

**Pattern:**
```markdown
## Instructions

[Task description]

Follow these examples:

### Example 1: [Scenario]
[Input]
[Expected output]

### Example 2: [Scenario]
[Input]
[Expected output]

Now apply this pattern to: $ARGUMENTS
```

**Example:**
```markdown
## API Endpoint Design

Design RESTful API endpoints following these examples:

### Example 1: User Resource
```
GET    /api/v1/users           - List all users
GET    /api/v1/users/:id       - Get specific user
POST   /api/v1/users           - Create new user
PUT    /api/v1/users/:id       - Update user
DELETE /api/v1/users/:id       - Delete user
```

### Example 2: Nested Resource
```
GET    /api/v1/users/:id/posts       - List user's posts
POST   /api/v1/users/:id/posts       - Create post for user
DELETE /api/v1/users/:id/posts/:pid  - Delete user's post
```

Now design endpoints for: $ARGUMENTS
```

### 4. Constraint-Based Prompting

Define explicit constraints to guide behavior.

**Pattern:**
```markdown
## Constraints

### Technical Constraints
- [Constraint 1]
- [Constraint 2]

### Business Constraints
- [Constraint 1]
- [Constraint 2]

### Security Constraints
- [Constraint 1]
- [Constraint 2]

All solutions must satisfy these constraints.
```

**Example:**
```markdown
## Database Schema Design

Design a database schema with these constraints:

### Technical Constraints
- Must use PostgreSQL 14+
- Maximum table size: 100M rows
- Query response time: < 100ms for 95th percentile
- Support for full-text search

### Business Constraints
- Support multi-tenancy with data isolation
- Maintain audit trail for all changes
- Enable soft deletes for compliance
- Support for eventual consistency

### Security Constraints
- Encrypt PII data at rest
- Implement row-level security
- No sensitive data in logs
- GDPR-compliant data retention
```

### 5. Output Format Specification

Always specify exact output format with examples.

**Pattern:**
```markdown
## Output Format

Create a [file type] named `[path/filename]` with this structure:

```[language]
[Example structure with placeholders]
```

Include:
- [Required element 1]
- [Required element 2]
- [Required element 3]
```

**Example:**
```markdown
## Output Format

Create a JSON file named `schema/database.json` with this structure:

```json
{
  "tables": [
    {
      "name": "table_name",
      "description": "Purpose of table",
      "columns": [
        {
          "name": "column_name",
          "type": "data_type",
          "nullable": true,
          "default": null,
          "description": "Column purpose"
        }
      ],
      "indexes": [
        {
          "name": "index_name",
          "columns": ["col1", "col2"],
          "unique": true
        }
      ]
    }
  ],
  "relationships": [
    {
      "from": "table.column",
      "to": "table.column",
      "type": "one-to-many"
    }
  ]
}
```

Include:
- All tables with descriptions
- Complete column definitions
- All indexes and constraints
- Foreign key relationships
- Comments explaining design decisions
```

## Advanced Patterns

### 6. Progressive Refinement

Break complex tasks into phases with validation.

**Pattern:**
```markdown
## Instructions

### Phase 1: [Initial Stage]
[Steps for phase 1]

**Checkpoint:** Verify [specific criteria]

### Phase 2: [Next Stage]
[Steps for phase 2]

**Checkpoint:** Ensure [specific criteria]

### Phase 3: [Final Stage]
[Steps for phase 3]

**Final Validation:** Confirm [complete criteria]
```

**Example:**
```markdown
## Feature Implementation Process

### Phase 1: Analysis
1. Read specification in `specs/FEATURE.md`
2. Identify key requirements and constraints
3. List dependencies and integration points
4. Map to existing architecture patterns

**Checkpoint:** Verify all requirements are understood and documented

### Phase 2: Design
1. Create technical design in `plans/FEATURE-plan.md`
2. Define component interfaces
3. Identify potential risks
4. Plan testing strategy

**Checkpoint:** Ensure design addresses all requirements and constraints

### Phase 3: Implementation
1. Break down into small, testable units
2. Implement following TDD approach
3. Write tests before code
4. Ensure all tests pass

**Final Validation:** Confirm all requirements implemented and tested
```

### 7. Contextual Awareness

Guide agents to use project-specific context.

**Pattern:**
```markdown
## Context Integration

Before proceeding:

1. **Review Project Standards**
   - Check `ARCHITECTURE.md` for patterns
   - Review `CONTRIBUTING.md` for conventions
   - Reference existing similar implementations

2. **Analyze Current Codebase**
   - Identify related modules
   - Find similar implementations
   - Note naming conventions
   - Understand folder structure

3. **Apply Context**
   - Follow established patterns
   - Use consistent naming
   - Match existing code style
```

**Example:**
```markdown
## API Implementation

Before creating new API endpoints:

1. **Review Project Standards**
   - Check `docs/api-guidelines.md` for REST conventions
   - Review `ARCHITECTURE.md` for layering principles
   - Reference existing API implementations in `src/api/`

2. **Analyze Current Codebase**
   - Examine existing route handlers in `src/api/routes/`
   - Study middleware patterns in `src/api/middleware/`
   - Note authentication patterns
   - Understand error handling approach

3. **Apply Context**
   - Follow established URL structure (`/api/v1/resource`)
   - Use consistent response format (see `src/api/responses.js`)
   - Apply standard error codes (see `src/api/errors.js`)
   - Match existing validation patterns
```

### 8. Error Anticipation

Proactively address common issues.

**Pattern:**
```markdown
## Error Handling

### Common Issues

**Issue 1: [Problem]**
- Symptom: [How it manifests]
- Cause: [Why it happens]
- Solution: [How to fix]

**Issue 2: [Problem]**
- Symptom: [How it manifests]
- Cause: [Why it happens]
- Solution: [How to fix]

### Validation Steps

Before considering complete:
- [ ] [Check 1]
- [ ] [Check 2]
- [ ] [Check 3]
```

**Example:**
```markdown
## Database Migration Creation

### Common Issues

**Issue 1: Migration Conflicts**
- Symptom: Error "Migration already exists"
- Cause: Timestamp collision with another developer
- Solution: Regenerate migration with `npm run migrate:create --force`

**Issue 2: Column Already Exists**
- Symptom: Error "column already exists" during migration
- Cause: Previous migration was partially applied
- Solution: Check `migrations_log` table, rollback if needed

**Issue 3: Foreign Key Constraint Violation**
- Symptom: Error creating foreign key
- Cause: Referenced table doesn't exist yet
- Solution: Ensure migrations run in dependency order

### Validation Steps

Before considering migration complete:
- [ ] Test up migration on clean database
- [ ] Test down migration (rollback)
- [ ] Verify no data loss in down/up cycle
- [ ] Check constraints are properly enforced
- [ ] Ensure indexes are created
```

### 9. Multi-Modal Output

Combine different output types for clarity.

**Pattern:**
```markdown
## Output Format

Provide multiple representations:

1. **Textual Description**
   [Prose explanation]

2. **Visual Diagram**
   ```[diagram language]
   [ASCII art or diagram code]
   ```

3. **Structured Data**
   ```[format]
   [Machine-readable representation]
   ```

4. **Code Examples**
   ```[language]
   [Working code samples]
   ```
```

**Example:**
```markdown
## Architecture Documentation

Provide comprehensive architecture documentation:

1. **Overview (Prose)**
   Write 2-3 paragraphs explaining the system architecture, key components, and design decisions.

2. **Architecture Diagram (Mermaid)**
   ```mermaid
   graph TD
       A[Client] --> B[API Gateway]
       B --> C[Service Layer]
       C --> D[Database]
       C --> E[Cache]
   ```

3. **Component Structure (YAML)**
   ```yaml
   components:
     - name: API Gateway
       type: service
       dependencies: [Service Layer]
       technologies: [Express, JWT]
   ```

4. **Usage Examples (Code)**
   ```javascript
   // Example API call
   const response = await fetch('/api/v1/users');
   const users = await response.json();
   ```
```

### 10. Conditional Logic

Provide different paths based on context.

**Pattern:**
```markdown
## Instructions

**If [condition 1]:**
1. [Steps for condition 1]

**If [condition 2]:**
1. [Steps for condition 2]

**Otherwise:**
1. [Default steps]
```

**Example:**
```markdown
## Testing Strategy

**If component has API endpoints:**
1. Write integration tests using supertest
2. Mock external service calls
3. Test all HTTP methods and status codes
4. Verify request/response schemas

**If component has UI elements:**
1. Write component tests using React Testing Library
2. Test user interactions (clicks, inputs)
3. Verify accessibility (ARIA roles, keyboard nav)
4. Test responsive behavior

**If component has pure business logic:**
1. Write unit tests with Jest
2. Test all edge cases
3. Achieve 100% code coverage
4. Use property-based testing for complex logic

**In all cases:**
1. Add tests to CI pipeline
2. Maintain test documentation in README
3. Use descriptive test names
```

## Anti-Patterns to Avoid

### ❌ Vague Instructions

```markdown
❌ "Help with code"
❌ "Fix the issues"
❌ "Make it better"
```

### ✅ Specific Instructions

```markdown
✅ "Refactor the authentication module to use async/await instead of callbacks"
✅ "Fix the memory leak in the event listener by adding cleanup in useEffect"
✅ "Optimize the database query by adding an index on the user_id column"
```

### ❌ No Examples

```markdown
❌ "Create API documentation"
```

### ✅ With Examples

```markdown
✅ "Create API documentation following OpenAPI 3.0 spec:

```yaml
paths:
  /users:
    get:
      summary: List all users
      responses:
        '200':
          description: Successful response
```
```

### ❌ Missing Context

```markdown
❌ "Add error handling"
```

### ✅ With Context

```markdown
✅ "Add error handling following the project's error handling pattern in `src/utils/errors.js`:
- Use custom error classes (ValidationError, NotFoundError, etc.)
- Include error codes from `src/constants/errorCodes.js`
- Log errors using the logger in `src/utils/logger.js`"
```

## Testing Your Prompts

### Quality Checklist

- [ ] Clear, specific instructions
- [ ] Numbered steps for sequential tasks
- [ ] Concrete examples provided
- [ ] Output format explicitly specified
- [ ] Edge cases addressed
- [ ] Context integration instructions
- [ ] Error handling guidance
- [ ] Validation criteria defined

### Iterative Improvement

1. **Test** with representative input
2. **Evaluate** output quality
3. **Identify** gaps or ambiguities
4. **Refine** instructions
5. **Repeat** until consistent quality
