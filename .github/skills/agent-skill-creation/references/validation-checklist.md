# Validation Checklist

## Complete Pre-Submission Validation

Use this comprehensive checklist before finalizing any agent skill.

## Structure Validation

### Directory Structure

- [ ] Directory name matches skill name exactly
- [ ] Directory name is lowercase with hyphens only
- [ ] SKILL.md exists in skill root directory
- [ ] Optional directories (scripts/, references/, assets/) only if needed
- [ ] No unnecessary empty directories

### File Organization

- [ ] All scripts in scripts/ directory
- [ ] All additional docs in references/ directory
- [ ] All static resources in assets/ directory
- [ ] No files in root except SKILL.md
- [ ] File references use forward slashes

## Frontmatter Validation

### Required Fields

- [ ] `name` field present
- [ ] `name` is 1-64 characters
- [ ] `name` matches pattern: `^[a-z0-9]+(-[a-z0-9]+)*$`
- [ ] `name` matches directory name
- [ ] `description` field present
- [ ] `description` is 1-1024 characters
- [ ] YAML syntax is valid

### Optional Fields (If Present)

- [ ] `license` specified (MIT recommended)
- [ ] `metadata.author` included
- [ ] `metadata.version` in semantic versioning format
- [ ] `metadata.last_updated` in YYYY-MM-DD format
- [ ] `compatibility` noted if platform-specific

## Description Quality

### Content Requirements

- [ ] Includes 2-4 specific actions (active verbs)
- [ ] Includes "Use when..." clause with 2-3 scenarios
- [ ] Includes 3-5 keywords users might mention
- [ ] Length is 150-300 characters (optimal) or up to 1024 if needed
- [ ] Specific, not vague (no "helps with", "tool for")
- [ ] No pronouns (no "it", "this", "that")

### Discovery Optimization

- [ ] Keywords match likely user queries
- [ ] Use cases clearly stated
- [ ] Scope is clear
- [ ] Related terms included

## Content Validation

### Structure

- [ ] Clear overview section (2-3 sentences)
- [ ] "When to Use" section with bullet points
- [ ] Prerequisites documented (if any)
- [ ] Step-by-step Instructions section
- [ ] Examples section with input/output
- [ ] Edge Cases section
- [ ] Error Handling section
- [ ] Total length under 500 lines

### Instructions Quality

- [ ] Steps are numbered and sequential
- [ ] Each step has clear action verb
- [ ] Specific, not generic guidance
- [ ] No assumptions about knowledge
- [ ] Concrete examples included
- [ ] Code blocks properly formatted
- [ ] Commands include full paths/flags

### Examples

- [ ] At least one complete example
- [ ] Input clearly shown
- [ ] Output clearly shown
- [ ] Example is realistic
- [ ] Multiple scenarios covered (if applicable)
- [ ] Edge cases demonstrated

### Edge Cases

- [ ] Common pitfalls identified
- [ ] Handling approach documented
- [ ] Platform-specific issues noted
- [ ] Workarounds provided

### Error Handling

- [ ] Common errors listed
- [ ] Error messages included
- [ ] Resolution steps provided
- [ ] Exit codes documented (for scripts)

## Script Validation (If Present)

### General Requirements

- [ ] All scripts in scripts/ directory
- [ ] Python 3.8+ used for cross-platform compatibility
- [ ] Shebang line included: `#!/usr/bin/env python3`
- [ ] Docstring with usage information
- [ ] Platform support documented (Windows, macOS, Linux)

### Code Quality

- [ ] Input validation included
- [ ] Error handling implemented
- [ ] Clear error messages
- [ ] Proper exit codes (0 = success, 1 = error, 130 = interrupted)
- [ ] Dependencies documented in docstring
- [ ] Usage examples in docstring

### Cross-Platform Compatibility

- [ ] Uses pathlib.Path for paths (not hardcoded separators)
- [ ] No platform-specific commands (unless documented alternative)
- [ ] Handles line endings correctly
- [ ] Works with spaces in file names
- [ ] Tested on Windows
- [ ] Tested on macOS
- [ ] Tested on Linux

### Execution

- [ ] Script runs without errors
- [ ] Produces expected output
- [ ] Handles missing dependencies gracefully
- [ ] Handles invalid input appropriately
- [ ] Performance is acceptable

## Reference Files (If Present)

### Organization

- [ ] Each reference focused on one topic
- [ ] Files referenced from SKILL.md
- [ ] Clear headings and structure
- [ ] Examples included where appropriate
- [ ] No reference chains (max one level deep)

### Content

- [ ] Information not duplicated from SKILL.md
- [ ] Provides deeper detail than main file
- [ ] Well-organized with clear sections
- [ ] Code examples properly formatted
- [ ] Links work correctly

## Progressive Disclosure

### Metadata (Tier 1)

- [ ] Name is descriptive
- [ ] Description optimized for discovery
- [ ] Description contains all matching keywords
- [ ] Approximately 100 tokens or less

### Instructions (Tier 2)

- [ ] SKILL.md under 500 lines
- [ ] Essential instructions in main file
- [ ] Detailed content in references/
- [ ] Approximately 5000 tokens or less

### Resources (Tier 3)

- [ ] Scripts loaded on demand
- [ ] References loaded when needed
- [ ] Assets accessed explicitly
- [ ] No unnecessary preloading

## Testing

### Manual Testing

- [ ] SKILL.md renders correctly in Markdown viewer
- [ ] All internal links work
- [ ] All file references resolve
- [ ] Code blocks display properly
- [ ] Examples can be copied and run

### Automated Testing

- [ ] Runs through skills-ref validator (if available)
- [ ] No validation errors
- [ ] No validation warnings (or documented)
- [ ] CI/CD pipeline passes (if applicable)

### Integration Testing

- [ ] Skill loads in target agent platform
- [ ] Skill activates on expected keywords
- [ ] Instructions are clear to agent
- [ ] Scripts execute correctly
- [ ] Examples work as documented

## Quality Standards

### Writing Quality

- [ ] Active voice used
- [ ] Imperative mood for instructions
- [ ] Present tense for descriptions
- [ ] Specific verbs (not generic "handle", "process")
- [ ] Short sentences (under 25 words)
- [ ] Simple language (minimal jargon)
- [ ] Consistent terminology throughout

### Technical Accuracy

- [ ] Commands are correct
- [ ] Code examples work
- [ ] Dependencies are accurate
- [ ] Version numbers current
- [ ] Links are valid
- [ ] No outdated information

### Completeness

- [ ] All prerequisites listed
- [ ] All dependencies documented
- [ ] All edge cases covered
- [ ] All errors addressed
- [ ] No TODOs or placeholders
- [ ] No missing sections

## Pre-Deployment

### Documentation

- [ ] README updated (if applicable)
- [ ] Changelog entry added (if applicable)
- [ ] Version number updated
- [ ] Last updated date current
- [ ] Author information correct

### Version Control

- [ ] Changes committed
- [ ] Commit message follows convention
- [ ] Branch named appropriately
- [ ] No sensitive data in commits

### Distribution

- [ ] Skill in correct directory
- [ ] File permissions set correctly (scripts executable)
- [ ] No unnecessary files included
- [ ] License file present (if separate)

## Post-Deployment

### Monitoring

- [ ] Skill discovery working (activates on keywords)
- [ ] No errors reported
- [ ] Usage metrics tracked (if available)
- [ ] User feedback collected

### Maintenance

- [ ] Regular updates scheduled
- [ ] Dependencies kept current
- [ ] Documentation kept accurate
- [ ] Issues tracked and resolved

## Common Validation Errors

### Critical Issues

- ❌ Invalid YAML frontmatter
- ❌ Missing required fields (name, description)
- ❌ Name doesn't match directory
- ❌ Name contains invalid characters
- ❌ SKILL.md missing

### Warnings

- ⚠️ Description too short (under 100 characters)
- ⚠️ SKILL.md over 500 lines
- ⚠️ No examples provided
- ⚠️ Missing error handling
- ⚠️ Scripts not cross-platform

### Recommendations

- 💡 Add more keywords to description
- 💡 Include more examples
- 💡 Document edge cases
- 💡 Add reference files for details
- 💡 Improve error messages

## Validation Tools

### Manual Validation

```bash
# Check YAML frontmatter
head -n 20 SKILL.md

# Count lines
wc -l SKILL.md

# Validate name format
echo "skill-name" | grep -E '^[a-z0-9]+(-[a-z0-9]+)*$'
```

### Automated Validation

```bash
# Using skills-ref tool
skills-ref validate ./skill-name

# Validate directory
skills-ref validate ./skills/

# CI/CD integration
skills-ref validate $CHANGED_SKILL || exit 1
```

### Python Validation Script

```python
#!/usr/bin/env python3
"""Quick validation script for agent skills."""

import sys
import re
from pathlib import Path

def validate_skill(skill_path: Path) -> bool:
    skill_md = skill_path / "SKILL.md"
    
    if not skill_md.exists():
        print(f"❌ SKILL.md not found in {skill_path}")
        return False
    
    # Check name matches directory
    content = skill_md.read_text()
    name_match = re.search(r'^name:\s*(.+)$', content, re.MULTILINE)
    if name_match:
        name = name_match.group(1).strip()
        if name != skill_path.name:
            print(f"❌ Name '{name}' doesn't match directory '{skill_path.name}'")
            return False
    
    # Check line count
    line_count = len(content.splitlines())
    if line_count > 500:
        print(f"⚠️  SKILL.md has {line_count} lines (recommended: <500)")
    
    print(f"✅ {skill_path.name} validation passed")
    return True

if __name__ == "__main__":
    skill_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
    sys.exit(0 if validate_skill(skill_path) else 1)
```

---

**Remember**: Validation is not just a checkbox—it ensures your skill will work correctly across different agent platforms and be discoverable when users need it.
