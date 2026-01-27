---
name: requirements-specification-review
description: Reviews and clarifies existing feature specifications by identifying underspecified areas, asking targeted questions, and integrating answers back into the spec. Use when refining requirements, detecting ambiguities, validating completeness, or when user mentions spec review, clarification, requirements validation, or gap analysis.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-25"
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

Scan the specification using this comprehensive taxonomy. For each category, assess status: **Clear** / **Partial** / **Missing**.

#### Taxonomy Categories

**1. Functional Scope & Behavior**

- Core user goals & success criteria defined
- Explicit out-of-scope declarations present
- User roles / personas differentiation clear

**2. Domain & Data Model**

- Entities, attributes, relationships documented
- Identity & uniqueness rules specified
- Lifecycle/state transitions defined
- Data volume / scale assumptions stated

**3. Interaction & UX Flow**

- Critical user journeys / sequences documented
- Error/empty/loading states specified
- Accessibility or localization notes included

**4. Non-Functional Quality Attributes**

- Performance targets (latency, throughput) specified
- Scalability expectations (horizontal/vertical, limits) defined
- Reliability & availability (uptime, recovery) stated
- Observability needs (logging, metrics, tracing) documented
- Security & privacy (authN/Z, data protection) specified
- Compliance / regulatory constraints noted

**5. Integration & External Dependencies**

- External services/APIs and failure modes documented
- Data import/export formats specified
- Protocol/versioning assumptions stated

**6. Edge Cases & Failure Handling**

- Negative scenarios documented
- Rate limiting / throttling behavior specified
- Conflict resolution (e.g., concurrent edits) defined

**7. Constraints & Tradeoffs**

- Technical constraints documented
- Explicit tradeoffs or rejected alternatives noted

**8. Architecture Alignment** (if architecture.md exists)

- Alignment with architectural patterns validated
- Consistency with technology stack verified
- Adherence to quality attribute requirements checked

**9. Standards Compliance** (if standards.md exists)

- Naming convention requirements checked
- File structure alignment verified
- Coding standard adherence validated

**10. Terminology & Consistency**

- Canonical glossary terms used consistently
- No conflicting synonyms / deprecated terms

**11. Completion Signals**

- Acceptance criteria are testable
- Measurable Definition of Done indicators present

**12. Placeholders & Ambiguities**

- No TODO markers remain
- Ambiguous adjectives ("robust", "intuitive") are quantified

**Create internal coverage map** (do not output unless no questions will be asked):

- List each category with its status
- Note specific gaps or ambiguities found
- Calculate priority score: Impact × Uncertainty

### Step 3: Generate Prioritized Question Queue

Based on the coverage scan, generate an internal prioritized queue of clarification questions:

**Constraints:**

- **Maximum 5 questions** per review session
- **Maximum 10 questions** across all sessions for this spec
- Each question must be answerable with:
  - Multiple-choice (2-5 options), OR
  - Short phrase answer (≤5 words)

**Prioritization Criteria:**

1. **Impact**: Will the answer materially change architecture, data modeling, testing, or UX?
2. **Uncertainty**: Is this highly ambiguous or missing?
3. **Risk**: Will lack of clarity cause downstream rework?
4. **Coverage balance**: Spread questions across high-impact categories

**Exclusion Rules:**

- Skip if already answered in spec
- Skip if trivial stylistic preference
- Skip if better deferred to planning phase
- Skip if doesn't block correctness

**Selection Strategy:**

- If >5 categories unresolved, select top 5 by (Impact × Uncertainty)
- Favor questions that reduce rework risk
- Ensure category diversity

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

After EACH accepted answer, immediately update the spec:

1. **Ensure Clarifications section exists**:
   - Add `## Clarifications` section if not present (after overview/context section)
   - Create `### Session YYYY-MM-DD` subheading for today

2. **Record the Q&A**:
   - Append: `- Q: [question] → A: [final answer]`

3. **Apply clarification to appropriate section(s)**:

   | Answer Type | Target Section | Action |
   |-------------|----------------|--------|
   | Functional requirement | Functional Requirements | Add/update requirement bullet |
   | User interaction/actor | User Scenarios or Actors | Update role, constraint, or scenario |
   | Data model | Key Entities or Data Model | Add fields, types, relationships |
   | Non-functional | Non-Functional / Quality Attributes | Add measurable criteria |
   | Edge case | Edge Cases / Error Handling | Add new bullet or subsection |
   | Terminology | Throughout spec | Normalize term, note old usage once |

4. **Replace, don't duplicate**:
   - If answer invalidates an earlier ambiguous statement, replace it
   - Remove obsolete contradictory text
   - Keep each clarification minimal and testable

5. **Save the spec file** after each integration (atomic write)

6. **Preserve formatting**:
   - Don't reorder unrelated sections
   - Keep heading hierarchy intact
   - Maintain consistent style

### Step 6: Validation

After EACH write and at final completion, validate:

**Per-Integration Checks:**

- [ ] Clarifications session has exactly one bullet per answer (no duplicates)
- [ ] Updated section contains no lingering vague placeholders
- [ ] No contradictory earlier statement remains
- [ ] Markdown structure is valid
- [ ] Terminology is consistent across updated sections

**Final Validation:**

- [ ] Total asked (accepted) questions ≤ 5
- [ ] Only allowed new headings: `## Clarifications`, `### Session YYYY-MM-DD`
- [ ] All integrated answers are reflected in appropriate sections
- [ ] Spec is internally consistent

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
   - Suggest next command: `/sunrise.design`, `/sunrise.architect`, or another review

5. **Next steps**: Guide user on what to do next based on spec completeness

## Examples

### Example 1: Data Model Clarification

**Input**: Review spec for user authentication feature

**Coverage Scan Findings**:

- Functional Scope: Clear
- Data Model: Partial (missing password storage details)
- Security: Partial (no password policy specified)
- Edge Cases: Missing (no account lockout policy)

**Questions Asked**:

```markdown
## Question 1: Password Storage

**Context**: Spec mentions "store user passwords" but doesn't specify hashing method.

**Recommended:** Option B - Industry standard with excellent security track record

| Option | Description |
|--------|-------------|
| A | bcrypt with cost factor 10 |
| B | bcrypt with cost factor 12 (recommended) |
| C | argon2id with default parameters |
```

**User Answer**: "B"

**Integration**:

- Clarifications section: `- Q: Password storage method? → A: bcrypt with cost factor 12`
- Security section: Added "Passwords hashed using bcrypt (cost factor 12)"
- Data Model: Updated User entity to note "password_hash: string (bcrypt)"

**Output**: Spec updated, 1 question asked, 4 sections touched, ready for next questions

### Example 2: Performance Requirements

**Input**: Review spec for analytics dashboard

**Coverage Scan**: Non-functional requirements partially specified

**Question**:

```markdown
## Question 1: Query Performance

**Context**: Spec says "dashboard should load quickly" but lacks measurable target.

**Suggested:** Initial load under 2 seconds - Standard for good UX

Format: Short answer (≤5 words). Accept suggestion or provide alternative.
```

**User Answer**: "yes"

**Integration**:

- Clarifications: `- Q: Dashboard load time target? → A: Initial load under 2 seconds`
- Success Criteria: Added "Dashboard initial load completes in under 2 seconds for 95th percentile"

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
3. Suggest: "Spec is ready for next phase: /sunrise.design or /sunrise.architect"

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

### Error: Spec File Not Readable

**Cause**: File permissions or encoding issue

**Action**:

1. Report: "Cannot read spec file at [path]"
2. Check file exists and is readable
3. Suggest: "Verify file permissions or encoding"
4. Exit with error

### Error: Invalid Markdown Structure

**Cause**: Spec has malformed markdown that breaks parsing

**Action**:

1. Report: "Spec file has invalid markdown structure"
2. Attempt to identify problematic section
3. Suggest: "Fix markdown syntax and retry"
4. Proceed with best-effort parsing if critical sections readable

### Error: Git Commit Fails

**Cause**: Git error when committing changes

**Action**:

1. Ensure changes are saved to file (priority)
2. Report: "Spec updated but commit failed: [error]"
3. Show git error message
4. Suggest: "Manually commit with: git add [spec] && git commit"
5. Continue with completion report

### Error: Integration Conflict

**Cause**: Can't determine where to integrate answer in spec

**Action**:

1. Save answer in Clarifications section only
2. Report: "Answer recorded in Clarifications but couldn't auto-integrate"
3. Note: "Manual integration needed in [section name]"
4. Continue with next question

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
4. **Use sunrise.architect**: Build architectural design
5. **Use sunrise.design**: Create detailed technical design

## Notes

- **Self-Contained**: Skill includes all necessary scripts and templates
- **Cross-Platform**: Bash and PowerShell scripts for maximum compatibility
- **Incremental Updates**: Saves after each answer to prevent data loss
- **Interactive**: Sequential questioning with recommendations
- **Comprehensive**: 12-category taxonomy for thorough coverage
- **Portable**: Works in any project with or without git
- **Non-Destructive**: Only adds/updates, never removes user content without explicit conflict resolution
