---
name: requirements-specification-review
description: Reviews and clarifies existing feature specifications by identifying underspecified areas, asking targeted questions, and integrating answers back into the spec. Use when refining requirements, detecting ambiguities, validating completeness, or when user mentions spec review, clarification, requirements validation, or gap analysis.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-27"
---

# Requirements Specification Review

## When to Use

Use this skill when:

- Reviewing an existing feature specification for completeness
- Identifying ambiguous or underspecified requirements
- Clarifying unclear aspects of a spec before implementation planning
- Validating that a spec is ready for design/development
- Finding gaps in functional or non-functional requirements
- User mentions: spec review, clarification, requirements validation, gap analysis, ambiguity detection

## Prerequisites

**Required:**

- Existing feature specification file
- Scripts provided with this skill (in `scripts/` directory)
- Templates provided with this skill (in `templates/` directory)

**Optional (workspace-level enhancements):**

- `docs/architecture.md` - For architecture alignment validation
- `docs/standards.md` - For standards compliance checking
- Git repository (for tracking and commits)

## Instructions

### Step 1: Setup and Load Specification

1. **Run prerequisites check script** to locate the feature specification:

   **Bash (macOS/Linux):**

   ```bash
   <SKILL_DIR>/scripts/check-prerequisites.sh --json --paths-only
   ```

   **PowerShell (Windows):**

   ```powershell
   <SKILL_DIR>/scripts/check-prerequisites.ps1 -Json -PathsOnly
   ```

   Replace `<SKILL_DIR>` with the absolute path to this skill directory.

   The script returns JSON with:
   - `FEATURE_DIR` - Feature directory path
   - `FEATURE_SPEC` - Path to spec.md file
   - `CURRENT_BRANCH` - Git branch name (if available)

2. **Load the specification file**:
   - Read the spec file from `FEATURE_SPEC` path
   - Parse its structure and sections
   - Identify existing content and placeholders

3. **Load optional context** (if available):
   - `docs/architecture.md` - For architecture alignment checks
   - `docs/standards.md` - For standards compliance checks

### Step 2: Perform Structured Coverage Scan

Scan the specification using a comprehensive 12-category taxonomy. For each category, assess status: **Clear** / **Partial** / **Missing**. See [references/review-guide.md](references/review-guide.md) for detailed assessment criteria and examples for each category.

**Categories**: Functional Scope & Behavior, Domain & Data Model, Interaction & UX Flow, Non-Functional Quality Attributes, Integration & External Dependencies, Edge Cases & Failure Handling, Constraints & Tradeoffs, Architecture Alignment, Standards Compliance, Terminology & Consistency, Completion Signals, Placeholders & Ambiguities

**Create internal coverage map**:
- List each category with status
- Note specific gaps/ambiguities
- Calculate priority: Impact × Uncertainty

### Step 3: Generate Prioritized Question Queue

Based on coverage scan, generate internal prioritized queue. See [references/review-guide.md](references/review-guide.md) for:
- Detailed prioritization matrix (Impact × Uncertainty)
- Question formulation guidelines
- Integration strategies by answer type

**Constraints**: Max 5 questions per session, max 10 total. Each question must be multiple-choice (2-5 options) OR short phrase (≤5 words).

**Prioritization**: Impact × Uncertainty, favor high-risk items, ensure category diversity.

**Exclusion**: Skip if already answered, trivial, or better deferred to planning.

### Step 4: Interactive Questioning Loop

Present questions one at a time in an interactive loop:

#### For Each Question

1. **Analyze and recommend** (for multiple-choice questions):
   - Determine the most suitable option based on:
     - Best practices for the project type
     - Common patterns in similar implementations
     - Risk reduction (security, performance, maintainability)
     - Alignment with project goals/constraints
   - Present recommendation prominently at the top

2. **Format the question**:

   **Multiple-choice format:**

   ```markdown
   ## Question N: [Topic]

   **Context**: [Quote relevant spec section or describe gap]

   **Recommended:** Option [X] - [Brief reasoning why this is best]

   | Option | Description |
   |--------|-------------|
   | A | [Option A description] |
   | B | [Option B description] |
   | C | [Option C description] |
   | Short | Provide a different short answer (≤5 words) |

   You can reply with the option letter (e.g., "A"), accept the recommendation by saying "yes" or "recommended", or provide your own short answer.
   ```

   **Short-answer format:**

   ```markdown
   ## Question N: [Topic]

   **Context**: [Quote relevant spec section or describe gap]

   **Suggested:** [Your proposed answer] - [Brief reasoning]

   Format: Short answer (≤5 words). You can accept the suggestion by saying "yes" or "suggested", or provide your own answer.
   ```

3. **Wait for user response**

4. **Process the answer**:
   - If user says "yes", "recommended", or "suggested": Use your recommendation/suggestion
   - If user provides option letter or short answer: Validate it
   - If ambiguous: Ask for quick disambiguation (doesn't count as new question)
   - Record answer in working memory

5. **Move to next question** until:
   - All critical ambiguities resolved, OR
   - User signals completion ("done", "good", "no more"), OR
   - 5 questions asked

**Special Cases:**

- If no valid questions exist: Report "No critical ambiguities detected" and suggest proceeding
- If spec file missing: Instruct user to create spec first
- Respect early termination: Stop when user says "stop" or "done"

### Step 5: Integrate Each Answer (Incremental Updates)

After EACH accepted answer, immediately update the spec. See [references/review-guide.md](references/review-guide.md) for detailed integration strategies and target sections by answer type.

1. **Ensure Clarifications section exists**: Add `## Clarifications` with `### Session YYYY-MM-DD` if not present
2. **Record Q&A**: Append `- Q: [question] → A: [answer]`
3. **Apply to appropriate section(s)**: Update relevant sections based on answer type
4. **Replace, don't duplicate**: Remove contradictory statements
5. **Save file** after each integration (atomic write)
6. **Preserve formatting**: Don't reorder unrelated sections

### Step 6: Validation

After EACH write and at final completion, validate. See [references/review-guide.md](references/review-guide.md) for detailed validation checklists.

**Per-Integration**: Single bullet per answer, no vague placeholders, no contradictions, valid markdown, consistent terminology

**Final Validation**: Question limits respected, only allowed new headings added, all answers integrated, spec internally consistent

### Step 7: Commit Changes

After all questions are answered and integrated:

1. **Stage the updated spec**:

   ```bash
   git add <FEATURE_SPEC>
   ```

2. **Create commit with 'docs:' prefix**:

   ```bash
   git commit -m "docs: clarify requirements for <feature-name>"
   ```

3. Include summary of what was clarified in commit message if helpful

### Step 8: Report Completion

Provide a completion report with:

1. **Summary statistics**:
   - Number of questions asked & answered
   - Path to updated spec file
   - Sections touched (list names)

2. **Coverage summary table**:

   | Category | Status | Notes |
   |----------|--------|-------|
   | Functional Scope | Resolved | Was Partial, now Clear |
   | Data Model | Clear | Already sufficient |
   | Non-Functional | Deferred | Low impact, defer to planning |
   | Edge Cases | Outstanding | Still Partial, needs follow-up |
   | ... | ... | ... |

3. **Status legend**:
   - **Resolved**: Was Partial/Missing, now addressed
   - **Clear**: Already sufficient from start
   - **Deferred**: Exceeds question quota or better suited for planning phase
   - **Outstanding**: Still Partial/Missing but low impact

4. **Recommendations**:
   - If Outstanding or Deferred items remain: Suggest whether to proceed or run review again
   - Suggest next command: `/phoenix.design`, `/phoenix.architect`, or another review

5. **Next steps**: Guide user on what to do next based on spec completeness

## Examples

See [references/review-guide.md](references/review-guide.md) for detailed coverage scan examples and question formulation patterns.

### Example 1: Data Model Clarification

**Coverage Scan**: Data Model Partial, Security Partial, Edge Cases Missing

**Question**: Password storage method?
**User Answer**: "B" (bcrypt cost factor 12)
**Integration**: Updated Security section, Data Model, Clarifications

### Example 2: Performance Requirements

**Coverage Scan**: Non-functional partially specified

**Question**: Dashboard load time target?
**User Answer**: "yes" (accepted suggestion: under 2 seconds)
**Integration**: Updated Success Criteria, Non-Functional Requirements

## Edge Cases

### No Spec File Found

**Scenario**: Prerequisites check returns empty or missing spec path

**Handling**:

1. Report: "No feature specification found"
2. Suggest: "Please create a spec first using requirements-specification skill"
3. Exit gracefully

### Spec Already Complete

**Scenario**: Coverage scan finds all categories Clear, no meaningful questions

**Handling**:

1. Report: "No critical ambiguities detected worth formal clarification"
2. Output compact coverage summary showing all Clear
3. Suggest: "Spec is ready for next phase: /phoenix.design or /phoenix.architect"

### User Terminates Early

**Scenario**: User says "done" or "stop" after 2 questions

**Handling**:

1. Stop asking questions immediately
2. Integrate any pending answers
3. Report what was completed
4. Note remaining Outstanding categories
5. Suggest running review again later if needed

### Maximum Questions Reached

**Scenario**: 5 questions asked but high-impact categories still unresolved

**Handling**:

1. Complete current session
2. Report completion with Outstanding items explicitly flagged
3. Warning: "High-impact areas remain unclear: [list categories]"
4. Recommend: "Run another review session before proceeding to design"

### Ambiguous User Answer

**Scenario**: User provides unclear answer (e.g., "maybe A or B")

**Handling**:

1. Don't count as new question
2. Ask: "Please clarify: choose A or B"
3. Wait for unambiguous response
4. Proceed only when clear

### Conflicting Information

**Scenario**: Answer contradicts existing spec content

**Handling**:

1. Highlight the conflict to user
2. Ask: "This conflicts with [existing statement]. Should I replace it?"
3. If yes: Replace old with new, note change in clarifications
4. If no: Keep old, note user's rationale

## Error Handling

See [references/review-guide.md](references/review-guide.md) for detailed error recovery strategies.

### Error: Spec File Not Readable
**Action**: Report error, check permissions/encoding, suggest fix, exit with error

### Error: Invalid Markdown Structure
**Action**: Report error, identify problematic section, suggest fix, proceed with best-effort parsing

### Error: Git Commit Fails
**Action**: Ensure file saved (priority), report error, suggest manual commit, continue with completion report

### Error: Integration Conflict
**Action**: Save in Clarifications only, report manual integration needed, continue with next question

## Guidelines

1. **Ask questions sequentially** - Never present multiple questions at once
2. **Always recommend an answer** - Help users make informed decisions
3. **Integrate immediately** - Update spec after each answer, don't batch
4. **Validate continuously** - Check consistency after each integration
5. **Preserve user content** - Don't rewrite unrelated sections
6. **Be explicit** - Make all clarifications concrete and testable
7. **Respect limits** - Stop at 5 questions even if more gaps exist
8. **Commit with 'docs:' prefix** - Follow git commit conventions
9. **Report thoroughly** - Provide complete coverage summary at end
10. **Guide next steps** - Always suggest what to do next

## Included Resources

This skill is self-contained and includes:

**Templates** (in `templates/` directory):

- `coverage-report-template.md` - Coverage summary report format
- `clarifications-section-template.md` - Format for spec clarifications section

**Scripts** (in `scripts/` directory):

- `check-prerequisites.sh` - Bash script to locate spec file (macOS/Linux)
- `check-prerequisites.ps1` - PowerShell script to locate spec file (Windows)

**Optional Workspace Files** (if available):

- `docs/architecture.md` - For architecture alignment validation
- `docs/standards.md` - For standards compliance checking

All templates are referenced as examples; the skill handles integration programmatically.

## Next Steps After Review

After completing the specification review, consider:

1. **If Outstanding items remain**: Run another review session
2. **If all Critical items resolved**: Proceed to technical design
3. **Use technical-design skill**: Create implementation plan
4. **Use phoenix.architect**: Build architectural design
5. **Use phoenix.design**: Create detailed technical design

## Notes

- **Self-Contained**: Skill includes all necessary scripts and templates
- **Cross-Platform**: Bash and PowerShell scripts for maximum compatibility
- **Incremental Updates**: Saves after each answer to prevent data loss
- **Interactive**: Sequential questioning with recommendations
- **Comprehensive**: 12-category taxonomy for thorough coverage
- **Portable**: Works in any project with or without git
- **Non-Destructive**: Only adds/updates, never removes user content without explicit conflict resolution
