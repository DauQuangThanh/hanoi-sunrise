# Argument Syntax Guide

Comprehensive guide to using correct argument syntax across different agentic platforms.

## Overview

Different agentic platforms use different syntax for passing user arguments to commands. Using the wrong syntax will cause commands to fail.

## Syntax Types

### 1. Markdown Syntax: `$ARGUMENTS`

**Used by**: Most platforms (19 out of 21)

**Format**: `$ARGUMENTS` (all caps, with dollar sign)

**Platforms**:

- Claude Code
- GitHub Copilot
- Cursor
- Windsurf
- Google Antigravity
- Amazon Q CLI
- Kilo Code, Roo Code, IBM Bob, Jules
- Amp, Auggie CLI, Qoder CLI, CodeBuddy CLI
- Codex CLI, SHAI, opencode

**Example**:

```markdown
---
description: "Analyze code for issues"
---

# Code Analysis

Analyze the following code for potential issues: $ARGUMENTS

## Instructions

1. Read the code at: $ARGUMENTS
2. Identify problems
3. Generate report
```

**Usage**:

```
/analyze-code src/auth/login.ts
```

**What the AI sees**:

```
Analyze the following code for potential issues: src/auth/login.ts

1. Read the code at: src/auth/login.ts
2. Identify problems
3. Generate report
```

### 2. TOML Syntax: `{{args}}`

**Used by**: TOML-based platforms (2 out of 21)

**Format**: `{{args}}` (lowercase, double curly braces)

**Platforms**:

- Gemini CLI
- Qwen Code

**Example**:

```toml
description = "Analyze code for issues"

prompt = """
# Code Analysis

Analyze the following code for potential issues: {{args}}

## Instructions

1. Read the code at: {{args}}
2. Identify problems
3. Generate report
"""
```

**Usage**:

```
gemini analyze-code src/auth/login.ts
```

**What the AI sees**:

```
Analyze the following code for potential issues: src/auth/login.ts

1. Read the code at: src/auth/login.ts
2. Identify problems
3. Generate report
```

### 3. Script Path: `{SCRIPT}`

**Used by**: Any platform (when referencing scripts)

**Format**: `{SCRIPT}` (single curly braces, uppercase)

**Purpose**: Gets replaced with actual script path

**Example**:

```markdown
---
description: "Initialize project structure"
---

# Project Initialization

Run the initialization script: {SCRIPT}/init-project.sh

Arguments: $ARGUMENTS
```

**Result**: `{SCRIPT}` becomes the actual path to the script directory.

### 4. Agent Name: `__AGENT__`

**Used by**: Any platform (when agent name is needed)

**Format**: `__AGENT__` (double underscores, uppercase)

**Purpose**: Gets replaced with the actual agent name

**Example**:

```markdown
---
description: "Display help information"
---

# Help

You are using __AGENT__ agent.

For assistance with: $ARGUMENTS
```

**Result**: `__AGENT__` becomes "Claude Code", "GitHub Copilot", etc.

## Decision Tree

```
Which syntax should I use?

Is the target platform Gemini CLI or Qwen Code?
  ├─ YES → Use {{args}}
  └─ NO  → Use $ARGUMENTS

Am I referencing a script file?
  ├─ YES → Use {SCRIPT} for script path
  └─ NO  → Continue

Do I need to show the agent name?
  ├─ YES → Use __AGENT__
  └─ NO  → Done
```

## Common Mistakes

### ❌ Mistake 1: Using TOML syntax in Markdown

```markdown
---
description: "Wrong syntax"
---

# Analyze Code

Target: {{args}}  ❌ WRONG - This won't work in Markdown-based platforms
```

**Fix**:

```markdown
---
description: "Correct syntax"
---

# Analyze Code

Target: $ARGUMENTS  ✅ CORRECT
```

### ❌ Mistake 2: Using Markdown syntax in TOML

```toml
description = "Wrong syntax"

prompt = """
Target: $ARGUMENTS  ❌ WRONG - This won't work in TOML-based platforms
"""
```

**Fix**:

```toml
description = "Correct syntax"

prompt = """
Target: {{args}}  ✅ CORRECT
"""
```

### ❌ Mistake 3: Using lowercase or wrong casing

```markdown
Target: $arguments  ❌ WRONG - lowercase
Target: ${ARGUMENTS}  ❌ WRONG - shell-style
```

**Fix**:

```markdown
Target: $ARGUMENTS  ✅ CORRECT
```

### ❌ Mistake 4: Using wrong braces for args

```toml
Target: {args}  ❌ WRONG - single braces
Target: ((args))  ❌ WRONG - wrong braces
```

**Fix**:

```toml
Target: {{args}}  ✅ CORRECT
```

## Best Practices

### 1. Always Validate Syntax

Before creating a command, check:

```yaml
✓ Is this Gemini CLI or Qwen Code?
  - YES → Use {{args}}
  - NO → Use $ARGUMENTS
✓ File format matches platform
✓ Syntax is consistent throughout
```

### 2. Document Expected Arguments

Always tell users what arguments are expected:

```markdown
## Usage

/command-name [argument-description]

## Arguments

- `argument-name`: Description of what this argument should be

## Examples

/command-name example-value
```

### 3. Provide Multiple Examples

Show various ways to use the command:

```markdown
## Examples

Basic usage:
/analyze-code src/utils/helper.ts

Multiple files:
/analyze-code src/utils/helper.ts src/services/api.ts

Directory:
/analyze-code src/auth/

With options:
/analyze-code src/ --include-tests
```

### 4. Handle Missing Arguments Gracefully

Include instructions for when arguments are missing:

```markdown
## Instructions

If no arguments provided:
- Analyze current file
- Or prompt user for target

If arguments provided:
- Process specified files/directories
- Show results
```

## Complete Examples

### Example 1: Markdown-Based Command (Claude Code)

```markdown
---
description: "Review code for best practices"
---

# Code Review

## Target

Files to review: $ARGUMENTS

## Process

1. Read files at: $ARGUMENTS
2. Check against best practices
3. Generate review comments

## Usage

/review src/components/Button.tsx
```

### Example 2: TOML-Based Command (Gemini CLI)

```toml
description = "Review code for best practices"

prompt = """
# Code Review

## Target

Files to review: {{args}}

## Process

1. Read files at: {{args}}
2. Check against best practices
3. Generate review comments

## Usage

gemini review src/components/Button.tsx
"""
```

### Example 3: Using Multiple Placeholder Types

```markdown
---
description: "Initialize project with custom script"
---

# Project Initialization

You are using the __AGENT__ agent.

## Process

1. Run: {SCRIPT}/init-project.sh
2. Configure for: $ARGUMENTS
3. Validate setup

## Output

Project initialized with __AGENT__ using configuration: $ARGUMENTS
```

### Example 4: No Arguments Required

```markdown
---
description: "Show project status"
---

# Project Status

## Instructions

Display current project status:
- Git branch and commit
- Open files count
- Recent changes
- Build status

Note: This command does not require arguments.
```

## Validation Checklist

Before finalizing a command:

```yaml
Syntax Validation:
  ✓ Correct argument syntax for target platform
  ✓ Consistent usage throughout command
  ✓ No mixing of syntax types
  ✓ Proper casing (uppercase/lowercase)
  ✓ Correct braces/delimiters

Documentation:
  ✓ Usage section present
  ✓ Arguments explained
  ✓ Examples provided
  ✓ Edge cases documented

Testing:
  ✓ Test with arguments
  ✓ Test without arguments
  ✓ Test with multiple arguments
  ✓ Test with special characters
```

## Quick Reference Table

| Platform | Syntax | Example Usage | What AI Receives |
|----------|--------|---------------|------------------|
| Claude Code | `$ARGUMENTS` | `/analyze src/` | `src/` |
| GitHub Copilot | `$ARGUMENTS` | `/vinh.review file.ts` | `file.ts` |
| Cursor | `$ARGUMENTS` | `/validate code/` | `code/` |
| Windsurf | `$ARGUMENTS` | `/implement spec.md` | `spec.md` |
| Gemini CLI | `{{args}}` | `gemini analyze src/` | `src/` |
| Qwen Code | `{{args}}` | `qwen review file.ts` | `file.ts` |
| Script Path | `{SCRIPT}` | (auto-replaced) | `/path/to/scripts/` |
| Agent Name | `__AGENT__` | (auto-replaced) | `Claude Code` |

## Additional Resources

For more information, see the other reference files in this skill:

- `platform-matrix.md` - Platform support overview with complete folder mappings
- `best-practices.md` - Comprehensive best practices for agent command creation
- `../templates/` - Ready-to-use command templates for different scenarios
