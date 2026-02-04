# Upgrade Guide

> You have Hanoi Sunrise installed and want to upgrade to the latest version to get new features, bug fixes, or updated slash commands. This guide covers both upgrading the CLI tool and updating your project files.

---

## Quick Reference

| What to Upgrade | Command | When to Use |
| ---------------- | --------- |-------------|
| **CLI Tool Only** | `uv tool install sunrise-cli --force --from git+https://github.com/dauquangthanh/hanoi-sunrise.git` | Get latest CLI features without touching project files |
| **Project Files** | `sunrise init --here --force --upgrade --ai <your-agent>` | Update slash commands, templates, and scripts in your project (automatic backups) |
| **Both** | Run CLI upgrade, then project update | Recommended for major version updates |

---

## Part 1: Upgrade the CLI Tool

The CLI tool (`sunrise`) is separate from your project files. Upgrade it to get the latest features and bug fixes.

### If you installed with `uv tool install`

```bash
uv tool install sunrise-cli --force --from git+https://github.com/dauquangthanh/hanoi-sunrise.git
```

### If you use one-shot `uvx` commands

No upgrade needed—`uvx` always fetches the latest version. Just run your commands as normal:

```bash
uvx --from git+https://github.com/dauquangthanh/hanoi-sunrise.git sunrise init --here --ai copilot
```

### Verify the upgrade

```bash
sunrise check
```

This shows installed tools and confirms the CLI is working.

---

## Part 2: Updating Project Files

When Hanoi Sunrise releases new features (like new slash commands or updated templates), you need to refresh your project's Hanoi Sunrise files.

### What gets updated?

Running `sunrise init --here --force --upgrade` will automatically back up and replace:

- ✅ **.sunrise/ folder** (scripts, templates, memory files including docs/)
- ✅ **Agent folders** (e.g., .claude/, .github/, .cursor/) - entire root folders are backed up and replaced
- ✅ **Skills folder** (for Jules agent) - backed up if present

**Automatic backups are created with timestamps** (e.g., `.sunrise.backup.20260204_120000`). User project files (specs/, source code, etc.) are preserved and never touched.

### What stays safe?

These files are **never touched** by the upgrade—the template packages don't even contain them:

- ✅ **Your specifications** (`specs/001-my-feature/spec.md`, etc.) - **CONFIRMED SAFE**
- ✅ **Your implementation plans** (`specs/001-my-feature/plan.md`, `tasks.md`, etc.) - **CONFIRMED SAFE**
- ✅ **Your source code** - **CONFIRMED SAFE**
- ✅ **Your git history** - **CONFIRMED SAFE**

The `specs/` directory is completely excluded from template packages and will never be modified during upgrades.

### Update command

Run this inside your project directory:

```bash
sunrise init --here --force --upgrade --ai <your-agent>
```

Replace `<your-agent>` with your AI assistant. Refer to this list of [Supported AI Agents](../README.md#-supported-ai-agents)

**Example:**

```bash
sunrise init --here --force --upgrade --ai copilot
```

### Understanding the `--upgrade` flag

The `--upgrade` flag enables upgrade mode, which:

- Detects existing Sunrise installation (.sunrise folder required)
- Automatically backs up folders with timestamps
- Replaces .sunrise, agent folders, and skills (for Jules) with latest templates
- Preserves user content (specs/, source code, git history)

---

## ⚠️ Important Warnings

### 1. Automatic backups are created

The upgrade process automatically creates timestamped backups of replaced folders (e.g., `.sunrise.backup.20260204_120000`). To restore from backup:

```bash
# List backup folders
ls -la | grep backup

# Remove current folder and rename backup (example)
rm -rf .sunrise
mv .sunrise.backup.20260204_120000 .sunrise
```

### 2. Ground rules file may be overwritten

**Known issue:** The upgrade replaces the entire `docs/` folder within `.sunrise`, which may overwrite `docs/ground-rules.md` with the default template, erasing any customizations.

**Workaround:** After upgrade, restore from backup or git:

```bash
# If you committed before upgrading
git restore docs/ground-rules.md

# Or from automatic backup
cp .sunrise.backup.*/docs/ground-rules.md docs/
```

### 3. Custom template modifications

If you customized templates in `.sunrise/templates/`, the upgrade will replace them. Restore from backup after upgrading.

### 3. Duplicate slash commands (IDE-based agents)

Some IDE-based agents (like Kilo Code, Windsurf) may show **duplicate slash commands** after upgrading—both old and new versions appear.

**Solution:** Manually delete the old command files from your agent's folder.

**Example for Kilo Code:**

```bash
# Navigate to the agent's commands folder
cd .kilocode/rules/

# List files and identify duplicates
ls -la

# Delete old versions (example filenames - yours may differ)
rm sunrise.specify-old.md
rm sunrise.design-v1.md
```

Restart your IDE to refresh the command list.

---

## Common Scenarios

### Scenario 1: "I just want new slash commands"

```bash
# Upgrade CLI (if using persistent install)
uv tool install sunrise-cli --force --from git+https://github.com/dauquangthanh/hanoi-sunrise.git

# Update project files to get new commands (automatic backups created)
sunrise init --here --force --upgrade --ai copilot

# Restore ground rules if customized (from automatic backup)
cp .sunrise.backup.*/docs/ground-rules.md docs/
```

### Scenario 2: "I customized templates and ground-rules"

```bash
# Upgrade CLI
uv tool install sunrise-cli --force --from git+https://github.com/dauquangthanh/hanoi-sunrise.git

# Update project (automatic backups created)
sunrise init --here --force --upgrade --ai copilot

# Restore customizations from automatic backups
cp .sunrise.backup.*/docs/ground-rules.md docs/
cp -r .sunrise.backup.*/templates .sunrise/
# Manually merge template changes if needed
```

### Scenario 3: "I see duplicate slash commands in my IDE"

This happens with IDE-based agents (Kilo Code, Windsurf, Roo Code, etc.).

```bash
# Find the agent folder (example: .kilocode/rules/)
cd .kilocode/rules/

# List all files
ls -la

# Delete old command files
rm sunrise.old-command-name.md

# Restart your IDE
```

### Scenario 4: "I'm working on a project without Git"

If you initialized your project with `--no-git`, you can still upgrade:

```bash
# Run upgrade (automatic backups created)
sunrise init --here --force --upgrade --ai copilot --no-git

# Restore customizations from automatic backups
cp .sunrise.backup.*/docs/ground-rules.md docs/
```

The `--no-git` flag skips git initialization but doesn't affect file updates.

---

## Using `--no-git` Flag

The `--no-git` flag tells Hanoi Sunrise to **skip git repository initialization**. This is useful when:

- You manage version control differently (Mercurial, SVN, etc.)
- Your project is part of a larger monorepo with existing git setup
- You're experimenting and don't want version control yet

**During initial setup:**

```bash
sunrise init my-project --ai copilot --no-git
```

**During upgrade:**

```bash
sunrise init --here --force --ai copilot --no-git
```

### What `--no-git` does NOT do

❌ Does NOT prevent file updates
❌ Does NOT skip slash command installation
❌ Does NOT affect template merging

It **only** skips running `git init` and creating the initial commit.

### Working without Git

If you use `--no-git`, you'll need to manage feature directories manually:

**Set the `SPECIFY_FEATURE` environment variable** before using planning commands:

```bash
# Bash/Zsh
export SPECIFY_FEATURE="001-my-feature"

# PowerShell
$env:SPECIFY_FEATURE = "001-my-feature"
```

This tells Hanoi Sunrise which feature directory to use when creating specs, plans, and tasks.

**Why this matters:** Without git, Hanoi Sunrise can't detect your current branch name to determine the active feature. The environment variable provides that context manually.

---

## Troubleshooting

### "Slash commands not showing up after upgrade"

**Cause:** Agent didn't reload the command files.

**Fix:**

1. **Restart your IDE/editor** completely (not just reload window)
2. **For CLI-based agents**, verify files exist:

   ```bash
   ls -la .claude/commands/      # Claude Code
   ls -la .gemini/commands/       # Gemini
   ls -la .cursor/commands/       # Cursor
   ```

3. **Check agent-specific setup:**
   - Codex requires `CODEX_HOME` environment variable
   - Some agents need workspace restart or cache clearing

### "I lost my ground rules customizations"

**Fix:** Restore from automatic backup:

```bash
# List backups
ls -la | grep backup

# Restore ground rules
cp .sunrise.backup.20260204_120000/docs/ground-rules.md docs/
```

**Prevention:** Commit `docs/ground-rules.md` before upgrading if using git.

### "Warning: Current directory is not empty"

**Full warning message:**

```
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may overwrite existing files
Do you want to continue? [y/N]
```

**What this means:**

This warning appears when you run `sunrise init --here` (or `sunrise init .`) in a directory that already has files. It's telling you:

1. **The directory has existing content** - In the example, 25 files/folders
2. **Files will be merged** - New template files will be added alongside your existing files
3. **Some files may be overwritten** - If you already have Hanoi Sunrise files (`.claude/`, `.sunrise/`, etc.), they'll be replaced with the new versions

**What gets overwritten:**

Only Hanoi Sunrise infrastructure files:

- Agent command files (`.claude/commands/`, `.github/prompts/`, etc.)
- Scripts in `.sunrise/scripts/`
- Templates in `.sunrise/templates/`
- Memory files in `docs/` (including ground-rules)

**What stays untouched:**

- Your `specs/` directory (specifications, plans, tasks)
- Your source code files
- Your `.git/` directory and git history
- Any other files not part of Hanoi Sunrise templates

**How to respond:**

- **Type `y` and press Enter** - Proceed with the merge (recommended if upgrading)
- **Type `n` and press Enter** - Cancel the operation
- **Use `--force` flag** - Skip this confirmation entirely:

  ```bash
  sunrise init --here --force --ai copilot
  ```

**When you see this warning:**

- ✅ **Expected** when upgrading an existing Sunrise project (use `--upgrade` flag)
- ✅ **Expected** when adding Sunrise to an existing codebase
- ⚠️ **Unexpected** if you thought you were creating a new project in an empty directory

**Prevention tip:** For upgrades, use the `--upgrade` flag to enable automatic backups.

### "CLI upgrade doesn't seem to work"

Verify the installation:

```bash
# Check installed tools
uv tool list

# Should show sunrise-cli

# Verify path
which sunrise

# Should point to the uv tool installation directory
```

If not found, reinstall:

```bash
uv tool uninstall sunrise-cli
uv tool install sunrise-cli --from git+https://github.com/dauquangthanh/hanoi-sunrise.git
```

### "Do I need to run sunrise every time I open my project?"

**Short answer:** No, you only run `sunrise init` once per project (or when upgrading).

**Explanation:**

The `sunrise` CLI tool is used for:

- **Initial setup:** `sunrise init` to bootstrap Hanoi Sunrise in your project
- **Upgrades:** `sunrise init --here --force` to update templates and commands
- **Diagnostics:** `sunrise check` to verify tool installation

Once you've run `sunrise init`, the slash commands (like `/sunrise.specify`, `/sunrise.design`, etc.) are **permanently installed** in your project's agent folder (`.claude/`, `.github/prompts/`, etc.). Your AI assistant reads these command files directly—no need to run `sunrise` again.

**If your agent isn't recognizing slash commands:**

1. **Verify command files exist:**

   ```bash
   # For GitHub Copilot
   ls -la .github/prompts/

   # For Claude
   ls -la .claude/commands/
   ```

2. **Restart your IDE/editor completely** (not just reload window)

3. **Check you're in the correct directory** where you ran `sunrise init`

4. **For some agents**, you may need to reload the workspace or clear cache

**Related issue:** If Copilot can't open local files or uses PowerShell commands unexpectedly, this is typically an IDE context issue, not related to `sunrise`. Try:

- Restarting VS Code
- Checking file permissions
- Ensuring the workspace folder is properly opened

---

## Version Compatibility

Hanoi Sunrise follows semantic versioning for major releases. The CLI and project files are designed to be compatible within the same major version.

**Best practice:** Keep both CLI and project files in sync by upgrading both together during major version changes.

---

## Next Steps

After upgrading:

- **Test new slash commands:** Run `/sunrise.set-ground-rules` or another command to verify everything works
- **Lint Markdown files:** Run `npx markdownlint-cli2 "**/*.md"` before committing
- **Review release notes:** Check [GitHub Releases](https://github.com/dauquangthanh/hanoi-sunrise/releases) for new features and breaking changes
- **Update workflows:** If new commands were added, update your team's development workflows
- **Check documentation:** Visit [https://dauquangthanh.github.io/hanoi-sunrise/](https://dauquangthanh.github.io/hanoi-sunrise/) for updated guides
