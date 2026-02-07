---
name: code-refactoring
description: Refactors code for improved simplicity, maintainability, performance, and readability. Use when cleaning up code, optimizing functions, or when user mentions refactoring, code improvement, or optimization.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.2"
  last_updated: "2026-02-07"
---

# Code Refactoring

## Overview

This skill guides AI agents through systematic code refactoring processes to improve code quality, simplicity, maintainability, performance, and readability. It provides structured approaches for identifying refactoring opportunities, simplifying complex code structures, and applying best practices across different programming languages and frameworks.

## When to Use

- Code has become overly complex or hard to understand
- Functions are too long, have too many responsibilities, or contain duplicate logic
- Code duplication exists across multiple files or modules
- Performance optimizations are needed without sacrificing clarity
- Preparing for new features by simplifying existing code
- User mentions: "refactor", "simplify code", "clean up code", "optimize", "improve code", "code quality"

## Prerequisites

- Access to source code files
- Understanding of the programming language and framework
- Version control system for tracking changes
- Basic knowledge of refactoring patterns

## Instructions

### Step 1: Analyze Code for Refactoring Opportunities

1. **Identify Code Smells and Complexity Issues**

   - Long methods (>50 lines) or methods with multiple responsibilities
   - Large classes (>300 lines) with too many concerns
   - Code duplication across files or within methods
   - Complex conditionals (nested ifs, long boolean expressions)
   - Tight coupling between components
   - Unused variables, functions, or imports
   - Overly complex algorithms that could be simplified

2. **Assess Impact and Simplicity**

   - Dependencies on the code and potential ripple effects
   - Test coverage to ensure safe refactoring
   - Frequency of changes (hotspots may need more care)
   - Business criticality and risk tolerance
   - Current complexity level and readability barriers

### Step 2: Plan Refactoring

1. **Choose Refactoring Techniques for Simplicity and Quality**

   - Extract Method: Break down complex functions into smaller, focused ones
   - Rename Variable/Function: Use clear, descriptive names
   - Move Method/Class: Organize code into logical groupings
   - Replace Conditional with Polymorphism: Simplify complex conditionals
   - Introduce Parameter Object: Reduce method parameter complexity
   - Simplify Conditional Logic: Use early returns, guard clauses
   - Remove Code Duplication: Extract common logic into shared functions

2. **Create Refactoring Plan**

   - List steps in order of execution
   - Identify potential risks and mitigation strategies
   - Plan testing strategy including unit and integration tests
   - Consider performance implications of changes

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

- **Use type hints**: Add type annotations for better IDE support, documentation, and error prevention
- **Follow PEP 8**: Use consistent naming, spacing, and line length for readability
- **Simplify comprehensions**: Use list comprehensions for simple transformations; break complex nested comprehensions into explicit loops for clarity
- **Prefer explicit over implicit**: Use clear variable names and avoid overly clever one-liners that sacrifice understandability

### JavaScript/TypeScript

- **Use const/let**: Replace var with const/let for block scoping and immutability where appropriate
- **Arrow functions**: Convert function expressions to arrow functions for concise syntax, but prefer named functions for complex logic
- **Destructuring**: Use object/array destructuring to simplify variable assignments and improve readability
- **Optional chaining**: Replace nested null checks with `?.` operator for cleaner, simpler conditional logic
- **Async/await**: Simplify promise chains with async/await for linear, easier-to-follow asynchronous code

### Java

- **Streams API**: Replace traditional loops with streams for data processing
- **Optional class**: Use Optional to avoid null pointer exceptions
- **Method references**: Use `::` syntax for cleaner lambda expressions

### C-Sharp

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

### Example 3: Simplify Complex Conditional Logic

**Before:**

```javascript
function processOrder(order) {
    let discount = 0;
    if (order.customerType === 'premium') {
        if (order.total > 1000) {
            discount = order.total * 0.15;
        } else if (order.total > 500) {
            discount = order.total * 0.10;
        } else {
            discount = order.total * 0.05;
        }
    } else if (order.customerType === 'regular') {
        if (order.total > 500) {
            discount = order.total * 0.05;
        }
    }
    return order.total - discount;
}
```

**After:**

```javascript
function calculateDiscount(customerType, total) {
    const discountRates = {
        premium: total > 1000 ? 0.15 : total > 500 ? 0.10 : 0.05,
        regular: total > 500 ? 0.05 : 0
    };
    return total * (discountRates[customerType] || 0);
}

function processOrder(order) {
    const discount = calculateDiscount(order.customerType, order.total);
    return order.total - discount;
}
```

## Edge Cases

### Case 1: Legacy Code with No Tests

**Handling:** Add tests before refactoring, or refactor in very small steps with manual testing.

### Case 2: Performance-Critical Code

**Handling:** Profile before and after refactoring, ensure optimizations don't break functionality.

### Case 3: Distributed Teams

**Handling:** Communicate refactoring plans, use feature flags for gradual rollout.

### Case 4: Over-Simplification Risk

**Handling:** Balance simplicity with functionality; avoid removing necessary complexity; ensure all edge cases are covered by tests.

## Error Handling

### Refactoring Breaks Functionality

**Solution:** Revert changes immediately, analyze what went wrong, refactor more carefully.

### Tests Fail After Refactoring

**Solution:** Update tests to match new structure, ensure tests are testing behavior not implementation.

### Performance Degradation

**Solution:** Profile the code, identify bottlenecks, optimize specific sections.

### Over-Simplification Causes Bugs

**Solution:** Review the simplified code for missing edge cases, add comprehensive tests, consider if some complexity was necessary.
