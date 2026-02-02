# Validation Rules

Comprehensive validation criteria for agent commands.

## Content Quality Validation

### Description Field

**Requirements:**
- [ ] Present in frontmatter
- [ ] 10-80 characters (recommended)
- [ ] Maximum 1024 characters
- [ ] Starts with action verb
- [ ] Specific and actionable
- [ ] Single line only
- [ ] No redundant words

**Action Verbs (Use these):**
- Create, Generate, Build, Design
- Analyze, Review, Inspect, Audit
- Refactor, Optimize, Improve
- Validate, Verify, Test, Check
- Document, Explain, Describe

**Examples:**
```yaml
✅ "Create feature specification from user requirements"
✅ "Analyze codebase for security vulnerabilities"
✅ "Generate API documentation from code comments"
❌ "This command helps with stuff" (vague, not verb-first)
❌ "A helper that does things" (not verb-first, vague)
```

### Instructions Section

**Requirements:**
- [ ] Present in command body
- [ ] Uses numbered or bulleted lists
- [ ] Each step is actionable
- [ ] Steps are in logical order
- [ ] No ambiguous language
- [ ] Specific file paths when applicable
- [ ] Clear success criteria

**Pattern:**
```markdown
## Instructions

1. [First clear action]
2. [Second clear action]
3. [Third clear action]
```

### Output Format Section

**Requirements:**
- [ ] Explicitly specified
- [ ] Exact file path provided
- [ ] File format stated
- [ ] Structure/schema shown
- [ ] Example provided
- [ ] All required fields listed

**Pattern:**
```markdown
## Output Format

Create file `path/to/output.md` with:

```markdown
# Required Structure

## Section 1
[Content]

## Section 2
[Content]
```

Include: [list of required elements]
```

### Examples Section

**Requirements:**
- [ ] At least 2 examples provided
- [ ] Each example has input
- [ ] Each example has expected output
- [ ] Examples cover different scenarios
- [ ] Examples are realistic
- [ ] Edge cases included

**Pattern:**
```markdown
## Examples

### Example 1: [Scenario]
**Input:** `/command [input]`

**Output:** [description of expected output]

### Example 2: [Different Scenario]
**Input:** `/command [different input]`

**Output:** [description of expected output]
```

### Arguments Documentation

**Requirements:**
- [ ] All arguments documented
- [ ] Required vs optional marked
- [ ] Types specified
- [ ] Default values noted
- [ ] Usage examples provided
- [ ] Correct syntax for format

**Pattern:**
```markdown
## Arguments

- `arg1` (required, string): Description
- `arg2` (optional, boolean, default: false): Description
- `--flag` (optional): Description

## Usage
/command arg1 arg2 --flag
```

## Technical Quality Validation

### File Naming

**Requirements:**
- [ ] Lowercase only
- [ ] Hyphens for word separation
- [ ] No underscores
- [ ] No spaces
- [ ] Descriptive name
- [ ] Not too long (<50 chars)
- [ ] Correct extension (.md or .toml)

**Examples:**
```
✅ specify.md
✅ analyze-coverage.md
✅ implement-feature.md
❌ Specify.md (uppercase)
❌ analyze_coverage.md (underscore)
❌ analyze coverage.md (space)
❌ do-stuff.md (vague)
```

### Frontmatter/YAML Validation

**Requirements:**
- [ ] Valid YAML syntax
- [ ] Starts with `---`
- [ ] Ends with `---`
- [ ] Proper indentation (2 spaces)
- [ ] All strings quoted
- [ ] No tabs (use spaces)
- [ ] Required fields present

**Valid example:**
```yaml
---
description: "Create feature specification"
mode: "project.command"
---
```

**Invalid examples:**
```yaml
❌ Missing closing delimiter
---
description: "Test"

❌ Unquoted description
---
description: Test description
---

❌ Wrong field name
---
desc: "Test"
---
```

### TOML Validation

**Requirements:**
- [ ] Valid TOML syntax
- [ ] description field present
- [ ] description is quoted string
- [ ] prompt field present
- [ ] prompt uses triple quotes `"""`
- [ ] No syntax errors

**Valid example:**
```toml
description = "Create feature specification"

prompt = """
# Command

Instructions here
"""
```

**Invalid examples:**
```toml
❌ Single quotes for prompt
description = "Test"
prompt = '''Content'''

❌ Missing quotes on description
description = Test
prompt = """Content"""
```

### Argument Syntax Validation

**Markdown commands:**
- [ ] Uses `$ARGUMENTS` (not `{{args}}`)
- [ ] Placed appropriately in instructions
- [ ] Documented in Arguments section

**TOML commands:**
- [ ] Uses `{{args}}` (not `$ARGUMENTS`)
- [ ] Placed in prompt string
- [ ] Documented in prompt

**Examples:**
```markdown
✅ Markdown: Arguments: $ARGUMENTS
❌ Markdown: Arguments: {{args}}

✅ TOML: Arguments: {{args}}
❌ TOML: Arguments: $ARGUMENTS
```

## Agent-Specific Validation

### GitHub Copilot

**Requirements:**
- [ ] mode field present in frontmatter
- [ ] mode format: `project.command-name`
- [ ] Both parts lowercase
- [ ] Hyphens for multi-word parts
- [ ] File extension: `.prompt.md` or `.agent.md`
- [ ] In `.github/prompts/` or `.github/agents/`

**Valid:**
```yaml
---
description: "Command description"
mode: vinh.specify
---
```

**Invalid:**
```yaml
---
description: "Command description"
mode: Vinh.Specify  # uppercase
---
```

### Cursor

**Requirements (if using glob):**
- [ ] glob field format valid
- [ ] Pattern matches intended files
- [ ] Uses double asterisks for recursive: `**`
- [ ] File extension included: `*.ext`

**Valid:**
```yaml
---
description: "TypeScript rules"
glob: "**/*.ts"
---
```

### Gemini CLI / Qwen Code

**Requirements:**
- [ ] File extension is `.toml`
- [ ] Uses TOML format (not Markdown)
- [ ] Uses `{{args}}` for arguments
- [ ] In `.gemini/commands/` or `.qwen/commands/`

## Cross-Platform Validation

### Path Handling

**Requirements:**
- [ ] Uses forward slashes `/`
- [ ] No backslashes `\`
- [ ] No absolute paths
- [ ] Uses relative paths from project root
- [ ] No platform-specific paths

**Examples:**
```markdown
✅ `docs/api/module.md`
✅ `./src/utils.py`
❌ `docs\api\module.md` (backslash)
❌ `/absolute/path/file` (absolute)
❌ `C:\Windows\file` (Windows-specific)
```

### Script References

**If command includes scripts:**
- [ ] Scripts are Python 3.8+ (recommended)
- [ ] OR both .sh and .ps1 provided
- [ ] Scripts tested on all platforms
- [ ] Platform requirements documented
- [ ] Uses pathlib for paths (Python)
- [ ] Proper error handling

## Structural Validation

### Markdown Structure

**Requirements:**
- [ ] One H1 heading
- [ ] H1 matches command name
- [ ] Uses H2 for major sections
- [ ] Uses H3 for subsections
- [ ] Logical heading hierarchy
- [ ] No skipped levels (H1 → H3)

**Example:**
```markdown
# Command Name (H1)

## Purpose (H2)

## Instructions (H2)

### Phase 1 (H3)

### Phase 2 (H3)

## Output Format (H2)
```

### Required Sections

**Minimum required:**
- [ ] Command title (H1)
- [ ] Purpose or Context section
- [ ] Instructions section
- [ ] Output Format section

**Recommended:**
- [ ] Examples section
- [ ] Arguments section (if applicable)
- [ ] Edge Cases section
- [ ] Error Handling section

## Completeness Validation

### Essential Elements Checklist

- [ ] Clear description in frontmatter
- [ ] Proper file naming
- [ ] Correct format for target agent
- [ ] Valid frontmatter syntax
- [ ] Numbered/bulleted instructions
- [ ] Explicit output format
- [ ] At least 2 examples
- [ ] Argument documentation
- [ ] Correct argument syntax
- [ ] Agent-specific requirements met
- [ ] Cross-platform compatible paths
- [ ] No spelling/grammar errors
- [ ] No broken formatting
- [ ] Logical flow
- [ ] Actionable steps

### Quality Indicators

**High quality command has:**
- Clear, specific description
- Step-by-step numbered instructions
- Multiple concrete examples
- Explicit output format with schema
- Edge case handling
- Error guidance
- Context integration instructions
- Validation checkpoints

**Low quality command has:**
- Vague description
- Ambiguous instructions
- No examples
- Unclear output format
- No error handling
- Missing edge cases

## Automated Validation

### Using Validation Script

```bash
python3 scripts/validate-command.py path/to/command.md
```

**Script checks:**
- File naming conventions
- Frontmatter validity
- Required sections present
- Argument syntax correctness
- Format compliance
- Cross-platform paths

### CI/CD Integration

```yaml
# .github/workflows/validate-commands.yml
name: Validate Commands

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.8'
      - name: Validate commands
        run: |
          python3 scripts/validate-all-commands.py
```

## Manual Review Checklist

Print this checklist and check each item:

### Basic Structure
- [ ] Correct file location for target agent
- [ ] Correct file extension (.md or .toml)
- [ ] Valid frontmatter/TOML syntax
- [ ] All required fields present

### Content Quality
- [ ] Description is clear and specific
- [ ] Instructions are numbered and actionable
- [ ] Output format explicitly specified
- [ ] At least 2 examples provided
- [ ] Arguments documented (if applicable)

### Technical Correctness
- [ ] Correct argument syntax for format
- [ ] Cross-platform compatible paths
- [ ] Agent-specific requirements met
- [ ] No platform-specific commands

### Completeness
- [ ] All sections present and complete
- [ ] Examples are realistic and helpful
- [ ] Edge cases addressed
- [ ] Error handling guidance provided

### Polish
- [ ] No spelling or grammar errors
- [ ] Consistent formatting
- [ ] Clear, professional language
- [ ] Proper Markdown rendering

## Common Validation Errors

### Error: Invalid YAML

**Symptom:** Parser error when reading frontmatter

**Common causes:**
- Missing closing `---`
- Unquoted strings with special characters
- Tabs instead of spaces
- Wrong indentation

**Solution:**
```yaml
✅ Correct
---
description: "Test: with colon"
---

❌ Wrong
---
description: Test: with colon
---
```

### Error: Wrong Argument Syntax

**Symptom:** Arguments not recognized

**Common causes:**
- Using `{{args}}` in Markdown
- Using `$ARGUMENTS` in TOML
- Missing Arguments declaration

**Solution:**
- Markdown → `$ARGUMENTS`
- TOML → `{{args}}`

### Error: Missing Required Sections

**Symptom:** Command works but incomplete

**Common causes:**
- No output format specified
- No examples provided
- Missing instructions section

**Solution:** Add all required sections per this guide

### Error: Platform-Specific Paths

**Symptom:** Command fails on some platforms

**Common causes:**
- Using backslashes `\`
- Using absolute paths
- Platform-specific commands

**Solution:** Use forward slashes and relative paths

## Validation Best Practices

1. **Validate early** - Check as you write
2. **Use automated tools** - Run validation script
3. **Test with examples** - Verify examples work
4. **Peer review** - Have someone else review
5. **Test on platforms** - Check Windows, macOS, Linux
6. **Update regularly** - Re-validate when rules change
