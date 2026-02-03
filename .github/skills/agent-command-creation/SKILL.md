---
name: agent-command-creation
description: Generates and updates agent command files following the Agent Command Creation Rules. Creates Markdown or TOML command files, validates structure, ensures cross-platform compatibility, and follows agent-specific guidelines. Use when creating new commands, updating existing commands, or when user mentions agent commands.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "2.1.0"
  last_updated: "2026-02-03"
---

# Agent Command Creation

## Overview

This self-contained skill helps AI agents create and update agent commands that conform to platform-specific guidelines. It provides complete resources: instructions, templates, validation rules, and scripts—all within this skill directory. Commands can be created in Markdown (.md) or TOML (.toml) format depending on the target agent.

**Key Concept: Progressive Disclosure**

- **Tier 1**: Metadata (name + description) for discovery
- **Tier 2**: This SKILL.md with instructions (<500 lines)
- **Tier 3**: references/, templates/, scripts/, assets/ for detailed content

## When to Use

- Creating new agent commands from scratch
- Converting existing commands to standardized format
- Updating or refactoring existing commands
- Validating command structure and compatibility
- When user requests "create command", "generate agent command", or mentions specific agents
- Setting up commands for Claude Code, GitHub Copilot, Cursor, Windsurf, Gemini CLI, etc.

## What This Skill Does

1. **Generates command files** in Markdown or TOML format
2. **Validates structure** against agent-specific requirements
3. **Ensures cross-platform compatibility** for scripts (Python 3.8+)
4. **Provides agent-specific templates** for 17+ supported agents
5. **Creates clear, actionable instructions** with examples
6. **100% self-contained** - no external dependencies

## Prerequisites

- Knowledge of target agent platform (Claude, Copilot, Cursor, etc.)
- Understanding of command's purpose and workflow
- Python 3.8+ for running validation scripts (optional)

## Core Instructions

### Quick Start: 5-Step Process

**Step 1: Choose Target Agent & Format**

- Identify target agent (see Agent Directory Reference below)
- Determine file format: Markdown (.md) or TOML (.toml)
- Note the correct directory path

**Step 2: Write Clear Description**

- One sentence, 10-80 characters
- Start with action verb
- Include expected outcome
- Example: "Create feature specification from user requirements"

**Step 3: Generate Command Structure**

```bash
python3 scripts/generate-command.py command-name --agent claude
```

**Step 4: Write Instructions**

- Use clear, step-by-step format
- Include examples with input/output
- Specify output format explicitly
- Handle edge cases

**Step 5: Validate**

```bash
python3 scripts/validate-command.py ./path/to/command.md
```

---

### Step 1: Select Format Based on Agent

**Decision Rule:**

- **TOML (.toml)**: Gemini CLI, Qwen Code
- **Markdown (.md)**: All other agents (Claude, Copilot, Cursor, Windsurf, etc.)

**Quick reference:**

| Agent Type | Directory | Format | Arguments |
|------------|-----------|--------|-----------|
| Claude Code | `.claude/commands/` | `.md` | `$ARGUMENTS` |
| GitHub Copilot | `.github/prompts/` | `.prompt.md` | `$ARGUMENTS` |
| Cursor | `.cursor/commands/` | `.md` | `$ARGUMENTS` |
| Windsurf | `.windsurf/workflows/` | `.md` | `$ARGUMENTS` |
| Gemini CLI | `.gemini/commands/` | `.toml` | `{{args}}` |
| Qwen Code | `.qwen/commands/` | `.toml` | `{{args}}` |

See `references/agent-directory-reference.md` for complete list of 17+ agents.

### Step 2: Name Your Command

**Naming rules (CRITICAL):**

✅ **Valid**: lowercase, hyphens, descriptive verbs  
❌ **Invalid**: uppercase, underscores, spaces, vague names  
📏 **Length**: Keep concise but meaningful

**Examples:**

- ✅ `specify.md`, `implement.md`, `analyze-coverage.md`
- ❌ `do-stuff.md` (vague), `Specify.md` (uppercase), `specify_.md` (underscore)

**For GitHub Copilot mode field:**

- Format: `project.command-name`
- Example: `vinh.specify`, `myapp.analyze`

### Step 3: Write Description

**Formula:** `[Action] + [from/with what] + [producing what]`

**Requirements:**

- Length: 10-80 characters
- Start with action verb
- Be specific and actionable
- Include expected outcome

**Examples:**

```yaml
✅ "Create feature specification from user requirements"
✅ "Analyze codebase for security vulnerabilities and generate report"
✅ "Break down implementation plan into actionable tasks"
❌ "This command does some analysis stuff" (too vague)
❌ "Helper function" (not descriptive)
```

### Step 4: Choose Command Structure

**Markdown Format (Most Agents):**

```markdown
---
description: "Clear, concise description"
---

# Command Name

## Purpose
[Explain when and why to use this command]

## Instructions
[Step-by-step instructions with numbered list]

## Output Format
[Specify exact structure expected]

## Examples
[Provide concrete input/output examples]

Arguments: $ARGUMENTS
```

**TOML Format (Gemini CLI, Qwen Code):**

```toml
description = "Clear, concise description"

prompt = """
# Command Name

## Purpose
[Explain when and why to use this command]

## Instructions
[Step-by-step instructions]

## Output Format
[Specify exact structure]

Arguments: {{args}}
"""
```

See `templates/` for complete templates.

### Step 5: Write Clear Instructions

**Use this structure:**

1. **Purpose Section**: When to use this command
2. **Context Section** (optional): What information is needed
3. **Instructions Section**: Step-by-step process
4. **Output Format Section**: Exact specification of output
5. **Examples Section**: At least 2 concrete examples

**Best practices:**

- Number each step explicitly
- Use imperative language ("Create", "Analyze", "Generate")
- Break complex tasks into phases
- Include validation checkpoints
- Provide specific file paths and formats

**Example instruction pattern:**

```markdown
## Instructions

### Phase 1: Analysis
1. Read the specification in `specs/FEATURE.md`
2. Identify key requirements and constraints
3. List dependencies and integration points

### Phase 2: Implementation
1. Create implementation plan in `plans/FEATURE-plan.md`
2. Break down into components
3. Identify risks and mitigation strategies

## Output Format
Create file `plans/FEATURE-plan.md` with:
- Architecture overview
- Component breakdown
- Testing strategy
```

### Step 6: Handle Arguments Correctly

**Markdown:** Use `$ARGUMENTS`  
**TOML:** Use `{{args}}`

Document expected arguments with types and examples. See templates/ for complete patterns.

### Step 7: Specify Output Format

Always be explicit about output. Include file path, format, required structure, and examples. See templates/ for complete patterns.

### Step 8: Add Examples

**Provide at least 2 complete examples:**

```markdown
## Examples

### Example 1: Simple Feature
**Input:** `/specify Create a login page`

**Output:** File `specs/login-page.md` containing:
- User stories for authentication
- UI wireframe description
- API requirements
- Security considerations

### Example 2: Complex Feature
**Input:** `/specify Build a real-time chat system with WebSockets`

**Output:** File `specs/chat-system.md` containing:
- Architecture diagram description
- Message protocol specification
- Scalability considerations
- Database schema
```

### Step 9: Validate Command

**Manual checklist:**

- [ ] Name follows conventions (lowercase, hyphens)
- [ ] Description is clear and actionable (10-80 chars)
- [ ] Correct file format for target agent
- [ ] Valid frontmatter/YAML
- [ ] Instructions are numbered and clear
- [ ] Output format is explicitly specified
- [ ] At least 2 examples provided
- [ ] Arguments are documented
- [ ] Correct argument syntax ($ARGUMENTS or {{args}})

**Automated validation:**

```bash
python3 scripts/validate-command.py path/to/command.md
```

## Agent Directory Reference

**Quick lookup for agent-specific details:**

| Agent | Directory | Format | Mode/Category |
|-------|-----------|--------|---------------|
| Claude Code | `.claude/commands/` | `.md` | N/A |
| GitHub Copilot | `.github/prompts/` | `.prompt.md` | `mode: project.name` |
| Cursor | `.cursor/commands/` | `.md` | `glob:` (optional) |
| Windsurf | `.windsurf/workflows/` | `.md` | N/A |
| Gemini CLI | `.gemini/commands/` | `.toml` | N/A |
| Amazon Q CLI | `.amazonq/prompts/` | `.md` | N/A |
| Google Antigravity | `.agent/rules/` or `.agent/skills/` | `.md` | `category:` |

See `references/agent-directory-reference.md` for complete list.

## Examples

### Example 1: Creating a Specification Command

**Scenario:** Create a command that generates feature specifications.

**Step-by-step:**

1. Choose target agent: Claude Code
2. Select format: Markdown (.md)
3. Name: `specify.md`
4. Location: `.claude/commands/specify.md`

**Content:**

```markdown
---
description: "Create detailed feature specification from requirements"
---

# Feature Specification

## Purpose
Generate a comprehensive specification document for a new feature based on user requirements.

## Instructions

1. Gather user requirements from $ARGUMENTS
2. Research existing codebase patterns
3. Identify dependencies and integration points
4. Create specification in `specs/FEATURE.md`

## Output Format

Create `specs/[feature-name].md` with:
- Feature overview
- User stories
- Technical requirements
- API specifications
- Testing criteria

## Examples

**Input:** `/specify User authentication with OAuth`

**Output:** `specs/user-auth.md` with OAuth flow, security requirements, and API endpoints
```

### Example 2: Creating a TOML Command

**Scenario:** Create an analysis command for Gemini CLI.

**Content for `.gemini/commands/analyze.toml`:**

```toml
description = "Analyze code quality and identify improvements"

prompt = """
# Code Analysis

## Purpose
Perform comprehensive code quality analysis.

## Instructions

1. Scan codebase: {{args}}
2. Check for code smells, security issues, performance bottlenecks
3. Generate report with severity levels

## Output Format

Create `reports/analysis.md` with:
- Summary of findings
- Issues by severity (Critical, High, Medium, Low)
- Remediation recommendations

## Examples
analyze ./src --detailed
analyze ./api --security-focus
"""
```

## Edge Cases

**Empty or missing arguments:**

- Document required vs optional arguments
- Provide helpful error message
- Show usage example

**Complex multi-step workflows:**

- Break into clear phases
- Include validation checkpoints
- Allow resuming from specific phase

**Platform-specific behavior:**

- Document any OS-specific requirements
- Ensure scripts use cross-platform paths
- Test on Windows, macOS, Linux

## Error Handling

**Common errors and solutions:**

**Error: Invalid frontmatter**

- Solution: Ensure YAML starts/ends with `---`
- Check for proper indentation
- Validate field names (e.g., `description`, not `desc`)

**Error: Wrong argument syntax**

- Solution: Use `$ARGUMENTS` for Markdown, `{{args}}` for TOML
- Check target agent requirements

**Error: Command not recognized**

- Solution: Verify file is in correct directory for target agent
- Check file extension (.md vs .toml)
- For GitHub Copilot, ensure `mode:` field is set

**Error: Unclear instructions**

- Solution: Add more specific steps
- Include concrete examples
- Specify exact file paths and formats

## Scripts

**Generate new command:**

```bash
python3 scripts/generate-command.py command-name --agent claude
```

**Validate existing command:**

```bash
python3 scripts/validate-command.py .claude/commands/specify.md
```

**Test command across platforms:**

```bash
python3 scripts/test-command.py specify.md
```

## References

For detailed information, see:

- `references/format-standards.md` - Complete format specifications
- `references/prompt-engineering.md` - Advanced instruction patterns
- `references/agent-directory-reference.md` - All supported agents
- `references/validation-rules.md` - Validation criteria
- `templates/` - Ready-to-use command templates

## Validation Checklist

Use `assets/checklists/command-validation-checklist.md` for systematic review.

**Quick validation:**

- [ ] Correct file format for target agent
- [ ] Valid YAML frontmatter
- [ ] Clear, actionable description
- [ ] Step-by-step instructions
- [ ] Output format explicitly specified
- [ ] At least 2 examples with input/output
- [ ] Correct argument syntax
- [ ] Edge cases documented
- [ ] Error handling included

## Quality Checklist

- [ ] **Agent Compatibility**: Command uses correct format and directory for target agent
- [ ] **Frontmatter Validity**: YAML frontmatter properly formatted with required fields
- [ ] **Description Quality**: Clear, concise description under 80 characters starting with action verb
- [ ] **Instruction Clarity**: Step-by-step instructions that are unambiguous and actionable
- [ ] **Example Coverage**: Multiple examples showing input/output with realistic scenarios
- [ ] **Argument Handling**: Proper use of $ARGUMENTS or {{args}} placeholders
- [ ] **Error Scenarios**: Documentation of common errors and edge cases
- [ ] **Output Specification**: Clear definition of expected output format
- [ ] **Cross-platform**: Scripts and paths work on Windows, macOS, and Linux
- [ ] **Validation Passed**: Command passes all automated validation checks

## Tips

- **Start with Templates**: Always begin with the provided templates rather than building from scratch
- **Validate Early**: Run validation after each major edit to catch issues quickly
- **Test on Multiple Platforms**: Ensure commands work across Windows, macOS, and Linux
- **Keep Descriptions Short**: One sentence, 10-80 characters, focus on what the command does
- **Use Action Verbs**: Start descriptions with verbs like "Create", "Analyze", "Generate", "Validate"
- **Include Real Examples**: Use actual input/output examples, not placeholders
- **Handle Edge Cases**: Document what happens with invalid inputs or unusual scenarios
- **Specify Output Format**: Clearly state what the command should return and in what format
- **Test Arguments**: Verify that $ARGUMENTS or {{args}} work correctly in your instructions
- **Review for Clarity**: Have someone else test the command to ensure instructions are clear

## Additional Resources

- [Agent Command Format Standards](references/format-standards.md) - Complete technical specifications
- [Prompt Engineering Guide](references/prompt-engineering.md) - Advanced instruction writing techniques
- [Agent Directory Reference](references/agent-directory-reference.md) - All supported AI agents and their requirements
- [Validation Rules](references/validation-rules.md) - Detailed validation criteria and error codes
- [Command Validation Checklist](assets/checklists/command-validation-checklist.md) - Systematic review checklist
- [Complete Examples](references/complete-examples.md) - Real-world command examples for different agents
