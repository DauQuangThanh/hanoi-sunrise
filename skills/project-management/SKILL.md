---
name: project-management
description: Generates actionable, dependency-ordered tasks.md files from design artifacts (spec.md, design.md, architecture.md). Organizes implementation tasks by user story with parallelization markers and test criteria. Use when breaking down features into tasks, creating implementation plans, or when user mentions tasks, project planning, implementation roadmap, task breakdown, or feature decomposition.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
license: MIT
---

# Project Management Skill

## Overview

This skill generates comprehensive implementation task lists (`tasks.md`) from design artifacts. It transforms high-level specifications into actionable, dependency-ordered tasks organized by user story, with clear parallelization opportunities and independent test criteria.

## When to Use

- Breaking down feature specifications into implementation tasks
- Creating implementation roadmaps from design documents
- Generating dependency-ordered task lists
- Planning feature development phases
- Organizing tasks by user story priority
- Identifying parallelizable implementation work
- User mentions: "create tasks", "implementation plan", "task breakdown", "feature decomposition"

## Prerequisites

- **Design artifacts in feature directory**:
  - `design.md` (tech stack, libraries, structure) - **Required**
  - `spec.md` (user stories with priorities) - **Required**
  - `data-model.md` (entities) - Optional
  - `contracts/` (API endpoints) - Optional
  - `research.md` (decisions) - Optional
  - `quickstart.md` (test scenarios) - Optional
- **Product-level documentation**:
  - `docs/architecture.md` (architectural patterns, ADRs, deployment) - Optional
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## Instructions

### Step 1: Check Prerequisites and Get Feature Directory

Run the prerequisite check script to identify the feature directory and available design documents:

**Bash (Unix/Linux/macOS):**

```bash
cd /path/to/repo
bash skills/project-management/scripts/check-prerequisites.sh --json
```

**PowerShell (Windows):**

```powershell
cd C:\path\to\repo
powershell -ExecutionPolicy Bypass -File skills/project-management/scripts/check-prerequisites.ps1 -Json
```

Parse the output to extract:

- `FEATURE_DIR`: Absolute path to feature directory
- `AVAILABLE_DOCS`: List of available design documents

### Step 2: Load Design Documents

Read design artifacts from `FEATURE_DIR` in this order:

1. **design.md** (Required):
   - Extract tech stack and libraries
   - Extract project structure and code organization
   - Extract architectural decisions

2. **spec.md** (Required):
   - Extract user stories with their priorities (P1, P2, P3, etc.)
   - Extract acceptance criteria for each story
   - Note story dependencies

3. **docs/architecture.md** (If exists):
   - Extract architectural patterns
   - Extract deployment requirements
   - Extract relevant ADRs for implementation

4. **data-model.md** (If exists):
   - Extract entities and relationships
   - Map entities to user stories that need them

5. **contracts/** directory (If exists):
   - List all contract/endpoint files
   - Map endpoints to user stories

6. **research.md** (If exists):
   - Extract technical decisions
   - Extract setup requirements

7. **quickstart.md** (If exists):
   - Extract test scenarios
   - Map scenarios to user stories

### Step 3: Generate Tasks

Create tasks.md following this structure:

#### Phase Organization

**Phase 1: Setup (Project Initialization)**

- Project structure creation
- Dependency installation
- Configuration setup
- If architecture.md exists: Infrastructure aligned with deployment architecture

**Phase 2: Foundational (Blocking Prerequisites)**

- Shared infrastructure that ALL user stories need
- Common utilities and base classes
- Core middleware or services
- MUST complete before any user story implementation

**Phase 3+: User Story Phases (In Priority Order)**

- One phase per user story (P1, P2, P3...)
- Each phase is independently testable
- Within each story phase:
  1. Tests (if requested in spec)
  2. Models/Entities needed for that story
  3. Services/Business logic for that story
  4. Endpoints/UI for that story
  5. Integration tasks for that story

**Final Phase: Polish & Cross-Cutting Concerns**

- Documentation
- Performance optimization
- Security hardening
- Cross-story integration

#### Task Format (CRITICAL)

Every task MUST follow this exact format:

```
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format Components:**

1. **Checkbox**: Always `- [ ]`
2. **Task ID**: Sequential (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if parallelizable (different files, no dependencies)
4. **[Story] label**: REQUIRED for user story tasks
   - Format: [US1], [US2], [US3]
   - Setup phase: NO story label
   - Foundational phase: NO story label
   - User Story phases: MUST have story label
   - Polish phase: NO story label
5. **Description**: Clear action with exact file path

**Examples:**

- ✅ `- [ ] T001 Create project structure per implementation plan`
- ✅ `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ✅ `- [ ] T012 [P] [US1] Create User model in src/models/user.py`
- ✅ `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- ❌ `- [ ] Create User model` (missing ID and Story label)
- ❌ `T001 [US1] Create model` (missing checkbox)

### Step 4: Use the Template

Use `templates/tasks-template.md` as the structure. Fill in:

1. **Feature name** from design.md
2. **All phases** with tasks in correct format
3. **Dependencies section** showing story completion order
4. **Parallel execution examples** per story
5. **Implementation strategy** (MVP first, incremental delivery)
6. **Architecture alignment** notes (if architecture.md exists)

### Step 5: Generate and Commit

1. Write tasks.md to the feature directory
2. Validate format:
   - ALL tasks have checkboxes
   - ALL tasks have sequential IDs
   - User story tasks have [US#] labels
   - All tasks include file paths
3. Generate commit message: `docs: add implementation tasks for [feature-name]`
4. Commit the tasks.md file

### Step 6: Report Summary

Provide a summary including:

- Path to generated tasks.md
- Total task count
- Task count per user story
- Parallel opportunities identified
- Independent test criteria for each story
- Suggested MVP scope (typically just User Story 1)
- Format validation confirmation

## Task Organization Mapping

### From User Stories (spec.md)

- Each user story → Separate phase
- Map components to their story:
  - Models needed for that story
  - Services needed for that story
  - Endpoints/UI needed for that story
  - Tests specific to that story (if requested)

### From Contracts (contracts/)

- Map each endpoint → User story it serves
- If tests requested: Contract test task [P] before implementation

### From Data Model (data-model.md)

- Map each entity → User story(ies) that need it
- If entity serves multiple stories → Earliest story or Setup phase
- Relationships → Service layer tasks in appropriate story phase

### From Architecture (docs/architecture.md)

- Deployment requirements → Setup/Foundational tasks
- Architectural patterns → Implementation tasks across stories
- ADRs → Reference in task descriptions
- Directory structure → File paths in tasks

## Examples

### Example Input

**spec.md excerpt:**

```markdown
## User Stories

### P1: User Registration
As a user, I want to register an account...

### P2: User Login
As a user, I want to log in...
```

**design.md excerpt:**

```markdown
## Tech Stack
- Backend: Python/FastAPI
- Database: PostgreSQL

## Project Structure
- src/models/ - Data models
- src/services/ - Business logic
- src/api/ - Endpoints
```

### Example Output (tasks.md excerpt)

```markdown
## Phase 3: User Story 1 - User Registration

**Story Goal**: User can create account with email/password

**Independent Test Criteria**:
- [ ] Can POST to /api/register with valid data
- [ ] Returns 201 with user ID
- [ ] User stored in database

**Tasks**:
- [ ] T010 [P] [US1] Create User model in src/models/user.py
- [ ] T011 [P] [US1] Create UserRepository in src/repositories/user_repo.py
- [ ] T012 [US1] Implement RegistrationService in src/services/registration.py
- [ ] T013 [US1] Create registration endpoint in src/api/users.py
- [ ] T014 [US1] Test registration flow end-to-end
```

## Edge Cases

- **Missing required documents**: If design.md or spec.md is missing, report error and list required documents
- **No user stories in spec.md**: Generate warning and create single implementation phase
- **Circular dependencies**: Identify and report for manual resolution
- **Ambiguous parallelization**: Mark as sequential if unclear
- **Multiple stories per component**: Place in earliest story or Foundational phase

## Error Handling

- **Script execution fails**: Report exact error, check working directory and script permissions
- **Invalid JSON from script**: Parse as text and extract feature directory manually
- **Missing design artifacts**: List what's missing and what's required vs optional
- **Invalid user story priorities**: Use document order as priority
- **Template not found**: Create tasks.md from scratch following the structure

## Scripts

This skill includes cross-platform scripts for checking prerequisites and identifying feature directories:

### Bash Script (Unix/Linux/macOS)

```bash
bash skills/project-management/scripts/check-prerequisites.sh --json
```

**Features:**

- Color-coded output for human-readable mode
- JSON output with `--json` flag
- Searches multiple standard locations for feature directories
- Validates required and optional design documents

### PowerShell Script (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File skills/project-management/scripts/check-prerequisites.ps1 -Json
```

**Features:**

- Color-coded output for human-readable mode
- JSON output with `-Json` switch
- Searches multiple standard locations for feature directories
- Validates required and optional design documents

### Script Output Format

Both scripts output JSON with:

- `success`: Boolean indicating if feature directory was found
- `feature_dir`: Absolute path to feature directory
- `available_docs`: Array of found design documents
- `missing_required`: Array of missing required documents
- `warning`: Warning message if required documents are missing
- `error`: Error message if feature directory not found

## Templates

- `templates/tasks-template.md`: Structure for generated tasks.md file

## Guidelines

1. **Task Completeness**: Every user story must be fully implementable and testable from its tasks
2. **Dependency Order**: Tasks within a phase should be ordered by dependency
3. **Parallelization**: Mark [P] only when truly independent (different files, no shared state)
4. **File Paths**: Always include specific file paths in task descriptions
5. **Story Independence**: Most user stories should be independently implementable
6. **MVP First**: Phase 3 (first user story) should be sufficient for MVP
7. **Tests Optional**: Only generate test tasks if explicitly requested or TDD approach specified
8. **Architecture Alignment**: When architecture.md exists, ensure tasks align with patterns and deployment requirements

## Validation

Before finalizing tasks.md, validate:

- [ ] All tasks follow checklist format with checkboxes
- [ ] All tasks have sequential IDs (T001, T002, T003...)
- [ ] User story tasks have [US#] labels
- [ ] All tasks include specific file paths
- [ ] Dependencies section is complete
- [ ] Each user story phase is independently testable
- [ ] Parallel execution examples provided per story
- [ ] Format matches template structure
