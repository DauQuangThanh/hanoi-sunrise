---
name: technical-design-review
description: Reviews technical design documentation for completeness, consistency, and quality. Validates design decisions, data models, API contracts, implementation plans, and alignment with requirements and ground rules. Use when reviewing technical designs, validating implementation plans, assessing design quality, or when user mentions design review, technical review, API contract validation, data model review, or implementation plan assessment.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-27"
---

# Technical Design Review Skill

## Overview

This skill performs comprehensive reviews of technical design documentation to ensure completeness, consistency, and quality. It validates all aspects of the technical design including implementation plans, research findings, data models, API contracts, and alignment with requirements, ground rules, and architecture.

## When to Use

- Reviewing completed technical design documentation
- Validating design decisions before implementation
- Assessing design quality and identifying gaps
- Ensuring designs align with requirements and constraints
- Checking data model completeness and correctness
- Validating API contracts and endpoint specifications
- Reviewing implementation approaches and quickstart guides
- Verifying research findings and decision rationale
- User mentions: "review design", "validate technical design", "check API contracts", "design assessment", "design quality check", "review implementation plan"

## Prerequisites

- **Technical design documentation**:
  - `design/design.md` or `specs/*/design/design.md` - Main design document (Required)
  - `design/research/research.md` - Research findings and decisions (Required)
  - `design/data-model.md` - Data model documentation (Required)
  - `design/contracts/*.md` - API contract specifications (Required)
  - `design/quickstart.md` - Implementation guide (Optional but recommended)
- **Supporting documents**:
  - `docs/ground-rules.md` - Project constraints (Optional but recommended)
  - `docs/architecture.md` - Architectural patterns (Optional but recommended)
  - `specs/*/spec.md` - Feature specifications (Required for traceability)
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## File Structure

```
technical-design-review/
├── SKILL.md                                 # Main skill documentation
├── scripts/
│   ├── check-design.sh                      # Bash prerequisite checker (macOS/Linux)
│   └── check-design.ps1                     # PowerShell prerequisite checker (Windows)
├── templates/
│   └── technical-design-review-template.md  # Review report template
└── references/
    └── review-checklist.md                  # Detailed review checklists
```

## Instructions

### Step 1: Check Prerequisites and Locate Design Documents

Run the prerequisite check script to verify design documentation exists and identify all design artifacts:

**Bash (Unix/Linux/macOS):**

```bash
/path/to/technical-design-review/scripts/check-design.sh --json
```

**PowerShell (Windows):**

```powershell
/path/to/technical-design-review/scripts/check-design.ps1 -Json
```

**Note**: Replace `/path/to/technical-design-review` with the actual path where this skill is located:
- Global installation: `~/.copilot/skills/technical-design-review`
- Project installation: `.github/skills/technical-design-review`
- Or wherever your agent stores skills (see agent-skills-folder-mapping.md for your specific tool)

Parse the output to extract:

- `design_file`: Path to main design.md
- `research_file`: Path to research.md
- `data_model_file`: Path to data-model.md
- `contracts_dir`: Path to contracts directory
- `quickstart_file`: Path to quickstart.md
- `feature_spec`: Path to feature specification
- `ground_rules_file`: Path to ground-rules.md (if exists)
- `architecture_file`: Path to architecture.md (if exists)

### Step 2: Load Design Documents and Supporting Context

Read all design documentation and supporting files:

1. **Load core design documents**:
   - `design.md` - Main implementation plan
   - `research.md` - Research findings and decisions
   - `data-model.md` - Entity and data model definitions
   - All files in `contracts/` directory - API specifications
   - `quickstart.md` - Implementation guide (if exists)

2. **Load supporting context** (if available):
   - Feature specification for requirement traceability
   - `ground-rules.md` for constraint validation
   - `architecture.md` for architectural alignment
   - Any referenced external documentation

3. **Note the following**:
   - Identify all "NEEDS CLARIFICATION" markers
   - Extract all "TODO" or "ACTION REQUIRED" items
   - List all referenced external files

### Step 3: Execute Technical Design Review Workflow

Perform comprehensive review following the template structure in `templates/technical-design-review-template.md`.

For detailed checklists, see [references/review-checklist.md](references/review-checklist.md).

#### Review Phase 1: Document Completeness

Check if all required sections and documents are present and complete:
- Main Design Document (design.md): Executive summary, feature context, technical context, implementation approach, technology choices, file structure, testing strategy, deployment considerations, timeline
- Research Document (research.md): Research findings, decisions with rationale, architecture alignment, trade-offs, references
- Data Model Document (data-model.md): Entity definitions, field specifications, relationships, state machines, diagrams
- API Contracts (contracts/*.md): Endpoint coverage, HTTP methods, request/response schemas, authentication, error handling
- Quickstart Guide (quickstart.md): Implementation steps, technology stack, key files, code examples, integration points, testing approach

#### Review Phase 2: Research Validation

Validate research findings for quality and completeness:
- Each decision has clear problem statement, explicit choice, rationale, alternatives considered
- Architecture alignment documented
- Trade-offs captured with advantages and disadvantages
- No unresolved questions or "NEEDS CLARIFICATION" markers
- Consistent terminology throughout
- External dependencies and technical risks identified

#### Review Phase 3: Data Model Validation

Validate data models for correctness and completeness:
- **Entity Definitions**: All domain concepts covered, clear naming, no redundancy
- **Field Specifications**: All fields defined with types, constraints, defaults, nullable handling
- **Relationships**: All relationships defined with cardinality, foreign keys, cascade behavior
- **State Management**: States enumerated, transitions mapped, triggers identified
- **Validation Rules**: Business rules captured, input validation specified, error messages defined

#### Review Phase 4: API Contract Validation

Validate API contracts for completeness and consistency:
- **Endpoint Design**: RESTful conventions, consistent naming, appropriate HTTP methods, idempotency, versioning
- **Request Specifications**: Path parameters, query parameters, request body schema, required fields, content-type
- **Response Specifications**: Success responses, response body schema, pagination, HTTP status codes
- **Error Handling**: Error response format, error codes, error messages, validation errors, HTTP error codes
- **Authentication & Authorization**: Auth requirements, mechanisms, authorization rules, token format
- **Schema Validation**: Valid JSON/YAML, type consistency, backward compatibility

#### Review Phase 5: Requirements Traceability

Verify all requirements are addressed in the design:
- **Functional Requirements**: Each requirement covered with entities, endpoints, and implementation approach
- **Non-Functional Requirements**: Performance, security, scalability, availability, monitoring documented
- **User Stories/Use Cases**: User flows documented with endpoints, data flow, and error scenarios

#### Review Phase 6: Ground Rules Compliance

Validate design adheres to project constraints and standards (if ground-rules.md exists):
- Compliance verified for each ground rule
- Exceptions documented and justified
- Common checks: technology stack, security standards, data privacy, API standards, error handling, logging, testing requirements

#### Review Phase 7: Architecture Alignment

Verify design aligns with established architecture (if architecture.md exists):
- Architectural patterns, container selection, component responsibilities
- Communication patterns, technology choices, data flow, integration patterns, deployment model
- Architecture Decision Records (ADRs) reviewed and followed

#### Review Phase 8: Implementation Feasibility

Assess whether the design is implementable:
- **Technical Feasibility**: No blockers, dependencies available, technologies mature, performance realistic, complexity manageable
- **Team Capability**: Skills available, reasonable learning curve, sufficient documentation, good support
- **Timeline Realism**: Estimate provided and reasonable, dependencies identified, risk buffer included

#### Review Phase 9: Quality and Clarity

Assess overall quality of the design documentation:
- **Writing Quality**: Clear language, consistent terminology, no ambiguity, no TODOs, proper formatting
- **Completeness**: No missing sections, all questions resolved, all references valid, examples provided
- **Diagrams**: Present where appropriate, accurate, and readable

### Step 4: Generate Review Report

Create a comprehensive review report using the template:

1. **Prepare review report**:
   - Use template from `templates/technical-design-review-template.md`
   - Fill in all review sections with findings
   - Document all issues found (critical, major, minor)

2. **Categorize findings**:
   - **Critical**: Must fix before implementation (missing requirements, ground rules violations)
   - **Major**: Should fix before implementation (incomplete sections, unclear decisions)
   - **Minor**: Nice to have (formatting, minor clarifications)

3. **Provide recommendations**:
   - Specific actions to address each finding
   - Priority order for fixes
   - Suggestions for improvement

4. **Create summary**:
   - Overall assessment (Pass, Pass with Conditions, Needs Revision)
   - Count of issues by severity
   - Key strengths of the design
   - Most critical items to address

### Step 5: Report Findings

Present the review findings to the user:

1. **Summary First**:
   - Overall assessment
   - Total issue count by severity
   - Key highlights (strengths and critical issues)

2. **Detailed Findings**:
   - List all issues found
   - Group by review phase
   - Include specific file/line references
   - Provide clear recommendations

3. **Actionable Next Steps**:
   - Prioritized list of actions
   - Suggested order of fixes
   - Estimated effort for revisions

4. **Positive Feedback**:
   - Highlight what's done well
   - Acknowledge good practices
   - Note comprehensive sections

## Examples

### Example 1: Complete Design Review

**Input**: Review design for user authentication feature

**Process**:

1. Run check-design script, finds all design files
2. Load design.md, research.md, data-model.md, contracts/
3. Execute all review phases
4. Find issues:
   - Critical: Password hashing algorithm not specified in research.md
   - Major: Token refresh flow missing from API contracts
   - Minor: Some field descriptions could be more detailed
5. Generate review report with recommendations

**Output**: Comprehensive review report with 1 critical, 1 major, 3 minor issues, overall assessment: "Pass with Conditions"

### Example 2: Design with Ground Rules Violation

**Input**: Review payment processing design

**Process**:

1. Check prerequisites, load all documents including ground-rules.md
2. Review ground rules compliance
3. Find violation: Design uses non-approved payment gateway
4. Check if exception is documented - No exception documented
5. Flag as critical issue

**Output**: Review report with critical ground rules violation, recommendation: "Document exception with justification and obtain approval, or switch to approved payment gateway"

### Example 3: Incomplete Research

**Input**: Review API integration design

**Process**:

1. Load all design documents
2. Review research.md validation
3. Find issues:
   - Multiple "NEEDS CLARIFICATION" markers still present
   - API rate limits not researched
   - No alternatives considered for webhook handling
4. Flag as critical - Phase 0 not complete

**Output**: Review report indicating design is not ready for implementation, must complete research phase first

## Edge Cases

### Missing Design Documents

- **Case**: Required design files (design.md, research.md, data-model.md) not found
- **Handling**: ERROR and report which files are missing, suggest running technical-design skill first

### Design in Progress

- **Case**: Design contains many "NEEDS CLARIFICATION" or "TODO" markers
- **Handling**: Report design is incomplete, list all unresolved items, recommend completing design before review

### No Ground Rules or Architecture

- **Case**: Project doesn't have ground-rules.md or architecture.md
- **Handling**: Skip those validation phases, note in report that compliance couldn't be verified

### Conflicting Documentation

- **Case**: Design contradicts requirements or architecture
- **Handling**: Flag as critical issue, document specific conflicts, recommend resolution

### Multiple API Contract Files

- **Case**: Many contract files in contracts/ directory
- **Handling**: Review each file individually, check for consistency across contracts

### Complex State Machines

- **Case**: Entity has very complex state transitions
- **Handling**: Request state diagram, verify all transitions are valid, check for unreachable states

## Error Handling

### Prerequisites Check Failed

- **Error**: check-design script reports missing files or returns error
- **Action**: Report specific missing files, provide path to expected location, suggest creating files first

### Invalid JSON Output

- **Error**: Script output is not valid JSON or missing required fields
- **Action**: Fall back to manual file discovery, document the script error, suggest script fix

### Unreadable Design Documents

- **Error**: Design files exist but are corrupted or have invalid Markdown
- **Action**: Report which file is problematic, suggest file restoration or recreation

### Ground Rules Violation Without Exception

- **Error**: Design violates ground rule but no exception documented
- **Action**: Flag as critical issue, require documentation of exception with justification, or design revision

### Missing Requirements

- **Error**: Cannot find feature specification to validate against
- **Action**: Report missing spec, suggest creating specification first, or request path to specification

### Architecture Conflict

- **Error**: Design conflicts with established architecture patterns
- **Action**: Document specific conflict, recommend aligning with architecture or proposing ADR for exception

## Guidelines

1. **Be thorough**: Review all sections and validate all claims
2. **Be specific**: Reference exact files, sections, and line numbers in findings
3. **Be constructive**: Provide actionable recommendations, not just criticisms
4. **Be fair**: Acknowledge good practices and complete sections
5. **Prioritize**: Categorize issues by severity (critical, major, minor)
6. **Check traceability**: Verify all requirements are addressed
7. **Validate compliance**: Check ground rules and architecture alignment
8. **Assess feasibility**: Consider implementation realism
9. **Report clearly**: Use structured format from template
10. **Use absolute paths**: Always reference files with full paths

## Included Resources

This skill is self-contained and includes:

**Templates** (in `templates/` directory):

- `technical-design-review-template.md` - Review report structure

**Scripts** (in `scripts/` directory):

- `check-design.sh` - Bash script for prerequisite checking (macOS/Linux)
- `check-design.ps1` - PowerShell script for prerequisite checking (Windows)

**References** (in `references/` directory):

- `review-checklist.md` - Detailed checklists for all review phases

## Next Steps After Review

After completing the technical design review, consider these actions:

1. **Address Findings**: Fix critical and major issues before proceeding
2. **Update Design**: Revise design documents based on recommendations
3. **Re-review** (if needed): Conduct follow-up review after major revisions
4. **Proceed to Implementation**: If design passes review, begin implementation
5. **Create Tasks**: Use sunrise.taskify to break design into implementation tasks
6. **Design Tests**: Use sunrise.design-e2e-test to create test scenarios
