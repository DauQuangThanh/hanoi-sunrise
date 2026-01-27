# Code Review Criteria Reference

This document provides detailed checklists and criteria for conducting comprehensive code reviews.

## Functional Requirements Review

- [ ] All user stories implemented
- [ ] Acceptance criteria met for each user story
- [ ] Required features present and working
- [ ] Edge cases handled
- [ ] Error scenarios addressed
- [ ] Input validation implemented

## Non-Functional Requirements Review

- [ ] Performance requirements met
- [ ] Security requirements implemented
- [ ] Scalability considerations addressed
- [ ] Maintainability patterns followed
- [ ] Accessibility standards met (if applicable)
- [ ] Internationalization support (if required)

## API Contract Validation (If contracts/ exists)

- [ ] All specified endpoints implemented
- [ ] Request/response schemas match contracts
- [ ] HTTP methods correct
- [ ] Status codes appropriate
- [ ] Error responses match specifications
- [ ] Authentication/authorization implemented

## Data Model Validation (If data-model.md exists)

- [ ] All entities implemented
- [ ] Relationships correctly established
- [ ] Constraints enforced
- [ ] Data types match specifications
- [ ] Indexes created as specified
- [ ] Migrations present and correct

## Architecture Alignment Review (If architecture.md exists)

### Architectural Patterns

- [ ] Design patterns correctly implemented
- [ ] Architectural style followed (MVC, layered, microservices, etc.)
- [ ] Component boundaries respected
- [ ] Dependency directions correct
- [ ] Separation of concerns maintained

### Component Organization

- [ ] Directory structure matches C4 Component View
- [ ] Code organization follows architecture
- [ ] Module dependencies align with architecture
- [ ] Cross-cutting concerns properly handled
- [ ] Configuration management correct

### Technology Stack Compliance

- [ ] Specified libraries and frameworks used
- [ ] Versions match architecture decisions
- [ ] No unauthorized dependencies added
- [ ] Technology choices align with ADRs
- [ ] Build tools configured correctly

### ADRs (Architecture Decision Records)

- [ ] All relevant ADRs followed
- [ ] No ADR violations present
- [ ] New decisions documented (if applicable)
- [ ] Rationale for deviations provided (if any)

### Quality Attributes

- [ ] Performance requirements addressed
- [ ] Security patterns implemented
- [ ] Scalability strategies applied
- [ ] Availability mechanisms present
- [ ] Reliability measures implemented
- [ ] Observability/monitoring added

## Standards Compliance Review (If standards.md exists)

### Naming Conventions

- [ ] **UI naming conventions** followed (components, props, events)
- [ ] **Code naming conventions** followed:
  - Variables: descriptive, consistent case
  - Functions/methods: verb-based, clear purpose
  - Classes: noun-based, single responsibility
  - Constants: uppercase, descriptive
  - Files: consistent naming pattern
- [ ] **Database naming conventions** followed (tables, columns, indexes)

### File and Directory Structure

- [ ] File organization follows standards
- [ ] Directory hierarchy matches conventions
- [ ] File naming consistent
- [ ] Related files grouped logically
- [ ] No unnecessary files present

### API Design Standards

- [ ] RESTful conventions followed (if REST)
- [ ] Endpoint naming consistent
- [ ] Versioning implemented correctly
- [ ] Request/response formats standardized
- [ ] Error handling consistent
- [ ] Documentation complete

### Code Quality Standards

- [ ] Code complexity within acceptable limits
- [ ] No code duplication (DRY principle)
- [ ] Functions/methods appropriate length
- [ ] Proper error handling throughout
- [ ] Logging implemented consistently
- [ ] Comments clear and helpful (not excessive)

### Testing Standards

- [ ] Test file organization follows conventions
- [ ] Test naming consistent and descriptive
- [ ] Test coverage meets minimum requirements
- [ ] Unit tests present for core logic
- [ ] Integration tests for key workflows
- [ ] Test isolation maintained

### Git Commit Standards

- [ ] Commit messages follow conventions
- [ ] Commit prefixes correct (feat:, fix:, test:, etc.)
- [ ] Commits atomic and logical
- [ ] No WIP or debug commits in history
- [ ] Branch naming follows conventions

### Documentation Standards

- [ ] Code documentation complete
- [ ] API documentation up-to-date
- [ ] README updated (if needed)
- [ ] Inline comments appropriate
- [ ] Complex logic explained
- [ ] Public APIs documented

## Test Coverage and Quality Review

### Test Presence

- [ ] Unit tests present for business logic
- [ ] Integration tests for key workflows
- [ ] Contract tests for APIs (if applicable)
- [ ] End-to-end tests for critical paths (if applicable)
- [ ] Test fixtures/mocks properly structured

### Test Quality

- [ ] Tests are readable and maintainable
- [ ] Test names clearly describe what's tested
- [ ] Arrange-Act-Assert pattern followed
- [ ] Tests are isolated and independent
- [ ] No flaky or intermittent tests
- [ ] Tests run quickly

### Coverage Metrics (If available)

- [ ] Line coverage meets minimum (typically 80%+)
- [ ] Branch coverage acceptable
- [ ] Critical paths fully covered
- [ ] Edge cases tested
- [ ] Error paths tested
- [ ] No untested complex code

### Test Execution

- [ ] All tests pass
- [ ] No skipped or ignored tests
- [ ] Test suite runs in reasonable time
- [ ] Tests are deterministic
- [ ] Tests clean up after themselves

## Code Quality Analysis

### Code Structure

- [ ] Classes/modules have single responsibility
- [ ] Functions are focused and concise
- [ ] Proper abstraction levels maintained
- [ ] Coupling is loose
- [ ] Cohesion is high
- [ ] Code is modular and reusable

### Error Handling

- [ ] Errors caught and handled appropriately
- [ ] Error messages are clear and actionable
- [ ] No silent failures
- [ ] Proper error propagation
- [ ] Resources cleaned up in error paths
- [ ] Consistent error handling patterns

### Security

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

### Performance

- [ ] No obvious performance bottlenecks
- [ ] Database queries optimized
- [ ] Appropriate caching used
- [ ] Resource usage reasonable
- [ ] No memory leaks
- [ ] Algorithms efficient for expected data sizes
- [ ] Network calls minimized

### Maintainability

- [ ] Code is readable and understandable
- [ ] No overly complex logic
- [ ] Magic numbers replaced with named constants
- [ ] Deprecated APIs not used
- [ ] Dependencies up-to-date and secure
- [ ] Technical debt minimized or documented

## Review Severity Classification

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
