---
name: code-review
description: Reviews implemented code against specifications, architecture, and standards. Validates test coverage, checks compliance with design patterns, verifies checklist completion, and generates comprehensive review reports. Use when reviewing code, validating implementation quality, checking standards compliance, or when user mentions code review, review implementation, validate code, or check quality.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
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

Systematically review the code against requirements. See [references/review-criteria.md](references/review-criteria.md) for complete checklists covering:

- **Functional Requirements**: User stories, acceptance criteria, features, edge cases
- **Non-Functional Requirements**: Performance, security, scalability, maintainability
- **API Contract Validation**: Endpoints, schemas, HTTP methods, status codes
- **Data Model Validation**: Entities, relationships, constraints, indexes

### Step 4: Architecture Alignment Review (If architecture.md exists)

Verify implementation follows architectural guidelines. See [references/review-criteria.md](references/review-criteria.md) for complete checklists covering:

- **Architectural Patterns**: Design patterns, architectural styles, component boundaries
- **Component Organization**: Directory structure, module dependencies, cross-cutting concerns
- **Technology Stack Compliance**: Libraries, versions, ADRs
- **Quality Attributes**: Performance, security, scalability, observability

### Step 5: Standards Compliance Review (If standards.md exists)

Check code against coding standards. See [references/review-criteria.md](references/review-criteria.md) for complete checklists covering:

- **Naming Conventions**: UI, code, database naming
- **File and Directory Structure**: Organization, hierarchy, consistency
- **API Design Standards**: RESTful conventions, versioning, error handling
- **Code Quality Standards**: Complexity, DRY, error handling, logging
- **Testing Standards**: Organization, coverage, isolation
- **Git Commit Standards**: Conventions, prefixes, atomicity
- **Documentation Standards**: Code docs, API docs, inline comments

### Step 6: Test Coverage and Quality Review

Analyze test implementation and coverage. See [references/review-criteria.md](references/review-criteria.md) for complete checklists covering:

- **Test Presence**: Unit, integration, contract, E2E tests
- **Test Quality**: Readability, naming, AAA pattern, isolation
- **Coverage Metrics**: Line coverage, branch coverage, critical paths
- **Test Execution**: Pass rate, determinism, performance

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

Perform detailed code quality assessment. See [references/review-criteria.md](references/review-criteria.md) for complete checklists covering:

- **Code Structure**: Single responsibility, abstraction, coupling, cohesion
- **Error Handling**: Error catching, messages, propagation, resource cleanup
- **Security**: Input validation, authentication, authorization, encryption
- **Performance**: Bottlenecks, queries, caching, algorithms
- **Maintainability**: Readability, complexity, constants, dependencies

Review severity levels are defined in [references/review-criteria.md](references/review-criteria.md).

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

## Additional Resources

- [references/review-criteria.md](references/review-criteria.md) - Complete review checklists and severity classifications
- `templates/review-report.md` - Structure for comprehensive review reports
- `templates/review-checklist.md` - Checklist template for manual review tracking

## Review Severity Classification

See [references/review-criteria.md](references/review-criteria.md) for complete severity level definitions:

- **Critical**: Security vulnerabilities, data corruption, complete failures
- **Major**: Incomplete requirements, performance issues, missing tests
- **Minor**: Style inconsistencies, minor violations, optimization opportunities
- **Informational**: Suggestions, alternative approaches, best practices

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
