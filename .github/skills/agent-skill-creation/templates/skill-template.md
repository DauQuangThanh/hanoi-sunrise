---
name: skill-name
description: "[ACTION 1], [ACTION 2], and [ACTION 3]. Use when [SCENARIO 1], [SCENARIO 2], or when user mentions [KEYWORD 1], [KEYWORD 2], or [KEYWORD 3]."
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "YYYY-MM-DD"
---

# Skill Name

## When to Use

- [Scenario 1: When to activate this skill]
- [Scenario 2: Another use case]
- [Scenario 3: Additional context]

## Prerequisites

- [Required tool or package 1]
- [Required tool or package 2]
- [Environment requirement if any]

## Instructions

### Step 1: [First Action]

[Provide clear, step-by-step instructions for the first action]

- Detail 1
- Detail 2
- Detail 3

### Step 2: [Second Action]

[Continue with sequential steps]

```bash
# Example command if applicable
command --option value
```

### Step 3: [Third Action]

[Final steps to complete the task]

## Examples

### Example 1: [Use Case Name]

**Input:**

```
[Show example input]
```

**Expected Output:**

```
[Show expected result]
```

**Explanation:**
[Brief explanation of what happened]

### Example 2: [Another Use Case]

**Input:**

```
[Another example]
```

**Expected Output:**

```
[Another result]
```

## Edge Cases

### Case 1: [Unusual Situation]

**Description**: [Explain the edge case]

**Handling**: [How to handle this situation]

### Case 2: [Error Condition]

**Description**: [Explain the error condition]

**Handling**: [Steps to resolve]

## Error Handling

### Error: [Error Type 1]

**Symptoms**: [How to identify this error]

**Cause**: [Why this error occurs]

**Resolution**:

1. [Step to resolve]
2. [Another step]

### Error: [Error Type 2]

**Symptoms**: [Error indicators]

**Resolution**: [How to fix]

## Scripts

If your skill includes executable scripts, document them here:

### Cross-Platform Script (Recommended)

```bash
# Python script works on all platforms
python3 scripts/script-name.py --input file.txt --output result.txt
```

**Requirements:**

- Python 3.8+
- [Package name]: `pip install package-name`

### Platform-Specific Scripts

**macOS/Linux (Bash):**

```bash
chmod +x scripts/script-name.sh
./scripts/script-name.sh --input file.txt
```

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy Bypass -File scripts/script-name.ps1 -Input file.txt
```

## Guidelines

1. [Guideline 1: Important rule to follow]
2. [Guideline 2: Best practice]
3. [Guideline 3: Convention to maintain]

## Validation

To validate this skill:

```bash
# If validation script available
python3 scripts/validate-skill.py .
```

**Manual Checks:**

- [ ] All instructions are clear and actionable
- [ ] Examples cover common use cases
- [ ] Edge cases documented
- [ ] Scripts tested on target platforms

## Additional Resources

- See [references/detailed-guide.md](references/detailed-guide.md) for in-depth information
- See [references/api-reference.md](references/api-reference.md) for technical details
- See [templates/output-template.md](templates/output-template.md) for output format

---

**Notes:**

- Replace all [PLACEHOLDER] text with actual content
- Remove sections not applicable to your skill
- Keep SKILL.md under 500 lines
- Move extensive details to references/
- Test thoroughly before deploying
