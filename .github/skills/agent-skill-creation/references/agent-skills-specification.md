# Agent Skills Specification Reference

## Overview

Agent Skills are self-contained folders containing instructions, scripts, and resources that AI agents can discover and use to perform specialized tasks accurately and efficiently.

## Core Principles

### 1. Progressive Disclosure

Load only what's needed, when it's needed:

**Three-Tier Loading:**

- **Tier 1 (Metadata)**: Always loaded - name + description only (~100 tokens/skill)
- **Tier 2 (Instructions)**: Loaded on activation - full SKILL.md body (<5000 tokens)
- **Tier 3 (Resources)**: Loaded on demand - scripts/, references/, assets/

**Why It Matters:**

- 200 skills without progressive disclosure: 1,000,000 tokens (OVERFLOW)
- 200 skills with progressive disclosure: 20,000 tokens discovery + 5,000 tokens active = 25,000 tokens (OPTIMAL)

**Rule**: Keep SKILL.md under 500 lines (~5000 tokens). Move details to references/.

### 2. Self-Contained Design

- Explicit dependencies
- Portable across platforms
- Version-controlled
- Independently testable
- Simple deployment

### 3. Clear Communication

- Explicit over implicit
- Actionable error messages
- Document edge cases
- Consistent terminology
- Concrete examples

## Directory Structure

### Minimal (Required)

```
skill-name/
└── SKILL.md          # Required: Core skill definition
```

### Complete (With Optional Directories)

```
skill-name/
├── SKILL.md              # Required: Core skill definition
├── scripts/              # Optional: Executable code
│   ├── script-name.py   # Cross-platform (recommended)
│   ├── script-name.sh   # Unix-like systems
│   └── script-name.ps1  # Windows
├── references/           # Optional: Additional documentation
│   ├── guide.md
│   └── api-reference.md
├── templates/            # Optional: File templates
│   └── template.md
└── assets/               # Optional: Static resources
    └── config.json
```

## SKILL.md Format

### Frontmatter (YAML)

```yaml
---
name: skill-name              # Required: 1-64 chars, lowercase, hyphens only
description: "[Actions]. Use when [scenarios] or when user mentions [keywords]."  # Required: 1-1024 chars
license: MIT                  # Optional
compatibility: Requires...    # Optional
metadata:                     # Optional
  author: Name
  version: "1.0.0"
allowed-tools: Bash(git:*)    # Optional, experimental
---
```

### Required Fields

#### name

- **Format**: 1-64 characters
- **Rules**:
  - Only lowercase letters (a-z), numbers (0-9), hyphens (-)
  - Cannot start or end with hyphen
  - No consecutive hyphens (--)
  - Must match parent directory name

**Valid**: `pdf-processing`, `data-analysis`, `code-review`
**Invalid**: `PDF-Processing`, `-pdf`, `pdf--processing`, `pdf_processing`

#### description

- **Format**: 1-1024 characters
- **Optimal**: 150-300 characters
- **Purpose**: Helps agents decide when to activate the skill
- **Must Include**:
  - What the skill does (2-4 actions)
  - When to use it (2-3 scenarios)
  - Keywords for matching (3-5 terms)

**Template**:

```
[ACTION 1], [ACTION 2], and [ACTION 3]. Use when [SCENARIO 1], [SCENARIO 2], or when user mentions [KEYWORD 1], [KEYWORD 2], or [KEYWORD 3].
```

**Good Example**:

```yaml
description: "Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when user mentions PDFs, forms, or document extraction."
```

**Poor Example**:

```yaml
description: "Helps with PDFs."  # Too vague, missing use cases and keywords
```

### Optional Fields

#### license

Short license name or reference.

```yaml
license: MIT
license: Apache-2.0
```

#### compatibility

Indicate specific environment requirements (1-500 chars). Only include if skill has specific requirements.

```yaml
compatibility: Requires Python 3.8+, pandas, and internet access
```

#### metadata

Key-value map for additional properties.

```yaml
metadata:
  author: Your Name
  version: "1.0.0"
  category: document-processing
  last-updated: "2026-01-28"
```

#### allowed-tools

**Experimental** - Pre-approved tools the skill may use. Support varies by implementation.

```yaml
allowed-tools: Bash(git:*) Bash(jq:*) Read
```

### Body Content

Markdown content after frontmatter. No strict format, but recommended sections:

1. **When to Use** - Specific scenarios for activation
2. **Prerequisites** - Required tools, packages, setup
3. **Instructions** - Step-by-step guidance
4. **Examples** - Input/output samples
5. **Edge Cases** - Common pitfalls and handling
6. **Error Handling** - How to handle failures
7. **Scripts** - Usage instructions for scripts
8. **Additional Resources** - References to other files

**Best Practices**:

- Keep under 500 lines
- Use clear, imperative language
- Provide concrete examples
- Document assumptions
- Reference detailed docs in references/

## Cross-Platform Scripts

### Recommended: Use Python or Node.js

Single file works on all platforms:

```python
#!/usr/bin/env python3
"""
Script description (cross-platform).

Usage: python script.py <input>

Platforms: Windows, macOS, Linux
Requirements: Python 3.8+
"""
import sys
from pathlib import Path

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <input>", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    if not input_path.exists():
        print(f"Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    # Your logic here
    print(f"Processing: {input_path}")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
```

### Alternative: Provide Both Bash and PowerShell

**Bash (script-name.sh)**:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <input>" >&2
    exit 1
fi

INPUT="$1"
if [ ! -f "$INPUT" ]; then
    echo "Error: File not found: $INPUT" >&2
    exit 1
fi

echo "Processing: $INPUT"
# Your logic here
```

**PowerShell (script-name.ps1)**:

```powershell
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Input
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $Input)) {
    Write-Error "File not found: $Input"
    exit 1
}

Write-Host "Processing: $Input"
# Your logic here
```

### Script Guidelines

- Be self-contained or document dependencies clearly
- Include helpful error messages
- Handle edge cases gracefully
- Add usage comments at the top
- Make Unix scripts executable: `chmod +x script.sh`
- Use meaningful filenames with proper extensions

### Naming Conventions

- Bash: `script-name.sh`
- PowerShell: `script-name.ps1`
- Python: `script-name.py` (preferred)
- Node.js: `script-name.js`

## File References

### Path Rules

- Use relative paths from skill root
- Use forward slashes (/)
- Maximum one level deep

**Good**:

```
SKILL.md → references/guide.md ✓
```

**Poor** (avoid chains):

```
SKILL.md → references/index.md → references/details/section.md ✗
```

## Writing Effective Instructions

### For LLM Comprehension

1. **Be Explicit**
   - ❌ "Process the document appropriately"
   - ✅ "Extract text from pages 1-10, then parse tables from page 11"

2. **Use Clear Structure**
   - Numbered lists for sequential steps
   - Bullet points for options
   - Subheadings to break up sections

3. **Provide Context**
   - "Use this approach for PDFs larger than 10MB to avoid memory errors"

4. **Include Concrete Examples**

   ```markdown
   **Input:** invoice.pdf
   **Output:** {"invoice_number": "INV-001", "total": 1234.56}
   ```

5. **Document Edge Cases**
   - "If PDF is password-protected, prompt for password"
   - "For scanned PDFs without text layer, use OCR"

6. **Use Consistent Terminology**
   - Define technical terms on first use
   - Use same term throughout

### Writing Style

- **Active voice**: "Extract the text" not "Text should be extracted"
- **Imperative mood**: "Run the script" not "You should run"
- **Present tense**: "The script processes files"
- **Specific verbs**: "Parse" not "handle", "Extract" not "get"
- **Short sentences**: Under 25 words when possible
- **Simple language**: Avoid jargon unless necessary
- **Concrete over abstract**: Specific examples over general statements

## Validation

Use the skills-ref validation tool:

```bash
# Validate a single skill
skills-ref validate ./skill-name

# Validate all skills
skills-ref validate ./skills/
```

**Validation Checks**:

- SKILL.md frontmatter is valid YAML
- Required fields present (name, description)
- Field constraints met (length, format, character restrictions)
- Name matches directory
- Name format follows rules
- File structure is correct

**Why Validation Matters**: Skills that fail validation may not load correctly, causing runtime errors or being ignored.

**Best Practice**: Integrate validation into your workflow:

- Run before committing changes
- Add to CI/CD pipelines
- Validate after structural changes

## Common Mistakes to Avoid

### 1. Vague Descriptions

❌ `description: "Helps with data"`
✅ `description: "Transforms CSV files into JSON format with validation. Use for data format conversions or when user mentions CSV, JSON, or data transformation."`

### 2. Missing Use Cases

❌ Only describing what it does
✅ Describing what it does AND when to use it

### 3. Overly Long SKILL.md

❌ 1000+ lines in main file
✅ <500 lines in SKILL.md, details in references/

### 4. Implicit Assumptions

❌ "Process the file normally"
✅ "Extract text from PDF, handling both text-based and scanned documents. For scanned PDFs, apply OCR."

### 5. Poor File Organization

❌ Flat structure with all files in root
✅ Organized with scripts/, references/, assets/

### 6. Undocumented Dependencies

❌ Script fails with "module not found"
✅ Clear prerequisites section listing all dependencies

### 7. Invalid Naming

❌ `My_Skill`, `my skill`, `MySkill`
✅ `my-skill`

### 8. No Examples

❌ Instructions without demonstrations
✅ Multiple examples showing different use cases

### 9. Ignoring Edge Cases

❌ Only happy path documented
✅ Edge cases and error handling included

### 10. Missing Validation

❌ Shipping without testing
✅ Validated with skills-ref and tested with agents

### 11. Platform-Specific Scripts Only

❌ Only Bash without PowerShell
✅ Python for cross-platform, or both .sh and .ps1

### 12. Hard-Coded Path Separators

❌ Using `\` or `/` directly
✅ Using `pathlib.Path` (Python) or `Join-Path` (PowerShell)

### 13. Untested on All Platforms

❌ Only testing on one OS
✅ Testing on Windows, macOS, and Linux

## Quality Checklist

### Before You Start

- [ ] Identify task or domain
- [ ] Verify no existing skill covers this
- [ ] Determine required tools and dependencies
- [ ] Plan directory structure

### Creating SKILL.md

- [ ] Valid name (lowercase, hyphens only)
- [ ] Comprehensive description (what, when, keywords)
- [ ] Appropriate license
- [ ] Include metadata (author, version)
- [ ] Clear, step-by-step instructions
- [ ] Concrete examples
- [ ] Document edge cases
- [ ] Add error handling guidance
- [ ] Keep under 500 lines

### Optional Content

- [ ] Create scripts with documentation
- [ ] Add reference documentation
- [ ] Include templates and assets
- [ ] All file references correct
- [ ] Test all scripts

### Quality Checks

- [ ] Validate with skills-ref
- [ ] Test with target agent(s)
- [ ] Review for clarity
- [ ] Verify all links work
- [ ] Check for typos
- [ ] Consistent terminology
- [ ] Test cross-platform scripts
- [ ] Document platform requirements

### Finalization

- [ ] Add to version control
- [ ] Document in knowledge base
- [ ] Share with team
- [ ] Gather feedback
- [ ] Monitor usage

## Example Patterns

### Analysis Skill

```markdown
---
name: code-security-analyzer
description: Analyzes code for security vulnerabilities, including SQL injection, XSS, and authentication issues. Use when reviewing code security, conducting security audits, or when user mentions vulnerabilities or security concerns.
---

# Code Security Analyzer

## When to Use
- Security code reviews
- Pre-deployment security checks
- Vulnerability assessments

## Instructions
### 1. Scan for Common Vulnerabilities
Review code for:
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Authentication/authorization flaws

### 2. Generate Report
Create report with:
- Severity ratings (Critical/High/Medium/Low)
- Specific vulnerable code locations
- Remediation recommendations
```

### Generation Skill

```markdown
---
name: api-documentation-generator
description: Generates API documentation from code with endpoints, parameters, and examples. Use when creating API docs, documenting REST APIs, or when user mentions API documentation or OpenAPI specifications.
---

# API Documentation Generator

## What It Does
Generates comprehensive API documentation including:
- Endpoint descriptions
- Request/response formats
- Authentication requirements
- Example requests

## Instructions
### 1. Analyze API Structure
- Identify all endpoints (GET, POST, PUT, DELETE)
- Extract path parameters and query strings
- Document request body schemas

### 2. Generate Documentation
For each endpoint, create formatted docs with examples
```

### Workflow Skill

```markdown
---
name: deployment-workflow
description: Guides through complete deployment process including testing, building, and deploying applications. Use for application deployments, CI/CD workflows, or when user mentions deploy, release, or production deployment.
---

# Deployment Workflow

## Prerequisites
- Git repository with source code
- Access to deployment environment
- Required credentials configured

## Workflow Steps
### Phase 1: Pre-Deployment
1. Run automated tests
2. Check code coverage (minimum 80%)
3. Review pending pull requests

### Phase 2: Build
1. Update version number
2. Build production bundle
3. Run security scan

### Phase 3: Deploy
1. Create git tag
2. Deploy to staging
3. Run smoke tests
4. Deploy to production
```

## Resources

### Official Resources

- Agent Skills Specification: <https://agentskills.io/specification>
- Reference Library (skills-ref): <https://github.com/agentskills/agentskills/tree/main/skills-ref>
- Anthropic's Skills Repository: <https://github.com/anthropics/skills>

### Tools

- skills-ref: Validation and prompt XML generation
- Skill Template: <https://github.com/anthropics/skills/tree/main/template>
