# 💻 Local Development Guide

**Work on Sunrise CLI locally without publishing releases.**

> **Note:** Scripts are now Python-based for cross-platform compatibility. Always lint Markdown files before committing: `npx markdownlint-cli2 "**/*.md"`.

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/dauquangthanh/hanoi-sunrise.git
cd hanoi-sunrise

# Work on a feature branch
git checkout -b your-feature-branch
```

---

### 2. Run CLI Directly (Fastest Way)

Test your changes instantly without installing:

```bash
# From repository root
python -m src.sunrise_cli --help
python -m src.sunrise_cli init demo-project --ai claude --ignore-agent-tools

# Multiple AI agents (comma-separated)
python -m src.sunrise_cli init demo-project --ai claude,gemini,copilot

# Use local templates (no GitHub download)
python -m src.sunrise_cli init demo-project --ai claude --local-templates --template-path .
```

**Alternative:** Run the script directly (uses shebang):

```bash
python src/sunrise_cli/__init__.py init demo-project
```

---

### 3. Use Editable Install (Like Real Users)

Create an isolated environment that matches how users run Sunrise:

```bash
# Create virtual environment (uv manages .venv automatically)
uv venv

# Activate it
source .venv/bin/activate  # Linux/macOS
# or on Windows PowerShell:
.venv\Scripts\Activate.ps1

# Install in editable mode
uv pip install -e .

# Now use 'sunrise' command directly
sunrise --help
```

**Benefit:** No need to reinstall after code changes—it updates automatically!

### 4. Test with uvx (Simulate User Experience)

Test how users will actually run Sunrise:

**From local directory:**

```bash
uvx --from . sunrise init demo-uvx --ai copilot --ignore-agent-tools
```

**From a specific branch (without merging):**

```bash
# Push your branch first
git push origin your-feature-branch

# Test it
uvx --from git+https://github.com/dauquangthanh/hanoi-sunrise.git@your-feature-branch sunrise init demo-branch-test
```

#### Run from Anywhere (Absolute Path)

Use absolute paths when you're in a different directory:

```bash
uvx --from /mnt/c/GitHub/hanoi-sunrise sunrise --help
uvx --from /mnt/c/GitHub/hanoi-sunrise sunrise init demo-anywhere --ai copilot
```

**Make it easier with an environment variable:**

```bash
# Set once
export RAINBOW_SRC=/mnt/c/GitHub/hanoi-sunrise

# Use anywhere
uvx --from "$RAINBOW_SRC" sunrise init demo-env --ai copilot
```

**Or create a shell function:**

```bash
sunrise-dev() { uvx --from /mnt/c/GitHub/hanoi-sunrise sunrise "$@"; }

# Then just use
sunrise-dev --help
```

---

### 5. Check Script Files

After running `init`, verify Python scripts are present:

```bash
ls -l scripts | grep .py
# Expect: -rw-r--r-- (Python scripts don't need execute permissions)
```

> **Note:** Python scripts work cross-platform without special permissions.

---

### 6. Quick Sanity Check

Verify your code imports correctly:

```bash
python -c "import sunrise_cli; print('Import OK')"
```

---

### 7. Build a Wheel (Optional)

Test packaging before publishing:

```bash
uv build
ls dist/
```

Install the built wheel in a fresh environment if needed.

### 8. Use a Temporary Workspace

Test `init --here` without cluttering your repo:

```bash
mkdir /tmp/sunrise-test && cd /tmp/sunrise-test
python -m src.sunrise_cli init --here --ai claude --ignore-agent-tools
```

---

### 9. Debug Network Issues

Skip TLS validation during local testing (not for production!):

```bash
sunrise check --skip-tls
sunrise init demo --skip-tls --ai gemini --ignore-agent-tools
```

---

## 📁 Repository Structure

Understanding the Sunrise CLI repository layout:

```
hanoi-sunrise/
├── LICENSE                 # MIT license
├── pyproject.toml          # Python project configuration
├── README.md               # Main project documentation
├── agent-commands/         # Slash command definitions (copied to agent folders)
│   ├── set-ground-rules.md       # Project principles command
│   ├── specify.md          # Requirements command
│   ├── design.md           # Technical planning command
│   └── templates-for-commands/  # Reusable templates
├── docs/                   # Documentation site (DocFX)
│   ├── index.md
│   ├── installation.md
│   ├── local-development.md
│   ├── quickstart.md
│   ├── README.md
│   ├── toc.yml
│   └── upgrade.md
├── media/                  # Media assets
├── rules/                  # Agent creation rules
│   ├── agent-skills-creation-rules.md
│   ├── agent-skills-folder-mapping.md
│   ├── agents-creation-rules.md
│   └── agents-folder-mapping.md
├── scripts/                # Automation scripts (Python)
├── skills/                 # Reusable skill modules (copied to agent skills folders)
│   ├── bug-analysis/
│   ├── git-commit/
│   └── ... (additional skills)
├── src/sunrise_cli/        # CLI source code
└── .github/                # GitHub configurations
    ├── copilot-instructions.md  # Copilot guidelines
    └── workflows/          # CI/CD and release automation
```

**Note:** The `agent-commands/` and `skills/` folders are source templates. When you run `sunrise init`, these are copied into your project's agent-specific folders (`.claude/commands/`, `.github/agents/`, etc.).

---

## 🔄 Quick Reference

| What You Want | Command |
| --------------- | ---------- |
| **Run CLI directly** | `python -m src.sunrise_cli --help` |
| **Editable install** | `uv pip install -e .` then `sunrise ...` |
| **Local uvx (repo root)** | `uvx --from . sunrise ...` |
| **Local uvx (absolute path)** | `uvx --from /path/to/hanoi-sunrise sunrise ...` |
| **Test specific branch** | `uvx --from git+URL@branch sunrise ...` |
| **Build package** | `uv build` |
| **Clean up** | `rm -rf .venv dist build *.egg-info` |

---

## 🧹 Cleanup

Remove build artifacts and virtual environments:

```bash
rm -rf .venv dist build *.egg-info
```

---

## 🛠️ Common Issues

| Problem | Solution |
| --------- | ---------- |
| **`ModuleNotFoundError: typer`** | Run `uv pip install -e .` to install dependencies |
| **Git step skipped** | You passed `--no-git` or Git isn't installed |
| **TLS errors (corporate network)** | Try `--skip-tls` (not recommended for production) |

---

## 👉 Next Steps

1. **Test your changes** - Run through the Quick Start guide with your modified CLI
2. **Lint Markdown files** - Run `npx markdownlint-cli2 "**/*.md"` before committing
3. **Update docs** - Document any new features or changes
4. **Open a PR** - Share your improvements when ready
5. **Tag a release** - Once merged to `main`, follow the release process: create tag (e.g., `git tag -a v0.1.16 -m "Release version 0.1.16"`), push tag (`git push origin v0.1.16`). CI builds packages and creates GitHub release.

---

## 📚 Resources

- 📖 [Quick Start Guide](quickstart.md) - Test your changes end-to-end
- 🐛 [Report Issues](https://github.com/dauquangthanh/hanoi-sunrise/issues/new) - Found a bug?
- 💬 [Discussions](https://github.com/dauquangthanh/hanoi-sunrise/discussions) - Ask questions
