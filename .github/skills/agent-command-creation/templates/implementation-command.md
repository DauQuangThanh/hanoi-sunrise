---
description: "Implement feature based on specification following project conventions"
---

# Implementation Command Template

## Purpose

Implement a new feature following the technical specification, project conventions, and best practices.

## Context

- Specification file: $ARGUMENTS
- Project conventions: docs/conventions.md
- Coding standards: docs/coding-standards.md
- Existing code patterns: [relevant examples in codebase]
- Tech stack: [languages, frameworks, libraries]

## Instructions

### Phase 1: Planning

1. **Read the specification**
   - Understand requirements thoroughly
   - Identify acceptance criteria
   - Note any ambiguities or questions
   - Clarify scope and boundaries

2. **Review existing codebase**
   - Study similar features/modules
   - Identify reusable components
   - Understand current architecture
   - Note integration points

3. **Plan implementation approach**
   - Break down into manageable components
   - Identify dependencies
   - Determine implementation order
   - Estimate complexity

4. **Design integration strategy**
   - Plan API contracts
   - Define data models
   - Consider error handling
   - Plan testing approach

### Phase 2: Implementation

1. **Set up structure**
   - Create necessary files/directories
   - Set up module exports/imports
   - Define interfaces/types
   - Create placeholder functions

2. **Implement core functionality**
   - Follow project coding standards
   - Use consistent naming conventions
   - Keep functions focused and single-purpose
   - Add inline comments for complex logic

3. **Add error handling**
   - Validate inputs
   - Handle edge cases
   - Provide meaningful error messages
   - Log appropriately

4. **Optimize performance**
   - Use efficient algorithms
   - Avoid unnecessary computations
   - Consider caching where appropriate
   - Profile if needed

5. **Ensure security**
   - Validate and sanitize inputs
   - Follow security best practices
   - Avoid common vulnerabilities
   - Protect sensitive data

### Phase 3: Testing

1. **Write unit tests**
   - Test each function/method
   - Cover happy paths
   - Test edge cases
   - Test error conditions
   - Aim for high coverage

2. **Write integration tests**
   - Test component interactions
   - Verify API contracts
   - Test data flow
   - Validate error propagation

3. **Manual testing**
   - Test in development environment
   - Verify UI/UX if applicable
   - Test with realistic data
   - Check error messages

4. **Performance testing**
   - Measure response times
   - Test with large datasets
   - Identify bottlenecks
   - Verify scalability

### Phase 4: Documentation

1. **Code documentation**
   - Add JSDoc/docstrings
   - Document complex algorithms
   - Explain non-obvious decisions
   - Add usage examples

2. **API documentation**
   - Document endpoints/methods
   - Specify parameters
   - Describe return values
   - Provide examples

3. **Update project docs**
   - Add feature to README
   - Update architecture docs
   - Document configuration
   - Add troubleshooting guide

4. **Create usage guide**
   - Provide step-by-step instructions
   - Include code examples
   - Show common use cases
   - Document limitations

### Phase 5: Review & Refinement

1. **Self-review**
   - Check code quality
   - Verify test coverage
   - Review documentation
   - Test edge cases

2. **Run quality checks**
   - Linting
   - Type checking
   - Security scanning
   - Performance profiling

3. **Refactor if needed**
   - Improve readability
   - Reduce complexity
   - Eliminate duplication
   - Optimize performance

## Output Format

Deliver the following:

### 1. Implementation Files

```
src/
  feature-name/
    index.ts
    types.ts
    utils.ts
    [feature].service.ts
    [feature].controller.ts
    [feature].validator.ts
```

### 2. Test Files

```
tests/
  unit/
    feature-name/
      [feature].service.test.ts
      utils.test.ts
  integration/
    feature-name/
      [feature].integration.test.ts
```

### 3. Documentation

```
docs/
  features/
    feature-name.md  # Feature documentation
api/
  feature-name.md    # API documentation
```

### 4. Implementation Summary

Create `IMPLEMENTATION.md`:

```markdown
# [Feature Name] Implementation

## Overview

Brief description of what was implemented.

## Changes Made

### New Files

- `src/feature/file.ts` - Purpose and functionality
- `tests/feature/file.test.ts` - Test coverage

### Modified Files

- `src/existing/file.ts` - Changes made and why

### Configuration Changes

- Added environment variables: `FEATURE_CONFIG`
- Updated `config/default.json`

## Implementation Details

### Architecture

[Diagram or description of architecture]

### Key Components

#### Component 1: [Name]

- Purpose: [What it does]
- Location: [File path]
- Dependencies: [What it depends on]

[Repeat for each component]

### Design Decisions

1. **Decision**: [What was decided]
   - **Rationale**: [Why]
   - **Alternatives**: [What else was considered]
   - **Trade-offs**: [Pros and cons]

## Testing

### Test Coverage

- Unit tests: X%
- Integration tests: Y scenarios
- Manual testing: Z test cases

### Test Results

```

All tests passing ✓
Total: X tests
Passed: X
Failed: 0
Duration: Xs

```

## Quality Checks

- [ ] Linting passed
- [ ] Type checking passed
- [ ] Security scan passed
- [ ] Performance benchmarks met
- [ ] Code review ready

## Usage Examples

### Example 1: Basic Usage

```typescript
import { Feature } from './feature';

const result = await Feature.doSomething({
  param: 'value'
});
```

### Example 2: Advanced Usage

```typescript
// Advanced example with error handling
try {
  const result = await Feature.doComplexThing({
    // parameters
  });
} catch (error) {
  // Handle error
}
```

## Migration Guide

If this affects existing code:

1. Update imports: `import { New } from 'new-location'`
2. Update API calls: [Show before/after]
3. Update configuration: [What to change]

## Known Limitations

- [Limitation 1]
- [Limitation 2]

## Future Improvements

- [Potential enhancement 1]
- [Potential enhancement 2]

## References

- Specification: [Link]
- Related Issues: [Links]
- Documentation: [Links]

```

## Quality Gates

Before marking as complete, verify:

- [ ] All requirements from specification implemented
- [ ] Code follows project conventions
- [ ] All tests passing (unit + integration)
- [ ] Test coverage meets project standards (typically 80%+)
- [ ] Error handling implemented
- [ ] Edge cases covered
- [ ] Documentation complete
- [ ] Code reviewed (self-review at minimum)
- [ ] Performance acceptable
- [ ] Security best practices followed
- [ ] No breaking changes (or properly documented)
- [ ] Backward compatibility maintained (if applicable)

## Examples

### Example 1: User Authentication Feature

**Input**: `/implement specs/user-authentication.md`

**Output**: Complete authentication implementation with login, logout, session management, tests, and documentation.

### Example 2: Payment Integration

**Input**: `/implement specs/payment-integration.md`

**Output**: Payment processing module with Stripe integration, webhook handlers, tests, and API documentation.

### Example 3: Search Functionality

**Input**: `/implement specs/search-feature.md`

**Output**: Full-text search implementation with indexing, query optimization, tests, and usage guide.
