---
name: coding
description: Executes feature implementation by processing tasks.md files, validating checklists, setting up project structure, and implementing code following architectural patterns and coding standards. Handles phase-by-phase execution with TDD approach, dependency management, and progress tracking. Use when implementing features, executing task plans, coding from specifications, or when user mentions implement tasks, execute implementation, code feature, or follow task breakdown.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
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

## Prerequisites

- **Required documents in feature directory**:
  - `tasks.md` - Task breakdown and execution plan (Required)
  - `design.md` - Technical design and architecture (Required)
  - `spec.md` - Feature requirements and user stories (Optional but recommended)
- **Product-level documentation** (Optional but recommended):
  - `docs/architecture.md` - System architecture, patterns, ADRs
  - `docs/standards.md` - Coding conventions and standards
- **Optional supporting documents**:
  - `data-model.md` - Entity definitions and relationships
  - `contracts/` - API specifications
  - `research.md` - Technical decisions
  - `checklists/` - Quality checklists
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## Instructions

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

If `FEATURE_DIR/checklists/` exists, validate all checklists before proceeding:

**Checklist Validation Process:**

1. **Scan all checklist files**:
   - Count total items: Lines matching `- [ ]` or `- [X]` or `- [x]`
   - Count completed: Lines matching `- [X]` or `- [x]`
   - Count incomplete: Lines matching `- [ ]`

2. **Create status table**:

   ```
   | Checklist    | Total | Completed | Incomplete | Status |
   |--------------|-------|-----------|------------|--------|
   | ux.md        | 12    | 12        | 0          | ✓ PASS |
   | test.md      | 8     | 5         | 3          | ✗ FAIL |
   | security.md  | 6     | 6         | 0          | ✓ PASS |
   ```

3. **Determine overall status**:
   - **PASS**: All checklists have 0 incomplete items → Proceed automatically
   - **FAIL**: One or more checklists have incomplete items → Ask user permission

4. **If checklists incomplete**:
   - Display table with incomplete counts
   - **STOP** and ask: "Some checklists are incomplete. Do you want to proceed with implementation anyway? (yes/no)"
   - Wait for user response:
     - If "no" / "wait" / "stop" → Halt execution
     - If "yes" / "proceed" / "continue" → Continue to Step 3

5. **If all checklists complete**:
   - Display table showing all passed
   - Proceed automatically to Step 3

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

Verify and create project infrastructure before implementation:

#### Architecture Alignment (If architecture.md exists)

- [ ] Verify directory structure matches code organization from architecture.md
- [ ] Ensure deployment configuration aligns with deployment architecture
- [ ] Follow component organization patterns from C4 Component View
- [ ] Apply architectural patterns from ADRs

#### Standards Compliance (If standards.md exists)

- [ ] Follow file and directory naming conventions
- [ ] Apply code naming conventions (UI, backend, database)
- [ ] Follow project structure standards
- [ ] Prepare for API design standards
- [ ] Prepare for testing standards

#### Ignore Files Management

Detect project technology and create/verify ignore files:

**Detection Logic**:

- Check if git repository → create/verify `.gitignore`
- Check if Dockerfile exists → create/verify `.dockerignore`
- Check if ESLint config exists → create/verify `.eslintignore`
- Check if Prettier config exists → create/verify `.prettierignore`
- Check if npm project → create/verify `.npmignore` (if publishing)
- Check if Terraform files → create/verify `.terraformignore`
- Check if Helm charts → create/verify `.helmignore`

**Ignore File Creation Rules**:

- If file exists → Verify essential patterns, append only missing critical ones
- If file missing → Create with full pattern set for detected technology

**Technology-Specific Patterns**:

- **Node.js/JavaScript/TypeScript**: `node_modules/`, `dist/`, `build/`, `*.log`, `.env*`
- **Python**: `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `dist/`, `*.egg-info/`
- **Java**: `target/`, `*.class`, `*.jar`, `.gradle/`, `build/`
- **C#/.NET**: `bin/`, `obj/`, `*.user`, `*.suo`, `packages/`
- **Go**: `*.exe`, `*.test`, `vendor/`, `*.out`
- **Ruby**: `.bundle/`, `log/`, `tmp/`, `*.gem`, `vendor/bundle/`
- **PHP**: `vendor/`, `*.log`, `*.cache`, `*.env`
- **Rust**: `target/`, `*.rs.bk`, `*.rlib`, `*.log`, `.env*`
- **Universal**: `.DS_Store`, `Thumbs.db`, `*.tmp`, `*.swp`, `.vscode/`, `.idea/`

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

Follow phase-by-phase execution with proper workflow:

#### Implementation Workflow

**Phase 1: Setup** (Project Initialization)

- Create directory structure (follow standards.md if exists)
- Initialize configuration files
- Install dependencies
- Set up development environment
- Create ignore files

**Phase 2: Foundational** (Blocking Prerequisites)

- Implement shared infrastructure
- Create base classes and utilities
- Set up middleware and common services
- Establish database connections

**Phase 3+: User Story Implementation**

For each user story phase, follow TDD approach:

1. **Tests First** (if tests requested):
   - Write unit tests for models/entities
   - Write integration tests for services
   - Write contract tests for APIs
   - Follow testing standards from standards.md

2. **Models/Entities**:
   - Create data models following data-model.md
   - Apply database naming conventions from standards.md
   - Implement entity relationships

3. **Services/Business Logic**:
   - Implement business logic following design.md
   - Apply code naming conventions from standards.md
   - Implement architectural patterns from architecture.md

4. **Endpoints/UI**:
   - Create API endpoints following contracts/
   - Apply UI naming conventions from standards.md
   - Apply API design standards from standards.md

5. **Integration**:
   - Wire components together
   - Implement integration patterns from architecture.md
   - Apply quality strategies (security, performance) from architecture.md

6. **Validation**:
   - Run tests (if implemented)
   - Verify acceptance criteria from spec.md
   - Mark tasks as complete in tasks.md: `- [X]`

**Final Phase: Polish**

- Add documentation (follow standards.md)
- Optimize performance
- Security hardening
- Code review and cleanup

#### Task Execution Rules

1. **Respect Dependencies**:
   - Sequential tasks: Run in order, one at a time
   - Parallel tasks [P]: Can execute simultaneously (different files)
   - Same-file tasks: Must be sequential regardless of [P] marker

2. **Error Handling**:
   - Non-parallel task fails → Halt execution
   - Parallel task fails → Continue with successful, report failed
   - Provide clear error context for debugging

3. **Progress Tracking**:
   - Report after each completed task
   - Update tasks.md: Change `- [ ]` to `- [X]` for completed tasks
   - Show phase completion status

4. **Commit Strategy**:
   - Commit after each logical unit of work
   - Use appropriate prefixes: `feat:`, `fix:`, `test:`, `docs:`, `refactor:`
   - Follow commit conventions from standards.md (if exists)
   - Reference task IDs in commit messages

### Step 7: Completion Validation

Verify implementation quality and completeness:

#### Implementation Verification

- [ ] All required tasks completed (marked as [X] in tasks.md)
- [ ] Implementation matches specifications from spec.md
- [ ] Tests pass (if tests were implemented)
- [ ] Code coverage meets requirements (if specified)

#### Architecture Alignment (If architecture.md exists)

- [ ] Implementation follows architectural patterns
- [ ] Component organization matches C4 Component View
- [ ] Technology stack matches architecture decisions
- [ ] Quality attribute requirements met (performance, security, scalability)
- [ ] ADRs (Architecture Decision Records) respected

#### Standards Compliance (If standards.md exists)

- [ ] UI naming conventions followed (for UI components)
- [ ] Code naming conventions applied consistently
- [ ] File and directory structure matches standards
- [ ] API design standards followed
- [ ] Database naming conventions applied
- [ ] Testing standards followed
- [ ] Git commit messages follow conventions
- [ ] Documentation standards met

#### Quality Checklist Validation (If checklists exist)

- [ ] Re-run checklist validation
- [ ] All checklist items should now be complete
- [ ] Address any remaining incomplete items

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

## Task Execution Patterns

### Sequential Execution (Default)

```
Task T001 → Complete → Mark [X] → Commit
Task T002 → Complete → Mark [X] → Commit
Task T003 → Complete → Mark [X] → Commit
```

### Parallel Execution (Tasks marked with [P])

```
Round 1:
  T010 [P] → Complete → Mark [X] ┐
  T011 [P] → Complete → Mark [X] ├→ Commit all together
  T012 [P] → Complete → Mark [X] ┘

Round 2:
  T013 → Complete → Mark [X] → Commit
```

### TDD Execution (Tests → Implementation)

```
Phase: User Story 1
  T010 [P] [US1] Write unit tests → Complete → Mark [X]
  T011 [P] [US1] Write integration tests → Complete → Mark [X]
  T012 [P] [US1] Create model → Complete → Mark [X]
  T013 [US1] Implement service → Complete → Mark [X]
  T014 [US1] Create endpoint → Complete → Mark [X]
  T015 [US1] Run tests → Validate → Complete
```

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
