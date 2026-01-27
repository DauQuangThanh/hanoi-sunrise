---
name: project-ground-rules-setup
description: Creates or updates project ground-rules documentation with versioned principles, governance rules, and automatic synchronization across dependent templates. Use when establishing project standards, defining development principles, setting up governance, or when user mentions ground-rules, project constitution, coding standards, or development principles.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-24"
---

# Project Ground Rules Setup

## When to Use

- Setting up initial project governance and development principles
- Updating existing ground-rules with new principles or changes
- Establishing coding standards and architectural guidelines
- Creating a project constitution with versioned principles
- Synchronizing ground-rules changes across dependent templates
- When user requests to "create ground rules", "establish project standards", or "define development principles"

## Prerequisites

- Write access to `docs/` directory
- Git initialized in the repository (for auto-commit functionality)
- Access to dependent template files (if synchronization with other templates is required)

## Overview

This skill guides you through creating or updating the project ground-rules document at `docs/ground-rules.md`. It follows a structured approach that:

1. Loads the ground-rules template
2. Collects/derives values for all placeholders
3. Applies semantic versioning to track governance changes
4. Propagates changes to dependent templates
5. Validates consistency across the codebase
6. Automatically commits changes with proper git message

## Instructions

### Step 1: Load Template and Existing Ground Rules

**Action**: Read the template and check for existing ground-rules.

```bash
# Read the template from skill folder
cat skills/project-ground-rules-setup/references/ground-rules-template.md

# Check if ground-rules already exist
if [ -f docs/ground-rules.md ]; then
    cat docs/ground-rules.md
fi
```

**Purpose**:

- Identify all placeholder tokens in format `[ALL_CAPS_IDENTIFIER]`
- Extract current values and version if updating existing ground-rules
- Understand the template structure

**Important**: The user might require different number of principles than in the template. Adapt the structure accordingly.

### Step 2: Collect Values for Placeholders

**Sources for values** (in priority order):

1. **User input**: Use explicitly provided values from conversation
2. **Existing ground-rules**: If `docs/ground-rules.md` exists, preserve current principles unless changes requested
3. **Repository context**: Infer from README.md, docs/, project structure
4. **Defaults**: Use sensible defaults only when no other source available

**Special fields handling**:

#### Dates

- `RATIFICATION_DATE`:
  - First creation: Use today's date (YYYY-MM-DD)
  - Updating: Preserve original adoption date from existing document
- `LAST_AMENDED_DATE`:
  - Changes made: Use today's date
  - No changes: Keep previous date

#### Versioning (`CONSTITUTION_VERSION`)

Apply semantic versioning rules:

- **MAJOR** (X.0.0): Backward incompatible changes
  - Removing principles
  - Fundamentally redefining core principles
  - Breaking governance structure changes

- **MINOR** (x.Y.0): Backward compatible additions
  - Adding new principles
  - Materially expanding existing guidance
  - New governance sections

- **PATCH** (x.y.Z): Non-semantic refinements
  - Clarifications
  - Wording improvements
  - Typo fixes
  - Minor reorganization

**First creation**: Start with version `1.0.0`

**If version bump type ambiguous**: Document reasoning before finalizing.

### Step 3: Draft Updated Ground Rules

**Process**:

1. Start with template from `skills/project-ground-rules-setup/references/ground-rules-template.md`
2. Replace every `[PLACEHOLDER]` with concrete text
3. Preserve heading hierarchy from template
4. Remove template comments after replacement (unless they add clarifying guidance)

**Content requirements for each Principle**:

- Succinct name/title line
- Paragraph or bullet list capturing non-negotiable rules
- Explicit rationale if not obvious
- Must be declarative and testable
- Avoid vague language (replace "should" with MUST/SHOULD with rationale)

**Governance section must include**:

- Amendment procedure
- Versioning policy
- Compliance review expectations

**Validation checkpoint**:

- No remaining unexplained bracket tokens (except intentionally deferred—must justify)
- Dates in ISO format (YYYY-MM-DD)
- Version matches semantic versioning rules
- Principles are clear, actionable, and testable

### Step 4: Consistency Propagation (Optional)

**Note**: If your project has dependent templates, validate and update them to maintain consistency.

#### Templates to check and update (if present)

1. **Design Template** (in `technical-design` skill)
   - Ensure "Ground-rules Check" sections align with updated principles
   - Update any hardcoded rule references

2. **Specification Template** (in `requirements-specification` skill)
   - Verify scope/requirements alignment
   - Update if ground-rules adds/removes mandatory sections
   - Check constraints match new principles

3. **Tasks Template** (in `project-management` skill)
   - Update task categorization for new/removed principles
   - Ensure principle-driven task types are current (e.g., observability, versioning, testing)

4. **Command Files** (`commands/*.md`)
   - Verify no outdated principle references
   - Update generic guidance if required

5. **Runtime Documentation**
   - `README.md`
   - `docs/quickstart.md`
   - Any agent-specific guidance files
   - Update references to changed principles

### Step 5: Create Sync Impact Report

**Prepend as HTML comment** at the top of `docs/ground-rules.md`:

```markdown
<!--
SYNC IMPACT REPORT
==================
Version: [OLD_VERSION] → [NEW_VERSION]
Generated: YYYY-MM-DD

Modified Principles:
- [Old Title] → [New Title] (renamed)
- [Principle Name]: [Description of change]

Added Sections:
- [Section Name]: [Purpose]

Removed Sections:
- [Section Name]: [Reason]

Template Updates:
✅ design-template.md - Updated ground-rules check section
✅ spec-template.md - Updated requirements constraints
⚠ tasks-template.md - Pending: Review observability task types
✅ README.md - Updated principle references

Follow-up TODOs:
- [ ] [Deferred item with explanation]
-->
```

### Step 6: Final Validation

Before writing the file, verify:

- [ ] No remaining unexplained bracket tokens
- [ ] Version line matches report
- [ ] Dates in ISO format (YYYY-MM-DD)
- [ ] All principles are declarative and testable
- [ ] Vague language replaced with clear MUST/SHOULD statements
- [ ] Rationale provided for non-obvious rules
- [ ] Heading hierarchy preserved
- [ ] Single blank line between sections
- [ ] No trailing whitespace
- [ ] Lines wrap appropriately (<100 chars when possible)

### Step 7: Write Ground Rules File

**Action**: Create or overwrite `docs/ground-rules.md`

```bash
# Ensure memory directory exists
mkdir -p memory

# Write the completed ground-rules
# (Use your editor/tool to write the content)
```

### Step 8: Auto-Commit Changes

**Generate commit message**:

- **First creation**: `docs: establish project ground rules v1.0.0`
- **Updates**: `docs: update ground rules to v{VERSION}`
- **With details**: `docs: amend ground-rules to v{VERSION} (principle additions + governance update)`

**Commit affected files**:

```bash
git add docs/ground-rules.md
git commit -m "docs: [generated message]"
```

### Step 9: Output Summary to User

Provide:

1. **Version information**:
   - New version: `X.Y.Z`
   - Bump rationale: "Added 2 new principles (observability + security) - MINOR version bump"
   - Or: "Initial ground-rules - version 1.0.0"

2. **Files updated**:
   - Primary: `docs/ground-rules.md`
   - Templates: List of updated template files

3. **Manual follow-up** (if any):
   - Files flagged for review
   - Deferred placeholders with TODOs

4. **Commit details**:
   - Suggested/executed commit message
   - Files included in commit

## Examples

### Example 1: First Creation

**Input:**

```
Create ground rules for our TypeScript API project with focus on:
- Clean code
- Type safety
- Testing
```

**Output:**

```
✅ Created initial ground rules v1.0.0

Files created/updated:
- docs/ground-rules.md (created)

Principles established:
- Clean Code: Readability and maintainability first
- Type Safety: Strict TypeScript with no `any` types
- Testing: Minimum 80% code coverage required

Committed as: "docs: establish project ground rules v1.0.0"
```

### Example 2: Adding New Principle

**Input:**

```
Add security principle: All endpoints must have authentication
```

**Output:**

```
✅ Updated ground rules to v1.1.0

Version change: 1.0.0 → 1.1.0 (MINOR - new principle added)

Changes:
- Added: Security principle (authentication requirement)

Files updated:
- docs/ground-rules.md

Committed as: "docs: update ground rules to v1.1.0 (security principle)"
```

### Example 3: Clarification (Patch)

**Input:**

```
Clarify that "Clean Code" includes max 300 lines per file
```

**Output:**

```
✅ Updated ground rules to v1.0.1

Version change: 1.0.0 → 1.0.1 (PATCH - clarification)

Changes:
- Modified: Clean Code principle (added file size constraint)

Files updated:
- docs/ground-rules.md

Committed as: "docs: update ground rules to v1.0.1 (clarify file size)"
```

## Edge Cases

### Case 1: Template File Issues

**Issue**: Template file in skill folder is missing or corrupted

**Handling**:

1. Template should be at `skills/project-ground-rules-setup/references/ground-rules-template.md`
2. If missing, use the minimal structure defined below
3. Warn user about using fallback template
4. Proceed with basic structure

**Minimal template structure**:

```markdown
# [PROJECT_NAME] Ground-rules

## Core Principles

### [PRINCIPLE_1_NAME]
[PRINCIPLE_1_DESCRIPTION]

### [PRINCIPLE_2_NAME]
[PRINCIPLE_2_DESCRIPTION]

## Governance
[GOVERNANCE_RULES]

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
```

### Case 2: Ambiguous Version Bump

**Issue**: Change could be MINOR or MAJOR

**Handling**:

1. Document reasoning for both options
2. Ask user to confirm which applies
3. Provide recommendation based on backward compatibility impact
4. Default to more conservative (MAJOR) if truly ambiguous

### Case 3: Conflicting Principles

**Issue**: New principle contradicts existing one

**Handling**:

1. Identify the conflict explicitly
2. Present both principles to user
3. Request decision: modify existing, modify new, or keep both with clarification
4. Document resolution in amendment history

### Case 4: Deferred Placeholders

**Issue**: Critical information missing (e.g., project name unknown)

**Handling**:

1. Insert `TODO(<FIELD_NAME>): explanation` in document
2. Add to "Follow-up TODOs" in Sync Impact Report
3. Continue with remaining placeholders
4. Flag file as requiring manual completion

### Case 5: Git Not Initialized

**Issue**: Auto-commit requested but no git repository

**Handling**:

1. Complete all file operations normally
2. Skip commit step
3. Provide manual commit instructions in summary
4. Suggest initializing git if appropriate

## Error Handling

### Error: Template Read Failure

**Symptom**: Cannot read ground-rules-template.md

**Action**:

1. Verify file exists: `test -f skills/project-ground-rules-setup/references/ground-rules-template.md`
2. Check file permissions
3. If corrupted, use minimal template structure (see Case 1 in Edge Cases)
4. Report issue to skill maintainer if template is consistently problematic

### Error: Version Parse Failure

**Symptom**: Existing ground-rules has invalid version format

**Action**:

1. Attempt to extract version with regex: `v?(\d+\.\d+\.\d+)`
2. If fails, start fresh with 1.0.0 and note in report
3. Preserve old version string as comment for reference

### Error: Dependent Template Update Failure

**Symptom**: Cannot update design-template.md or other dependent files

**Action**:

1. Continue with ground-rules creation/update
2. Log failed file in Sync Impact Report with ⚠ status
3. Provide manual update instructions in summary
4. Do not fail entire operation

### Error: Commit Failure

**Symptom**: Git commit fails (no git, conflicts, permissions)

**Action**:

1. Complete file writes successfully
2. Capture git error message
3. Provide manual commit instructions with exact commands
4. Include troubleshooting guidance in output

## Guidelines

1. **Always preserve existing content** unless explicitly changing it
2. **Version bumps must follow semantic versioning strictly**
3. **Never skip consistency propagation** - dependent templates must stay in sync
4. **Make changes atomic** - all related files in single commit
5. **User input takes precedence** over inferred values
6. **Document all deferred items** clearly with rationale
7. **Validate before writing** - catch issues early
8. **Provide actionable output** - user should know exactly what happened and what's next

## Additional Resources

### Included Template

This skill includes a reference template at:

- `skills/project-ground-rules-setup/references/ground-rules-template.md`

The template provides:

- Standard structure with placeholders
- Example comments showing typical content
- Core sections: Principles, Governance, Versioning
- Flexible principle count (adjust as needed)

### Related Skills

- `technical-writing` - For improving ground-rules prose
- `git-commit` - For proper commit message formatting
- `requirements-gathering` - For extracting principles from stakeholder input

### Template Structure Reference

The ground-rules template typically includes:

- **Header**: Title, version, dates
- **Purpose**: Why ground-rules exist
- **Principles**: Core development rules (typically 3-7 principles)
- **Governance**: Amendment process, versioning, compliance
- **Appendix**: Change history, references

### Semantic Versioning Quick Reference

- **MAJOR (X.0.0)**: Breaking changes, removed features
- **MINOR (x.Y.0)**: New features, backward compatible
- **PATCH (x.y.Z)**: Bug fixes, clarifications, no new features

### Best Practices for Principles

1. **Be specific**: "Max 300 lines per file" not "Keep files small"
2. **Be measurable**: Define clear success criteria
3. **Be actionable**: Developers should know what to do
4. **Provide rationale**: Explain the "why" behind each rule
5. **Use strong language**: MUST/SHOULD/MAY with clear meaning
6. **Avoid redundancy**: Each principle should be distinct
7. **Keep focused**: 3-7 principles max for memorability

---

**Note**: This skill automates the workflow for setting up and maintaining project ground rules, ensuring consistency across project documentation.
