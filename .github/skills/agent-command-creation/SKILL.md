---
name: agent-command-creation
description: "Creates and updates agent commands/prompts for agentic platforms including Claude Code, GitHub Copilot, Cursor, Windsurf, and Gemini CLI. Use when creating slash commands, agent prompts, or custom commands, or when user mentions agent commands, prompts, command generation, or platform-specific agents."
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-28"
---

# Agent Command Creation

## Overview

This skill enables AI agents to create and update **agent commands** (also called slash commands or prompts) for various agentic platforms following the **Agent Creation Rules and Best Practices** specification.

**IMPORTANT DISTINCTION**:

- This skill creates **COMMANDS**: Platform-specific instructions in `.claude/commands/`, `.github/prompts/`, etc.
- For creating **SKILLS**: Use the separate `agent-skill-creation` skill

Supports 21+ AI development tools including Claude Code, GitHub Copilot, Cursor, Windsurf, Gemini CLI, and more.

## Capabilities

- **Create new agent commands** with proper structure and format
- **Update existing commands** while maintaining consistency
- **Generate cross-platform scripts** (Bash, PowerShell, Python)
- **Validate command structure** against platform requirements
- **Support multiple formats**: Markdown (.md), TOML (.toml), MDC (.mdc)
- **Generate templates** for common command patterns

## Supported Platforms

**IMPORTANT**: These are **command folders**, not skill folders.

| Platform | Command Folder | Skill Folder (Different!) | Format |
|----------|----------------|---------------------------|--------|
| Claude Code | `.claude/commands/` | `.claude/skills/` | `.md` |
| GitHub Copilot | `.github/agents/`, `.github/prompts/` | `.github/skills/` | `.agent.md`, `.prompt.md` |
| Cursor | `.cursor/commands/`, `.cursor/rules/` | `.cursor/skills/` | `.md`, `.mdc` |
| Windsurf | `.windsurf/workflows/`, `.windsurf/rules/` | `.windsurf/skills/` | `.md` |
| Gemini CLI | `.gemini/commands/` | `.gemini/extensions/` | `.toml` |
| Qwen Code | `.qwen/commands/` | `.qwen/skills/` | `.toml` |
| Google Antigravity | `.agent/rules/` | `.agent/skills/` | `.md` |
| Amazon Q CLI | `.amazonq/prompts/` | `.amazonq/cli-agents/` | `.md` |
| Kilo Code | `.kilocode/rules/` | `.kilocode/skills/` | `.md` |
| Roo Code | `.roo/rules/` | `.roo/skills/` | `.md` |
| IBM Bob | `.bob/commands/` | `.bob/skills/` | `.md` |
| Jules | `.agent/` | `skills/` | `.md` |
| Amp | `.agents/commands/` | `.agents/skills/` | `.md` |
| Auggie CLI | `.augment/rules/` | `.augment/rules/` | `.md` |
| Qoder CLI | `.qoder/commands/` | `.qoder/skills/` | `.md` |
| CodeBuddy CLI | `.codebuddy/commands/` | `.codebuddy/skills/` | `.md` |
| Codex CLI | `.codex/commands/` | `.codex/skills/` | `.md` |
| SHAI | `.shai/commands/` | `.shai/commands/` | `.md` |
| opencode | `.opencode/command/` | `.opencode/skill/` | `.md` |

**Note**: This skill creates files in the **Command Folder** column. For creating skills (SKILL.md files) in the **Skill Folder** column, use the `agent-skill-creation` skill.

## When to Use This Skill

Use this skill when:

- Creating new agent **commands** or **slash commands** (e.g., `/analyze`, `/implement`)
- Creating platform-specific **prompts** (GitHub Copilot, Gemini CLI)
- Converting commands between different agent formats (Markdown ↔ TOML)
- Updating existing commands with new features
- Standardizing command structure across platforms
- Generating command initialization scripts

**NOT for**: Creating agent skills (SKILL.md files) - use `agent-skill-creation` instead

## Command Structure

### Markdown Format (.md)

Used by most platforms (Claude Code, Copilot, Cursor, Windsurf, etc.):

```markdown
---
description: "Clear, concise description of what this command does"
---

# Command Name

## Purpose
[Explain the command's purpose and when to use it]

## Context
[Describe what context/information is needed]

## Instructions
[Step-by-step instructions for the AI agent]

## Output Format
[Specify the expected output structure]

## Examples
[Provide concrete examples if applicable]
```

### GitHub Copilot Chat Mode

```markdown
---
description: "Command description"
mode: project-name.command-name
---

[Command instructions]
```

### TOML Format (.toml)

Used by Gemini CLI and Qwen Code:

```toml
description = "Clear, concise description"

prompt = """
# Command Name

## Purpose
[Instructions...]

Arguments: {{args}}
"""
```

## Instructions for AI Agent

When creating or updating agent commands, follow these steps:

### Step 1: Identify Target Platform

```
Ask the user (if not specified):
1. Which platform are you targeting? (Claude Code, GitHub Copilot, etc.)
2. What should the command do?
3. What should it be called?
```

### Step 2: Determine File Format

```
Based on target platform:
- Gemini CLI or Qwen Code → Use TOML format
- All other platforms → Use Markdown format
- GitHub Copilot with slash command → Include mode field
```

### Step 3: Create Command Structure

#### For Markdown Commands

1. **Create frontmatter** with description
2. **Add mode field** (GitHub Copilot only): `mode: project.command-name`
3. **Define sections**:
   - Purpose: What the command does
   - Context: Required information
   - Instructions: Step-by-step guidance
   - Output Format: Expected results
   - Examples: Concrete usage examples
4. **Use correct argument syntax**: `$ARGUMENTS` for Markdown, `{{args}}` for TOML

#### For TOML Commands

1. **Add description** field (single line)
2. **Create prompt** field with triple quotes
3. **Include all sections** inside prompt
4. **Use `{{args}}`** for arguments

### Step 4: Apply Best Practices

✅ **DO:**

- Use clear, descriptive command names (lowercase-with-hyphens)
- Write actionable descriptions starting with verbs
- Break complex tasks into phases
- Include validation checkpoints
- Provide concrete examples
- Specify output format explicitly
- Use proper argument syntax for the platform
- Include error handling guidance

❌ **DON'T:**

- Use vague descriptions like "Help with code"
- Create monolithic commands that do everything
- Forget to specify expected output
- Mix argument syntaxes (don't use `{{args}}` in Markdown)
- Skip platform-specific requirements
- Use capital letters in file names

### Step 5: Validate Command

Check these requirements:

```yaml
✓ Description is clear and under 80 characters
✓ File name follows pattern: [verb]-[noun].md or .toml
✓ All required sections are present
✓ Correct argument syntax for platform
✓ Output format is specified
✓ Examples are provided (when applicable)
✓ Proper frontmatter/TOML structure
✓ Mode field added (GitHub Copilot only)
```

### Step 6: Generate Cross-Platform Scripts (if needed)

If the command requires automation scripts:

1. **Provide both .sh and .ps1** versions (see `scripts/init-agent.sh` and `scripts/init-agent.ps1`)
2. **Bash for macOS/Linux** - Use `scripts/init-agent.sh` as template
3. **PowerShell for Windows** - Use `scripts/init-agent.ps1` as template
4. **Include error handling** in all scripts
5. **Test on all platforms** (Windows, macOS, Linux)
6. **Document prerequisites** in comments
7. **Reference** `references/cross-platform-scripts.md` for detailed guidance

## Command Naming Conventions

### File Names

```
Format: [verb]-[noun].md or [verb]-[noun].toml

✅ Good examples:
- analyze-security.md
- implement-feature.md
- validate-tests.md
- design-architecture.md

❌ Bad examples:
- do-stuff.md (too vague)
- TheCommand.md (capital letters)
- helper.md (not descriptive)
```

### Mode Names (GitHub Copilot)

```
Format: project.command-name

✅ Good examples:
- vinh.specify
- myapp.implement
- project.review

❌ Bad examples:
- specify (missing project prefix)
- vinh_specify (underscore instead of dot)
- VINH.SPECIFY (capital letters)
```

## Argument Syntax

**CRITICAL**: Use the correct syntax for your target platform.

| Platform Type | Syntax | Example |
|---------------|--------|---------|
| Markdown-based (most) | `$ARGUMENTS` | `Review the code: $ARGUMENTS` |
| TOML-based (Gemini/Qwen) | `{{args}}` | `Analyze: {{args}}` |
| Script paths | `{SCRIPT}` | `Run {SCRIPT}` |
| Agent name | `__AGENT__` | `Using __AGENT__` |

## Templates

### Template 1: Analysis Command

```markdown
---
description: "Analyze codebase for [specific aspect]"
---

# [Aspect] Analysis

## Purpose
Perform comprehensive analysis of [specific aspect] in the codebase.

## Context
- Target files/directories: $ARGUMENTS
- Project conventions in: docs/conventions.md
- Existing patterns in: [relevant files]

## Instructions

### Phase 1: Discovery
1. Scan the specified files/directories
2. Identify current [aspect] patterns
3. Document existing approaches

### Phase 2: Analysis
1. Evaluate each instance against best practices
2. Identify issues, anti-patterns, or violations
3. Assess severity (Critical, High, Medium, Low)

### Phase 3: Reporting
1. Create findings summary
2. Provide specific examples
3. Suggest remediation steps

## Output Format

Create `analysis-[aspect]-[date].md` with:

```markdown
# [Aspect] Analysis Report

## Summary
- Total issues found: X
- Critical: X
- High: X
- Medium: X
- Low: X

## Findings

### [Finding 1]
- **Severity**: Critical
- **Location**: [file:line]
- **Issue**: [description]
- **Impact**: [business/technical impact]
- **Remediation**: [specific steps]
```

## Examples

Input: `/analyze-security src/auth`
Output: Security analysis report for auth module

```

### Template 2: Implementation Command

```markdown
---
description: "Implement feature based on specification"
---

# Feature Implementation

## Purpose
Implement a new feature following the technical specification and project conventions.

## Context
- Specification file: $ARGUMENTS
- Project conventions: docs/conventions.md
- Code patterns: [relevant examples]

## Instructions

### Phase 1: Planning
1. Read and understand the specification
2. Review existing codebase patterns
3. Identify integration points
4. Plan implementation approach

### Phase 2: Implementation
1. Create necessary files/modules
2. Implement core functionality
3. Add error handling
4. Follow project coding standards

### Phase 3: Testing
1. Write unit tests
2. Write integration tests
3. Verify edge cases
4. Test error scenarios

### Phase 4: Documentation
1. Add code comments
2. Update API documentation
3. Create usage examples

## Output Format

Deliver:
1. Implemented code files
2. Test files
3. Updated documentation
4. Summary of changes

## Quality Gates
- [ ] All tests passing
- [ ] Code follows project conventions
- [ ] Documentation updated
- [ ] Error handling implemented
- [ ] Edge cases covered
```

### Template 3: Validation Command

```markdown
---
description: "Validate code against project standards"
---

# Code Validation

## Purpose
Validate code quality, standards compliance, and best practices adherence.

## Context
- Files to validate: $ARGUMENTS
- Project standards: docs/standards.md
- Coding conventions: docs/conventions.md

## Instructions

### Validation Checklist

#### 1. Code Quality
- [ ] Functions are single-purpose
- [ ] Variables have descriptive names
- [ ] No code duplication
- [ ] Proper error handling
- [ ] Efficient algorithms

#### 2. Standards Compliance
- [ ] Follows naming conventions
- [ ] Adheres to formatting rules
- [ ] Uses approved patterns
- [ ] Meets security requirements
- [ ] Passes linting

#### 3. Documentation
- [ ] Functions are documented
- [ ] Complex logic explained
- [ ] API contracts clear
- [ ] Usage examples provided

#### 4. Testing
- [ ] Unit tests present
- [ ] Tests are meaningful
- [ ] Edge cases covered
- [ ] Test coverage adequate

## Output Format

Create validation report:

```markdown
# Validation Report

## Overall Status
✅ PASS / ❌ FAIL

## Violations Found: X

### Critical Issues
1. [Issue description] - [Location]
   - Impact: [description]
   - Fix: [remediation steps]

### Warnings
1. [Warning description] - [Location]
   - Suggestion: [improvement]

## Recommendations
- [Recommendation 1]
- [Recommendation 2]
```

## Examples

Input: `/validate src/api/user-service.ts`
Output: Validation report with issues and recommendations

```

## Example Usage Scenarios

### Scenario 1: Create Claude Code Command

```

User: Create an agent command for Claude Code that reviews pull requests

AI Actions:

1. Determine platform: Claude Code → Use Markdown format
2. Create file: .claude/commands/review-pr.md
3. Use standard Markdown structure
4. Include $ARGUMENTS for PR number
5. Add phases: Fetch Changes → Analyze Code → Generate Review
6. Specify output format: PR review comment

```

### Scenario 2: Create GitHub Copilot Slash Command

```

User: Create a /vinh.security command for GitHub Copilot

AI Actions:

1. Determine platform: GitHub Copilot → Use Markdown with mode
2. Create file: .github/prompts/security.prompt.md
3. Add frontmatter with mode: vinh.security
4. Use $ARGUMENTS syntax
5. Structure security analysis workflow
6. Specify vulnerability report format

```

### Scenario 3: Create Gemini CLI Command

```

User: Create a Gemini CLI command to generate unit tests

AI Actions:

1. Determine platform: Gemini CLI → Use TOML format
2. Create file: .gemini/commands/generate-tests.toml
3. Add description field
4. Use {{args}} in prompt field
5. Include test generation instructions
6. Specify test file output format

```

### Scenario 4: Convert Between Formats

```

User: Convert this Claude command to work with Gemini CLI

AI Actions:

1. Read existing .claude/commands/analyze.md
2. Extract description from frontmatter
3. Extract instructions from body
4. Convert $ARGUMENTS to {{args}}
5. Create .gemini/commands/analyze.toml
6. Wrap content in prompt = """..."""

```

## Validation Checklist

Before delivering a command, verify:

```yaml
Structure:
  ✓ Correct file format for platform
  ✓ Proper frontmatter/TOML structure
  ✓ All required sections present
  ✓ Mode field (GitHub Copilot only)

Content:
  ✓ Clear, actionable description
  ✓ Well-defined purpose
  ✓ Step-by-step instructions
  ✓ Explicit output format
  ✓ Concrete examples

Best Practices:
  ✓ Follows naming conventions
  ✓ Correct argument syntax
  ✓ Includes validation checkpoints
  ✓ Provides error handling guidance
  ✓ Under 80 chars description
  ✓ Lowercase with hyphens filename

Platform-Specific:
  ✓ Correct folder location
  ✓ Correct file extension
  ✓ Platform-specific features used
  ✓ Compatible argument syntax
```

## Error Handling

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Wrong argument syntax | Check platform: Markdown uses `$ARGUMENTS`, TOML uses `{{args}}` |
| Missing mode field | Add `mode: project.command` for GitHub Copilot only |
| Capital letters in filename | Use lowercase-with-hyphens format |
| Vague description | Start with action verb, include outcome, keep under 80 chars |
| Missing output format | Always specify what the command should produce |
| No examples | Provide at least one concrete usage example |
| Monolithic command | Break into phases with clear steps |

## References

### Scripts

- **scripts/init-agent.sh**: Bash script for macOS/Linux
- **scripts/init-agent.ps1**: PowerShell script for Windows

### Reference Documentation

- **references/argument-syntax-guide.md**: Complete argument syntax reference for all platforms
- **references/best-practices.md**: Comprehensive best practices for agent command creation
- **references/platform-matrix.md**: Platform support matrix with folder configurations
- **references/cross-platform-scripts.md**: Guide for developing cross-platform scripts

### Templates

- **templates/analysis-command.md**: Template for analysis/review commands
- **templates/implementation-command.md**: Template for implementation commands
- **templates/validation-command.md**: Template for validation/testing commands
- **templates/copilot-slash-command.md**: Template for GitHub Copilot slash commands
- **templates/gemini-command.toml**: Template for TOML-based commands (Gemini CLI, Qwen Code)

## Advanced Features

### Multi-Phase Commands

For complex workflows, structure commands with multiple phases:

```markdown
## Phase 1: [Name]
[Steps with clear entry/exit criteria]

## Phase 2: [Name]
[Steps that depend on Phase 1 completion]

## Phase 3: [Name]
[Final steps with validation]
```

### Chain-of-Thought Prompting

Encourage AI reasoning:

```markdown
## Instructions

Think through this step-by-step:

1. **First**, understand the overall context
2. **Then**, analyze each component
3. **Next**, identify issues or opportunities
4. **After that**, propose solutions
5. **Finally**, validate your approach

Think out loud as you work through each step.
```

### Role-Based Commands

Assign specific expertise:

```markdown
You are a [role] with expertise in [domains].

When performing this task:
- Think from the perspective of [viewpoint]
- Consider [specific aspects]
- Apply [methodologies]
```

## Output

When creating an agent command, deliver:

1. **Command file** in the correct location with proper format
2. **Brief confirmation** of what was created
3. **Usage example** showing how to invoke the command
4. **Any platform-specific notes** or requirements

Example output:

```
Created .claude/commands/review-security.md

Usage: /review-security src/auth

This command analyzes the specified directory for security vulnerabilities
and generates a detailed report with remediation steps.
```

## Notes

- Always validate the command structure against platform requirements
- Use templates as starting points, customize for specific needs
- Test commands with actual AI platforms when possible
- Keep commands focused and single-purpose
- Document any platform-specific behaviors or limitations
- Follow the project's license (MIT) and author attribution requirements
