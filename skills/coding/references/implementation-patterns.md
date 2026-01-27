# Coding Implementation Patterns

This document provides detailed patterns and workflows for implementing features systematically.

## Task Execution Patterns

### Sequential Execution (Default)

```
Task T001 → Complete → Mark [X] → Commit
Task T002 → Complete → Mark [X] → Commit
Task T003 → Complete → Mark [X] → Commit
```

### Parallel Execution (Tasks marked with [P])

```
Round 1:
  T010 [P] → Complete → Mark [X] ┐
  T011 [P] → Complete → Mark [X] ├→ Commit all together
  T012 [P] → Complete → Mark [X] ┘

Round 2:
  T013 → Complete → Mark [X] → Commit
```

### TDD Execution (Tests → Implementation)

```
Phase: User Story 1
  T010 [P] [US1] Write unit tests → Complete → Mark [X]
  T011 [P] [US1] Write integration tests → Complete → Mark [X]
  T012 [P] [US1] Create model → Complete → Mark [X]
  T013 [US1] Implement service → Complete → Mark [X]
  T014 [US1] Create endpoint → Complete → Mark [X]
  T015 [US1] Run tests → Validate → Complete
```

## Phase-by-Phase Implementation Workflow

### Phase 1: Setup (Project Initialization)

- Create directory structure (follow standards.md if exists)
- Initialize configuration files
- Install dependencies
- Set up development environment
- Create ignore files

**Standards Application:**
- Follow file and directory naming conventions from standards.md
- Apply project structure standards

**Architecture Application:**
- Verify directory structure matches code organization from architecture.md
- Ensure deployment configuration aligns with deployment architecture

### Phase 2: Foundational (Blocking Prerequisites)

- Implement shared infrastructure
- Create base classes and utilities
- Set up middleware and common services
- Establish database connections

**Standards Application:**
- Apply code naming conventions
- Follow architectural patterns from architecture.md
- Use database naming conventions

### Phase 3+: User Story Implementation

For each user story phase, follow TDD approach:

#### 1. Tests First (if tests requested)

- Write unit tests for models/entities
- Write integration tests for services
- Write contract tests for APIs
- Follow testing standards from standards.md

#### 2. Models/Entities

- Create data models following data-model.md
- Apply database naming conventions from standards.md
- Implement entity relationships

#### 3. Services/Business Logic

- Implement business logic following design.md
- Apply code naming conventions from standards.md
- Implement architectural patterns from architecture.md

#### 4. Endpoints/UI

- Create API endpoints following contracts/
- Apply UI naming conventions from standards.md
- Apply API design standards from standards.md

#### 5. Integration

- Wire components together
- Implement integration patterns from architecture.md
- Apply quality strategies (security, performance) from architecture.md

#### 6. Validation

- Run tests (if implemented)
- Verify acceptance criteria from spec.md
- Mark tasks as complete in tasks.md: `- [X]`

### Final Phase: Polish

- Add documentation (follow standards.md)
- Optimize performance
- Security hardening
- Code review and cleanup

## Task Execution Rules

### 1. Respect Dependencies

- **Sequential tasks**: Run in order, one at a time
- **Parallel tasks [P]**: Can execute simultaneously (different files)
- **Same-file tasks**: Must be sequential regardless of [P] marker

### 2. Error Handling

- **Non-parallel task fails** → Halt execution
- **Parallel task fails** → Continue with successful, report failed
- Provide clear error context for debugging

### 3. Progress Tracking

- Report after each completed task
- Update tasks.md: Change `- [ ]` to `- [X]` for completed tasks
- Show phase completion status

### 4. Commit Strategy

- Commit after each logical unit of work
- Use appropriate prefixes: `feat:`, `fix:`, `test:`, `docs:`, `refactor:`
- Follow commit conventions from standards.md (if exists)
- Reference task IDs in commit messages

## Ignore Files Management

### Detection Logic

Detect project technology and create/verify ignore files:

- Check if git repository → create/verify `.gitignore`
- Check if Dockerfile exists → create/verify `.dockerignore`
- Check if ESLint config exists → create/verify `.eslintignore`
- Check if Prettier config exists → create/verify `.prettierignore`
- Check if npm project → create/verify `.npmignore` (if publishing)
- Check if Terraform files → create/verify `.terraformignore`
- Check if Helm charts → create/verify `.helmignore`

### Ignore File Creation Rules

- **If file exists** → Verify essential patterns, append only missing critical ones
- **If file missing** → Create with full pattern set for detected technology

### Technology-Specific Patterns

**Node.js/JavaScript/TypeScript**:
```
node_modules/
dist/
build/
*.log
.env*
coverage/
```

**Python**:
```
__pycache__/
*.pyc
.venv/
venv/
dist/
*.egg-info/
.pytest_cache/
```

**Java**:
```
target/
*.class
*.jar
.gradle/
build/
*.iml
```

**C#/.NET**:
```
bin/
obj/
*.user
*.suo
packages/
*.dll
```

**Go**:
```
*.exe
*.test
vendor/
*.out
go.work
```

**Ruby**:
```
.bundle/
log/
tmp/
*.gem
vendor/bundle/
```

**PHP**:
```
vendor/
*.log
*.cache
*.env
composer.phar
```

**Rust**:
```
target/
*.rs.bk
*.rlib
*.log
.env*
```

**Universal** (all projects):
```
.DS_Store
Thumbs.db
*.tmp
*.swp
.vscode/
.idea/
*.bak
```

## Checklist Validation Process

### 1. Scan All Checklist Files

Count for each checklist:
- Total items: Lines matching `- [ ]` or `- [X]` or `- [x]`
- Completed: Lines matching `- [X]` or `- [x]`
- Incomplete: Lines matching `- [ ]`

### 2. Create Status Table

```
| Checklist    | Total | Completed | Incomplete | Status |
|--------------|-------|-----------|------------|--------|
| ux.md        | 12    | 12        | 0          | ✓ PASS |
| test.md      | 8     | 5         | 3          | ✗ FAIL |
| security.md  | 6     | 6         | 0          | ✓ PASS |
```

### 3. Determine Overall Status

- **PASS**: All checklists have 0 incomplete items → Proceed automatically
- **FAIL**: One or more checklists have incomplete items → Ask user permission

### 4. Handle Incomplete Checklists

- Display table with incomplete counts
- **STOP** and ask: "Some checklists are incomplete. Do you want to proceed with implementation anyway? (yes/no)"
- Wait for user response:
  - If "no" / "wait" / "stop" → Halt execution
  - If "yes" / "proceed" / "continue" → Continue to implementation

### 5. If All Checklists Complete

- Display table showing all passed
- Proceed automatically to implementation

## Implementation Verification Checklist

### Implementation Verification

- [ ] All required tasks completed (marked as [X] in tasks.md)
- [ ] Implementation matches specifications from spec.md
- [ ] Tests pass (if tests were implemented)
- [ ] Code coverage meets requirements (if specified)

### Architecture Alignment (If architecture.md exists)

- [ ] Implementation follows architectural patterns
- [ ] Component organization matches C4 Component View
- [ ] Technology stack matches architecture decisions
- [ ] Quality attribute requirements met (performance, security, scalability)
- [ ] ADRs (Architecture Decision Records) respected

### Standards Compliance (If standards.md exists)

- [ ] UI naming conventions followed (for UI components)
- [ ] Code naming conventions applied consistently
- [ ] File and directory structure matches standards
- [ ] API design standards followed
- [ ] Database naming conventions applied
- [ ] Testing standards followed
- [ ] Git commit messages follow conventions
- [ ] Documentation standards met

### Quality Checklist Validation (If checklists exist)

- [ ] Re-run checklist validation
- [ ] All checklist items should now be complete
- [ ] Address any remaining incomplete items

## Next Steps Recommendations

After completing implementation:

1. **Run code-review skill** to validate:
   - Code quality and adherence to standards
   - Proper error handling and edge cases
   - Test coverage and test quality
   - Documentation completeness
   - Security considerations

2. **Address findings** from review before creating PR/MR

3. **Consider additional skills**:
   - `e2e-test-design` if E2E tests needed
   - `bug-analysis` if issues discovered during testing

4. **Create pull request** for team review after validation passes
