# Troubleshooting Guide

## Common Issues and Solutions

### Issue 1: Validation Errors

#### Invalid Name Format

**Symptom:**
```
❌ Invalid name format: 'My_Skill' (must be lowercase letters, numbers, and hyphens only)
```

**Cause:** Name contains invalid characters (uppercase, underscores, spaces)

**Solution:**
```python
# Convert to valid format
invalid_name = "My_Skill"
valid_name = invalid_name.lower().replace('_', '-').replace(' ', '-')
# Result: "my-skill"
```

**Rules:**
- Only lowercase letters (a-z)
- Only numbers (0-9)
- Only hyphens (-)
- No leading/trailing hyphens
- No consecutive hyphens
- Must match directory name

#### Name-Directory Mismatch

**Symptom:**
```
❌ Name 'pdf-processor' doesn't match directory 'pdf-processing'
```

**Cause:** The `name` field in frontmatter doesn't match the parent directory name

**Solution:**
1. Rename directory to match name field, OR
2. Update name field to match directory name

```bash
# Option 1: Rename directory
mv pdf-processing pdf-processor

# Option 2: Update SKILL.md name field
# Change: name: pdf-processor
# To: name: pdf-processing
```

#### Missing Frontmatter

**Symptom:**
```
❌ Missing frontmatter (should start with ---)
```

**Cause:** SKILL.md doesn't start with `---`

**Solution:**
Add YAML frontmatter at the very beginning of SKILL.md:

```markdown
---
name: skill-name
description: "Skill description here."
---

# Skill Name
...
```

### Issue 2: Description Problems

#### Description Too Vague

**Symptom:**
```
⚠️  Description contains vague term: 'helps with'
```

**Poor examples:**
- "Helps with documents"
- "Tool for processing"
- "Does PDF stuff"

**Solution:**
Use the 3-part formula:

```yaml
# BAD
description: "Helps with PDFs"

# GOOD
description: "Extracts text and tables from PDF files, fills forms, and merges multiple PDFs. Use when working with PDF documents or when user mentions PDFs, forms, or document extraction."
```

**Formula:**
```
[SPECIFIC ACTIONS] + [USE CASES] + [KEYWORDS]
```

#### Missing Discovery Hints

**Symptom:**
```
⚠️  Description missing 'Use when...' clause
⚠️  Description missing keyword matching hints
```

**Solution:**
Add explicit activation triggers:

```yaml
description: "[Actions]. Use when [scenario 1], [scenario 2], or when user mentions [keyword 1], [keyword 2], or [keyword 3]."
```

**Example:**
```yaml
description: "Analyzes code for security vulnerabilities including SQL injection and XSS. Use when reviewing code security, conducting audits, or when user mentions security, vulnerabilities, or code review."
```

### Issue 3: File Structure Problems

#### SKILL.md Too Long

**Symptom:**
```
⚠️  SKILL.md has 850 lines (recommended: <500)
```

**Cause:** Too much content in main file

**Solution:**
Move detailed content to references/:

**Before (850 lines in SKILL.md):**
```markdown
---
name: pdf-processing
---

# PDF Processing

## Instructions
[100 lines of instructions]

## Detailed Examples
[300 lines of examples]

## Complete API Reference
[200 lines of API docs]

## Troubleshooting
[150 lines of troubleshooting]

## Advanced Topics
[100 lines of advanced content]
```

**After (main SKILL.md ~400 lines):**
```markdown
---
name: pdf-processing
---

# PDF Processing

## Instructions
[100 lines of core instructions]

## Examples
[50 lines of essential examples]

For more examples, see [references/examples.md](references/examples.md)

## Troubleshooting
[50 lines of common issues]

For complete troubleshooting guide, see [references/troubleshooting.md](references/troubleshooting.md)

## Advanced Topics
See [references/advanced.md](references/advanced.md) for:
- [Topic list]
```

**Create reference files:**
- `references/examples.md` - Detailed examples
- `references/api-reference.md` - Complete API documentation
- `references/troubleshooting.md` - Extended troubleshooting
- `references/advanced.md` - Advanced topics

#### Missing Required File

**Symptom:**
```
❌ SKILL.md not found
```

**Cause:** SKILL.md doesn't exist in skill directory

**Solution:**
1. Create SKILL.md in the skill root directory
2. Add proper frontmatter and content

```bash
cd my-skill/
touch SKILL.md
# Edit SKILL.md with proper content
```

### Issue 4: Script Problems

#### Non-Cross-Platform Script

**Symptom:**
- Script works on macOS/Linux but fails on Windows
- Uses bash-specific features
- Hardcoded path separators

**Solution:**
Use Python 3.8+ for cross-platform compatibility:

**BAD (bash script):**
```bash
#!/bin/bash
# Only works on Unix-like systems
input_dir="/path/to/input"
output_dir="/path/to/output"
ls $input_dir/*.txt | while read file; do
    cat "$file" > "$output_dir/$(basename $file)"
done
```

**GOOD (Python script):**
```python
#!/usr/bin/env python3
"""Cross-platform file processor."""

from pathlib import Path

def main():
    input_dir = Path("/path/to/input")
    output_dir = Path("/path/to/output")
    
    for file_path in input_dir.glob("*.txt"):
        output_path = output_dir / file_path.name
        output_path.write_text(file_path.read_text())

if __name__ == "__main__":
    main()
```

**Key differences:**
- `pathlib.Path` handles separators automatically
- Works on Windows, macOS, and Linux
- No shell-specific commands

#### Missing Script Dependencies

**Symptom:**
```
ModuleNotFoundError: No module named 'pandas'
```

**Cause:** Script uses external library not documented

**Solution:**
1. Document dependencies in script docstring
2. Add requirements.txt (optional)
3. Include installation instructions

**Script docstring:**
```python
#!/usr/bin/env python3
"""
Data processor script.

Requirements:
    - Python 3.8+
    - pandas >= 1.5.0
    - numpy >= 1.24.0

Install:
    pip install pandas numpy
"""
```

**SKILL.md instructions:**
```markdown
## Prerequisites

Install required Python packages:
```bash
pip install pandas numpy
```
```

### Issue 5: Validation Tool Issues

#### skills-ref Not Found

**Symptom:**
```
bash: skills-ref: command not found
```

**Solution:**
Install the skills-ref tool or use manual validation:

**Option 1: Use provided Python validator**
```bash
python3 scripts/validate.py ./my-skill
```

**Option 2: Manual validation**
Check the validation checklist in [references/validation-checklist.md](validation-checklist.md)

#### PyYAML Not Installed

**Symptom:**
```
Error: PyYAML is required
```

**Solution:**
```bash
pip install pyyaml
```

### Issue 6: Frontmatter YAML Errors

#### Invalid YAML Syntax

**Symptom:**
```
❌ Invalid YAML in frontmatter: ...
```

**Common causes:**

1. **Unquoted special characters:**
```yaml
# BAD
description: Use when: working with files

# GOOD
description: "Use when: working with files"
```

2. **Incorrect indentation:**
```yaml
# BAD
metadata:
author: Name
  version: 1.0

# GOOD
metadata:
  author: Name
  version: "1.0"
```

3. **Missing closing quotes:**
```yaml
# BAD
description: "Processing files

# GOOD
description: "Processing files"
```

4. **Unescaped colons:**
```yaml
# BAD
description: Handles files: all types

# GOOD
description: "Handles files: all types"
```

**Solution:**
- Always quote strings with colons, newlines, or special characters
- Use consistent indentation (2 spaces recommended)
- Validate YAML online: https://www.yamllint.com/

### Issue 7: Content Quality Issues

#### No Examples Provided

**Symptom:**
```
⚠️  No examples section found
```

**Impact:** Users don't understand how to use the skill

**Solution:**
Add concrete examples with input and output:

```markdown
## Examples

### Example 1: Basic Usage

**Input:** `invoice.pdf`

**Command:**
```bash
python3 scripts/extract.py invoice.pdf
```

**Output:**
```json
{
  "invoice_number": "INV-2024-001",
  "total": 1234.56,
  "date": "2024-01-15"
}
```

### Example 2: Multiple Files

**Input:** `documents/*.pdf`

**Command:**
```bash
python3 scripts/extract.py documents/*.pdf --output results/
```

**Output:**
```
Processed 5 files:
- invoice.pdf → results/invoice.json
- report.pdf → results/report.json
...
```
```

#### Missing Error Handling Documentation

**Symptom:**
```
⚠️  No error handling section
```

**Solution:**
Document common errors and solutions:

```markdown
## Error Handling

### Error: "File not found"

**Cause:** Input file path is incorrect

**Solution:**
1. Verify file path exists
2. Use absolute path or correct relative path
3. Check file permissions

### Error: "Permission denied"

**Cause:** Insufficient permissions to read/write files

**Solution:**
```bash
# On Unix-like systems
chmod +r input.pdf
chmod +w output-directory/
```
```

## Quick Reference

### Validation Checklist

```bash
# 1. Check name format
echo "my-skill-name" | grep -E '^[a-z0-9]+(-[a-z0-9]+)*$'

# 2. Verify name matches directory
basename $(pwd)  # Should match name in SKILL.md

# 3. Count lines
wc -l SKILL.md  # Should be < 500

# 4. Validate YAML (using Python)
python3 -c "import yaml; yaml.safe_load(open('SKILL.md').read().split('---')[1])"

# 5. Run validation script (if available)
python3 scripts/validate.py .
```

### Common Fixes

```bash
# Fix name format
name="My_Skill Name"
fixed_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | tr -s '-')
echo "$fixed_name"  # my-skill-name

# Create directory structure
mkdir -p my-skill/{scripts,references,assets}
touch my-skill/SKILL.md

# Count SKILL.md lines
wc -l my-skill/SKILL.md

# Make scripts executable
chmod +x my-skill/scripts/*.py
```

### Getting Help

1. **Check specification:** `/rules/agent-skills-creation-rules.md`
2. **Review examples:** `https://github.com/anthropics/skills`
3. **Validate:** Use `scripts/validate.py`
4. **Test:** Load in target agent platform

## Platform-Specific Issues

### Windows

#### Line Ending Issues

**Symptom:** Scripts fail with `^M` or `\r\n` errors

**Solution:**
Configure Git to handle line endings:

```bash
# .gitattributes
*.py text eol=lf
*.sh text eol=lf
*.md text eol=lf
```

#### Path Separator Issues

**Symptom:** Paths with backslashes fail

**Solution:**
Use `pathlib.Path`:

```python
from pathlib import Path

# GOOD - works on all platforms
path = Path("folder") / "file.txt"

# BAD - Windows-specific
path = "folder\\file.txt"
```

### macOS

#### Permission Issues

**Symptom:** `Permission denied` when running scripts

**Solution:**
```bash
chmod +x scripts/*.py
```

### Linux

#### Missing Dependencies

**Symptom:** `command not found` or `module not found`

**Solution:**
```bash
# Install Python
sudo apt-get install python3 python3-pip

# Install dependencies
pip3 install -r requirements.txt
```

---

**Remember:** Most issues can be prevented by following the validation checklist and testing on multiple platforms before deployment.
