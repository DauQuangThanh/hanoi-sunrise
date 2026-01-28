# Agent Skill Deployment Guide

## Platform-Specific Skill Directories

Different AI tools look for skills in different locations. Deploy your skill to the appropriate directory based on your target platform.

### Project/Workspace Level (checked into repository)

These directories are checked into version control and shared across the team:

| Platform | Directory | Notes |
|----------|-----------|-------|
| **GitHub Copilot** | `.github/skills/` | Standard location for Copilot skills |
| **Cursor** | `.cursor/rules/` or `.cursor/skills/` | Uses MDC files, can be in either location |
| **Claude Code** | `.claude/skills/` | Official Claude skills directory |
| **Windsurf** | `.windsurf/skills/` | Codeium-based IDE |
| **Amazon Q Developer** | `.amazonq/cli-agents/` | AWS developer tool |
| **Roo Code** | `.roo/skills/` | Roo-specific skills |
| **Jules** | `skills/` or `AGENTS.md` | Can use either format |
| **Google Antigravity** | `.agent/skills/` | Google AI tool |
| **Qoder CLI** | `.qoder/skills/` | Qoder command-line interface |
| **Amp** | `.agents/skills/` | Amp agent skills |
| **Auggie CLI** | `.augment/rules/` | Auggie uses rules format |
| **CodeBuddy CLI** | `.codebuddy/skills/` | CodeBuddy skills |
| **Codex CLI** | `.codex/skills/` | Codex skills directory |
| **Gemini CLI** | `.gemini/extensions/` | Uses extensions format |
| **IBM Bob** | `.bob/skills/` | IBM Bob skills |
| **Kilo Code** | `.kilocode/skills/` | Kilo Code skills |
| **opencode** | `.opencode/skill/` | Note: singular "skill" |
| **Qwen Code** | `.qwen/skills/` | Qwen skills |
| **SHAI (OVHcloud)** | `.shai/commands/` | Uses commands format |

### Global/User Level (applies to all projects)

These directories apply to all projects for a specific user:

| Platform | Directory | Notes |
|----------|-----------|-------|
| **GitHub Copilot** | `~/.copilot/skills/` | User-wide Copilot skills |
| **Cursor** | `~/.cursor/rules/` | Global Cursor rules |
| **Claude Code** | `~/.claude/skills/` | Global Claude skills |
| **Windsurf** | `~/.codeium/windsurf/skills/` | Global Windsurf skills |
| **Amazon Q Developer** | `~/.aws/amazonq/cli-agents/` | AWS config directory |
| **Roo Code** | `~/.roo/skills/` | Global Roo skills |
| **Google Antigravity** | `~/.gemini/antigravity/skills/` | Google AI global |
| **Qoder CLI** | `~/.qoder/skills/` | Global Qoder skills |
| **Amp** | `~/.config/agents/skills/` | Uses XDG config |
| **Auggie CLI** | `~/.claude/skills/` | Shared with Claude |
| **CodeBuddy CLI** | `~/.codebuddy/skills/` | Global CodeBuddy |
| **Codex CLI** | `~/.codex/skills/` | Global Codex |
| **Gemini CLI** | `~/.gemini/skills/` | Global Gemini |
| **IBM Bob** | `~/.bob/skills/` | Global Bob skills |
| **Kilo Code** | `~/.kilocode/skills/` | Global Kilo Code |
| **opencode** | `~/.config/opencode/skill/` | XDG config with singular "skill" |
| **Qwen Code** | `~/.qwen/skills/` | Global Qwen |
| **SHAI (OVHcloud)** | `~/.config/shai/agents/` | XDG config |

## Deployment Examples

### Deploy to Project (Team-Shared)

**GitHub Copilot:**

```bash
# Copy skill to project
cp -r my-skill .github/skills/

# Commit to version control
git add .github/skills/my-skill
git commit -m "Add my-skill for team"
git push
```

**Cursor:**

```bash
# Copy to Cursor directory
cp -r my-skill .cursor/skills/

# Commit
git add .cursor/skills/my-skill
git commit -m "Add my-skill skill"
```

**Claude Code:**

```bash
# Copy to Claude directory
cp -r my-skill .claude/skills/

# Commit
git add .claude/skills/my-skill
git commit -m "Add my-skill skill"
```

### Deploy Globally (User-Only)

**GitHub Copilot:**

```bash
# Copy to global directory
mkdir -p ~/.copilot/skills
cp -r my-skill ~/.copilot/skills/

# Restart VS Code to load skill
```

**Cursor:**

```bash
# Copy to global directory
mkdir -p ~/.cursor/rules
cp -r my-skill ~/.cursor/rules/

# Restart Cursor
```

**Claude Code:**

```bash
# Copy to global directory
mkdir -p ~/.claude/skills
cp -r my-skill ~/.claude/skills/
```

### Multi-Platform Deployment

If you want your skill to work across multiple platforms:

```bash
#!/bin/bash
# deploy-skill.sh - Deploy skill to multiple platforms

SKILL_NAME="my-skill"
SKILL_PATH="./skills/$SKILL_NAME"

# Check skill exists
if [ ! -d "$SKILL_PATH" ]; then
    echo "Error: Skill not found: $SKILL_PATH"
    exit 1
fi

# Deploy to project directories
echo "Deploying to project directories..."
mkdir -p .github/skills && cp -r "$SKILL_PATH" .github/skills/
mkdir -p .cursor/skills && cp -r "$SKILL_PATH" .cursor/skills/
mkdir -p .claude/skills && cp -r "$SKILL_PATH" .claude/skills/
mkdir -p .windsurf/skills && cp -r "$SKILL_PATH" .windsurf/skills/

echo "Deployed to: .github/skills, .cursor/skills, .claude/skills, .windsurf/skills"
echo "Commit these changes to share with your team"
```

## Notable Platform Differences

### Google Antigravity

Google Antigravity uses three different directories for different purposes:

- `.agent/rules/` - Passive constraints applied automatically
- `.agent/workflows/` - Explicit `/` slash commands
- `.agent/skills/` - Agent-triggered capabilities (standard skills)

For most use cases, use `.agent/skills/`.

### Cursor

Cursor predominantly uses `.cursor/rules` with MDC (Markdown Context) files. These behave similarly to skills but are often automatically applied based on context rather than explicitly activated.

### Amazon Q Developer

Amazon Q often uses `.amazonq/prompts/` for custom slash-command definitions rather than a pure modular skill folder. Check the Q documentation for the latest approach.

### Jules

Jules can use either:

- Individual skills in `skills/` directory
- Combined `AGENTS.md` file with multiple skill definitions

Choose based on your preference for file organization.

## Verification

After deploying, verify the skill is loaded:

1. **Restart the IDE/CLI** - Most tools load skills on startup
2. **Check agent response** - Use keywords from the description to test activation
3. **Review logs** - Some tools provide skill loading logs
4. **Test with simple task** - Execute a task that should activate the skill

## Troubleshooting

### Skill Not Discovered

**Possible causes:**

- Skill directory not in correct location
- SKILL.md frontmatter has syntax errors
- Required fields (name, description) missing
- Name doesn't match directory name

**Solutions:**

1. Validate with `skills-ref validate ./skill-name`
2. Check frontmatter YAML syntax
3. Verify name matches directory
4. Restart IDE/CLI

### Skill Not Activated

**Possible causes:**

- Description doesn't match user's keywords
- Another skill activated instead
- Skill loaded but agent chose different approach

**Solutions:**

1. Improve description with more keywords
2. Be more specific in user prompt
3. Explicitly mention skill name or key terms
4. Check if other skills have overlapping descriptions

### Cross-Platform Issues

**Possible causes:**

- Scripts not compatible across platforms
- Path separators differ (Windows vs Unix)
- Line ending issues (CRLF vs LF)

**Solutions:**

1. Use Python/Node.js for cross-platform scripts
2. Provide both Bash and PowerShell versions
3. Configure `.gitattributes` for line endings
4. Test on all target platforms before deploying
