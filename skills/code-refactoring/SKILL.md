---
name: code-refactoring
description: Refactors code for improved readability, performance, and maintainability. Use when cleaning up code, optimizing functions, or when user mentions refactoring, code improvement, or optimization.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.1"
  last_updated: "2026-02-05"
---

# Code Refactoring

## Overview

This skill guides AI agents through systematic code refactoring processes to improve code quality, readability, performance, and maintainability. It provides structured approaches for identifying refactoring opportunities and applying best practices.

## When to Use

- Code has become hard to understand or maintain
- Functions are too long or complex
- Code duplication exists
- Performance optimizations needed
- Preparing for new features
- User mentions: "refactor", "clean up code", "optimize", "improve code", "code quality"

## Prerequisites

- Access to source code files
- Understanding of the programming language and framework
- Version control system for tracking changes
- Basic knowledge of refactoring patterns

## Instructions

### Step 1: Analyze Code for Refactoring Opportunities

1. **Identify Code Smells**

   - Long methods (>50 lines)
   - Large classes (>300 lines)
   - Duplicate code
   - Complex conditionals
   - Unused variables/functions
   - Tight coupling

2. **Assess Impact**

   - Dependencies on the code
   - Test coverage
   - Frequency of changes
   - Business criticality

### Step 2: Plan Refactoring

1. **Choose Refactoring Technique**

   - Extract Method
   - Rename Variable/Function
   - Move Method/Class
   - Replace Conditional with Polymorphism
   - Introduce Parameter Object

2. **Create Refactoring Plan**

   - List steps in order
   - Identify potential risks
   - Plan testing strategy

### Step 3: Apply Refactoring

1. **Make Small Changes**

   - One refactoring at a time
   - Run tests after each change
   - Commit frequently

2. **Use IDE Tools**

   - Automated refactoring tools
   - Code analysis tools

### Step 4: Validate and Test

1. **Run All Tests**

   - Unit tests
   - Integration tests
   - Regression tests

2. **Code Review**

   - Peer review
   - Automated code quality checks

## Language and Framework Specific Guidelines

### Python

- **Use type hints**: Add type annotations for better IDE support and documentation
- **Follow PEP 8**: Use consistent naming, spacing, and line length
- **Replace list comprehensions**: For complex logic, use generator expressions or regular loops for readability

### JavaScript/TypeScript

- **Use const/let**: Replace var with const/let for block scoping
- **Arrow functions**: Convert function expressions to arrow functions where appropriate
- **Destructuring**: Use object/array destructuring to simplify variable assignments
- **Optional chaining**: Replace nested null checks with `?.` operator

### Java

- **Streams API**: Replace traditional loops with streams for data processing
- **Optional class**: Use Optional to avoid null pointer exceptions
- **Method references**: Use `::` syntax for cleaner lambda expressions

### C#

- **LINQ queries**: Convert loops to LINQ for data manipulation
- **Async/await**: Ensure proper asynchronous programming patterns
- **Pattern matching**: Use switch expressions and pattern matching for cleaner conditionals

### Go (Golang)

- **Error handling**: Use error wrapping and custom error types
- **Goroutines**: Ensure proper channel usage and avoid goroutine leaks
- **Interfaces**: Use small, focused interfaces following the implicit interface pattern

### React.js

- **Hooks**: Convert class components to functional components with hooks
- **Memoization**: Use React.memo, useMemo, and useCallback for performance
- **Component composition**: Break down large components into smaller, reusable ones

### Vue.js

- **Composition API**: Migrate from Options API to Composition API for better TypeScript support
- **Computed properties**: Use computed for reactive data transformations
- **Component organization**: Separate concerns with mixins or composables

### Next.js

- **Server Components**: Use App Router with Server Components for better performance
- **Image optimization**: Replace img tags with Next.js Image component
- **API routes**: Ensure proper error handling and validation in API routes

### Nuxt.js

- **Composables**: Extract reusable logic into composables
- **Server API**: Use Nuxt's server API for better type safety
- **Modules**: Leverage Nuxt modules for common functionality

### Tailwind CSS

- **Utility classes**: Replace custom CSS with Tailwind utilities
- **Responsive design**: Use responsive prefixes consistently
- **Component extraction**: Create reusable component classes for repeated patterns

### Frontend General

- **Component extraction**: Break down large components into smaller, focused ones
- **State management**: Centralize state logic and avoid prop drilling
- **Accessibility**: Ensure proper ARIA attributes and keyboard navigation

### Backend General

- **Dependency injection**: Use DI containers for better testability
- **Middleware**: Extract cross-cutting concerns into middleware
- **Database optimization**: Use proper indexing and query optimization

## Examples

### Example 1: Extract Method

**Before:**

```python
def process_data(data):
    # Validate data
    if not data:
        raise ValueError("Data is empty")
    if len(data) > 1000:
        raise ValueError("Data too large")
    
    # Process each item
    results = []
    for item in data:
        if item['status'] == 'active':
            processed = item['value'] * 2
            results.append(processed)
    
    return results
```

**After:**

```python
def validate_data(data):
    if not data:
        raise ValueError("Data is empty")
    if len(data) > 1000:
        raise ValueError("Data too large")

def process_item(item):
    if item['status'] == 'active':
        return item['value'] * 2
    return None

def process_data(data):
    validate_data(data)
    
    results = []
    for item in data:
        processed = process_item(item)
        if processed is not None:
            results.append(processed)
    
    return results
```

### Example 2: Rename Variables for Clarity

**Before:**

```javascript
function calc(x, y, z) {
    let a = x * 2;
    let b = y + z;
    return a + b;
}
```

**After:**

```javascript
function calculate_total_price(base_price, tax_rate, discount) {
    let price_with_tax = base_price * (1 + tax_rate);
    let final_discount = discount;
    return price_with_tax - final_discount;
}
```

## Edge Cases

### Case 1: Legacy Code with No Tests

**Handling:** Add tests before refactoring, or refactor in very small steps with manual testing.

### Case 2: Performance-Critical Code

**Handling:** Profile before and after refactoring, ensure optimizations don't break functionality.

### Case 3: Distributed Teams

**Handling:** Communicate refactoring plans, use feature flags for gradual rollout.

## Error Handling

### Refactoring Breaks Functionality

**Solution:** Revert changes immediately, analyze what went wrong, refactor more carefully.

### Tests Fail After Refactoring

**Solution:** Update tests to match new structure, ensure tests are testing behavior not implementation.

### Performance Degradation

**Solution:** Profile the code, identify bottlenecks, optimize specific sections.