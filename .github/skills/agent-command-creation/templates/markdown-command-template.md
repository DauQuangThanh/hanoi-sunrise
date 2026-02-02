---
description: "Brief description starting with action verb (10-80 chars)"
---

# Command Name

## Purpose
Explain when and why to use this command. Describe the problem it solves and the expected outcome.

## Context
What information or files does the agent need? What should be in place before running this command?

## Instructions

### Step 1: [First Phase]
1. [Specific action]
2. [Specific action]
3. [Specific action]

### Step 2: [Second Phase]
1. [Specific action]
2. [Specific action]
3. [Specific action]

## Output Format

Create a file `path/to/output.md` with the following structure:

```markdown
# Output Title

## Section 1
[Content description]

## Section 2
[Content description]
```

Requirements:
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

## Examples

### Example 1: [Simple Case]
**Input:** `/command simple-input`

**Output:** File `output/simple.md` containing:
- [Element 1]
- [Element 2]
- [Element 3]

### Example 2: [Complex Case]
**Input:** `/command complex-input --flag`

**Output:** File `output/complex.md` containing:
- [Element 1]
- [Element 2]
- [Element 3 with additional details]

## Arguments

- `arg1` (required, string): Description of first argument
- `arg2` (optional, string, default: "value"): Description of second argument
- `--flag` (optional, boolean): Description of flag

**Usage:**
```
/command arg1 arg2 --flag
```

Arguments: $ARGUMENTS

## Edge Cases

### Case 1: Empty or Missing Arguments
If no arguments provided, display usage help and example.

### Case 2: Invalid Input
If input doesn't match expected format, show error with specific guidance.

### Case 3: [Specific Edge Case]
Description of unusual situation and how to handle it.

## Error Handling

**Error: [Common Error 1]**
- Symptom: [How it appears]
- Solution: [How to fix]

**Error: [Common Error 2]**
- Symptom: [How it appears]
- Solution: [How to fix]

## Validation

Before considering complete, verify:
- [ ] [Checkpoint 1]
- [ ] [Checkpoint 2]
- [ ] [Checkpoint 3]
