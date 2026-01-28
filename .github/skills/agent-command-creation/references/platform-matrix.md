# Platform Support Matrix

Quick reference for supported agentic platforms and their **command folder** configurations.

**IMPORTANT**: This matrix shows **COMMAND folders** (where slash commands/prompts are stored), not SKILL folders.

## Complete Platform List - Command Folders

| # | Platform | Command Folder | Primary File Type | Mode Support | Format | Argument Syntax |
|---|----------|----------------|-------------------|--------------|--------|-----------------|
| 1 | **Claude Code** | `.claude/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 2 | **GitHub Copilot (Agents)** | `.github/agents/` | `.agent.md` | No | Markdown | `$ARGUMENTS` |
| 3 | **GitHub Copilot (Prompts)** | `.github/prompts/` | `.prompt.md` | **Yes** | Markdown | `$ARGUMENTS` |
| 4 | **Cursor** | `.cursor/commands/`, `.cursor/rules/` | `.md`, `.mdc` | No | Markdown/MDC | `$ARGUMENTS` |
| 5 | **Windsurf** | `.windsurf/workflows/`, `.windsurf/rules/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 6 | **Gemini CLI** | `.gemini/commands/` | `.toml` | No | TOML | `{{args}}` |
| 7 | **Qwen Code** | `.qwen/commands/` | `.toml` | No | TOML | `{{args}}` |
| 8 | **Google Antigravity** | `.agent/rules/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 9 | **Amazon Q CLI** | `.amazonq/prompts/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 10 | **Kilo Code** | `.kilocode/rules/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 11 | **Roo Code** | `.roo/rules/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 12 | **IBM Bob** | `.bob/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 13 | **Jules** | `.agent/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 14 | **Amp (Sourcegraph)** | `.agents/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 15 | **Auggie CLI** | `.augment/rules/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 16 | **Qoder CLI** | `.qoder/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 17 | **CodeBuddy CLI** | `.codebuddy/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 18 | **Codex CLI** | `.codex/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 19 | **SHAI (OVHcloud)** | `.shai/commands/` | `.md` | No | Markdown | `$ARGUMENTS` |
| 20 | **opencode** | `.opencode/command/` | `.md` | No | Markdown | `$ARGUMENTS` |

## Skill Folders (For Reference - Not Created by This Tool)

For creating agent **skills** (SKILL.md files with frontmatter), see the `agent-skill-creation` skill. Skills are stored in different folders:

- Claude Code: `.claude/skills/`
- GitHub Copilot: `.github/skills/`
- Cursor: `.cursor/skills/`
- Windsurf: `.windsurf/skills/`
- Gemini CLI: `.gemini/extensions/`
- Google Antigravity: `.agent/skills/`
- (And more - see agent-skills-folder-mapping.md)

## Format Categories

### Markdown-Based Platforms (18 platforms)

**File Extension**: `.md`, `.agent.md`, `.prompt.md`, `.mdc`

**Argument Syntax**: `$ARGUMENTS`

**Platforms**:

- Claude Code
- GitHub Copilot (both types)
- Cursor
- Windsurf
- Google Antigravity
- Amazon Q CLI
- Kilo Code
- Roo Code
- IBM Bob
- Jules
- Amp
- Auggie CLI
- Qoder CLI
- CodeBuddy CLI
- Codex CLI
- SHAI
- opencode

### TOML-Based Platforms (2 platforms)

**File Extension**: `.toml`

**Argument Syntax**: `{{args}}`

**Platforms**:

- Gemini CLI
- Qwen Code

## Special Features

### Mode Support

Only **GitHub Copilot Prompts** support the `mode` field for creating slash commands.

**Format**:

```markdown
---
description: "Command description"
mode: project-name.command-name
---
```

**Example**:

```markdown
---
description: "Create specification from requirements"
mode: vinh.specify
---
```

### File Type Variations

#### GitHub Copilot

- **Agents**: `.github/agents/` → `.agent.md`
- **Prompts**: `.github/prompts/` → `.prompt.md`

#### Cursor

- **Commands**: `.cursor/commands/` → `.md`
- **Rules**: `.cursor/rules/` → `.md` or `.mdc`

The `.mdc` format allows metadata for automatic rule triggering (e.g., `glob` patterns).

#### Windsurf

- **Workflows**: `.windsurf/workflows/` → `.md`
- **Rules**: `.windsurf/rules/` → `.md`

Windsurf also maintains a "Memory Bank" in `.windsurf/core/` for long-term context.

#### Google Antigravity

- **Rules**: `.agent/rules/` → Passive constraints
- **Skills**: `.agent/skills/` → Active tools/capabilities

## Platform-Specific Notes

### Claude Code

- Very conversational and context-aware
- Excellent at reasoning and explanation
- Strong multi-file awareness

### GitHub Copilot

- Two distinct modes: agents (custom) and prompts (slash commands)
- Slash commands require `mode` field
- Integrated deeply with VS Code

### Cursor

- MDC format supports rule metadata
- `glob` patterns for automatic rule activation
- Example: `glob: "**/*.test.ts"`

### Windsurf

- Memory Bank concept for persistent context
- Workflows for multi-step processes
- Rules for constraints and standards

### Gemini CLI & Qwen Code

- TOML format only
- Use `{{args}}` instead of `$ARGUMENTS`
- Triple-quoted strings for multi-line prompts

### Google Antigravity

- Clear distinction between Rules (constraints) and Skills (capabilities)
- Rules are passive: "Don't do X"
- Skills are active: "Can do Y"

## Quick Selection Guide

**Question: Which format should I use?**

```
Is it Gemini CLI or Qwen Code?
  ├─ YES → Use TOML (.toml)
  └─ NO  → Use Markdown (.md, .agent.md, .prompt.md)

Is it GitHub Copilot slash command?
  ├─ YES → Use .prompt.md with mode field
  └─ NO  → Use standard .md

Is it Cursor with auto-trigger rules?
  ├─ YES → Consider .mdc with glob patterns
  └─ NO  → Use standard .md
```

## File Naming Conventions

**All Platforms**:

- Use lowercase
- Use hyphens for word separation
- Be descriptive and clear
- Follow pattern: `[verb]-[noun].[ext]`

**Examples**:

```
✅ analyze-security.md
✅ generate-tests.md
✅ review-code.md
✅ validate-standards.md

❌ AnalyzeSecurity.md     (capitals)
❌ analyze_security.md    (underscores)
❌ doStuff.md             (vague)
❌ cmd1.md                (not descriptive)
```

## Global vs Project Commands

Most platforms support both:

### Global Commands

Located in user home directory, available for all projects.

**Examples**:

- `~/.claude/commands/`
- `~/.gemini/commands/`
- `~/.cursor/rules/`

### Project Commands

Located in project root, specific to that project.

**Examples**:

- `.claude/commands/` (in project root)
- `.gemini/commands/` (in project root)
- `.cursor/rules/` (in project root)

## References

- [agents-creation-rules.md](../../../rules/agents-creation-rules.md)
- [agents-folder-mapping.md](../../../rules/agents-folder-mapping.md)
