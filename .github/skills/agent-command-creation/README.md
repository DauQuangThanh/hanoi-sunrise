# Agent Command Creation

Creates and updates agent **commands** (slash commands/prompts) for agentic platforms like Claude Code, GitHub Copilot, Cursor, Windsurf, Gemini CLI, and 21+ other AI development tools.

## Important Distinction

- **This skill**: Creates agent **COMMANDS** (`.claude/commands/`, `.github/prompts/`, etc.)
- **Different skill**: For creating agent **SKILLS** (SKILL.md files), use `agent-skill-creation` instead

**What are commands?**

- Platform-specific instructions or prompts
- Invoked as slash commands (e.g., `/analyze`, `/implement`)
- Simple Markdown or TOML files with instructions
- Located in `commands/` or `prompts/` folders

**What are skills?** (Not created by this skill)

- Self-contained capability packages
- Have YAML frontmatter with `name:` and `description:` fields
- Can include scripts, references, and assets
- Located in `skills/` folders

## Quick Start

This skill enables AI agents to:

- Create new agent commands with proper structure
- Update existing commands while maintaining consistency
- Generate cross-platform scripts (Bash, PowerShell, Python)
- Validate command structure against platform requirements
- Support multiple formats: Markdown (.md), TOML (.toml), MDC (.mdc)

## Supported Platforms

- **Claude Code** (`.claude/commands/`)
- **GitHub Copilot** (`.github/agents/`, `.github/prompts/`)
- **Cursor** (`.cursor/commands/`, `.cursor/rules/`)
- **Windsurf** (`.windsurf/workflows/`, `.windsurf/rules/`)
- **Gemini CLI** (`.gemini/commands/`)
- **Qwen Code** (`.qwen/commands/`)
- **Google Antigravity** (`.agent/rules/`, `.agent/skills/`)
- And 12 more platforms...

## Usage

The AI agent will automatically use this skill when you request agent command creation or updates.

### Example Requests

```
"Create a Claude Code command that reviews pull requests"
"Convert this Cursor command to work with GitHub Copilot"
"Generate a Gemini CLI command for security analysis"
"Create a slash command for Windsurf that generates unit tests"
```

## Structure

```
agent-command-creation/
├── SKILL.md                    # Main skill instructions
├── README.md                   # This file
├── references/                 # Reference documentation
│   ├── platform-matrix.md      # Platform support matrix
│   ├── argument-syntax-guide.md # Argument syntax reference
│   ├── best-practices.md       # Best practices guide
│   └── cross-platform-scripts.md # Cross-platform development guide
├── scripts/                    # Helper scripts
│   ├── init-agent.sh          # Bash script (macOS/Linux)
│   └── init-agent.ps1         # PowerShell script (Windows)
└── templates/                  # Command templates
    ├── analysis-command.md
    ├── implementation-command.md
    ├── validation-command.md
    ├── copilot-slash-command.md
    └── gemini-command.toml
```

## Key Features

### Format Support

- **Markdown** (.md): Used by most platforms
- **TOML** (.toml): Used by Gemini CLI and Qwen Code
- **MDC** (.mdc): Used by Cursor for advanced rules

### Argument Syntax

The skill automatically uses the correct argument syntax for each platform:

- **Markdown-based**: `$ARGUMENTS`
- **TOML-based**: `{{args}}`
- **Script paths**: `{SCRIPT}`

### Validation

Every generated command is validated against:

- Platform-specific requirements
- Naming conventions
- Structure completeness
- Best practices compliance

## References

- [agents-creation-rules.md](../../rules/agents-creation-rules.md): Complete specification
- [agents-folder-mapping.md](../../rules/agents-folder-mapping.md): Platform folders
- [SKILL.md](SKILL.md): Full skill documentation

## License

MIT License - See [LICENSE](../../LICENSE)

## Author

Dau Quang Thanh
