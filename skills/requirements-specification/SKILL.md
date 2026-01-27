---
name: requirements-specification
description: Creates or updates feature specifications from natural language descriptions. Generates branch names, validates specification quality, and ensures requirements are testable and unambiguous. Use when creating product requirements, defining new features, documenting user needs, or when user mentions specifications, requirements gathering, feature definition, or needs to write a spec.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-25"
---

# Requirements Specification

## When to Use

Use this skill when:

- Creating a new feature specification from a user description
- Converting natural language requirements into structured specifications
- Documenting product requirements for stakeholders
- Validating specification quality and completeness
- Ensuring requirements are testable and unambiguous
- User mentions: specs, requirements, feature definition, user stories, acceptance criteria

## Prerequisites

**Required Tools:**

- Git (for branch management)
- Bash or PowerShell (for running scripts)
- Text editor or file system access

**Required Files:**

- `templates/spec-template.md` (specification template - provided with this skill)
- `templates/checklist-template.md` (checklist template - provided with this skill)
- Scripts: `scripts/create-feature.sh` or `scripts/create-feature.ps1` (provided with this skill)

**Optional Context Files:**

- `docs/architecture.md` (for technology stack and architectural patterns)
- `docs/standards.md` (for naming conventions and coding standards)

## Instructions

### Step 1: Extract Feature Short Name

Analyze the feature description and generate a concise short name (2-4 words):

1. **Extract meaningful keywords** from the description
2. **Use action-noun format** when possible (e.g., "add-user-auth", "fix-payment-bug")
3. **Preserve technical terms** and acronyms (OAuth2, API, JWT, etc.)
4. **Keep it descriptive** but concise enough to understand at a glance

**Examples:**

- "I want to add user authentication" → `user-auth`
- "Implement OAuth2 integration for the API" → `oauth2-api-integration`
- "Create a dashboard for analytics" → `analytics-dashboard`
- "Fix payment processing timeout bug" → `fix-payment-timeout`

### Step 2: Check for Existing Branches

Before creating a new branch, find the highest feature number for this short name:

```bash
# Fetch all remote branches
git fetch --all --prune

# Find highest number across all sources
# Remote branches
git ls-remote --heads origin | grep -E "refs/heads/[0-9]+-<short-name>$"

# Local branches
git branch | grep -E "^[* ]*[0-9]+-<short-name>$"

# Specs directories
ls -d specs/[0-9]*-<short-name> 2>/dev/null || true
```

**Determine next number:**

- Extract all numbers from all three sources
- Find the highest number N
- Use N+1 for the new branch number
- If no existing branches/directories found, start with number 1

### Step 3: Run Feature Creation Script

Execute the appropriate script with the calculated number and short-name:

**Bash:**

```bash
<SKILL_DIR>/scripts/create-feature.sh --json --number <N+1> --short-name "<short-name>" "<feature description>"
```

**PowerShell:**

```powershell
<SKILL_DIR>/scripts/create-feature.ps1 -Json -Number <N+1> -ShortName "<short-name>" "<feature description>"
```

Replace `<SKILL_DIR>` with the absolute path to this skill directory.

**Important Notes:**

- Only run this script once per feature
- The JSON output contains BRANCH_NAME and SPEC_FILE paths
- For single quotes in args, use escape syntax: `'I'\''m Groot'` or use double quotes: `"I'm Groot"`
- The script creates and checks  (Optional)

If available in the workspace, load product-level context to ensure alignment:

1. **Read `docs/architecture.md`** (if exists in workspace):
   - Understand technology stack
   - Review architectural patterns
   - Note quality requirements

2. **Read `docs/standards.md`** (if exists in workspace):
   - Understand naming conventions
   - Review coding standards
   - Note best practices

**Note**: This step is optional. The skill works independently without these files.onventions

- Review coding standards
- Note best practices

### Step 5: Create Specification

Follow this execution flow to create the specification:

1. **Parse User Description**
   - Extract from user input
   - If empty, return error: "No feature description provided"

2. **Extract Key Concepts**
   - Identify: actors, actions, data, constraints
   - Document in appropriate spec sections

3. **Handle Unclear Aspects**
   - **Make informed guesses** based on context and industry standards
   - **Only mark with [NEEDS CLARIFICATION: specific question]** if:
     - Choice significantly impacts scope or user experience
     - Multiple reasonable interpretations exist with different implications
     - No reasonable default exists
   - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
   - **Priority**: scope > security/privacy > user experience > technical details

4. **Fill User Scenarios & Testing**
   - Define user flows
   - Create acceptance scenarios
   - If no clear user flow, return error: "Cannot determine user scenarios"

5. **Generate Functional Requirements**
   - Each requirement must be testable
   - Use reasonable defaults for unspecified details
   - Document assumptions in Assumptions section

6. **Define Success Criteria**
   - Create measurable, technology-agnostic outcomes
   - Include quantitative metrics (time, performance, volume)
   - Include qualitative measures (user satisfaction, task completion)
   - Each criterion must be verifiable without implementation details

7. **Identify Key Entities** (if data involved)

The script creates the initial spec file from `templates/spec-template.md`. Now enhance it:

1. The template is already copied to SPEC_FILE by the script
2. Replace placeholders with concrete details from feature description
3. Preserve section order and headings
4. Ensure consistency with architecture.md and standards.md (if they exist in workspace)
5. Fill in all mandatory sectionsdescription
6. Preserve section order and headings
7. Ensure consistency with architecture.md and standards.md

**Section Requirements:**

- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant
- **When section doesn't apply**: Remove it entirely (don't leave as "N/A")

### Step 7: Validate Specification Quality

Create and use a quality checklist to validate the specification:

#### 7a. Create Spec Quality Checklist

Generate a checklist file at `<FEATURE_DIR>/checklists/requirements.md`:

```markdown
# Specification Quality Checklist: [FEATURE NAME]

**Purpose**: Validate specification completeness and quality before proceeding to planning
**Created**: [DATE]
**Feature**: [Link to spec.md]

## Content Quality

- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] All mandatory sections completed

## Requirement Completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
- [ ] Success criteria are technology-agnostic
- [ ] All acceptance scenarios are defined
- [ ] Edge cases are identified
- [ ] Scope is clearly bounded
- [ ] Dependencies and assumptions identified

## Feature Readiness

- [ ] All functional requirements have clear acceptance criteria
- [ ] User scenarios cover primary flows
- [ ] Feature meets measurable outcomes defined in Success Criteria
- [ ] No implementation details leak into specification

## Notes

- Items marked incomplete require spec updates before next phase
```

#### 7b. Run Validation Check

Review the spec against each checklist item:

- For each item, determine pass or fail
- Document specific issues found (quote relevant spec sections)

#### 7c. Handle Validation Results

**If all items pass:**

- Mark checklist complete
- Proceed to final commit

**If items fail (excluding [NEEDS CLARIFICATION]):**

1. List the failing items and specific issues
2. Update the spec to address each issue
3. Re-run validation until all items pass (max 3 iterations)
4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user

**If [NEEDS CLARIFICATION] markers remain:**

1. Extract all [NEEDS CLARIFICATION: ...] markers from the spec
2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by scope/security/UX impact) and make informed guesses for the rest
3. For each clarification needed (max 3), present options to user:

```markdown
## Question [N]: [Topic]

**Context**: [Quote relevant spec section]

**What we need to know**: [Specific question from NEEDS CLARIFICATION marker]

**Suggested Answers**:

| Option | Answer | Implications |
|--------|--------|--------------|
| A      | [First suggested answer] | [What this means for the feature] |
| B      | [Second suggested answer] | [What this means for the feature] |
| C      | [Third suggested answer] | [What this means for the feature] |
| Custom | Provide your own answer | [Explain how to provide custom input] |

**Your choice**: _[Wait for user response]_
```

1. Present all questions together before waiting for responses
2. Wait for user to respond with their choices (e.g., "Q1: A, Q2: Custom - [details], Q3: B")
3. Update the spec by replacing each [NEEDS CLARIFICATION] marker with the user's answer
4. Re-run validation after all clarifications are resolved

#### 7d. Update Checklist

After each validation iteration, update the checklist file with current pass/fail status.

### Step 8: Commit Specification

Generate a 'docs:' prefixed git commit message and commit:

```bash
git add <SPEC_FILE> <CHECKLIST_FILE>
git commit -m "docs: add specification for <feature-name>"
```

### Step 9: Report Completion

Report to user with:

- Branch name
- Spec file path
- Checklist results summary
- Readiness for next phase (`/sunrise.clarify`, `/sunrise.architect`, or `/sunrise.design`)

## Examples

### Example 1: Simple Feature

**Input:**

```
Add user login with email and password
```

**Processing:**

1. Short name: `user-login`
2. Check existing: No existing branches found
3. Branch number: 1
4. Run: `scripts/bash/create-new-feature.sh --json --number 1 --short-name "user-login" "Add user login with email and password"`
5. Create spec with:
   - User scenario: User enters email/password to access account
   - Functional requirements: Email validation, password hashing, session management
   - Success criteria: "95% of users can log in within 10 seconds"

**Output:**

- Branch: `1-user-login`
- Spec: `specs/1-user-login/spec.md`
- Checklist: `specs/1-user-login/checklists/requirements.md`
- All validations pass
- Ready for `/sunrise.design`

### Example 2: Feature Requiring Clarification

**Input:**

```
Add payment processing
```

**Processing:**

1. Short name: `payment-processing`
2. Initial spec created with [NEEDS CLARIFICATION] markers
3. Present questions:

```markdown
## Question 1: Payment Methods

**Context**: The feature requires payment processing but doesn't specify which methods to support.

**What we need to know**: Which payment methods should be supported?

| Option | Answer | Implications |
|--------|--------|--------------|
| A | Credit/debit cards only | Simplest implementation, covers 80% of users |
| B | Credit cards + PayPal | Wider user coverage, requires PayPal integration |
| C | Multiple methods (cards, PayPal, bank transfer) | Maximum flexibility, more complex |
| Custom | Specify your own set | Provide specific payment methods |

**Your choice**: _[Wait for user response]_
```

**User responds**: "Q1: B"

**Output:**

- Spec updated with "Support credit/debit cards and PayPal" requirement
- Re-validated and passes
- Ready for next phase

## Edge Cases

### Case 1: Branch Already Exists

**Scenario**: User tries to create a feature with short-name that already has active branches.

**Handling:**

1. Find highest existing number (e.g., `3-user-auth` exists)
2. Increment to next number: `4-user-auth`
3. Create new branch with incremented number
4. Document in spec: "Related to feature 3-user-auth"

### Case 2: Empty or Vague Description

**Scenario**: User provides minimal description like "Add feature"

**Handling:**

1. Identify the description is too vague
2. Ask clarifying questions about:
   - What the feature should do
   - Who will use it
   - What problem it solves
3. Once clarified, proceed with spec creation

### Case 3: Script Execution Fails

**Scenario**: Feature creation script returns an error.

**Handling:**

1. Check script output for specific error message
2. Common issues:
   - Git not installed: "Please install git"
   - Template not found: "Template file missing at path X"
   - Permission denied: "Check file permissions"
3. Resolve issue and retry
4. If unresolvable, create branch and directories manually

### Case 4: Too Many Clarification Markers

**Scenario**: Initial spec generation creates more than 3 [NEEDS CLARIFICATION] markers.

**Handling:**

1. Prioritize by impact: scope > security/privacy > UX > technical
2. Keep top 3 most critical markers
3. For remaining items, make informed guesses based on:
   - Industry standards
   - Similar features in the product
   - Common patterns
4. Document assumptions in Assumptions section

## Guidelines

### Focus on WHAT and WHY, Not HOW

**DO:**

- "Users can reset their password via email"
- "System supports 10,000 concurrent users"
- "Search results appear in under 1 second"

**DON'T:**

- "Use bcrypt for password hashing" (implementation detail)
- "Store sessions in Redis" (technology choice)
- "Implement with React hooks" (framework-specific)

### Success Criteria Must Be

1. **Measurable**: Include specific metrics (time, percentage, count, rate)
2. **Technology-agnostic**: No frameworks, languages, databases, or tools
3. **User-focused**: Outcomes from user/business perspective
4. **Verifiable**: Can be tested without knowing implementation

### Reasonable Defaults (Don't Ask About These)

- **Data retention**: Industry-standard practices for the domain
- **Performance targets**: Standard web/mobile app expectations unless specified
- **Error handling**: User-friendly messages with appropriate fallbacks
- **Authentication method**: Standard session-based or OAuth2 for web apps
- **Integration patterns**: RESTful APIs unless specified otherwise

### When to Use [NEEDS CLARIFICATION]

Only use when:

- **Scope impact**: Decision significantly changes feature scope
- **Security/privacy**: Legal or financial implications
- **Multiple interpretations**: No clear reasonable default exists
- **User experience**: Fundamentally different UX approaches possible

**Don't use for:**

- Technical implementation details (make reasonable technical assumptions)
- Standard industry practices (use common patterns)
- Minor UX details (use best practices)
- Performance targets (use industry standards)

## Error Handling

### Error: "No feature description provided"

**Cause**: User ran command without providing a description.

**Action:**

1. Prompt user: "Please provide a feature description. What should this feature do?"
2. Wait for user input
3. Proceed with provided description

### Error: "Cannot determine user scenarios"

**Cause**: Feature description is too technical or lacks user context.

**Action:**

1. Ask user: "Who will use this feature and what are they trying to accomplish?"
2. Example prompt: "Describe the user's goal and the steps they'll take"
3. Once clarified, generate user scenarios

### Error: "Template file not found"

**Cause**: Spec template doesn't exist at expected path.

**Action:**

1. Check if `.sunrise/templates/templates-for-commands/spec-template.md` exists
2. If missing, prompt user to create it or provide alternative template path
3. Alternatively, use a generic spec structure with these sections:
   - Feature Name
   - Overview
   - User Scenarios
   - Functional Requirements
   - Success Criteria
   - Assumptions
   - Out of Scope

### Error: "Script execution failed"

**Cause**: Feature creation script returned non-zero exit code.

**Action:**

1. Parse script output for specific error message
2. Common resolutions:
   - Git not configured: `git config --global user.name "Your Name"`
   - Permission denied: `chmod +x scripts/bash/create-new-feature.sh`
   - Invalid arguments: Check JSON formatting and escape characters
3. If script fails repeatedly, create branch and directories manually:
   cp <SKILL_DIR>/templates/spec-template.md specs/<number>-<short-name>/spec.md
   cp <SKILL_DIR>/templates/checklist-template.md specs/<number>-<short-name>/checklists/requirements.md
   git checkout -b <number>-<short-name>
   mkdir -p specs/<number>-<short-name>/checklists
   touch specs/<number>-<short-name>/spec.md

   ```

### Error: "Validation failed after 3 iterations"

**Cause**: Spec quality issues persist after multiple correction attempts.

**Action:**

1. Document specific failing checklist items in checklist notes
2. Provide detailed explanation of each failure to user
3. Suggest manual review of:
   - Requirements clarity
   - Success criteria measurability
   - Implementation detail leakage
4. Offer to proceed with warnings or ask user to manually fix issues

This skill includes:

- `templates/spec-template.md` - Comprehensive specification template with all required sections
- `templates/checklist-template.md` - Quality validation checklist template
- `scripts/create-feature.sh` - Bash script for feature creation (cross-platform: macOS/Linux)
- `scripts/create-feature.ps1` - PowerShell script for feature creation (Windows)

Optional workspace files (if available):

- `docs/architecture.md` - Technology stack and architectural patterns
- `dSelf-Contained**: This skill includes all necessary templates and scripts - no external dependencies required
- **Cross-Platform**: Provides both Bash (macOS/Linux) and PowerShell (Windows) scripts for maximum compatibility
- **Progressive Disclosure**: Loads minimal context initially and fetches additional details only when needed
- **Technology-Agnostic**: Specifications describe user needs and business value, not implementation details
- **Validation-First**: Quality validation ensures specifications are complete before proceeding to design
- **User-Focused**: All requirements and success criteria must be verifiable from a user/business perspective
- **Portable**: Can be used in any project - workspace-level architecture/standards files are optional enhancements

## Notes

- **Progressive Disclosure**: This skill loads minimal context initially and fetches additional details (templates, context files) only when needed
- **Technology-Agnostic**: Specifications should describe user needs and business value, not implementation details
- **Validation-First**: Quality validation ensures specifications are complete before proceeding to design
- **User-Focused**: All requirements and success criteria must be verifiable from a user/business perspective
