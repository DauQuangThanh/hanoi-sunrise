# Hanoi Sunrise - Agent Skills & Commands Framework

This repository provides a comprehensive framework for creating, managing, and deploying agent skills and commands. It includes a CLI tool for skill management, extensive documentation, and curated agent skills following the Agent Skills specification.

## Coding Guidelines

### General Standards

- **Always use all-lowercase file names** for skill references, templates, scripts, and assets
- Follow PEP 8 style guide for Python code
- Use type hints in Python code where applicable
- Write descriptive commit messages following conventional commits format

### Markdown Standards

- **Critical**: Always run `npx markdownlint-cli2 "**/*.md" --fix` for the changed markdown files before committing
- All Markdown files must pass linting without errors
- Use consistent heading hierarchy (single H1, then H2, H3, etc.)
- Keep line lengths reasonable for readability

### Skill and Command Development

- **Critical**: Use `agent-skill-creation` skill to validate when creating or updating Agent skills
- **Critical**: Use `agent-command-creation` skill to validate when creating or updating Agent commands
- All skills must follow the Agent Skills specification
- Skills must include SKILL.md with proper frontmatter
- Set author to 'Dau Quang Thanh' for all skills
- Set license to 'MIT' for all skills

## Resources & Tools

### MCP Servers

- Playwright MCP server (if configured)

## Key Workflows

### Creating a New Agent Skill

1. Use the `agent-skill-creation` skill for guidance
2. Create folder structure: `skills/skill-name/`
3. Add `SKILL.md` with proper frontmatter (author: Dau Quang Thanh, license: MIT)
4. Create subfolders: `references/`, `scripts/`, `templates/`
5. Lint markdown: `npx markdownlint-cli2 "**/*.md" --fix` for the markdown file in <SKILL_DIR>
6. Commit changes with descriptive message

### Creating a New Agent Command

1. Use the `agent-command-creation` skill for guidance
2. Follow the Agent Command Creation Rules
3. Create Markdown or TOML command file
4. Lint and validate before committing

## Important Notes

- This repository follows a strict convention for file naming (all-lowercase)
- Markdown linting is mandatory before any commit
- Always validate skills and commands using the respective validation skills
- The framework is designed for cross-platform compatibility
- Always create detailed plan with manage_todo_list before implementing changes
