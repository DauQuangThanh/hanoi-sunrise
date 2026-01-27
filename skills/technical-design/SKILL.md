---
name: technical-design
description: Executes implementation planning workflow to generate technical design artifacts including design documents, research findings, data models, and API contracts. Use when planning feature implementation, creating technical specifications, designing system components, or when user mentions implementation planning, technical design, API design, or data modeling.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-24"
---

# Technical Design Skill

## Overview

This skill guides you through a structured implementation planning workflow to create comprehensive technical design artifacts. It follows a phased approach from research through design to contract generation, ensuring all technical decisions are documented and aligned with project architecture.

## When to Use

- Planning implementation for new features or components
- Creating technical specifications and design documents
- Designing data models and API contracts
- Researching technical decisions and alternatives
- Aligning feature design with existing architecture
- Documenting implementation approaches
- When user requests "design this feature", "create technical plan", "plan implementation", or "design API"

## Prerequisites

**Required:**

- Feature specification or requirements document available
- Templates provided with this skill (in `templates/` directory)
- Scripts provided with this skill (in `scripts/` directory)

**Optional (workspace-level enhancements):**

- `docs/ground-rules.md` - Project constraints and standards
- `docs/architecture.md` - Architectural decisions and patterns
- Git repository (for branch tracking and commits)

## Instructions

### Step 1: Setup and Context Loading

1. **Run setup script** to create directory structure and copy templates:

   **Bash (macOS/Linux):**

   ```bash
   <SKILL_DIR>/scripts/setup-design.sh --json
   ```

   **PowerShell (Windows):**

   ```powershell
   <SKILL_DIR>/scripts/setup-design.ps1 -Json
   ```

   Replace `<SKILL_DIR>` with the absolute path to this skill directory.

   The script will:
   - Create `design/` directory structure (or `specs/N-feature/design/` if on feature branch)
   - Copy all templates from skill's `templates/` directory
   - Return JSON with paths: `feature_design`, `research_file`, `data_model_file`, `contracts_dir`

2. **Load required context**:
   - Read feature specification/requirements (from JSON output: `feature_spec`)
   - Load `docs/ground-rules.md` if exists (optional - for project standards)
   - Load `docs/architecture.md` if exists (optional - for architectural patterns)
   - Identify current git branch from JSON output: `current_branch`

3. **Review design document template**:
   - Template already copied to path in JSON: `feature_design`
   - Review structure and sections
   - Begin filling in feature name and basic context

### Step 2: Technical Context Analysis

1. **Extract key information from requirements**:
   - Functional requirements (what the system must do)
   - Non-functional requirements (performance, security, scalability)
   - User interactions and workflows
   - Integration points with existing systems
   - Data requirements

2. **Document in design.md Technical Context section**:
   - List all known technical details
   - Mark unknowns as "NEEDS CLARIFICATION"
   - Reference ground-rules that apply
   - Note architectural patterns from architecture.md (if available)

3. **Evaluate against ground-rules**:
   - Check compliance with project standards
   - Document any conflicts or exceptions needed
   - Justify deviations if necessary

### Step 3: Phase 0 - Research & Resolution

**Goal**: Resolve all NEEDS CLARIFICATION items before proceeding to design

1. **Identify research tasks from Technical Context**:
   - For each NEEDS CLARIFICATION → create research question
   - For each technology choice → identify best practices needed
   - For each integration point → research integration patterns
   - Review architecture.md for relevant decisions and patterns

2. **Conduct research and document findings**:
   - Research template already copied by setup script (path in JSON: `research_file`)
   - Template structure provided in `templates/research-template.md`
   - For each decision, document:
     - **Decision**: What was chosen
     - **Rationale**: Why it was chosen
     - **Alternatives Considered**: What else was evaluated
     - **Architecture Alignment**: How it aligns with existing architecture (if applicable)
     - **Trade-offs**: Pros and cons
     - **References**: Sources consulted

3. **Update design.md with research outcomes**:
   - Replace all NEEDS CLARIFICATION with concrete decisions
   - Link to research.md for details

### Step 4: Phase 1 - Data Model Design

**Prerequisites**: All NEEDS CLARIFICATION resolved in Phase 0

1. **Extract entities from requirements**:
   - Identify domain objects and concepts
   - List attributes for each entity
   - Define relationships between entities
   - Identify state transitions (if applicable)

2. **Create data model document**:
   - Data model template already copied by setup script (path in JSON: `data_model_file`)
   - Template structure provided in `templates/data-model-template.md`
   - For each entity document:
     - Entity name and description
     - Fields with types and constraints
     - Validation rules
     - Relationships to other entities
     - State machine (if stateful)
   - Align with data models from architecture.md (if available in workspace)

3. **Add diagrams** (if helpful):
   - Entity-relationship diagrams
   - State transition diagrams
   - Data flow diagrams

### Step 5: Phase 1 - API Contract Generation

1. **Identify API endpoints from requirements**:
   - For each user action → determine endpoint
   - For each data query → determine read endpoint
   - For each data mutation → determine write endpoint

2. **Design API contracts**:
   - API contract template already copied by setup script (path in JSON: `contracts_dir`)
   - Template structure provided in `templates/api-contract-template.md`
   - Create additional contract files in contracts directory as needed
   - Follow REST or GraphQL patterns (per project standards)
   - Include:
     - Endpoint path/operation
     - HTTP method / GraphQL type
     - Request schema
     - Response schema
     - Error responses
     - Authentication requirements
   - Follow API design patterns from architecture.md (if available in workspace)

3. **Generate OpenAPI or GraphQL schemas**:
   - Create machine-readable contract files
   - Validate schema syntax
   - Add examples for each endpoint

### Step 6: Create Quickstart Guide

1. **Document implementation approach**:
   - Create quickstart file (path in JSON: `quickstart_file`)
   - Include:
     - High-level implementation steps
     - Technology stack for this feature
     - Key files/modules to create/modify
     - Integration points
     - Testing strategy
     - Deployment considerations

2. **Add code examples**:
   - Show key code patterns to use
   - Provide starter templates
   - Reference design decisions from research.md

### Step 7: Final Validation

1. **Review against ground-rules**:
   - Re-check all ground-rules compliance
   - Update Ground-rules Check section in design.md
   - Document any approved exceptions

2. **Verify completeness**:
   - All requirements addressed in design
   - All entities have data models
   - All user actions have API contracts
   - All NEEDS CLARIFICATION resolved
   - Architecture alignment verified (if architecture.md exists)

3. **Create summary**:
   - Update design.md Executive Summary
   - List all generated artifacts
   - Document next steps (implementation)

### Step 8: Commit Design Artifacts

1. **Stage all design files**:

   ```bash
   git add design/design.md
   git add design/research/research.md
   git add design/data-model.md
   git add design/contracts/
   git add design/quickstart.md
   ```

2. **Create commit with 'docs:' prefix**:

   ```bash
   git commit -m "docs: add implementation plan for [feature-name]"
   ```

3. **Report completion**:
   - List all generated artifacts with paths
   - Confirm commit completed
   - Note current branch
   - Suggest next steps (task breakdown, checklist creation, E2E test design)

## Examples

### Example 1: User Authentication Feature

**Input**:

```
Design user authentication with email/password and OAuth support
```

**Process**:

1. Create design/design.md from template
2. Technical Context identifies: auth provider choice, token strategy, session management
3. Research.md documents: JWT vs sessions (chose JWT), OAuth provider comparison (chose Auth0)
4. data-model.md defines: User entity, AuthToken entity, relationships
5. contracts/ includes: POST /auth/login, POST /auth/register, GET /auth/me, POST /auth/oauth/callback
6. quickstart.md outlines: auth middleware setup, token validation, refresh flow

**Output**: Complete design package in design/ directory, committed to git

### Example 2: Payment Processing Integration

**Input**:

```
Add Stripe payment processing to checkout flow
```

**Process**:

1. Load ground-rules.md for security requirements
2. Technical Context: Stripe API version, webhook handling, idempotency
3. Research: Stripe best practices, payment flow patterns, security considerations
4. Data model: Payment, PaymentIntent, PaymentMethod entities
5. Contracts: POST /payments/create-intent, POST /payments/confirm, POST /webhooks/stripe
6. Quickstart: Stripe SDK setup, webhook verification, error handling patterns

**Output**: Payment integration design, aligned with security ground-rules, ready for implementation

## Edge Cases

### No architecture.md Available

- **Case**: Project doesn't have architecture documentation
- **Handling**: Skip architecture alignment steps, document design decisions directly in research.md

### Conflicting Ground Rules

- **Case**: Feature requirements conflict with established ground-rules
- **Handling**: Document conflict in design.md, propose exception with justification, escalate to team lead

### Incomplete Requirements

- **Case**: Feature spec lacks critical details
- **Handling**: Add to NEEDS CLARIFICATION, create research tasks to fill gaps, document assumptions

### External API Dependencies

- **Case**: Feature depends on third-party API
- **Handling**: Research API thoroughly, document API version and capabilities in research.md, include fallback strategies

### Complex State Machines

- **Case**: Entity has many states and transitions
- **Handling**: Create detailed state diagram in data-model.md, document all valid transitions, include error states

## Error Handling

### Research Findings Incomplete

- **Error**: NEEDS CLARIFICATION items remain after research phase
- **Action**: Return to research phase, conduct deeper investigation, consult team if needed

### Ground Rules Violation

- **Error**: Design conflicts with mandatory ground-rules
- **Action**: Stop design process, document conflict, revise design to comply or get exception approval

### Missing Prerequisites

- **Error**: Required context files (feature spec, ground-rules.md) not found
- **Action**: Report missing files, request user to provide or create them first

### Invalid API Contract

- **Error**: Generated OpenAPI/GraphQL schema has validation errors
- **Action**: Review contract structure, fix schema syntax, validate again

### Incomplete Data Model

- **Error**: Entities missing relationships or validation rules
- **Action**: Review requirements again, add missing details, ensure all entity interactions documented

## Guidelines

1. **Always use absolute paths** when referencing files
2. **ERROR and stop** if ground-rules violations cannot be justified
3. **Document all decisions** with rationale in research.md
4. **Align with architecture** when architecture.md exists
5. **Generate complete contracts** - don't leave TODOs in API specifications
6. **Validate schemas** before committing
7. **Use templates provided** in templates/ directory for consistency
8. **Commit with 'docs:' prefix** for design documentation
9. **Mark unknowns clearly** with "NEEDS CLARIFICATION" during initial analysis
10. **Resolve all clarifications** before moving to design phase

## Included Resources

This skill is self-contained and includes:

**Templates** (in `templates/` directory):

- `design-template.md` - Main implementation plan structure
- `research-template.md` - Research findings and decisions format
- `data-model-template.md` - Entity and data model documentation
- `api-contract-template.md` - API endpoint specification format

**Scripts** (in `scripts/` directory):

- `setup-design.sh` - Bash script for directory setup (macOS/Linux)
- `setup-design.ps1` - PowerShell script for directory setup (Windows)

**Optional Workspace Files** (if available in project):

- `docs/ground-rules.md` - Project constraints and standards
- `docs/architecture.md` - Architectural decisions and patterns

All templates are automatically copied by the setup script to the appropriate design directory.

## Next Steps After Design

After completing the technical design, consider these follow-up actions:

1. **Task Breakdown**: Use sunrise.taskify agent to break design into implementation tasks
2. **Checklist Creation**: Use sunrise.checklist agent to create validation checklist
3. **E2E Test Design**: Use sunrise.design-e2e-test agent to design end-to-end tests
4. **Implementation**: Begin implementing according to quickstart.md and data models
