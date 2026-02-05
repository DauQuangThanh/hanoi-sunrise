---
name: bug-fixing
description: Implements fixes for identified bugs through systematic debugging and code changes. Use when applying bug fixes, resolving errors, patching crashes, or when user mentions fixing bugs, implementing solutions, or applying patches. Requires prior analysis.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.1"
  last_updated: "2026-02-05"
---

# Bug Fixing

## Overview

This skill guides AI agents through systematic bug identification, analysis, and fixing processes. It provides structured approaches for reproducing issues, analyzing root causes, implementing fixes, and validating solutions.

## When to Use

- Application crashes or throws errors
- Unexpected behavior or incorrect results
- Performance issues or resource leaks
- Integration problems between components
- User reports bugs or failures
- User mentions: "bug", "error", "crash", "doesn't work", "broken", "debug", "fix"
- **Focus**: Implementing fixes after root cause analysis

## Prerequisites

- Access to source code and error logs
- Ability to reproduce the issue
- Development environment for testing
- Version control system for tracking changes
- Basic understanding of the application architecture

## Instructions

### Step 1: Reproduce the Bug

1. **Gather Information**

   - Error messages and stack traces
   - Steps to reproduce
   - Environment details (OS, browser, versions)
   - Input data that triggers the issue

2. **Create Minimal Test Case**

   - Isolate the problem
   - Remove unrelated code
   - Verify reproduction consistently

### Step 2: Analyze the Root Cause

1. **Review Code and Logs**

   - Examine error locations
   - Check variable values and flow
   - Analyze dependencies and interactions

2. **Use Debugging Tools**

   - Breakpoints and step-through debugging
   - Logging and tracing
   - Profilers for performance issues

3. **Identify Bug Type**

   - Logic errors
   - Null pointer exceptions
   - Race conditions
   - Memory leaks
   - Type mismatches

### Step 3: Implement the Fix

1. **Plan the Solution**

   - Choose the simplest effective fix
   - Consider edge cases
   - Ensure backward compatibility

2. **Apply the Fix**

   - Make minimal changes
   - Add comments explaining the fix
   - Update related code if needed

### Step 4: Test and Validate

1. **Unit Testing**

   - Test the specific fix
   - Verify no regressions

2. **Integration Testing**

   - Test with related components
   - Full application testing

3. **Edge Case Testing**

   - Test boundary conditions
   - Stress testing for performance issues

## Language and Framework Specific Guidelines

### Python

- **Exception handling**: Use specific exception types, avoid bare except
- **None checks**: Use `if variable is None` instead of truthiness
- **Import errors**: Check for circular imports and missing modules

### JavaScript/TypeScript

- **Type errors**: Ensure proper type checking and casting
- **Async issues**: Check promise chains and await usage
- **DOM manipulation**: Verify element existence before manipulation

### Java

- **NullPointerException**: Use Optional or null checks
- **ConcurrentModificationException**: Use proper iteration methods
- **Memory leaks**: Close resources properly

### C-Sharp

- **NullReferenceException**: Use null-conditional operators
- **IndexOutOfRangeException**: Check array bounds
- **Threading issues**: Use proper synchronization

### Go (Golang)

- **Panic recovery**: Use defer/recover for graceful error handling
- **Goroutine leaks**: Ensure proper channel closing
- **Slice bounds**: Check slice lengths before access

### React.js

- **State updates**: Use functional updates to avoid stale closures
- **Effect dependencies**: Include all dependencies in useEffect
- **Key props**: Ensure unique keys in lists

### Vue.js

- **Reactive data**: Avoid mutating props directly
- **Lifecycle hooks**: Proper cleanup in beforeUnmount
- **Computed properties**: Ensure dependencies are reactive

## Examples

### Example 1: Null Pointer Fix (Java)

**Before:**

```java
public String getUserName(User user) {
    return user.getName().toUpperCase();
}
```

**After:**

```java
public String getUserName(User user) {
    if (user == null || user.getName() == null) {
        return "Unknown";
    }
    return user.getName().toUpperCase();
}
```

### Example 2: Race Condition Fix (JavaScript)

**Before:**

```javascript
let counter = 0;

function increment() {
    counter++;
}

function getCounter() {
    return counter;
}
```

**After:**

```javascript
let counter = 0;

function increment() {
    counter = counter + 1; // More explicit
}

function getCounter() {
    return counter;
}

// For concurrent access, consider using locks or atomic operations
```

### Example 3: Memory Leak Fix (Python)

**Before:**

```python
class Processor:
    def __init__(self):
        self.listeners = []
    
    def add_listener(self, listener):
        self.listeners.append(listener)
    
    def process(self):
        for listener in self.listeners:
            listener.notify()
```

**After:**

```python
import weakref

class Processor:
    def __init__(self):
        self.listeners = []
    
    def add_listener(self, listener):
        self.listeners.append(weakref.ref(listener))
    
    def process(self):
        # Clean up dead references
        self.listeners = [ref for ref in self.listeners if ref() is not None]
        for ref in self.listeners:
            listener = ref()
            if listener:
                listener.notify()
```

## Edge Cases

### Case 1: Intermittent Bugs

**Handling:** Add extensive logging, use debugging tools to capture state, consider threading or timing issues.

### Case 2: Production Only Bugs

**Handling:** Replicate production environment locally, check configuration differences, use remote debugging.

### Case 3: Third-Party Library Issues

**Handling:** Check library versions, review documentation, consider workarounds or alternative libraries.

## Error Handling

### Fix Introduces New Bugs

**Solution:** Revert changes, add comprehensive tests before re-implementing, use smaller incremental changes.

### Cannot Reproduce the Bug

**Solution:** Gather more environment details, ask for specific reproduction steps, consider environmental factors.

### Performance Impact from Fix

**Solution:** Profile the fix, optimize if necessary, consider alternative approaches that maintain performance.
