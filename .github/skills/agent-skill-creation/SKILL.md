---
name: agent-skill-creation
description: Creates new agent skills following the Agent Skills specification with proper structure, frontmatter, and cross-platform scripts. Use when creating new skills, scaffolding skill directories, or when user mentions agent skills, skill creation, or SKILL.md generation.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-28"
---

# Agent Skill Creation

## When to Use

Use this skill when:

- Creating a new agent skill from scratch
- Scaffolding a skill directory structure
- Generating SKILL.md files with proper frontmatter
- Setting up cross-platform scripts for skills
- Validating skill structure and content
- Converting existing documentation into agent skills

## Prerequisites

- Bash (macOS/Linux) or PowerShell (Windows)
- Text editor or IDE
- Basic understanding of Markdown
- Git (recommended for version control)

## Instructions

### Step 1: Plan Your Skill

Before creating a skill, identify:

1. **Purpose**: What specific task or domain does this skill address?
2. **Capabilities**: What concrete actions can the skill perform?
3. **Use Cases**: When should an agent activate this skill?
4. **Keywords**: What terms might users mention that should trigger this skill?
5. **Dependencies**: What tools, packages, or resources are required?

### Step 2: Choose a Valid Skill Name

The skill name must follow these rules:

- Only lowercase letters (a-z), numbers (0-9), and hyphens (-)
- Cannot start or end with a hyphen
- No consecutive hyphens
- Must be 1-64 characters
- No underscores or spaces

**Valid Examples:**

- `pdf-processing`
- `data-analysis`
- `code-review`
- `api-documentation-generator`

**Invalid Examples:**

- `PDF-Processing` (uppercase not allowed)
- `-pdf` (cannot start with hyphen)
- `pdf__processing` (underscores not allowed)
- `pdf--processing` (consecutive hyphens not allowed)

### Step 3: Write a Comprehensive Description

**CRITICAL:** The description field is the ONLY information agents have during skill discovery. Poor description = skill never activated.

Use the formula: **[What it does] + [When to use it] + [Key terms]**

**Optimal Length:** 150-300 characters (use the full 1-1024 limit when needed for better matching)

Template:

```
[ACTION 1], [ACTION 2], and [ACTION 3]. Use when [SCENARIO 1], [SCENARIO 2], or when user mentions [KEYWORD 1], [KEYWORD 2], or [KEYWORD 3].
```

**Good Examples:**

```yaml
# Specific capabilities + use cases + keywords (optimal)
description: "Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when user mentions PDFs, forms, or document extraction."

# Analysis skill with clear triggers
description: "Analyzes code for security vulnerabilities, including SQL injection, XSS, and authentication issues. Use when reviewing code security, conducting security audits, or when user mentions vulnerabilities or security concerns."

# Workflow skill with scenario-based triggers
description: "Guides through complete deployment process including testing, building, and deploying applications. Use for application deployments, CI/CD workflows, or when user mentions deploy, release, or production deployment."
```

**Poor Examples:**

```yaml
# Too vague
description: "Helps with documents"  # Missing: what, when, keywords

# Too short
description: "PDF tool"  # No use cases or keywords

# Too technical without context
description: "Uses PyPDF2 to process files"  # Focus on what, not how
```

### Step 4: Create Directory Structure

**Minimal Structure:**

```
skill-name/
└── SKILL.md
```

**Full Structure:**

```
skill-name/
├── SKILL.md              # Required: Core skill definition
├── scripts/              # Optional: Executable code
│   ├── process.sh       # macOS/Linux
│   └── process.ps1      # Windows
├── references/           # Optional: Additional documentation
│   ├── detailed-guide.md
│   └── examples.md
├── templates/            # Optional: Templates
│   └── output-template.md
└── assets/               # Optional: Static resources
    └── config.json
```

### Step 5: Generate SKILL.md with Frontmatter

Create SKILL.md with this structure:

```markdown
---
name: skill-name
description: "Comprehensive description following the formula"
license: MIT
metadata:
  author: Your Name
  version: "1.0.0"
  last-updated: "2026-01-28"
---

# Skill Name

## When to Use
- [Scenario 1]
- [Scenario 2]
- [Scenario 3]

## Prerequisites
- [Required tool 1]
- [Required tool 2]

## Instructions

### Step 1: [Action Name]
[Detailed instructions]

### Step 2: [Action Name]
[Detailed instructions]

## Examples

**Input:**
```

[example input]

```

**Output:**
```

[example output]

```

## Edge Cases

- **Case 1**: [Description and handling]
- **Case 2**: [Description and handling]

## Error Handling

- **Error Type**: [Resolution steps]

## Scripts

If applicable:

**Bash (macOS/Linux):**
```bash
./scripts/process.sh --input data.csv
```

**PowerShell (Windows):**

```powershell
.\scripts\process.ps1 -Input data.csv
```

## Additional Resources

- See [references/detailed-guide.md](references/detailed-guide.md) for more information

```

### Step 6: Add Cross-Platform Scripts (If Needed)

**Recommended Approach:** Use Python or Node.js for true cross-platform compatibility.

**Quick Example (Python):**
```python
#!/usr/bin/env python3
import sys
from pathlib import Path

def main():
    if len(sys.argv) < 2:
        print("Usage: python process.py <input-file>", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    if not input_path.exists():
        print(f"Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    print(f"Processing: {input_path}")
    # Your logic here

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
```

**Alternative:** Provide both Bash and PowerShell versions. See [references/cross-platform-scripts.md](references/cross-platform-scripts.md) for complete templates and best practices.

### Step 7: Add References (For Complex Topics)

Keep SKILL.md under 500 lines. Move detailed content to `references/`:

```
references/
├── detailed-guide.md     # In-depth explanations
├── api-reference.md      # Technical specifications
├── examples.md           # Extended examples
└── troubleshooting.md    # Common issues
```

### Step 8: Validate Your Skill

**Recommended: Use skills-ref validation tool**

```bash
# Install skills-ref (if not already installed)
npm install -g @agentskills/skills-ref

# Validate a single skill
skills-ref validate ./skill-name

# Validate all skills in a directory
skills-ref validate ./skills/
```

**Alternative: Use local validation scripts**

**Bash (macOS/Linux):**

```bash
./scripts/validate-skill.sh ./skills/skill-name
```

**PowerShell (Windows):**

```powershell
.\scripts\validate-skill.ps1 -Path .\skills\skill-name
```

**Validation Checks:**

- SKILL.md frontmatter is valid YAML
- Required fields present (name, description)
- Field constraints met (length, format, character restrictions)
- Name matches directory
- Name format follows rules (lowercase, hyphens, no consecutive hyphens)
- No uppercase letters, underscores, or spaces in name
- File structure is correct
- Description includes actions, use cases, and keywords

**Manual Validation Checklist:**

- [ ] Name is lowercase with hyphens only
- [ ] Description includes what, when, and keywords
- [ ] SKILL.md frontmatter is valid YAML
- [ ] Required fields present (name, description)
- [ ] Name matches directory name
- [ ] File structure follows specification
- [ ] Scripts tested on target platforms
- [ ] All file references are correct
- [ ] No broken links

### Step 9: Test the Skill

1. **Load test**: Place skill in agent's skill directory
2. **Discovery test**: Use keywords from description to verify activation
3. **Execution test**: Follow instructions to complete a task
4. **Cross-platform test**: Test scripts on Windows, macOS, and Linux
5. **Error handling test**: Verify edge cases are handled properly

### Step 10: Document and Deploy

1. Add to version control
2. Write changelog
3. Update team documentation
4. Deploy to appropriate skill directory (see [references/deployment-guide.md](references/deployment-guide.md))
5. Share with relevant stakeholders
6. Monitor usage and gather feedback

## Deployment

Deploy your skill to platform-specific directories. See [references/deployment-guide.md](references/deployment-guide.md) for complete platform mapping and deployment instructions.

**Quick Reference:**

```bash
# GitHub Copilot (project-level)
cp -r my-skill .github/skills/

# Cursor (global)
cp -r my-skill ~/.cursor/rules/

# Claude Code (project-level)
cp -r my-skill .claude/skills/
```

**Progressive Disclosure:**

Agents use a three-tier loading strategy:

- **Tier 1:** Metadata only (name + description) - Always loaded
- **Tier 2:** SKILL.md body - Loaded when skill activates
- **Tier 3:** References and scripts - Loaded on demand

**Impact:** Keep SKILL.md under 500 lines. The `description` field is the ONLY information agents see during discovery.

See [references/progressive-disclosure.md](references/progressive-disclosure.md) for detailed explanation.

## Examples

### Example 1: Simple Analysis Skill

**Input:** Create a skill for analyzing JSON files

**Generated Structure:**

```
json-analyzer/
├── SKILL.md
└── scripts/
    ├── analyze.sh
    └── analyze.ps1
```

**SKILL.md:**

```markdown
---
name: json-analyzer
description: "Analyzes JSON files for structure, validates schema, and reports errors. Use when working with JSON data, validating JSON structure, or when user mentions JSON analysis or validation."
license: MIT
metadata:
  author: Your Name
  version: "1.0.0"
---

# JSON Analyzer

## When to Use
- Validating JSON file structure
- Analyzing JSON schemas
- Detecting JSON formatting issues

## Instructions

### Step 1: Load JSON File
Read the JSON file and parse contents.

### Step 2: Validate Structure
Check for:
- Valid JSON syntax
- Required fields present
- Data type consistency

### Step 3: Generate Report
Report findings including:
- Schema structure
- Validation errors
- Recommendations

## Scripts

**Bash:**
```bash
./scripts/analyze.sh --input data.json
```

**PowerShell:**

```powershell
.\scripts\analyze.ps1 -Input data.json
```

```

### Example 2: Workflow Skill with Templates

**Input:** Create a skill for code review workflow

**Generated Structure:**
```

code-review-workflow/
├── SKILL.md
├── templates/
│   ├── review-checklist.md
│   └── review-report.md
└── references/
    └── review-guidelines.md

```

## Edge Cases

### Case 1: Skill Name Already Exists
- **Handling**: Check for existing skills with the same name
- **Action**: Choose a more specific name or version the existing skill

### Case 2: Dependencies Not Available
- **Handling**: Document all dependencies in Prerequisites section
- **Action**: Provide installation instructions or alternative approaches

### Case 3: Platform-Specific Requirements
- **Handling**: Provide both Bash and PowerShell script versions
- **Action**: Test scripts on both Unix-like systems and Windows

### Case 4: Large Reference Documents
- **Handling**: Keep SKILL.md under 500 lines
- **Action**: Move detailed content to `references/` directory

## Error Handling

### Error: Invalid Skill Name
- **Message**: "Skill name must be lowercase with hyphens only"
- **Action**: Rename skill following naming rules

### Error: Missing Required Fields
- **Message**: "Missing required frontmatter field: description"
- **Action**: Add all required fields (name, description)

### Error: Description Too Short
- **Message**: "Description must be 1-1024 characters"
- **Action**: Expand description with what, when, and keywords

### Error: SKILL.md Too Large
- **Message**: "SKILL.md exceeds 500 lines"
- **Action**: Move detailed content to `references/` directory

## Scripts

### Generation Scripts

**Bash (macOS/Linux):**
```bash
./scripts/generate-skill.sh --name skill-name --description "Skill description"
./scripts/generate-skill.sh --name skill-name --description "Skill description" --author "Your Name" --full
```

**PowerShell (Windows):**

```powershell
.\scripts\generate-skill.ps1 -Name skill-name -Description "Skill description"
.\scripts\generate-skill.ps1 -Name skill-name -Description "Skill description" -Author "Your Name" -Full
```

### Validation Scripts

**Bash (macOS/Linux):**

```bash
./scripts/validate-skill.sh ./skills/skill-name
```

**PowerShell (Windows):**

```powershell
.\scripts\validate-skill.ps1 -Path .\skills\skill-name
```

## Guidelines

1. **Start Simple**: Begin with minimal structure, add complexity as needed
2. **Test Early**: Validate frequently during development
3. **Document Thoroughly**: Clear instructions prevent confusion
4. **Think Cross-Platform**: Provide Python/Node.js scripts or both Bash and PowerShell
5. **Optimize Description**: This is the ONLY field used for skill discovery (150-300 chars optimal)
6. **Follow Conventions**: Consistent structure helps agents and users
7. **Version Control**: Track changes and maintain changelog
8. **Gather Feedback**: Learn from users and iterate
9. **Progressive Disclosure**: Keep SKILL.md under 500 lines, use references/ for details
10. **Validate Before Deploy**: Always run validation before committing

## CI/CD Integration

Integrate skill validation into your development workflow to catch errors early:

**Pre-commit Hook:**

```bash
#!/bin/bash
# .git/hooks/pre-commit
echo "Validating skills..."
skills-ref validate ./skills/ || exit 1
```

**GitHub Actions:**

```yaml
name: Validate Skills
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install -g @agentskills/skills-ref
      - run: skills-ref validate ./skills/
```

See project documentation for additional CI/CD examples.

## Quality Checklist

Before finalizing your skill:

### Structure & Format

- [ ] Name follows lowercase-with-hyphens convention
- [ ] Name matches directory name exactly
- [ ] SKILL.md has valid YAML frontmatter
- [ ] All required fields present (name, description)
- [ ] SKILL.md is under 500 lines (~5000 tokens)
- [ ] File structure follows specification

### Description Quality

- [ ] Description includes actions, use cases, and keywords
- [ ] Description is 150-300 characters (optimal for discovery)
- [ ] Description answers: What does it do?
- [ ] Description answers: When to use it?
- [ ] Description includes keywords users might mention

### Content Quality

- [ ] Instructions are clear and actionable
- [ ] Examples show concrete inputs and outputs
- [ ] Edge cases documented with handling
- [ ] Error handling guidance provided
- [ ] Prerequisites clearly listed
- [ ] All file references are correct and working

### Cross-Platform Support

- [ ] Scripts are cross-platform (Python/Node.js) OR
- [ ] Both Bash and PowerShell versions provided
- [ ] Scripts tested on Windows (if applicable)
- [ ] Scripts tested on macOS (if applicable)
- [ ] Scripts tested on Linux (if applicable)
- [ ] Path handling works across platforms
- [ ] Line endings configured correctly (.gitattributes)

### Validation & Testing

- [ ] Validated with skills-ref tool
- [ ] No validation errors or warnings
- [ ] Tested with target agent(s)
- [ ] Skills discovered correctly by agent
- [ ] Skills activated on appropriate keywords
- [ ] Scripts execute without errors

### Deployment

- [ ] Deployed to correct platform directory
- [ ] Added to version control
- [ ] Team documentation updated
- [ ] Changelog maintained

## Additional Resources

### Core References

- [references/agent-skills-specification.md](references/agent-skills-specification.md) - Complete Agent Skills specification with rules and best practices
- [references/deployment-guide.md](references/deployment-guide.md) - Platform-specific deployment directories for all AI tools
- [references/progressive-disclosure.md](references/progressive-disclosure.md) - Understanding the three-tier loading strategy
- [references/cross-platform-scripts.md](references/cross-platform-scripts.md) - Complete guide to cross-platform script development

### Quick Start

- [references/quickstart-guide.md](references/quickstart-guide.md) - 5-minute skill creation guide with examples

### Templates

- [templates/skill-template.md](templates/skill-template.md) - Ready-to-use SKILL.md template

### Scripts

- [scripts/generate-skill.sh](scripts/generate-skill.sh) - Bash script to generate new skill scaffolding (macOS/Linux)
- [scripts/generate-skill.ps1](scripts/generate-skill.ps1) - PowerShell script to generate new skill scaffolding (Windows)
- [scripts/validate-skill.sh](scripts/validate-skill.sh) - Bash script to validate skill structure (macOS/Linux)
- [scripts/validate-skill.ps1](scripts/validate-skill.ps1) - PowerShell script to validate skill structure (Windows)
