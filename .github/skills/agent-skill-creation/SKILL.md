---
name: agent-skill-creation
description: Generates and updates agent skills following the Agent Skills specification. Creates SKILL.md files with proper frontmatter, organizes supporting files, validates structure, and ensures cross-platform compatibility. Use when creating new agent skills, updating existing skills, converting documentation to skills format, or when user mentions agent skills, skill generation, or Agent Skills specification.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "2.0"
  last_updated: "2026-02-01"
---

# Agent Skill Creation

## Overview

This self-contained skill helps AI agents create and update agent skills that conform to the Agent Skills specification. It provides everything needed: instructions, templates, examples, validation rules, and scripts—all within this skill directory.

**Key Concept: Progressive Disclosure**
- **Tier 1** (Always loaded): Metadata (name + description) for discovery  
- **Tier 2** (On activation): This SKILL.md with instructions (<500 lines)
- **Tier 3** (On demand): references/, templates/, scripts/, assets/

## When to Use

- Creating new agent skills from scratch
- Converting existing documentation to agent skills format
- Updating or refactoring existing agent skills
- Validating skill structure and compliance
- Reviewing skills for quality and completeness
- When user requests "create a skill", "generate skill", or mentions Agent Skills specification

## What This Skill Does

1. **Generates SKILL.md files** with proper YAML frontmatter
2. **Organizes supporting files** into scripts/, references/, and assets/ directories
3. **Validates structure** against Agent Skills specification
4. **Ensures cross-platform compatibility** for Python scripts (3.8+)
5. **Writes effective descriptions** for skill discovery
6. **Keeps main file concise** (<500 lines) using progressive disclosure
7. **100% self-contained** - no external dependencies

## Prerequisites

- Understanding of target skill's domain and purpose
- Python 3.8+ for running validation scripts (optional)

## Core Instructions

### Quick Start: 5-Step Process

**Step 1: Gather Requirements**
1. What task or problem does it solve?
2. What specific actions can it perform?
3. When should agents activate this skill?
4. What keywords might users mention?

**Step 2: Choose Name & Write Description**
- Name: lowercase, hyphens only, 1-64 chars, matches directory
- Description formula: `[Actions]. Use when [scenarios] or when user mentions [keywords].`
- Length: 150-300 chars optimal (max 1024)

**Step 3: Generate Skill Structure (Automated)**
```bash
python3 scripts/generate-skill.py skill-name
```

**Step 4: Write SKILL.md**
- Generated automatically by script, but needs customization
- Include: Overview, When to Use, Prerequisites, Instructions, Examples, Edge Cases, Error Handling
- Keep under 500 lines

**Step 5: Validate**
```bash
python3 scripts/validate-skill.py ./skill-name
```

---

### Step 1: Understand Requirements

**Gather information about the skill:**

1. **Purpose**: What task or problem does it solve?
2. **Capabilities**: What specific actions can it perform?
3. **Use cases**: When should agents activate this skill?
4. **Keywords**: What terms might users mention?
5. **Dependencies**: Required tools, packages, or environment?

**Ask clarifying questions if needed:**
- "What specific capabilities should this skill have?"
- "Are there existing examples or documentation to reference?"
- "What platforms should scripts support?"

### Step 2: Choose Skill Name

**Naming rules (CRITICAL):**

✅ **Valid**: lowercase letters (a-z), numbers (0-9), hyphens (-)  
❌ **Invalid**: uppercase, underscores, spaces, leading/trailing hyphens, consecutive hyphens (--)  
📏 **Length**: 1-64 characters  
🔗 **Must match**: Directory name

**Examples:**
- ✅ `pdf-processing`, `code-review`, `api-documentation`
- ❌ `PDF-Processing` (uppercase), `pdf_processing` (underscore), `pdf processing` (space), `-pdf` (leading hyphen)

### Step 3: Write Description

**Use the 3-part formula:**

```
[What it does] + [When to use] + [Keywords for matching]
```

**Template:**
```yaml
description: "[ACTION 1], [ACTION 2], and [ACTION 3]. Use when [SCENARIO 1], [SCENARIO 2], or when user mentions [KEYWORD 1], [KEYWORD 2], or [KEYWORD 3]."
```

**Requirements:**
- Length: 150-300 characters optimal (max 1024)
- Include 2-4 specific actions (active verbs)
- Include 2-3 use cases starting with "Use when..."
- Include 3-5 keywords users might mention
- Be specific, not vague

**Example:**
```yaml
description: "Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents, extracting form data, or when user mentions PDFs, forms, or document extraction."
```

**Bad Example:**
```yaml
description: "Helps with PDFs."  # Too vague, missing use cases and keywords
```

### Step 4: Generate Skill Structure

**Use the generator script (Recommended):**
```bash
python3 scripts/generate-skill.py skill-name
```
This will create the directory, `SKILL.md` with frontmatter, and a sample script.

**Manual creation (Fallback):**

**Minimal structure (always required):**
```
skill-name/
└── SKILL.md
```

**Full structure (when needed):**
```
skill-name/
├── SKILL.md                     # Core skill definition (<500 lines)
├── scripts/                     # Python 3.8+ automation
│   ├── process.py
│   └── validate.py
├── references/                  # Detailed documentation
│   ├── best-practices.md
│   ├── advanced-patterns.md
│   └── troubleshooting.md
├── templates/                   # Ready-to-use files
│   ├── skill-template.md
│   └── script-template.py
└── assets/                      # Static resources
    ├── examples/               # Complete example skills
    └── checklists/            # Validation checklists
```

**When to add optional directories:**
- `scripts/`: If skill needs automated processing or validation
- `references/`: If SKILL.md would exceed 500 lines
- `templates/`: If skill provides reusable templates
- `assets/`: If skill needs examples, checklists, images, or data files

### Step 5: Write SKILL.md

**Required YAML frontmatter:**
```yaml
---
name: skill-name                    # Required: matches directory, lowercase, hyphens only
description: "[Actions]. Use when..." # Required: 1-1024 chars (150-300 optimal)
license: MIT                         # Optional but recommended
metadata:                            # Optional
  author: Your Name
  version: "1.0"
  last_updated: "2026-02-01"
---
```

**Required sections:**

1. **# Skill Name** - Title matching the skill name
2. **## Overview** - 2-3 sentences explaining what the skill does
3. **## When to Use** - Bullet list of 3-5 specific scenarios
4. **## Prerequisites** - Required tools, packages, versions (or "None")
5. **## Instructions** - Step-by-step with numbered sections, code examples
6. **## Examples** - At least 2 examples with input/output
7. **## Edge Cases** - 2-3 unusual situations and handling
8. **## Error Handling** - Common errors and solutions

**Optional sections:**
- **## Scripts** - Usage of automation scripts (if using scripts/)
- **## References** - Links to detailed documentation (if using references/)
- **## Validation** - How to validate usage

**Key requirements:**
- Keep under 500 lines total
- Use clear, imperative language
- Provide concrete examples
- Document assumptions
- Include error handling guidance

### Step 6: Write Scripts (If Needed)

**Use Python 3.8+ for cross-platform compatibility:**

```python
#!/usr/bin/env python3
"""
Script description.

Usage: python3 scripts/script.py <input> [--option value]
Platforms: Windows, macOS, Linux
Requirements: Python 3.8+
"""

import sys
from pathlib import Path

def main():
    if len(sys.argv) < 2:
        print("Usage: script.py <input>", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    if not input_path.exists():
        print(f"Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    print(f"Processing {input_path}...")
    # Your logic here
    print("Done!")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nCancelled", file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
```

**Key requirements:**
- Use `pathlib` for cross-platform paths (not hardcoded `/` or `\`)
- Clear error messages with proper exit codes
- Usage documentation in docstring
- Test on Windows, macOS, Linux

### Step 7: Create References (If Needed)

**When to use references/:**
- SKILL.md exceeds 400 lines
- Detailed technical documentation needed
- Multiple complex topics to cover
- Large examples or data

**Keep references focused:**
- One topic per file
- Clear headings
- Concrete examples
- Referenced from SKILL.md

### Step 8: Validate

**Manual validation checklist:**
- [ ] Name follows rules (lowercase, hyphens only, 1-64 chars)
- [ ] Name matches directory name exactly
- [ ] Description includes actions, use cases, keywords (150-300 chars optimal)
- [ ] SKILL.md has valid YAML frontmatter
- [ ] Required fields present (name, description)
- [ ] SKILL.md is under 500 lines
- [ ] Instructions are clear and specific
- [ ] At least 2 examples with input/output
- [ ] Edge cases documented
- [ ] Error handling included
- [ ] Scripts are cross-platform Python 3.8+ (if present)
- [ ] File references use forward slashes
- [ ] No external references (no /rules/, no https:// external links)

**Automated validation:**
```bash
python3 scripts/validate-skill.py ./skill-name
```

**Quick validation commands:**
```bash
# Count lines
wc -l skill-name/SKILL.md

# Check name format
echo "skill-name" | grep -E '^[a-z0-9]+(-[a-z0-9]+)*$'

# Check for external references  
grep -n "https://" skill-name/SKILL.md
grep -n "/rules/" skill-name/SKILL.md
```

## Examples

### Example 1: Minimal Skill - Code Review

**Directory structure:**
```
code-review/
└── SKILL.md (with frontmatter, instructions, examples)
```

**Key elements:** Clear description, step-by-step instructions, concrete examples

### Example 2: Skill with Scripts - CSV Processing

**Directory structure:**
```
csv-processing/
├── SKILL.md
└── scripts/convert.py, validate.py
```

**Key elements:** Python 3.8+ scripts, usage instructions, error handling

### Example 3: Complex Skill - This Skill

**Directory structure:**
```
agent-skill-creation/
├── SKILL.md (<500 lines)
├── scripts/validate-skill.py
├── references/ (detailed guidance)
├── templates/ (ready-to-use)
└── assets/ (examples, checklists)
```

See [assets/examples/](assets/examples/) for complete working examples and [references/advanced-patterns.md](references/advanced-patterns.md) for more patterns.

## Edge Cases

### Case 1: Large Documentation (2000+ lines)
**Handling**: Extract core instructions for SKILL.md (<500), move details to references/, link from main file

### Case 2: Platform-Specific Requirements
**Handling**: Use Python with `platform.system()` detection, document in Prerequisites, test all platforms

### Case 3: Complex Dependencies
**Handling**: List in Prerequisites with versions, provide install commands, create validation script

### Case 4: No Clear Keywords
**Handling**: Include synonyms, problem symptoms, technical and non-technical terms in description

For detailed edge case handling, see [references/troubleshooting.md](references/troubleshooting.md)

## Error Handling

### Invalid Skill Name
**Solution**: Convert to lowercase, replace spaces/underscores with hyphens, validate with `grep -E '^[a-z0-9]+(-[a-z0-9]+)*$'`

### Description Too Vague
**Solution**: Add 2-4 action verbs, "Use when..." scenarios, 3-5 keywords, aim for 150-300 chars

### SKILL.md Too Long (>500 lines)
**Solution**: Move detailed content to references/, keep essential instructions in main file

### Missing Required Fields
**Solution**: Add name and description to frontmatter, validate YAML syntax (spaces, not tabs)

### Script Not Cross-Platform
**Solution**: Use Python 3.8+, use `pathlib.Path` for paths, test on Windows/macOS/Linux

### External References
**Solution**: Copy content into skill directory (references/ or assets/), use relative paths

For comprehensive error handling, see [references/troubleshooting.md](references/troubleshooting.md)

## Quality Checklist

**Before finalizing, verify:**

**Structure:**
- [ ] Name matches directory (lowercase, hyphens only, 1-64 chars)
- [ ] Valid YAML frontmatter with required fields (name, description)
- [ ] SKILL.md under 500 lines
- [ ] Self-contained (no dependencies on external files outside skill directory)

**Content:**
- [ ] Description is comprehensive (actions + use cases + keywords, 150-300 chars)
- [ ] Clear instructions with step-by-step guidance
- [ ] At least 2 examples with input/output
- [ ] Edge cases documented (2-3 minimum)
- [ ] Error handling included with solutions

**Scripts (if present):**
- [ ] Python 3.8+ for cross-platform support
- [ ] Usage documentation in docstring
- [ ] Error messages are clear
- [ ] Tested on Windows, macOS, Linux
- [ ] Uses `pathlib` for paths

**References (if present):**
- [ ] Referenced from SKILL.md
- [ ] One topic per file
- [ ] Clear structure with headings

## Resources

This skill includes comprehensive self-contained resources:

- **[references/best-practices.md](references/best-practices.md)** - Advanced skill creation guidance
- **[references/advanced-patterns.md](references/advanced-patterns.md)** - Complex skill patterns and techniques
- **[references/troubleshooting.md](references/troubleshooting.md)** - Detailed error handling and debugging
- **[templates/skill-template.md](templates/skill-template.md)** - Complete SKILL.md template
- **[templates/script-template.py](templates/script-template.py)** - Cross-platform Python script template
- **[templates/frontmatter-examples.yaml](templates/frontmatter-examples.yaml)** - Frontmatter samples with validation
- **[assets/examples/](assets/examples/)** - Complete working example skills
- **[assets/checklists/](assets/checklists/)** - Comprehensive validation checklists
- **[scripts/generate-skill.py](scripts/generate-skill.py)** - Automated skill generator
- **[scripts/validate-skill.py](scripts/validate-skill.py)** - Automated validation script

## Tips for Success

1. **Start simple**: Minimal structure first, add complexity only if needed
2. **Be specific**: Concrete examples over abstract descriptions
3. **Test early**: Validate as you build, don't wait until the end
4. **Focus on discovery**: Description is critical for skill activation
5. **Think progressive**: Keep SKILL.md concise, use references/ for details
6. **Stay self-contained**: No external dependencies outside skill directory
7. **Use templates**: Start with templates/skill-template.md
8. **Validate often**: Run validation after each major change

---

**Version**: 2.0  
**Last Updated**: 2026-02-01  
**Author**: Dau Quang Thanh  
**License**: MIT
