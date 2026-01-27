---
name: code-review
description: Reviews implemented code against specifications, architecture, and standards. Validates test coverage, checks compliance with design patterns, verifies checklist completion, and generates comprehensive review reports. Use when reviewing code, validating implementation quality, checking standards compliance, or when user mentions code review, review implementation, validate code, or check quality.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
license: MIT
---

# Code Review Skill

## Overview

This skill performs comprehensive code reviews by analyzing implemented code against specifications, design documents, architectural patterns, and coding standards. It validates test coverage, checks quality checklist completion, and generates detailed review reports with actionable feedback.

## When to Use

- Reviewing completed implementations
- Validating code quality before merging
- Checking compliance with specifications and standards
- Verifying test coverage and quality
- Assessing architectural alignment
- Validating checklist completion
- User mentions: "review code", "validate implementation", "check code quality", "code review", "review my code"

## Prerequisites

- **Required documents in feature directory**:
  - Implementation code files (Required)
  - `spec.md` - Feature requirements and acceptance criteria (Required)
  - `design.md` - Technical design and architecture (Required)
- **Product-level documentation** (Optional but recommended):
  - `docs/architecture.md` - System architecture, patterns, ADRs
  - `docs/standards.md` - Coding conventions and standards
- **Optional supporting documents**:
  - `tasks.md` - Implementation task checklist
  - `data-model.md` - Entity definitions
  - `contracts/` - API specifications
  - `checklists/` - Quality checklists
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## Instructions

### Step 1: Check Prerequisites and Discover Implementation

Run the prerequisite check script to discover implementation artifacts:

**Bash (Unix/Linux/macOS):**

```bash
cd /path/to/repo
bash skills/code-review/scripts/check-review-prerequisites.sh --json
```

**PowerShell (Windows):**

```powershell
cd C:\path\to\repo
powershell -ExecutionPolicy Bypass -File skills/code-review/scripts/check-review-prerequisites.ps1 -Json
```

Parse the output to extract:

- `FEATURE_DIR`: Absolute path to feature directory
- `AVAILABLE_DOCS`: List of available documentation
- `IMPLEMENTATION_FILES`: List of code files to review
- `TEST_FILES`: List of test files found
- `CHECKLIST_STATUS`: Status of quality checklists

### Step 2: Load Review Context

Read all available documents to build complete review context:

#### Required Documents

1. **spec.md** (Required):
   - Extract user stories and acceptance criteria
   - Extract functional requirements
   - Extract non-functional requirements
   - Extract constraints and assumptions

2. **design.md** (Required):
   - Extract tech stack and libraries
   - Extract project structure
   - Extract component architecture
   - Extract technical decisions
   - Extract API contracts
   - Extract data models

#### Product-Level Documents (If Available)

1. **docs/architecture.md** (Optional):
   - Extract architectural patterns and styles
   - Extract C4 model component organization
   - Extract technology stack decisions
   - Extract ADRs (Architecture Decision Records)
   - Extract deployment architecture
   - Extract quality attribute requirements
   - Extract security patterns
   - Extract performance strategies

2. **docs/standards.md** (Optional):
   - Extract UI naming conventions
   - Extract code naming conventions
   - Extract file structure standards
   - Extract API design standards
   - Extract database naming conventions
   - Extract testing standards
   - Extract Git commit conventions
   - Extract documentation standards
   - Extract code quality metrics

#### Supporting Documents (If Available)

1. **tasks.md** (Optional):
   - Extract completed tasks list
   - Verify all tasks marked as [X]
   - Identify any incomplete tasks

2. **data-model.md** (Optional):
   - Extract entity definitions
   - Extract relationships and constraints

3. **contracts/** (Optional):
   - Extract API specifications
   - Extract endpoint definitions
   - Extract request/response schemas

4. **checklists/** (Optional):
   - Extract quality checklist items
   - Verify completion status

### Step 3: Review Implementation Against Specifications

Systematically review the code against requirements:

#### Functional Requirements Review

- [ ] All user stories implemented
- [ ] Acceptance criteria met for each user story
- [ ] Required features present and working
- [ ] Edge cases handled
- [ ] Error scenarios addressed
- [ ] Input validation implemented

#### Non-Functional Requirements Review

- [ ] Performance requirements met
- [ ] Security requirements implemented
- [ ] Scalability considerations addressed
- [ ] Maintainability patterns followed
- [ ] Accessibility standards met (if applicable)
- [ ] Internationalization support (if required)

#### API Contract Validation (If contracts/ exists)

- [ ] All specified endpoints implemented
- [ ] Request/response schemas match contracts
- [ ] HTTP methods correct
- [ ] Status codes appropriate
- [ ] Error responses match specifications
- [ ] Authentication/authorization implemented

#### Data Model Validation (If data-model.md exists)

- [ ] All entities implemented
- [ ] Relationships correctly established
- [ ] Constraints enforced
- [ ] Data types match specifications
- [ ] Indexes created as specified
- [ ] Migrations present and correct

### Step 4: Architecture Alignment Review (If architecture.md exists)

Verify implementation follows architectural guidelines:

#### Architectural Patterns

- [ ] Design patterns correctly implemented
- [ ] Architectural style followed (MVC, layered, microservices, etc.)
- [ ] Component boundaries respected
- [ ] Dependency directions correct
- [ ] Separation of concerns maintained

#### Component Organization

- [ ] Directory structure matches C4 Component View
- [ ] Code organization follows architecture
- [ ] Module dependencies align with architecture
- [ ] Cross-cutting concerns properly handled
- [ ] Configuration management correct

#### Technology Stack Compliance

- [ ] Specified libraries and frameworks used
- [ ] Versions match architecture decisions
- [ ] No unauthorized dependencies added
- [ ] Technology choices align with ADRs
- [ ] Build tools configured correctly

#### ADRs (Architecture Decision Records)

- [ ] All relevant ADRs followed
- [ ] No ADR violations present
- [ ] New decisions documented (if applicable)
- [ ] Rationale for deviations provided (if any)

#### Quality Attributes

- [ ] Performance requirements addressed
- [ ] Security patterns implemented
- [ ] Scalability strategies applied
- [ ] Availability mechanisms present
- [ ] Reliability measures implemented
- [ ] Observability/monitoring added

### Step 5: Standards Compliance Review (If standards.md exists)

Check code against coding standards:

#### Naming Conventions

- [ ] **UI naming conventions** followed (components, props, events)
- [ ] **Code naming conventions** followed:
  - Variables: descriptive, consistent case
  - Functions/methods: verb-based, clear purpose
  - Classes: noun-based, single responsibility
  - Constants: uppercase, descriptive
  - Files: consistent naming pattern
- [ ] **Database naming conventions** followed (tables, columns, indexes)

#### File and Directory Structure

- [ ] File organization follows standards
- [ ] Directory hierarchy matches conventions
- [ ] File naming consistent
- [ ] Related files grouped logically
- [ ] No unnecessary files present

#### API Design Standards

- [ ] RESTful conventions followed (if REST)
- [ ] Endpoint naming consistent
- [ ] Versioning implemented correctly
- [ ] Request/response formats standardized
- [ ] Error handling consistent
- [ ] Documentation complete

#### Code Quality Standards

- [ ] Code complexity within acceptable limits
- [ ] No code duplication (DRY principle)
- [ ] Functions/methods appropriate length
- [ ] Proper error handling throughout
- [ ] Logging implemented consistently
- [ ] Comments clear and helpful (not excessive)

#### Testing Standards

- [ ] Test file organization follows conventions
- [ ] Test naming consistent and descriptive
- [ ] Test coverage meets minimum requirements
- [ ] Unit tests present for core logic
- [ ] Integration tests for key workflows
- [ ] Test isolation maintained

#### Git Commit Standards

- [ ] Commit messages follow conventions
- [ ] Commit prefixes correct (feat:, fix:, test:, etc.)
- [ ] Commits atomic and logical
- [ ] No WIP or debug commits in history
- [ ] Branch naming follows conventions

#### Documentation Standards

- [ ] Code documentation complete
- [ ] API documentation up-to-date
- [ ] README updated (if needed)
- [ ] Inline comments appropriate
- [ ] Complex logic explained
- [ ] Public APIs documented

### Step 6: Test Coverage and Quality Review

Analyze test implementation and coverage:

#### Test Presence

- [ ] Unit tests present for business logic
- [ ] Integration tests for key workflows
- [ ] Contract tests for APIs (if applicable)
- [ ] End-to-end tests for critical paths (if applicable)
- [ ] Test fixtures/mocks properly structured

#### Test Quality

- [ ] Tests are readable and maintainable
- [ ] Test names clearly describe what's tested
- [ ] Arrange-Act-Assert pattern followed
- [ ] Tests are isolated and independent
- [ ] No flaky or intermittent tests
- [ ] Tests run quickly

#### Coverage Metrics (If available)

- [ ] Line coverage meets minimum (typically 80%+)
- [ ] Branch coverage acceptable
- [ ] Critical paths fully covered
- [ ] Edge cases tested
- [ ] Error paths tested
- [ ] No untested complex code

#### Test Execution

- [ ] All tests pass
- [ ] No skipped or ignored tests
- [ ] Test suite runs in reasonable time
- [ ] Tests are deterministic
- [ ] Tests clean up after themselves

### Step 7: Quality Checklist Validation (If checklists exist)

Verify all quality checklists are complete:

**Checklist Validation Process:**

1. **Scan all checklist files** in `FEATURE_DIR/checklists/`:
   - Count total items: Lines matching `- [ ]` or `- [X]` or `- [x]`
   - Count completed: Lines matching `- [X]` or `- [x]`
   - Count incomplete: Lines matching `- [ ]`

2. **Create status table**:

   ```text
   | Checklist    | Total | Completed | Incomplete | Status |
   |--------------|-------|-----------|------------|--------|
   | ux.md        | 12    | 12        | 0          | ✓ PASS |
   | test.md      | 10    | 10        | 0          | ✓ PASS |
   | security.md  | 8     | 8         | 0          | ✓ PASS |
   | performance.md | 6   | 5         | 1          | ✗ FAIL |
   ```

3. **Determine overall status**:
   - **PASS**: All checklists have 0 incomplete items
   - **FAIL**: One or more checklists have incomplete items

4. **Review incomplete items**:
   - List specific incomplete checklist items
   - Assess impact of incomplete items
   - Recommend completion or document exceptions

### Step 8: Code Quality Analysis

Perform detailed code quality assessment:

#### Code Structure

- [ ] Classes/modules have single responsibility
- [ ] Functions are focused and concise
- [ ] Proper abstraction levels maintained
- [ ] Coupling is loose
- [ ] Cohesion is high
- [ ] Code is modular and reusable

#### Error Handling

- [ ] Errors caught and handled appropriately
- [ ] Error messages are clear and actionable
- [ ] No silent failures
- [ ] Proper error propagation
- [ ] Resources cleaned up in error paths
- [ ] Consistent error handling patterns

#### Security

- [ ] Input validation present
- [ ] Output encoding correct
- [ ] Authentication implemented correctly
- [ ] Authorization checks in place
- [ ] No hardcoded secrets or credentials
- [ ] SQL injection prevention (if applicable)
- [ ] XSS prevention (if applicable)
- [ ] CSRF protection (if applicable)
- [ ] Sensitive data encrypted
- [ ] Security headers configured (if web app)

#### Performance

- [ ] No obvious performance bottlenecks
- [ ] Database queries optimized
- [ ] Appropriate caching used
- [ ] Resource usage reasonable
- [ ] No memory leaks
- [ ] Algorithms efficient for expected data sizes
- [ ] Network calls minimized

#### Maintainability

- [ ] Code is readable and understandable
- [ ] No overly complex logic
- [ ] Magic numbers replaced with named constants
- [ ] Deprecated APIs not used
- [ ] Dependencies up-to-date and secure
- [ ] Technical debt minimized or documented

### Step 9: Generate Review Report

Create comprehensive review using `templates/review-report.md`:

**Report Contents**:

- **Executive Summary**: Overall assessment and key findings
- **Specification Compliance**: Requirements met vs missing
- **Architecture Alignment**: Patterns followed, ADRs respected
- **Standards Compliance**: Naming, structure, API design, testing
- **Test Coverage**: Metrics and quality assessment
- **Checklist Status**: Completion status and incomplete items
- **Code Quality**: Structure, security, performance, maintainability
- **Issues Found**: Critical, major, minor issues with severity
- **Recommendations**: Actionable improvements prioritized
- **Approval Status**: Approved / Approved with conditions / Changes required

Save report to `FEATURE_DIR/code-review-report.md`

### Step 10: Report Summary

Provide concise summary including:

- Overall review status (Approved / Conditional / Changes Required)
- Total issues found (Critical: X, Major: Y, Minor: Z)
- Specification compliance (X% complete)
- Architecture alignment (Pass/Fail)
- Standards compliance (Pass/Fail)
- Test coverage (X%)
- Checklist status (All passed / Some incomplete)
- Path to detailed review report
- Key recommendations (top 3-5)

## Review Severity Classification

Use consistent severity levels for issues:

### Critical Issues

- Security vulnerabilities
- Data corruption risks
- Complete failure scenarios
- Violations of core requirements
- Breaking architectural patterns
- No tests for critical functionality

**Action Required**: Must fix before merge

### Major Issues

- Incomplete requirements
- Significant performance problems
- Poor error handling
- Missing important tests
- Standards violations in core code
- Architectural misalignments

**Action Required**: Should fix before merge or document exception

### Minor Issues

- Code style inconsistencies
- Minor naming convention violations
- Missing edge case tests
- Optimization opportunities
- Documentation gaps
- Technical debt items

**Action Required**: Can be addressed in follow-up or backlog

### Informational

- Suggestions for improvement
- Alternative approaches
- Best practice recommendations
- Learning opportunities
- Future enhancement ideas

**Action Required**: Optional, for consideration

## Examples

### Example 1: Comprehensive Review with All Documents

**Input:**

```bash
bash skills/code-review/scripts/check-review-prerequisites.sh --json
```

**Output:**

```json
{
  "success": true,
  "feature_dir": "/path/to/specs/feature-name",
  "available_docs": ["spec.md", "design.md", "tasks.md", "checklists/"],
  "implementation_files": ["src/feature.ts", "src/feature-service.ts", "src/types.ts"],
  "test_files": ["tests/feature.test.ts", "tests/feature-service.test.ts"],
  "checklist_status": "all_passed",
  "architecture_available": true,
  "standards_available": true
}
```

**Review Process:**

1. Load all documents (spec, design, architecture, standards)
2. Review 3 implementation files against specifications
3. Validate 2 test files for coverage and quality
4. Check architecture alignment with docs/architecture.md
5. Verify standards compliance with docs/standards.md
6. Validate checklist completion (all passed)
7. Generate comprehensive review report
8. Report: "Approved - All checks passed, 2 minor suggestions"

### Example 2: Review with Incomplete Checklists

**Checklist Status:**

```text
| Checklist       | Total | Completed | Incomplete | Status |
|-----------------|-------|-----------|------------|--------|
| ux.md           | 12    | 12        | 0          | ✓ PASS |
| security.md     | 8     | 6         | 2          | ✗ FAIL |
| performance.md  | 6     | 6         | 0          | ✓ PASS |
```

**Incomplete Items:**

- security.md: Input validation for file uploads
- security.md: Rate limiting for API endpoints

**Review Process:**

1. Identify incomplete security checklist items
2. Assess impact: Critical security issues
3. Review code for actual implementation status
4. Generate report with Critical severity issues
5. Report: "Changes Required - 2 critical security items incomplete"

## Edge Cases

- **Missing spec.md or design.md**: Cannot perform comprehensive review, report error
- **No implementation files found**: Verify FEATURE_DIR, check if implementation started
- **No test files found**: Report as Major issue, recommend adding tests
- **Malformed checklists**: Attempt to parse, report parsing issues
- **Architecture.md or standards.md missing**: Skip those checks, note in report
- **Test coverage tool unavailable**: Perform manual coverage assessment from test files
- **Conflicting standards**: Prioritize standards.md over architecture.md, note conflicts

## Error Handling

- **Script execution fails**: Report exact error, check working directory and permissions
- **Invalid JSON from script**: Parse as text and extract paths manually
- **Missing required documents**: List missing documents and halt review
- **Cannot read implementation files**: Report access issues, suggest checking permissions
- **Test execution fails**: Report failed tests, include error logs, mark as Critical
- **Checklist parsing errors**: Report malformed checklists, attempt best-effort parsing

## Scripts

This skill includes cross-platform scripts for checking review prerequisites:

### Bash Script (Unix/Linux/macOS)

```bash
bash skills/code-review/scripts/check-review-prerequisites.sh --json
```

**Features:**

- Locates feature directory and documentation
- Discovers implementation files
- Finds test files
- Validates checklist status
- Checks for architecture.md and standards.md
- JSON and human-readable output

### PowerShell Script (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File skills/code-review/scripts/check-review-prerequisites.ps1 -Json
```

**Features:**

- Locates feature directory and documentation
- Discovers implementation files
- Finds test files
- Validates checklist status
- Checks for architecture.md and standards.md
- JSON and human-readable output

### Script Output Format

Both scripts output JSON with:

- `success`: Boolean indicating if prerequisites met
- `feature_dir`: Path to feature directory
- `available_docs`: Array of found documents
- `implementation_files`: Array of code files to review
- `test_files`: Array of test files
- `checklist_status`: "all_passed", "some_incomplete", or "no_checklists"
- `checklist_details`: Array of checklist statuses
- `architecture_available`: Boolean indicating docs/architecture.md exists
- `standards_available`: Boolean indicating docs/standards.md exists
- `error`: Error message if prerequisites not met

## Templates

- `templates/review-report.md`: Structure for comprehensive code review reports
- `templates/review-checklist.md`: Checklist template for manual review tracking

## Guidelines

1. **Be Thorough**: Review all aspects systematically
2. **Be Objective**: Focus on facts, not opinions
3. **Be Constructive**: Provide actionable feedback
4. **Be Specific**: Reference exact files, lines, and issues
5. **Prioritize Issues**: Use severity levels consistently
6. **Explain Rationale**: Why something is an issue
7. **Suggest Solutions**: How to fix issues
8. **Acknowledge Good Work**: Note well-implemented sections
9. **Consider Context**: Understand project constraints
10. **Document Exceptions**: Note approved deviations from standards

## Success Criteria

A code review is complete when:

- [ ] All required documents reviewed
- [ ] Implementation verified against specifications
- [ ] Architecture alignment checked (if architecture.md exists)
- [ ] Standards compliance verified (if standards.md exists)
- [ ] Test coverage assessed
- [ ] Checklists validated (if checklists exist)
- [ ] Code quality analyzed
- [ ] Issues categorized by severity
- [ ] Review report generated with recommendations
- [ ] Approval status determined and documented
