# Skill Validation Checklist

## Quick Validation Commands

### Name Format Validation

```bash
# Check if name matches pattern: lowercase, hyphens, numbers only
echo "skill-name" | grep -E '^[a-z0-9]+(-[a-z0-9]+)*$' && echo "✅ Valid" || echo "❌ Invalid"
```

### Line Count Check

```bash
# Count lines in SKILL.md (should be < 500)
wc -l SKILL.md
```

### External References Check

```bash
# Check for /rules/ references (should have none)
grep -n "/rules/" SKILL.md

# Check for external URLs
grep -n "https://" SKILL.md
```

### YAML Frontmatter Validation

```bash
# Extract and validate frontmatter
python3 -c "
import yaml
import sys
content = open('SKILL.md').read()
parts = content.split('---', 2)
if len(parts) >= 3:
    try:
        fm = yaml.safe_load(parts[1])
        print('✅ Valid YAML')
        print(f\"Name: {fm.get('name', 'MISSING')}\" )
        print(f\"Description length: {len(fm.get('description', ''))} chars\")
    except Exception as e:
        print(f'❌ Invalid YAML: {e}')
        sys.exit(1)
else:
    print('❌ Frontmatter not found')
    sys.exit(1)
"
```

## Complete Validation Checklist

### Structure Validation

- [ ] SKILL.md file exists
- [ ] SKILL.md starts with `---` (YAML frontmatter)
- [ ] SKILL.md frontmatter ends with `---`
- [ ] SKILL.md is under 500 lines
- [ ] Skill name matches directory name exactly
- [ ] Name format: lowercase, hyphens, numbers only (1-64 chars)
- [ ] No leading/trailing hyphens in name
- [ ] No consecutive hyphens (`--`) in name
- [ ] No external references to `/rules/` directory
- [ ] Skill is self-contained (all resources within directory)

### Required Frontmatter Fields

- [ ] `name` field present
- [ ] `name` matches pattern: `^[a-z0-9]+(-[a-z0-9]+)*$`
- [ ] `name` length is 1-64 characters
- [ ] `description` field present
- [ ] `description` length is 1-1024 characters
- [ ] `description` is specific (not vague)

### Recommended Frontmatter Fields

- [ ] `license` field present (MIT recommended)
- [ ] `metadata.author` present
- [ ] `metadata.version` present (e.g., "1.0")
- [ ] `metadata.last_updated` present (YYYY-MM-DD format)

### Description Quality

- [ ] Includes 2-4 specific action verbs
- [ ] Includes "Use when..." with 2-3 scenarios
- [ ] Includes "when user mentions..." with 3-5 keywords
- [ ] Length is 150-300 characters (optimal)
- [ ] Avoids vague terms ("helps with", "tool for")
- [ ] Specific enough to differentiate from similar skills

### Content Sections (Required in SKILL.md)

- [ ] `# Skill Name` (H1 title)
- [ ] `## Overview` section (2-3 sentences)
- [ ] `## When to Use` section (3-5 bullet points)
- [ ] `## Prerequisites` section (or "None")
- [ ] `## Instructions` section (step-by-step)
- [ ] `## Examples` section (at least 2 examples)
- [ ] `## Edge Cases` section (2-3 cases)
- [ ] `## Error Handling` section (common errors)

### Optional Content Sections

- [ ] `## Scripts` (if scripts/ directory exists)
- [ ] `## References` (if references/ directory exists)
- [ ] `## Validation` section
- [ ] Footer with version, author, license

### Examples Quality

- [ ] At least 2 complete examples
- [ ] Each example shows input
- [ ] Each example shows output
- [ ] Examples cover common use cases
- [ ] Examples are concrete (not abstract)

### Instructions Quality

- [ ] Steps are numbered
- [ ] Each step has clear action verb
- [ ] Code examples included where relevant
- [ ] Commands are copy-paste ready
- [ ] Platform differences documented (if any)

### Scripts Directory (if present)

- [ ] Scripts use Python 3.8+ (cross-platform)
- [ ] Scripts have shebang: `#!/usr/bin/env python3`
- [ ] Scripts have docstrings with usage
- [ ] Scripts use `pathlib` for paths (not hardcoded `/` or `\`)
- [ ] Scripts have error handling
- [ ] Scripts have clear error messages
- [ ] Scripts tested on Windows, macOS, Linux

### References Directory (if present)

- [ ] Referenced from SKILL.md
- [ ] One topic per file
- [ ] Clear structure with headings
- [ ] Files use `.md` extension

### Templates Directory (if present)

- [ ] Contains reusable templates
- [ ] Templates are well-documented
- [ ] Templates follow same standards as main skill

### Assets Directory (if present)

- [ ] Contains static resources
- [ ] Referenced from SKILL.md or references/
- [ ] Examples are complete and working
- [ ] Checklists are comprehensive

### Cross-Platform Compatibility

- [ ] No platform-specific paths (use `pathlib.Path`)
- [ ] No platform-specific commands (or provide alternatives)
- [ ] File references use forward slashes
- [ ] Line endings configured in `.gitattributes` (if needed)
- [ ] Scripts tested on Windows
- [ ] Scripts tested on macOS
- [ ] Scripts tested on Linux

### Final Checks

- [ ] SKILL.md renders correctly in Markdown viewer
- [ ] All internal links resolve correctly
- [ ] No broken references
- [ ] No typos in critical sections
- [ ] Consistent terminology throughout
- [ ] Clear and actionable error messages
- [ ] Version number updated (if updating existing skill)
- [ ] Last updated date current

## Quick Test Commands

```bash
# Navigate to skill directory
cd /path/to/skill-name

# Run all checks
echo "=== Structure Check ==="
[[ -f "SKILL.md" ]] && echo "✅ SKILL.md exists" || echo "❌ SKILL.md missing"
[[ $(wc -l < SKILL.md) -lt 500 ]] && echo "✅ Under 500 lines" || echo "⚠️ Over 500 lines"

echo -e "\n=== Name Check ==="
skill_name=$(basename $(pwd))
echo "Directory name: $skill_name"
[[ "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] && echo "✅ Valid format" || echo "❌ Invalid format"

echo -e "\n=== External References Check ==="
! grep -q "/rules/" SKILL.md && echo "✅ No /rules/ refs" || echo "❌ Has /rules/ refs"

echo -e "\n=== Required Sections Check ==="
for section in "## When to Use" "## Prerequisites" "## Instructions" "## Examples" "## Edge Cases" "## Error Handling"; do
    grep -q "$section" SKILL.md && echo "✅ $section" || echo "❌ Missing: $section"
done
```

## Automated Validation

For automated validation, consider creating a validation script with Python 3.8+:

```python
#!/usr/bin/env python3
import re
import sys
from pathlib import Path
import yaml

def validate_skill(skill_path: Path):
    """Validates agent skill structure and content"""
    errors = []
    warnings = []
    
    # Check SKILL.md exists
    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        errors.append("SKILL.md not found")
        return errors, warnings
    
    # Check line count
    lines = skill_md.read_text().count('\n') + 1
    if lines >= 500:
        warnings.append(f"SKILL.md has {lines} lines (recommended: <500)")
    
    # Parse frontmatter
    content = skill_md.read_text()
    if not content.startswith('---'):
        errors.append("Missing YAML frontmatter")
        return errors, warnings
    
    parts = content.split('---', 2)
    if len(parts) < 3:
        errors.append("Frontmatter not properly closed")
        return errors, warnings
    
    try:
        fm = yaml.safe_load(parts[1])
    except Exception as e:
        errors.append(f"Invalid YAML: {e}")
        return errors, warnings
    
    # Validate required fields
    if 'name' not in fm:
        errors.append("Missing 'name' field")
    elif not re.match(r'^[a-z0-9]+(-[a-z0-9]+)*$', fm['name']):
        errors.append(f"Invalid name format: {fm['name']}")
    elif fm['name'] != skill_path.name:
        errors.append(f"Name '{fm['name']}' doesn't match directory '{skill_path.name}'")
    
    if 'description' not in fm:
        errors.append("Missing 'description' field")
    elif len(fm['description']) < 50:
        warnings.append("Description is very short")
    elif len(fm['description']) > 1024:
        errors.append("Description too long (max 1024 chars)")
    
    # Check for external references
    if '/rules/' in content:
        errors.append("Contains /rules/ references")
    
    return errors, warnings

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 validate.py <skill-directory>")
        sys.exit(1)
    
    skill_path = Path(sys.argv[1])
    errors, warnings = validate_skill(skill_path)
    
    if errors:
        print("❌ ERRORS:")
        for error in errors:
            print(f"  • {error}")
    
    if warnings:
        print("⚠️  WARNINGS:")
        for warning in warnings:
            print(f"  • {warning}")
    
    if not errors:
        print("✅ Validation passed")
    
    sys.exit(0 if not errors else 1)
```

---

**Note**: The validation script in this file can be saved and run independently. Due to Copilot ignore configuration, it cannot be placed in `scripts/` directory, but can be run from any location.
