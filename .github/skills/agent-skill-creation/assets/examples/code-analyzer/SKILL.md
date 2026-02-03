---
name: code-analyzer
description: Analyzes code quality, complexity, and potential issues. Provides actionable recommendations for improvements. Use when analyzing code structure, identifying technical debt, reviewing code patterns, or when user mentions code analysis, quality review, or refactoring suggestions.
license: MIT
version: 1.0
author: Dau Quang Thanh
---

# Code Analyzer Skill

**A minimal example skill demonstrating the analysis pattern.**

## Overview

This skill analyzes source code files and provides quality insights, complexity metrics, and improvement recommendations.

## When to Use

- User requests code analysis or quality review
- Need to assess technical debt
- Reviewing code before refactoring
- Identifying potential issues or anti-patterns
- User mentions: "analyze", "code quality", "review", "complexity"

## Requirements

Before analyzing:

1. Identify the code file or directory to analyze
2. Determine the programming language
3. Understand the analysis scope (full file vs specific function)
4. Confirm desired metrics (complexity, patterns, best practices)

## Analysis Process

### Step 1: Read Code

Read the target file using the `read_file` tool:

```
read_file(filePath="/path/to/file.py", startLine=1, endLine=100)
```

### Step 2: Analyze Structure

Examine:

- Function complexity (cyclomatic complexity)
- Nesting levels
- Function length
- Code duplication
- Naming conventions

### Step 3: Identify Issues

Look for:

- Long functions (>50 lines)
- High cyclomatic complexity (>10)
- Deep nesting (>4 levels)
- Code smells (duplicated code, large classes)
- Security vulnerabilities

### Step 4: Generate Report

Provide:

**Metrics:**

- Lines of code
- Number of functions/classes
- Average function length
- Complexity score

**Issues Found:**

- Critical: Security issues, major bugs
- High: Code smells, high complexity
- Medium: Style violations, minor improvements
- Low: Suggestions, optimizations

**Recommendations:**

- Prioritized action items
- Code examples for fixes
- Best practice references

## Example

**Input:**

```python
def process_data(data):
    if data:
        if len(data) > 0:
            for item in data:
                if item.value:
                    if item.value > 100:
                        result = item.value * 2
                        return result
    return None
```

**Analysis:**

```
Issues:
1. High nesting (5 levels) - Consider early returns
2. Inconsistent validation - Use guard clauses
3. Single return value - Simplify logic

Recommended refactoring:
def process_data(data):
    if not data or len(data) == 0:
        return None
    
    for item in data:
        if item.value and item.value > 100:
            return item.value * 2
    
    return None
```

## Output Format

Always provide analysis in this structure:

```markdown
## Code Analysis: [filename]

### Metrics
- Lines: X
- Functions: Y
- Avg Complexity: Z

### Issues
**Critical (N)**
- [Issue description with line number]

**High (N)**
- [Issue description with line number]

### Recommendations
1. [Priority 1 action]
2. [Priority 2 action]
```

## Notes

- Focus on actionable feedback
- Provide code examples for fixes
- Prioritize by impact and effort
- Consider language-specific best practices
- Be specific with line numbers

---

This is a minimal example. Real skills may include:

- references/ directory with detailed guidelines
- templates/ for report formats
- scripts/ for automation
