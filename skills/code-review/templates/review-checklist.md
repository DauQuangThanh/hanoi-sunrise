# Code Review Checklist

Use this checklist to systematically review code implementation. Check off items as you verify them.

**Feature:** [Feature Name]  
**Reviewer:** [Your Name]  
**Date:** [YYYY-MM-DD]

---

## Pre-Review Setup

- [ ] Feature directory located
- [ ] spec.md loaded and reviewed
- [ ] design.md loaded and reviewed
- [ ] docs/architecture.md loaded (if exists)
- [ ] docs/standards.md loaded (if exists)
- [ ] Implementation files identified
- [ ] Test files identified
- [ ] Checklists reviewed (if exist)

---

## Specification Compliance

### Requirements Coverage

- [ ] All user stories implemented
- [ ] Acceptance criteria met for each story
- [ ] Required features present
- [ ] Edge cases handled
- [ ] Error scenarios addressed
- [ ] Input validation implemented

### Functional Requirements

- [ ] Core functionality working as specified
- [ ] Business logic correct
- [ ] Data flows match design
- [ ] User interactions work correctly
- [ ] Integration points functional

### Non-Functional Requirements

- [ ] Performance requirements met
- [ ] Security requirements implemented
- [ ] Scalability considerations addressed
- [ ] Maintainability patterns followed
- [ ] Accessibility standards met (if applicable)

---

## Architecture Alignment

### Architectural Patterns

- [ ] Design patterns correctly implemented
- [ ] Architectural style followed (MVC, layered, etc.)
- [ ] Component boundaries respected
- [ ] Dependency directions correct
- [ ] Separation of concerns maintained

### Component Organization

- [ ] Directory structure matches architecture
- [ ] Code organization follows design
- [ ] Module dependencies correct
- [ ] Cross-cutting concerns handled properly

### Technology Stack

- [ ] Specified libraries and frameworks used
- [ ] Versions match architecture decisions
- [ ] No unauthorized dependencies
- [ ] Build tools configured correctly

### ADRs (Architecture Decision Records)

- [ ] All relevant ADRs followed
- [ ] No ADR violations present
- [ ] Deviations documented and justified

### Quality Attributes

- [ ] Performance strategies applied
- [ ] Security patterns implemented
- [ ] Scalability mechanisms present
- [ ] Availability considerations addressed
- [ ] Observability/monitoring added

---

## Standards Compliance

### Naming Conventions

- [ ] UI naming conventions followed
- [ ] Variable names descriptive and consistent
- [ ] Function names clear and verb-based
- [ ] Class names appropriate and noun-based
- [ ] Constants properly named
- [ ] Database naming conventions followed

### File and Directory Structure

- [ ] File organization follows standards
- [ ] Directory hierarchy correct
- [ ] File naming consistent
- [ ] Related files grouped logically

### API Design

- [ ] RESTful conventions followed (if REST)
- [ ] Endpoint naming consistent
- [ ] Versioning implemented
- [ ] Request/response formats standardized
- [ ] Error handling consistent

### Code Quality

- [ ] Code complexity acceptable
- [ ] No excessive code duplication
- [ ] Functions appropriate length
- [ ] Proper error handling throughout
- [ ] Logging implemented consistently
- [ ] Comments clear and helpful

### Testing Standards

- [ ] Test file organization correct
- [ ] Test naming descriptive
- [ ] Test coverage meets requirements
- [ ] Unit tests for core logic
- [ ] Integration tests for workflows

### Git Conventions

- [ ] Commit messages follow standards
- [ ] Commit prefixes correct
- [ ] Commits atomic and logical
- [ ] No WIP or debug commits

### Documentation

- [ ] Code documentation complete
- [ ] API documentation present
- [ ] README updated (if needed)
- [ ] Inline comments appropriate
- [ ] Complex logic explained

---

## Test Coverage and Quality

### Test Presence

- [ ] Unit tests present
- [ ] Integration tests present
- [ ] Contract tests present (if applicable)
- [ ] E2E tests present (if applicable)
- [ ] Test fixtures/mocks properly structured

### Test Quality

- [ ] Tests are readable
- [ ] Test names describe scenarios
- [ ] Arrange-Act-Assert pattern used
- [ ] Tests isolated and independent
- [ ] No flaky tests
- [ ] Tests run quickly

### Coverage Metrics

- [ ] Line coverage meets minimum (80%+)
- [ ] Branch coverage acceptable
- [ ] Critical paths fully covered
- [ ] Edge cases tested
- [ ] Error paths tested

### Test Execution

- [ ] All tests pass
- [ ] No skipped or ignored tests
- [ ] Test suite completes quickly
- [ ] Tests are deterministic

---

## Quality Checklists

### Checklist Validation

- [ ] All checklists identified
- [ ] UX checklist complete (if exists)
- [ ] Test checklist complete (if exists)
- [ ] Security checklist complete (if exists)
- [ ] Performance checklist complete (if exists)
- [ ] Accessibility checklist complete (if exists)
- [ ] Incomplete items documented and justified

---

## Code Quality Analysis

### Code Structure

- [ ] Single Responsibility Principle
- [ ] Classes/modules focused
- [ ] Functions concise
- [ ] Appropriate abstraction levels
- [ ] Loose coupling
- [ ] High cohesion

### Error Handling

- [ ] Errors caught appropriately
- [ ] Error messages clear
- [ ] No silent failures
- [ ] Proper error propagation
- [ ] Resources cleaned up in error paths

### Security

- [ ] Input validation present
- [ ] Output encoding correct
- [ ] Authentication implemented
- [ ] Authorization checks in place
- [ ] No hardcoded secrets
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Sensitive data encrypted
- [ ] Security headers configured

### Performance

- [ ] No obvious bottlenecks
- [ ] Database queries optimized
- [ ] Appropriate caching used
- [ ] Resource usage reasonable
- [ ] No memory leaks
- [ ] Algorithms efficient

### Maintainability

- [ ] Code readable and understandable
- [ ] No overly complex logic
- [ ] Magic numbers replaced with constants
- [ ] No deprecated APIs
- [ ] Dependencies up-to-date
- [ ] Technical debt minimized

---

## Issues Identified

### Critical Issues (Must Fix Before Merge)

1. [Issue description]
   - **Location:** [File:Line]
   - **Impact:** [Description]
   - **Recommendation:** [How to fix]

### Major Issues (Should Fix Before Production)

1. [Issue description]
   - **Location:** [File:Line]
   - **Impact:** [Description]
   - **Recommendation:** [How to fix]

### Minor Issues (Can Address Later)

1. [Issue description]
   - **Location:** [File:Line]
   - **Impact:** [Description]
   - **Recommendation:** [How to fix]

### Informational (Suggestions)

1. [Suggestion]
   - **Location:** [File:Line]
   - **Benefit:** [Description]

---

## Recommendations

### Immediate Actions

1. [Action item]
   - **Priority:** P0
   - **Effort:** [Hours]

### High Priority

1. [Action item]
   - **Priority:** P1
   - **Effort:** [Hours]

### Medium Priority

1. [Action item]
   - **Priority:** P2
   - **Effort:** [Hours]

### Low Priority

1. [Action item]
   - **Priority:** P3
   - **Effort:** [Hours]

---

## Approval Decision

**Status:** ☐ Approved / ☐ Approved with Conditions / ☐ Changes Required

**Rationale:**

[Explain the approval decision based on findings]

**Conditions for Approval (if applicable):**

- [ ] [Condition 1]
- [ ] [Condition 2]

**Timeline:**

- Estimated time to address issues: [X hours/days]
- Next review: [Required / Not required]

---

## Summary

### Strengths

- [Positive aspect 1]
- [Positive aspect 2]
- [Positive aspect 3]

### Areas for Improvement

- [Improvement area 1]
- [Improvement area 2]
- [Improvement area 3]

### Overall Assessment

[Brief summary of code quality and readiness]

---

**Completed By:** [Reviewer Name]  
**Completion Date:** [YYYY-MM-DD]  
**Review Duration:** [X hours]
