---
name: coding
description: Executes feature implementation by processing tasks.md files, validating checklists, setting up project structure, and implementing code following architectural patterns and coding standards. Handles phase-by-phase execution with TDD approach, dependency management, and progress tracking. Use when implementing features, executing task plans, coding from specifications, or when user mentions implement tasks, execute implementation, code feature, or follow task breakdown.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
license: MIT
---

# Coding Skill

## Overview

This skill executes feature implementations by processing structured task lists (tasks.md), validating quality checklists, and systematically implementing code following architectural patterns, coding standards, and test-driven development practices. It manages phase-by-phase execution with proper dependency handling and progress tracking.

## When to Use

- Implementing features from task breakdowns
- Executing implementation plans systematically
- Coding from specifications and design documents
- Following TDD (Test-Driven Development) approach
- Managing phase-based implementation workflow
- Tracking implementation progress
- User mentions: "implement tasks", "execute implementation", "code feature", "follow task breakdown", "implement from tasks.md"

**Related Skills:**
- **Before coding**: Use `technical-design` and `project-management` skills for planning
- **After coding**: Use `code-review` skill for quality validation
- **During coding**: Use `bug-analysis` skill if issues discovered
- **Standards**: Use `coding-standards` skill if standards.md is missing

## Prerequisites

- **Required documents in feature directory**:
  - `tasks.md` - Task breakdown and execution plan (Required)
  - `design.md` - Technical design and architecture (Required)
  - `spec.md` - Feature requirements and user stories (Optional but recommended)
- **Product-level documentation** (Optional but recommended):
  - `docs/architecture.md` - System architecture, patterns, ADRs
  - `docs/standards.md` - Coding conventions and standards (**Recommended:** use `coding-standards` skill to create if missing)
- **Optional supporting documents**:
  - `data-model.md` - Entity definitions and relationships
  - `contracts/` - API specifications
  - `research.md` - Technical decisions
  - `checklists/` - Quality checklists
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## Instructions

### Step 0: Technical Design and Task Plan Verification

**⚠️ IMPORTANT: Always request technical design and task breakdown before starting implementation.**

1. **Request required documents:**
   - Ask the user to provide the technical design document (`design.md`)
   - Request the task breakdown file (`tasks.md`) with detailed implementation tasks
   - If missing, ask the user to provide or confirm the location of:
     - Technical specifications and design decisions
     - Implementation plan with task breakdown by phase
     - Task dependencies and execution order
     - Data models and API contracts (if applicable)

2. **Verify task breakdown completeness:**
   - Confirm `tasks.md` exists with:
     - Clear task breakdown organized by phases (Setup, Tests, Core, Integration, Polish)
     - Task IDs and descriptions
     - File paths for each task
     - Dependencies between tasks
     - Parallelization markers ([P]) where applicable
   - Verify tasks are actionable and specific

3. **Verify technical design completeness:**
   - Confirm `design.md` exists with:
     - Technology stack and libraries to be used
     - Project structure and file organization
     - Component architecture and design patterns
     - Technical decisions and rationale
   - Check if `spec.md` (feature requirements) is available
   - Verify if product-level docs exist (`docs/architecture.md`, `docs/standards.md`)

4. **Review and confirm understanding:**
   - Summarize the feature to be implemented
   - Review the task breakdown, phases, and dependencies
   - Clarify any ambiguities in the technical design
   - Confirm the implementation approach and technology stack
   - Identify which phase or task to start with
   - Ask about any specific concerns or constraints

5. **Only proceed to Step 1 after:**
   - Technical design document (`design.md`) is provided and reviewed
   - Task breakdown (`tasks.md`) is provided and reviewed with clear phases and dependencies
   - Implementation approach is clearly understood
   - Starting point (phase/task) is confirmed
   - User confirms readiness to start implementation

### Step 1: Check Prerequisites and Load Context

Run the prerequisite check script to verify required documents exist:

**Bash (Unix/Linux/macOS):**

```bash
cd /path/to/repo
bash skills/coding/scripts/check-implementation.sh --json
```

**PowerShell (Windows):**

```powershell
cd C:\path\to\repo
powershell -ExecutionPolicy Bypass -File skills/coding/scripts/check-implementation.ps1 -Json
```

Parse the output to extract:

- `FEATURE_DIR`: Absolute path to feature directory
- `AVAILABLE_DOCS`: List of available design/spec documents
- `TASKS_FILE`: Path to tasks.md
- `CHECKLIST_STATUS`: Status of quality checklists (if exists)

### Step 2: Validate Quality Checklists (If Present)

If `FEATURE_DIR/checklists/` exists, validate all checklists before proceeding. See [references/implementation-patterns.md](references/implementation-patterns.md#checklist-validation-process) for detailed validation process.

**Quick Summary:**
- Scan all checklist files and count completed vs incomplete items
- Create status table showing pass/fail for each checklist
- If all pass → proceed automatically
- If any incomplete → ask user permission to proceed or halt

### Step 3: Load Implementation Context

Read all available documents to build complete implementation context:

#### Required Documents

1. **tasks.md** (Required):
   - Extract task phases (Setup, Tests, Core, Integration, Polish)
   - Parse task IDs, descriptions, file paths
   - Identify parallel tasks (marked with [P])
   - Extract dependencies and execution order

2. **design.md** (Required):
   - Extract tech stack and libraries
   - Extract project structure and file organization
   - Extract component architecture
   - Extract technical decisions

#### Product-Level Documents (If Available)

1. **docs/architecture.md** (Optional):
   - Extract architectural patterns and styles
   - Extract C4 model component organization
   - Extract technology stack decisions
   - Extract ADRs (Architecture Decision Records)
   - Extract deployment architecture
   - Extract quality attribute requirements

2. **docs/standards.md** (Optional):
   - Extract UI naming conventions
   - Extract code naming conventions
   - Extract file structure standards
   - Extract API design standards
   - Extract database naming conventions
   - Extract testing standards
   - Extract Git commit conventions
   - Extract documentation standards

#### Supporting Documents (If Available)

1. **spec.md** (Optional):
   - Extract user stories and acceptance criteria
   - Extract requirements and constraints

2. **data-model.md** (Optional):
   - Extract entities and relationships
   - Extract data constraints

3. **contracts/** (Optional):
   - Extract API specifications
   - Extract endpoint definitions
   - Extract test requirements

4. **research.md** (Optional):
   - Extract technical decisions and rationale
   - Extract constraints and considerations

### Step 4: Project Setup Verification

Verify and create project infrastructure before implementation. See [references/implementation-patterns.md](references/implementation-patterns.md#ignore-files-management) for detailed ignore file patterns.

**Key Tasks:**

#### Architecture Alignment (If architecture.md exists)

- Verify directory structure matches code organization
- Ensure deployment configuration aligns with architecture
- Follow component organization patterns from C4 Component View

#### Standards Compliance (If standards.md exists)

- Follow file and directory naming conventions
- Apply code naming conventions (UI, backend, database)
- Follow project structure standards

#### Ignore Files Management

- Detect project technology (Node.js, Python, Java, etc.)
- Create/verify ignore files (.gitignore, .dockerignore, etc.)
- Apply technology-specific patterns (see references/implementation-patterns.md)

### Step 5: Parse Tasks Structure

Extract task organization from tasks.md:

**Task Structure Elements**:

- **Task ID**: Sequential identifier (T001, T002, etc.)
- **Parallel Marker**: [P] indicates task can run in parallel
- **User Story Label**: [US1], [US2], etc. for traceability
- **Description**: What to implement
- **File Path**: Where to implement it
- **Dependencies**: Order requirements

**Phase Organization**:

1. **Phase 1: Setup** - Project initialization
2. **Phase 2: Foundational** - Blocking prerequisites
3. **Phase 3+: User Stories** - Feature implementation by story
4. **Final Phase: Polish** - Cross-cutting concerns

**Execution Rules**:

- Sequential tasks must run in order
- Parallel tasks [P] can run simultaneously
- Tasks affecting same files must be sequential
- User story phases should be independently testable

### Step 6: Execute Implementation Plan

Follow phase-by-phase execution with proper workflow. See [references/implementation-patterns.md](references/implementation-patterns.md#phase-by-phase-implementation-workflow) for detailed phase workflows and execution patterns.

**Phase Overview:**

1. **Phase 1: Setup** - Project initialization and configuration
2. **Phase 2: Foundational** - Shared infrastructure and base classes
3. **Phase 3+: User Story Implementation** - Feature implementation using TDD:
   - Tests first (if requested)
   - Models/Entities
   - Services/Business Logic
   - Endpoints/UI
   - Integration
   - Validation
4. **Final Phase: Polish** - Documentation, optimization, security

**Task Execution Rules** (see [references/implementation-patterns.md](references/implementation-patterns.md#task-execution-rules)):

- Respect dependencies (sequential vs parallel tasks)
- Handle errors appropriately (halt on critical, continue on parallel)
- Track progress (update tasks.md, report status)
- Commit frequently (after each logical unit, use proper prefixes)

### Step 7: Completion Validation

Verify implementation quality and completeness. See [references/implementation-patterns.md](references/implementation-patterns.md#implementation-verification-checklist) for complete validation checklist.

**Quick Checks:**

- [ ] All tasks completed (marked as [X] in tasks.md)
- [ ] Implementation matches specifications
- [ ] Tests pass (if tests implemented)
- [ ] Architecture alignment validated (if architecture.md exists)
- [ ] Standards compliance validated (if standards.md exists)
- [ ] Checklists all passed (if checklists exist)

### Step 8: Generate Implementation Report

Create summary using `templates/implementation-report.md`:

**Report Contents**:

- Implementation date and duration
- Tasks completed count by phase
- Files created/modified
- Tests status (if applicable)
- Compliance status (architecture + standards)
- Remaining work (if any)
- Known issues or technical debt

Save report to `FEATURE_DIR/implementation-report.md`

### Step 9: Report Summary

Provide concise summary including:

- Path to tasks.md showing completion status
- Total tasks completed vs total tasks
- Phases completed
- Architecture compliance (pass/fail)
- Standards compliance (pass/fail)
- Checklist status (all passed/some incomplete)
- Next steps or recommendations

### Step 10: Quality Review (Recommended)

After completing the implementation, it's highly recommended to run additional validation. See [references/implementation-patterns.md](references/implementation-patterns.md#next-steps-recommendations) for detailed next steps.

**Recommended:**
1. **Run `code-review` skill** to validate code quality, error handling, test coverage, and security
2. **Address findings** from review before creating PR/MR
3. **Consider `e2e-test-design` skill** if E2E tests needed
4. **Use `bug-analysis` skill** if issues discovered during testing

## Additional Resources

- [references/implementation-patterns.md](references/implementation-patterns.md) - Detailed implementation patterns and workflows
- `templates/implementation-report.md` - Implementation completion report structure
- `templates/progress-tracker.md` - Progress tracking template

## Task Execution Patterns

See [references/implementation-patterns.md](references/implementation-patterns.md#task-execution-patterns) for complete patterns including:

- Sequential execution
- Parallel execution (tasks marked with [P])
- TDD execution (Tests → Implementation)

## Examples

### Example 1: Basic Feature Implementation

**Input:**

```bash
bash skills/coding/scripts/check-implementation.sh --json
```

**Output:**

```json
{
  "success": true,
  "feature_dir": "/path/to/specs/feature-name",
  "tasks_file": "/path/to/specs/feature-name/tasks.md",
  "available_docs": ["tasks.md", "design.md", "spec.md"],
  "checklist_status": "all_passed",
  "task_count": 45
}
```

**Execution:**

1. All checklists passed → Proceed automatically
2. Load tasks.md, design.md, spec.md
3. Execute Phase 1: Setup (5 tasks)
4. Execute Phase 2: Foundational (8 tasks)
5. Execute Phase 3: User Story 1 (15 tasks)
6. Execute Phase 4: User Story 2 (12 tasks)
7. Execute Final Phase: Polish (5 tasks)
8. Generate implementation report

### Example 2: Implementation with Incomplete Checklists

**Checklist Status:**

```
| Checklist    | Total | Completed | Incomplete | Status |
|--------------|-------|-----------|------------|--------|
| ux.md        | 12    | 12        | 0          | ✓ PASS |
| security.md  | 8     | 5         | 3          | ✗ FAIL |
```

**Execution:**

1. Display table showing incomplete security checklist
2. **STOP** and ask: "Some checklists are incomplete. Proceed anyway?"
3. Wait for user response
4. If "yes" → Continue with implementation
5. If "no" → Halt and recommend completing checklists first

## Edge Cases

- **Missing tasks.md**: Report error and suggest running task generation skill first
- **Missing design.md**: Report error, cannot proceed without technical design
- **No checklists directory**: Skip checklist validation, proceed with implementation
- **Empty tasks.md**: Report error, no tasks to execute
- **Malformed tasks.md**: Attempt to parse, report specific formatting issues
- **Git repository not initialized**: Create .git if needed for ignore file management
- **Test failures during execution**: Report failures, suggest fixes, may continue or halt depending on severity
- **Conflicting standards**: Prioritize standards.md over architecture.md for naming conventions

## Error Handling

- **Script execution fails**: Report exact error, check working directory and script permissions
- **Invalid JSON from script**: Parse as text and extract file paths manually
- **Missing required documents**: List what's missing and halt execution
- **Task execution fails**: Report task ID, error message, affected files, suggest next steps
- **Test failures**: Report failed tests, log output, suggest investigation
- **Standards violation detected**: Report violation, reference standards.md section, suggest correction
- **Architecture pattern mismatch**: Report mismatch, reference architecture.md section, suggest alignment

## Scripts

This skill includes cross-platform scripts for checking implementation prerequisites:

### Bash Script (Unix/Linux/macOS)

```bash
bash skills/coding/scripts/check-implementation.sh --json
```

**Features:**

- Locates feature directory and tasks.md
- Validates checklist status
- Counts tasks by phase
- Identifies available documentation
- JSON and human-readable output

### PowerShell Script (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File skills/coding/scripts/check-implementation.ps1 -Json
```

**Features:**

- Locates feature directory and tasks.md
- Validates checklist status
- Counts tasks by phase
- Identifies available documentation
- JSON and human-readable output

### Script Output Format

Both scripts output JSON with:

- `success`: Boolean indicating if tasks.md was found
- `feature_dir`: Path to feature directory
- `tasks_file`: Path to tasks.md
- `available_docs`: Array of found documents
- `task_count`: Total number of tasks
- `checklist_status`: "all_passed", "some_incomplete", or "no_checklists"
- `checklist_details`: Array of checklist statuses (if checklists exist)
- `error`: Error message if prerequisites not met

## Templates

- `templates/implementation-report.md`: Structure for implementation completion reports
- `templates/progress-tracker.md`: Template for tracking ongoing implementation progress

## Guidelines

1. **Follow TDD**: Tests before implementation when tests are required
2. **Respect Dependencies**: Never skip dependency order
3. **Mark Progress**: Update tasks.md after each completed task
4. **Commit Frequently**: Commit after each logical unit of work
5. **Apply Standards**: Follow standards.md conventions consistently
6. **Align with Architecture**: Respect architectural patterns from architecture.md
7. **Validate Quality**: Check against checklists before and after implementation
8. **Document as You Go**: Add inline comments and documentation while coding
9. **Handle Errors Gracefully**: Provide clear context for debugging
10. **Report Progress**: Keep user informed of implementation status

## Success Criteria

An implementation is complete when:

- [ ] All tasks in tasks.md marked as [X]
- [ ] All required phases completed
- [ ] Tests pass (if tests were implemented)
- [ ] Code matches specifications from spec.md
- [ ] Architecture alignment validated (if architecture.md exists)
- [ ] Standards compliance validated (if standards.md exists)
- [ ] Checklists all passed (if checklists exist)
- [ ] Implementation report generated
- [ ] All changes committed with appropriate messages
- [ ] No critical errors or blockers remain
