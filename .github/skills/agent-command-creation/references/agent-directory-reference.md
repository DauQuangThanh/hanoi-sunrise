# Agent Directory Reference

Complete listing of supported agents with directory paths, file formats, and specific requirements.

## CLI-Based Agents

CLI-based agents require command-line tools to be installed.

### Claude Code

**Directory:** `.claude/commands/`  
**File Format:** `.md` (Markdown)  
**Arguments:** `$ARGUMENTS`  
**CLI Required:** Yes (`claude`)

**Example:**

```markdown
---
description: "Create feature specification"
---

# Specify

Analyze $ARGUMENTS and create specification...
```

### Gemini CLI

**Directory:** `.gemini/commands/`  
**File Format:** `.toml`  
**Arguments:** `{{args}}`  
**CLI Required:** Yes (`gemini`)

**Example:**

```toml
description = "Create feature specification"

prompt = """
Analyze {{args}} and create specification...
"""
```

### Qwen Code

**Directory:** `.qwen/commands/`  
**File Format:** `.toml`  
**Arguments:** `{{args}}`  
**CLI Required:** Yes (`qwen`)

### Amazon Q Developer CLI

**Directory:** `.amazonq/prompts/`  
**File Format:** `.md`  
**Arguments:** No custom arguments  
**CLI Required:** Yes (`q`)

### Other CLI-Based Agents

| Agent | Directory | Format | CLI Command |
|-------|-----------|--------|-------------|
| Qoder CLI | `.qoder/commands/` | `.md` | `qoder` |
| Auggie CLI | `.augment/rules/` | `.md` | `auggie` |
| CodeBuddy CLI | `.codebuddy/commands/` | `.md` | `codebuddy` |
| Codex CLI | `.codex/commands/` | `.md` | `codex` |
| SHAI | `.shai/commands/` | `.md` | `shai` |
| opencode | `.opencode/command/` | `.md` | `opencode` |
| Amp | `.agents/commands/` | `.md` | `amp` |

## IDE-Based Agents

IDE-based agents are integrated directly into code editors and do not require separate CLI tools.

### GitHub Copilot

**Directory:** `.github/prompts/` (for slash commands) or `.github/agents/` (for custom agents)  
**File Format:** `.prompt.md` or `.agent.md`  
**Arguments:** `$ARGUMENTS`  
**IDE Required:** VS Code with GitHub Copilot extension

**Special Field:** `mode: project.command-name`

**Example:**

```markdown
---
description: "Create feature specification"
mode: vinh.specify
---

Analyze $ARGUMENTS and create specification...
```

### Cursor

**Directory:** `.cursor/commands/` or `.cursor/rules/`  
**File Format:** `.md` or `.mdc`  
**Arguments:** `$ARGUMENTS`  
**IDE Required:** Cursor editor

**Optional Field:** `glob: "**/*.ext"` for file-specific rules

**Example:**

```markdown
---
description: "TypeScript coding rules"
glob: "**/*.ts"
---

Follow these TypeScript conventions...
```

### Windsurf

**Directory:** `.windsurf/workflows/` or `.windsurf/rules/`  
**File Format:** `.md`  
**Arguments:** `$ARGUMENTS`  
**IDE Required:** Windsurf editor

**Structure:** Organized by phases for workflows

### Other IDE-Based Agents

| Agent | Directory | Format | IDE/Extension |
|-------|-----------|--------|---------------|
| Kilo Code | `.kilocode/rules/` | `.md` | VS Code extension |
| Roo Code | `.roo/rules/` | `.md` | VS Code extension |
| IBM Bob | `.bob/commands/` | `.md` | VS Code extension |
| Jules | `.agent/` | `.md` | VS Code extension |
| Google Antigravity | `.agent/rules/` or `.agent/skills/` | `.md` | VS Code extension |

## Agent-Specific Features

### GitHub Copilot: Mode Field

The `mode` field enables slash command functionality:

```markdown
---
description: "Description"
mode: project.command-name
---
```

- Format: `{project-identifier}.{command-name}`
- Both parts must be lowercase
- Use hyphens for multi-word names
- Examples: `vinh.specify`, `myapp.analyze-code`

### Cursor: Glob Pattern

The `glob` field applies rules to specific file types:

```markdown
---
description: "Python coding standards"
glob: "**/*.py"
---
```

### Google Antigravity: Category Field

Distinguishes between rules (constraints) and skills (capabilities):

```markdown
---
description: "Security rules"
category: rules
---
```

or

```markdown
---
description: "Code generation skill"
category: skills
---
```

## Quick Decision Matrix

**Choose your agent:**

1. **Gemini CLI or Qwen Code?** → Use TOML format
2. **GitHub Copilot?** → Add `mode:` field to YAML frontmatter
3. **Cursor with file-specific rules?** → Add `glob:` pattern
4. **All other agents?** → Use standard Markdown format

## Platform Requirements Summary

| Platform | Windows | macOS | Linux | Notes |
|----------|---------|-------|-------|-------|
| CLI agents | ✅ | ✅ | ✅ | Requires CLI installation |
| IDE agents | ✅ | ✅ | ✅ | Requires IDE/extension |
| Python scripts | ✅ | ✅ | ✅ | Python 3.8+ required |
| Bash scripts | ❌ | ✅ | ✅ | Unix-like only |
| PowerShell scripts | ✅ | ✅ | ✅ | PS 5.1+ or PS Core |

## Common Pitfalls

**Wrong directory:**

- ❌ `.claude/command/specify.md` (singular)
- ✅ `.claude/commands/specify.md` (plural)

**Wrong format:**

- ❌ `.gemini/commands/analyze.md` (should be TOML)
- ✅ `.gemini/commands/analyze.toml`

**Wrong arguments:**

- ❌ Using `{{args}}` in Markdown files
- ✅ Using `$ARGUMENTS` in Markdown files

**Missing required fields:**

- ❌ GitHub Copilot command without `mode:` field
- ✅ Including `mode: project.name` in frontmatter

## Testing Commands

**For CLI agents:**

```bash
# Claude Code
claude chat /specify "Create user login feature"

# Gemini CLI
gemini analyze --file=src/app.py

# Amazon Q
q chat /review
```

**For IDE agents:**

- GitHub Copilot: Type `/` in chat to see available commands
- Cursor: Use Cmd+K (Mac) or Ctrl+K (Windows) then type command
- Windsurf: Use workflow menu or command palette
