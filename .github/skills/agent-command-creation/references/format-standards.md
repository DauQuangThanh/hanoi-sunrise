# Format Standards

Complete specifications for Markdown and TOML command formats.

## Markdown Format Specification

### File Extension

- Standard: `.md`
- GitHub Copilot: `.prompt.md` or `.agent.md`
- Cursor: `.md` or `.mdc`

### YAML Frontmatter Structure

```yaml
---
description: "Required: clear description (10-80 chars)"
mode: "Optional: for GitHub Copilot (project.command-name)"
glob: "Optional: for Cursor file patterns (**/*.ext)"
category: "Optional: for Google Antigravity (rules/skills)"
deprecated: false  # Optional: mark as deprecated
replacement: "/new-command"  # Optional: suggest replacement
---
```

### Required Frontmatter Fields

**description:**

- Type: String
- Length: 10-80 characters (recommended)
- Maximum: 1024 characters
- Must start with action verb
- Must be specific and actionable
- Single line only

### Optional Frontmatter Fields

**mode (GitHub Copilot only):**

- Format: `project-name.command-name`
- Both parts lowercase
- Use hyphens for multi-word
- Example: `vinh.specify`, `myapp.analyze-code`

**glob (Cursor only):**

- Glob pattern for file matching
- Examples: `**/*.ts`, `src/**/*.py`, `*.md`

**category (Google Antigravity only):**

- Values: `rules` or `skills`
- Rules = constraints/guidelines
- Skills = capabilities/actions

### Body Structure

```markdown
# Command Name (H1 - Required)

## Purpose (H2 - Recommended)
[Brief explanation of command's purpose]

## Context (H2 - Optional)
[What context/information is needed]

## Instructions (H2 - Required)
[Step-by-step instructions]

## Output Format (H2 - Required)
[Exact specification of expected output]

## Examples (H2 - Recommended)
[Concrete examples with input/output]

## Arguments (H2 - If applicable)
[Document expected arguments]

Arguments: $ARGUMENTS
```

### Markdown Best Practices

1. **One H1 heading** matching command name
2. **Use H2** for major sections
3. **Use H3** for subsections or phases
4. **Code blocks** for examples and formats
5. **Bullet lists** for requirements
6. **Numbered lists** for sequential steps
7. **Bold** for emphasis on key terms
8. **Inline code** for file paths, commands, variables

### Argument Syntax

**Standard Markdown commands:**

```markdown
Arguments: $ARGUMENTS
```

**Usage in instructions:**

```markdown
1. Analyze the requirements: $ARGUMENTS
2. Create specification based on $ARGUMENTS
```

### Example Markdown Command

```markdown
---
description: "Generate API documentation from code comments"
---

# API Documentation Generator

## Purpose
Automatically generate comprehensive API documentation from inline code comments and type definitions.

## Context
This command scans source files for specially formatted comments and generates structured documentation.

## Instructions

### Phase 1: Scan Codebase
1. Locate all source files in the specified directory
2. Extract function/method signatures
3. Parse JSDoc/docstring comments
4. Identify types and interfaces

### Phase 2: Generate Documentation
1. Create `docs/api/` directory if not exists
2. Generate one markdown file per module
3. Include function signatures, parameters, return types
4. Add usage examples from code comments

## Output Format

Create files in `docs/api/` with structure:

```markdown
# Module Name

## Functions

### functionName(param1, param2)

**Description:** [From docstring]

**Parameters:**
- `param1` (type): Description
- `param2` (type): Description

**Returns:** (type) Description

**Example:**
```language
// Code example
```

```

## Examples

### Example 1: JavaScript Module
**Input:** `/api-docs src/utils.js`

**Output:** `docs/api/utils.md` with documented functions

### Example 2: Python Package
**Input:** `/api-docs src/api --format=sphinx`

**Output:** Sphinx-compatible documentation files

## Arguments
$ARGUMENTS - Path to source directory or file, optional flags

Flags:
- `--format=markdown|sphinx|html` - Output format
- `--private` - Include private functions
```

## TOML Format Specification

### File Extension

- Always: `.toml`

### Structure

```toml
# Required field
description = "Clear description (10-80 chars)"

# Required field
prompt = """
# Command Name

## Purpose
[Brief explanation]

## Instructions
[Step-by-step instructions]

## Output Format
[Expected output structure]

Arguments: {{args}}
"""

# Optional metadata
[metadata]
author = "Your Name"
version = "1.0"
```

### Required Fields

**description:**

- Type: String
- Single line only
- Length: 10-80 characters (recommended)
- Must be quoted
- Example: `description = "Analyze code quality"`

**prompt:**

- Type: Multi-line string
- Use triple quotes: `"""`
- Contains full command instructions
- Format as Markdown within the string
- Must include argument placeholder

### Argument Syntax

**TOML commands:**

```toml
prompt = """
Arguments: {{args}}
"""
```

**Usage in instructions:**

```toml
prompt = """
1. Analyze the file: {{args}}
2. Process results from {{args}}
"""
```

### TOML Best Practices

1. **Use triple quotes** for prompt field
2. **Maintain Markdown structure** within prompt
3. **Escape quotes** if needed in prompt text
4. **Keep description** on single line
5. **Use [metadata]** section for optional fields
6. **No YAML frontmatter** - TOML has its own structure

### Example TOML Command

```toml
description = "Analyze security vulnerabilities in codebase"

prompt = """
# Security Analysis

## Purpose
Perform comprehensive security audit of the codebase.

## Instructions

### Phase 1: Static Analysis
1. Scan files in {{args}} for common vulnerabilities
2. Check for SQL injection points
3. Identify XSS vulnerabilities
4. Find authentication/authorization issues

### Phase 2: Dependency Check
1. Analyze package dependencies
2. Check for known CVEs
3. Identify outdated packages

### Phase 3: Report Generation
1. Create report in `reports/security-analysis.md`
2. Rank issues by severity (Critical, High, Medium, Low)
3. Provide remediation recommendations

## Output Format

Create `reports/security-analysis.md`:

```markdown
# Security Analysis Report

## Summary
- Total issues: [count]
- Critical: [count]
- High: [count]

## Findings

### [Severity]: [Issue Title]
**Location:** file:line
**Description:** [Details]
**Recommendation:** [Fix]
```

## Examples

### Example 1: Full Codebase Scan

Input: `analyze ./src`
Output: Comprehensive security report

### Example 2: Targeted Analysis

Input: `analyze ./src/auth --focus=authentication`
Output: Authentication-specific findings

## Arguments

{{args}} - Directory or file path to analyze

Optional flags:

- --focus=area - Focus on specific security area
- --detailed - Include detailed explanation
"""

[metadata]
author = "Security Team"
version = "1.0"
category = "security"

```

## Format Selection Decision Tree

```

Is target agent Gemini CLI or Qwen Code?
├─ YES → Use TOML format (.toml)
│         • Use {{args}} for arguments
│         • Single description line
│         • prompt field with triple quotes
│
└─ NO  → Use Markdown format (.md)
          • Use $ARGUMENTS for arguments
          • YAML frontmatter with ---
          • Standard Markdown body
          │
          ├─ Is it GitHub Copilot?
          │  └─ YES → Add mode: field
          │
          ├─ Is it Cursor?
          │  └─ YES → Add glob: if file-specific
          │
          └─ Is it Google Antigravity?
             └─ YES → Add category: field

```

## Validation Rules

### Markdown Validation

**Frontmatter:**
- [ ] Starts and ends with `---`
- [ ] Contains `description:` field
- [ ] Description is quoted string
- [ ] All fields use correct YAML syntax
- [ ] No tabs (use spaces for indentation)

**Body:**
- [ ] Has one H1 heading
- [ ] Has at least H2 sections for Purpose and Instructions
- [ ] Contains `$ARGUMENTS` if command accepts arguments
- [ ] Code blocks are properly fenced
- [ ] Examples show input and output

### TOML Validation

**Structure:**
- [ ] Contains `description =` field
- [ ] Description is quoted string on single line
- [ ] Contains `prompt =` field
- [ ] Prompt uses triple quotes `"""`
- [ ] Prompt contains Markdown formatting
- [ ] Contains `{{args}}` if command accepts arguments
- [ ] Valid TOML syntax (no syntax errors)

## Common Formatting Errors

**Markdown errors:**
```markdown
❌ Missing closing frontmatter delimiter
---
description: "Test"

# Command
```

```markdown
✅ Correct frontmatter
---
description: "Test"
---

# Command
```

**TOML errors:**

```toml
❌ Single quotes in prompt (use double quotes)
prompt = '''
Content here
'''
```

```toml
✅ Correct quotes
prompt = """
Content here
"""
```

**Argument errors:**

```markdown
❌ Wrong syntax for Markdown
Arguments: {{args}}
```

```markdown
✅ Correct syntax for Markdown
Arguments: $ARGUMENTS
```

## Cross-Platform Compatibility

### File Paths in Commands

**Always use forward slashes:**

```markdown
✅ Create file `docs/api/module.md`
❌ Create file `docs\api\module.md`
```

**Use relative paths from project root:**

```markdown
✅ `./src/utils.py`
✅ `specs/feature.md`
❌ `/absolute/path/to/file`
❌ `C:\Windows\Path\file.txt`
```

### Line Endings

- Use LF (`\n`) for line endings
- Configure git: `git config core.autocrlf input`
- Most editors auto-detect and convert
