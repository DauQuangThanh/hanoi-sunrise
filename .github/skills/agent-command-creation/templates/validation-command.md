---
description: "Validate code against project standards and best practices"
---

# Validation Command Template

## Purpose

Validate code quality, standards compliance, and best practices adherence to ensure high-quality, maintainable code.

## Context

- Files to validate: $ARGUMENTS
- Project standards: docs/coding-standards.md
- Coding conventions: docs/conventions.md
- Quality benchmarks: docs/quality-metrics.md
- Tech stack requirements: docs/tech-stack.md

## Instructions

### Phase 1: Structural Validation

#### 1.1 File Organization

- [ ] Files are in correct directories
- [ ] Naming conventions followed
- [ ] Proper file structure maintained
- [ ] No orphaned or unused files

#### 1.2 Module Structure

- [ ] Proper exports/imports
- [ ] No circular dependencies
- [ ] Appropriate module boundaries
- [ ] Clear separation of concerns

#### 1.3 Code Organization

- [ ] Logical grouping of related code
- [ ] Consistent file/folder structure
- [ ] Appropriate use of subdirectories
- [ ] Index files used correctly

### Phase 2: Code Quality Validation

#### 2.1 Readability

- [ ] Clear, descriptive naming
- [ ] Consistent formatting
- [ ] Appropriate line lengths
- [ ] Proper indentation
- [ ] Logical code flow

#### 2.2 Simplicity

- [ ] Functions are single-purpose
- [ ] No unnecessary complexity
- [ ] KISS principle followed
- [ ] DRY principle applied
- [ ] YAGNI principle respected

#### 2.3 Maintainability

- [ ] Low cyclomatic complexity
- [ ] No deeply nested logic
- [ ] No code duplication
- [ ] Easy to modify/extend
- [ ] Clear dependencies

#### 2.4 Performance

- [ ] Efficient algorithms used
- [ ] No obvious bottlenecks
- [ ] Proper resource management
- [ ] Appropriate caching
- [ ] No memory leaks

### Phase 3: Standards Compliance

#### 3.1 Naming Conventions

- [ ] Variables: camelCase/snake_case as per standard
- [ ] Functions: descriptive verb phrases
- [ ] Classes: PascalCase nouns
- [ ] Constants: UPPER_SNAKE_CASE
- [ ] Files: kebab-case or camelCase as per standard
- [ ] No abbreviations without context

#### 3.2 Formatting

- [ ] Consistent indentation (2 or 4 spaces)
- [ ] Proper spacing around operators
- [ ] Consistent quote style
- [ ] Trailing commas as per standard
- [ ] Line length within limits (80-120 chars)

#### 3.3 Code Patterns

- [ ] Follows project patterns
- [ ] Uses approved libraries/frameworks
- [ ] Consistent error handling approach
- [ ] Standard logging format
- [ ] Proper async/await usage

#### 3.4 Architecture

- [ ] Follows layered architecture
- [ ] Proper separation of concerns
- [ ] Dependency injection used correctly
- [ ] Design patterns applied appropriately
- [ ] SOLID principles followed

### Phase 4: Security Validation

#### 4.1 Input Validation

- [ ] All inputs validated
- [ ] Proper sanitization
- [ ] Type checking performed
- [ ] Boundary checks in place
- [ ] No SQL/NoSQL injection vulnerabilities

#### 4.2 Data Protection

- [ ] Sensitive data encrypted
- [ ] No hardcoded secrets
- [ ] Proper credential management
- [ ] Secure communication (HTTPS)
- [ ] PII handled correctly

#### 4.3 Authentication & Authorization

- [ ] Proper authentication checks
- [ ] Authorization enforced
- [ ] Session management secure
- [ ] No privilege escalation risks
- [ ] JWT/tokens handled securely

#### 4.4 Common Vulnerabilities

- [ ] No XSS vulnerabilities
- [ ] No CSRF vulnerabilities
- [ ] No command injection
- [ ] No path traversal issues
- [ ] Proper error handling (no info leak)

### Phase 5: Testing Validation

#### 5.1 Test Coverage

- [ ] Unit tests present
- [ ] Integration tests present
- [ ] Coverage meets minimum (typically 80%+)
- [ ] Critical paths covered
- [ ] Edge cases tested

#### 5.2 Test Quality

- [ ] Tests are meaningful
- [ ] Tests are independent
- [ ] Tests are repeatable
- [ ] Tests are fast
- [ ] Good assertions (not just smoke tests)

#### 5.3 Test Organization

- [ ] Tests mirror source structure
- [ ] Clear test names
- [ ] Proper setup/teardown
- [ ] Test data managed well
- [ ] Mocks used appropriately

### Phase 6: Documentation Validation

#### 6.1 Code Documentation

- [ ] Functions documented (JSDoc/docstrings)
- [ ] Complex logic explained
- [ ] Parameters documented
- [ ] Return values documented
- [ ] Exceptions documented

#### 6.2 API Documentation

- [ ] Endpoints documented
- [ ] Request/response formats specified
- [ ] Error codes documented
- [ ] Examples provided
- [ ] Authentication requirements clear

#### 6.3 Project Documentation

- [ ] README up to date
- [ ] CHANGELOG maintained
- [ ] Contributing guide present
- [ ] Architecture documented
- [ ] Setup instructions clear

## Output Format

Create `validation-report-[YYYY-MM-DD].md`:

```markdown
# Code Validation Report

**Date**: [YYYY-MM-DD]
**Scope**: [Files/directories validated]
**Validator**: [Tool/Manual]

## Overall Status

🟢 **PASS** / 🟡 **PASS WITH WARNINGS** / 🔴 **FAIL**

## Summary

- Total checks: X
- Passed: X
- Failed: X
- Warnings: X
- Compliance score: X%

## Validation Results by Category

### 1. Structural Validation

**Status**: ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

- File organization: ✅
- Module structure: ✅
- Code organization: ⚠️ (2 warnings)

**Issues**:

- [ ] **Warning**: Inconsistent file organization in `src/utils/`
  - Location: `src/utils/`
  - Impact: Reduced maintainability
  - Suggestion: Group related utilities into subdirectories

### 2. Code Quality

**Status**: ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

**Metrics**:

- Cyclomatic complexity: Avg 4.2 (target: < 10) ✅
- Maintainability index: 78 (target: > 70) ✅
- Code duplication: 2.1% (target: < 3%) ✅

**Issues**:

- [ ] **FAIL**: High complexity in `processData()` function
  - Location: `src/services/processor.ts:45`
  - Complexity: 18 (limit: 10)
  - Impact: Hard to test and maintain
  - Remediation: Extract sub-functions, simplify logic
  - Estimated effort: 2-3 hours

### 3. Standards Compliance

**Status**: ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

- Naming conventions: ❌ (3 violations)
- Formatting: ✅
- Code patterns: ⚠️ (1 inconsistency)
- Architecture: ✅

**Issues**:

- [ ] **FAIL**: Inconsistent naming in variable declarations
  - Location: `src/utils/helpers.ts:12`
  - Current: `user_data`
  - Expected: `userData` (camelCase)
  - Fix: Rename to follow camelCase convention

### 4. Security

**Status**: ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

**Security Scan Results**:

- Critical vulnerabilities: 0 ✅
- High severity: 0 ✅
- Medium severity: 1 ⚠️
- Low severity: 2 ⚠️

**Issues**:

- [ ] **WARNING**: Potential SQL injection risk
  - Location: `src/db/queries.ts:78`
  - Issue: Direct string concatenation in SQL query
  - Impact: SQL injection vulnerability
  - Remediation: Use parameterized queries
  - Example:
    ```typescript
    // Current (vulnerable)
    const query = `SELECT * FROM users WHERE id = ${userId}`;
    
    // Fixed (secure)
    const query = `SELECT * FROM users WHERE id = $1`;
    db.query(query, [userId]);
    ```
  - Estimated effort: 30 minutes

### 5. Testing

**Status**: ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

**Coverage**:

- Overall: 85% ✅ (target: 80%)
- Statements: 87%
- Branches: 82%
- Functions: 88%
- Lines: 85%

**Gaps**:

- [ ] **WARNING**: Low coverage in error handling paths
  - Location: `src/services/payment.ts`
  - Coverage: 45% (target: 80%)
  - Missing: Error scenario tests
  - Action: Add tests for error conditions

### 6. Documentation

**Status**: ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

- Code comments: ⚠️ (some missing)
- API documentation: ✅
- Project docs: ✅

**Issues**:

- [ ] **WARNING**: Missing documentation for public API
  - Location: `src/api/service.ts:getUserProfile()`
  - Missing: JSDoc comment
  - Required: Parameters, return value, exceptions
  - Template:
    ```typescript
    /**
     * Retrieves user profile by ID
     * @param userId - Unique user identifier
     * @returns User profile object
     * @throws UserNotFoundError if user doesn't exist
     */
    ```

## Critical Issues (Must Fix)

1. **High complexity in processData()** - `src/services/processor.ts:45`
2. **SQL injection risk** - `src/db/queries.ts:78`
3. **Inconsistent naming** - `src/utils/helpers.ts:12`

## Warnings (Should Fix)

1. **Inconsistent file organization** - `src/utils/`
2. **Low test coverage in error paths** - `src/services/payment.ts`
3. **Missing API documentation** - `src/api/service.ts`

## Recommendations

### Immediate Actions

1. Fix SQL injection vulnerability (Critical - 30 min)
2. Reduce processData() complexity (High - 2-3 hours)
3. Fix naming convention violations (Medium - 15 min)

### Short-term Improvements

1. Improve test coverage for error scenarios
2. Add missing API documentation
3. Reorganize utilities directory

### Long-term Enhancements

1. Set up automated linting in CI/CD
2. Implement pre-commit hooks for validation
3. Regular code quality reviews
4. Developer training on standards

## Quality Metrics

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Test Coverage | 85% | 80% | ✅ |
| Complexity (avg) | 4.2 | < 10 | ✅ |
| Duplication | 2.1% | < 3% | ✅ |
| Maintainability | 78 | > 70 | ✅ |
| Security Issues | 3 | 0 | ⚠️ |
| Standards Compliance | 92% | 95% | ⚠️ |

## Next Steps

1. Address critical issues immediately
2. Create tickets for warnings
3. Schedule follow-up validation
4. Update documentation
5. Share findings with team

## Validation Tools Used

- ESLint / Pylint / RuboCop (linting)
- TypeScript / mypy (type checking)
- Jest / pytest (test coverage)
- SonarQube (code quality)
- Snyk / OWASP (security scanning)
```

## Examples

### Example 1: Pre-commit Validation

**Input**: `/validate src/features/user-profile.ts`

**Output**: Validation report showing code quality, standards compliance, and any issues before committing.

### Example 2: Pull Request Validation

**Input**: `/validate src/`

**Output**: Comprehensive validation report for all changes in the PR, highlighting blockers and recommendations.

### Example 3: Release Validation

**Input**: `/validate .`

**Output**: Full project validation ensuring readiness for production release.
