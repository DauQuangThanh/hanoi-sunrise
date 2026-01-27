---
name: project-consistency-analysis
description: Performs read-only cross-artifact consistency analysis across spec.md, design.md, and tasks.md. Detects duplications, ambiguities, coverage gaps, ground-rules violations, and inconsistencies. Generates structured analysis reports with severity levels and remediation recommendations. Use when validating project artifacts, checking consistency, analyzing quality, or when user mentions analyze project, check consistency, validate artifacts, or quality analysis.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
license: MIT
---

# Project Consistency Analysis Skill

## Overview

This skill performs comprehensive, non-destructive consistency and quality analysis across project specification artifacts (spec.md, design.md, tasks.md). It identifies duplications, ambiguities, underspecifications, ground-rules violations, coverage gaps, and inconsistencies before implementation begins. The analysis is strictly read-only and produces structured reports with actionable recommendations.

## When to Use

- After completing task breakdown (tasks.md generated)
- Before starting implementation
- Validating project artifact consistency
- Checking ground-rules compliance
- Identifying requirements coverage gaps
- Detecting ambiguous or duplicate requirements
- User mentions: "analyze project", "check consistency", "validate artifacts", "quality analysis", "check spec"

## Prerequisites

- **Required documents in feature directory**:
  - `spec.md` - Feature requirements and user stories (Required)
  - `design.md` - Technical design and architecture (Required)
  - `tasks.md` - Implementation task breakdown (Required)
- **Ground rules document** (Highly recommended):
  - `docs/ground-rules.md` - Project principles and guidelines
- **Product-level documentation** (Optional):
  - `docs/architecture.md` - Architectural patterns and decisions
  - `docs/standards.md` - Coding and design standards
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## Instructions

### Step 1: Check Prerequisites and Load Artifacts

Run the prerequisite check script to verify required documents exist:

**Bash (Unix/Linux/macOS):**

```bash
cd /path/to/repo
bash skills/project-consistency-analysis/scripts/check-analysis-prerequisites.sh --json
```

**PowerShell (Windows):**

```powershell
cd C:\path\to\repo
powershell -ExecutionPolicy Bypass -File skills/project-consistency-analysis/scripts/check-analysis-prerequisites.ps1 -Json
```

Parse the output to extract:

- `FEATURE_DIR`: Absolute path to feature directory
- `SPEC_FILE`: Path to spec.md
- `DESIGN_FILE`: Path to design.md
- `TASKS_FILE`: Path to tasks.md
- `GROUND_RULES_AVAILABLE`: Boolean indicating if ground-rules.md exists
- `ARCHITECTURE_AVAILABLE`: Boolean indicating if architecture.md exists
- `STANDARDS_AVAILABLE`: Boolean indicating if standards.md exists

### Step 2: Load Artifacts with Progressive Disclosure

Load only minimal necessary context from each artifact to maintain token efficiency:

#### From spec.md (Required)

- **Overview/Context**: Project purpose and scope
- **Functional Requirements**: What the system must do
- **Non-Functional Requirements**: Performance, security, scalability, etc.
- **User Stories**: User actions with acceptance criteria
- **Edge Cases**: Unusual scenarios and handling (if present)

#### From design.md (Required)

- **Architecture/Stack Choices**: Technology decisions
- **Data Model References**: Entity definitions
- **Phases**: Development phases or milestones
- **Technical Constraints**: Limitations and dependencies

#### From tasks.md (Required)

- **Task IDs**: Unique identifiers (T001, T002, etc.)
- **Task Descriptions**: What each task accomplishes
- **Phase Grouping**: Which phase each task belongs to
- **Parallel Markers**: [P] indicators for parallel execution
- **Referenced File Paths**: Files to create/modify

#### From docs/ground-rules.md (If Available)

- **Principle Names**: Core project principles
- **MUST/SHOULD Statements**: Normative requirements
- **Quality Gates**: Required checkpoints
- **Prohibited Practices**: What to avoid

#### From docs/architecture.md (If Available)

- **Architectural Patterns**: Design patterns to follow
- **Technology Stack**: Approved technologies
- **Component Organization**: System structure
- **Quality Attribute Requirements**: Performance, security goals
- **ADRs**: Architecture Decision Records

#### From docs/standards.md (If Available)

- **UI Naming Conventions**: Component, prop, event names
- **Code Naming Conventions**: Variables, functions, classes
- **File Structure Standards**: Directory organization
- **API Design Standards**: Endpoint conventions

### Step 3: Build Semantic Models

Create internal representations for analysis (do not include in output):

#### Requirements Inventory

- Extract each functional and non-functional requirement
- Generate stable keys using slug format (e.g., "User can upload file" → `user-can-upload-file`)
- Track requirement location (file, line number)

#### User Story/Action Inventory

- Extract discrete user actions
- Map acceptance criteria to each story
- Identify story dependencies

#### Task Coverage Mapping

- Map each task to one or more requirements or stories
- Use keyword matching and explicit references (IDs, key phrases)
- Track unmapped tasks and uncovered requirements

#### Ground-Rules Rule Set

- Extract principle names
- Identify MUST and SHOULD normative statements
- Create validation criteria

### Step 4: Detection Passes (High-Signal Analysis)

Focus on actionable findings. Limit to 50 findings total; summarize overflow.

#### A. Duplication Detection

**Objective:** Identify near-duplicate requirements that should be consolidated

**Detection Criteria:**

- Requirements with >70% textual similarity
- Same user story described multiple times
- Repeated non-functional requirements with different wording

**Example Finding:**

- **Location:** spec.md:L45, spec.md:L120
- **Issue:** Two requirements both specify "fast response time" without clear distinction
- **Recommendation:** Consolidate into single requirement with measurable criteria

#### B. Ambiguity Detection

**Objective:** Flag vague or unmeasurable requirements

**Detection Criteria:**

- Vague adjectives without measurable criteria:
  - "fast", "scalable", "secure", "intuitive", "robust", "efficient", "user-friendly"
- Unresolved placeholders:
  - "TODO", "TKTK", "???", "<placeholder>", "[to be determined]"
- Requirements using "should" without clear definition
- Acceptance criteria with subjective measures

**Example Finding:**

- **Location:** spec.md:L78
- **Issue:** "System must be fast" - no measurable performance criteria
- **Recommendation:** Specify concrete metric (e.g., "API responses < 200ms for 95th percentile")

#### C. Underspecification Detection

**Objective:** Identify incomplete or unclear requirements

**Detection Criteria:**

- Requirements with action verbs but missing objects or outcomes
- User stories missing acceptance criteria
- Tasks referencing undefined files or components
- Non-functional requirements without implementation guidance

**Example Finding:**

- **Location:** spec.md:L92
- **Issue:** "System must handle errors" - missing error types and handling strategies
- **Recommendation:** Specify error types, logging requirements, and user feedback mechanisms

#### D. Ground-Rules Alignment

**Objective:** Validate compliance with project principles

**Detection Criteria:**

- Any requirement or design element conflicting with MUST principles
- Missing mandated sections from ground-rules
- Skipped quality gates
- Use of prohibited practices

**Severity:** All ground-rules violations are CRITICAL

**Example Finding:**

- **Location:** design.md:L150
- **Issue:** Violates ground-rule "MUST use TypeScript for type safety" - design specifies plain JavaScript
- **Recommendation:** Update design to use TypeScript or update ground-rules if principle changed

#### E. Coverage Gap Detection

**Objective:** Ensure all requirements have corresponding tasks

**Detection Criteria:**

- Requirements with zero associated tasks
- Tasks with no mapped requirement or user story
- Non-functional requirements not reflected in implementation tasks
- Missing tasks for security, performance, or accessibility requirements

**Example Finding:**

- **Location:** spec.md:L56 (Requirement: data-encryption)
- **Issue:** No tasks implement data encryption requirement
- **Recommendation:** Add tasks for encryption implementation and testing

#### F. Inconsistency Detection

**Objective:** Identify contradictions and misalignments

**Detection Criteria:**

- **Terminology Drift**: Same concept named differently (e.g., "User" vs "Account" vs "Profile")
- **Data Entity Mismatches**: Entities in design.md not defined in spec.md (or vice versa)
- **Task Ordering Issues**: Integration tasks before foundational setup without dependency notes
- **Conflicting Requirements**: Contradictory technology or approach specifications
- **Architecture Misalignment**: Design uses technology not approved in architecture.md
- **Standards Violations**: File/code naming not following standards.md
- **Pattern Deviations**: Implementation not following architectural patterns

**Example Finding:**

- **Location:** spec.md:L34 vs design.md:L78
- **Issue:** Spec requires Next.js, design specifies Vue.js
- **Recommendation:** Resolve technology conflict - align spec and design

### Step 5: Severity Assignment

Assign severity levels to prioritize findings:

#### CRITICAL

- Violates ground-rules MUST requirement
- Missing core spec artifact
- Requirement with zero coverage that blocks baseline functionality
- Contradictory requirements preventing implementation
- Major security or data integrity gaps

**Action:** Must resolve before implementation

#### HIGH

- Duplicate or conflicting requirements
- Ambiguous security/performance attributes
- Untestable acceptance criteria
- Missing non-functional requirement coverage
- Architecture/standards violations

**Action:** Should resolve before implementation

#### MEDIUM

- Terminology drift affecting clarity
- Underspecified edge cases
- Minor coverage gaps in optional features
- Task ordering inconsistencies with workarounds

**Action:** Can proceed but recommend fixes

#### LOW

- Style/wording improvements
- Minor redundancy not affecting execution
- Optional documentation gaps
- Cosmetic inconsistencies

**Action:** Optional improvements, can defer

### Step 6: Generate Analysis Report

Create structured report using `templates/analysis-report.md`:

**Report Structure:**

1. **Executive Summary**
   - Overall status (Pass / Issues Found / Critical Issues)
   - Total findings by severity
   - Coverage percentage
   - Key metrics

2. **Findings Table**

   | ID | Category | Severity | Location(s) | Summary | Recommendation |
   |---|---|---|---|---|---|
   | A1 | Ambiguity | HIGH | spec.md:L78 | "Fast response" unmeasurable | Define < 200ms target |
   | D1 | Duplication | MEDIUM | spec.md:L45, L120 | Duplicate requirements | Merge into single req |

3. **Coverage Summary**

   | Requirement Key | Has Tasks? | Task IDs | Notes |
   |---|---|---|---|
   | user-can-login | ✅ | T010, T011 | Complete |
   | data-encryption | ❌ | - | Missing implementation |

4. **Ground-Rules Alignment Issues** (if any)

   List all CRITICAL ground-rules violations with recommendations

5. **Unmapped Tasks** (if any)

   Tasks that don't map to any requirement or user story

6. **Metrics Summary**
   - Total Requirements: X
   - Total Tasks: Y
   - Coverage %: Z% (requirements with ≥1 task)
   - Findings: Critical: A, High: B, Medium: C, Low: D
   - Ambiguity Count: E
   - Duplication Count: F

### Step 7: Provide Next Actions

Based on analysis results, recommend next steps:

#### If CRITICAL Issues Exist

- **Stop:** Do not proceed with implementation
- **Action:** Resolve critical issues first
- **Commands:** Suggest specific commands to fix issues
  - `/sunrise.specify` - Refine specifications
  - `/sunrise.design` - Adjust architecture
  - Manually edit tasks.md to add coverage

#### If Only HIGH/MEDIUM Issues

- **Proceed with Caution:** Can start implementation but should fix issues
- **Action:** Address high-priority items, defer medium if needed
- **Commands:** Provide improvement suggestions

#### If Only LOW Issues or No Issues

- **Clear to Proceed:** Ready for implementation
- **Action:** Optional improvements can be deferred
- **Commands:** `/sunrise.implement` to start implementation

**Example Next Actions Block:**

```markdown
## Next Actions

**Status:** 🔴 Critical Issues Found - Do Not Implement

### Immediate Actions Required

1. **Resolve Technology Conflict** (CRITICAL)
   - Location: spec.md:L34 vs design.md:L78
   - Action: Align on Next.js or Vue.js, update conflicting document

2. **Add Encryption Tasks** (CRITICAL)
   - Location: spec.md:L56
   - Action: Add tasks to tasks.md for data encryption implementation

3. **Fix Ground-Rules Violation** (CRITICAL)
   - Location: design.md:L150
   - Action: Update design to use TypeScript per ground-rules

### Recommended Next Steps

1. Run `/sunrise.specify` to refine ambiguous requirements
2. Edit tasks.md to add coverage for missing requirements
3. Re-run analysis after fixes to verify resolution
```

### Step 8: Offer Remediation Suggestions

After presenting the report, ask the user:

**"Would you like me to suggest concrete remediation edits for the top N issues?"**

**Important:** Do NOT apply edits automatically. This skill is strictly read-only.

If user agrees, provide specific edit recommendations:

- Exact file paths and line numbers
- "Change from" → "Change to" examples
- Rationale for each change

## Operating Principles

### Strictly Read-Only

- **NEVER** modify any files during analysis
- **NEVER** auto-apply fixes or remediation
- **ALWAYS** output findings to console or report file only

### Token Efficiency

- **Minimal High-Signal Tokens**: Focus on actionable findings, not exhaustive documentation
- **Progressive Disclosure**: Load artifacts incrementally, don't dump all content
- **Limited Output**: Cap findings at 50 rows, summarize overflow
- **Deterministic Results**: Rerunning without changes produces consistent IDs and counts

### Analysis Quality

- **No Hallucination**: If sections are missing, report accurately - don't invent content
- **Prioritize Ground-Rules**: Violations are automatically CRITICAL
- **Concrete Examples**: Cite specific instances, not generic patterns
- **Graceful Zero-Issues**: Emit success report with coverage statistics if no issues found

### Ground-Rules Authority

Ground rules from `docs/ground-rules.md` are **non-negotiable**:

- MUST principles cannot be overridden or reinterpreted
- Ground-rules conflicts are automatically CRITICAL
- Changing principles requires explicit ground-rules update (separate process)
- Do not dilute or ignore principles in analysis

## Examples

### Example 1: Basic Analysis with Issues

**Input:**

```bash
bash skills/project-consistency-analysis/scripts/check-analysis-prerequisites.sh --json
```

**Output:**

```json
{
  "success": true,
  "feature_dir": "/path/to/specs/feature-name",
  "spec_file": "/path/to/specs/feature-name/spec.md",
  "design_file": "/path/to/specs/feature-name/design.md",
  "tasks_file": "/path/to/specs/feature-name/tasks.md",
  "ground_rules_available": true,
  "architecture_available": true,
  "standards_available": true
}
```

**Analysis Results:**

- 3 Critical issues (1 ground-rules violation, 2 missing coverage)
- 5 High issues (ambiguous requirements)
- 8 Medium issues (terminology drift)
- 2 Low issues (style improvements)
- Coverage: 85% (45/53 requirements have tasks)

**Recommendation:** Resolve critical issues before implementation

### Example 2: Clean Analysis (No Issues)

**Analysis Results:**

- 0 Critical issues
- 0 High issues
- 2 Medium issues (minor terminology inconsistencies)
- 1 Low issue (optional documentation)
- Coverage: 100% (all requirements have tasks)

**Recommendation:** Ready to proceed with implementation

## Edge Cases

- **Missing tasks.md**: Report error, suggest running task generation first
- **Malformed YAML frontmatter**: Attempt to parse, report parsing errors
- **Empty artifacts**: Report as critical underspecification
- **No ground-rules.md**: Skip ground-rules validation, note absence in report
- **Architecture/standards.md missing**: Skip those validation passes
- **Circular references**: Detect and report as inconsistency
- **Very large artifacts**: Use sampling or focus on high-priority sections

## Error Handling

- **Script execution fails**: Report exact error, check working directory
- **Invalid JSON from script**: Parse as text and extract paths manually
- **Missing required documents**: List what's missing, provide commands to create
- **Cannot read artifacts**: Report access issues, suggest checking permissions
- **Analysis timeout**: Report partial results, suggest breaking down analysis
- **Memory constraints**: Use streaming analysis for large artifacts

## Scripts

This skill includes cross-platform scripts for checking analysis prerequisites:

### Bash Script (Unix/Linux/macOS)

```bash
bash skills/project-consistency-analysis/scripts/check-analysis-prerequisites.sh --json
```

**Features:**

- Locates feature directory and required artifacts
- Verifies spec.md, design.md, tasks.md exist
- Checks for ground-rules.md, architecture.md, standards.md
- JSON and human-readable output

### PowerShell Script (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File skills/project-consistency-analysis/scripts/check-analysis-prerequisites.ps1 -Json
```

**Features:**

- Locates feature directory and required artifacts
- Verifies spec.md, design.md, tasks.md exist
- Checks for ground-rules.md, architecture.md, standards.md
- JSON and human-readable output

### Script Output Format

Both scripts output JSON with:

- `success`: Boolean indicating if prerequisites met
- `feature_dir`: Path to feature directory
- `spec_file`: Path to spec.md
- `design_file`: Path to design.md
- `tasks_file`: Path to tasks.md
- `ground_rules_available`: Boolean for ground-rules.md
- `architecture_available`: Boolean for architecture.md
- `standards_available`: Boolean for standards.md
- `error`: Error message if prerequisites not met

## Templates

- `templates/analysis-report.md`: Structure for comprehensive consistency analysis reports

## Guidelines

1. **Be Thorough But Focused**: Analyze systematically, prioritize high-impact findings
2. **Be Objective**: Report facts, not opinions
3. **Be Specific**: Reference exact locations (file:line)
4. **Prioritize Severity**: Use severity levels consistently
5. **Explain Rationale**: Why something is an issue, not just what
6. **Suggest Solutions**: Provide actionable recommendations
7. **Respect Context**: Understand project constraints
8. **Never Modify Files**: Strictly read-only analysis
9. **Use Examples**: Show concrete instances, not abstractions
10. **Report Gracefully**: Handle zero-issues case positively

## Success Criteria

An analysis is complete when:

- [ ] All three required artifacts analyzed (spec.md, design.md, tasks.md)
- [ ] Six detection passes completed (duplication, ambiguity, underspecification, ground-rules, coverage, inconsistency)
- [ ] Severity assigned to all findings
- [ ] Coverage percentage calculated
- [ ] Report generated with findings table and metrics
- [ ] Next actions provided based on severity
- [ ] Remediation suggestions offered (but not applied)
- [ ] No files modified during analysis
