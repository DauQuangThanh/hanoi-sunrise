---
name: architecture-design-review
description: Reviews system architecture documentation for completeness, consistency, and quality. Validates C4 model diagrams, architecture decisions (ADRs), quality attributes, deployment design, and alignment with requirements. Use when reviewing architecture documents, validating architectural decisions, assessing architecture quality, or when user mentions architecture review, ADR validation, C4 model check, or architecture assessment.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
license: MIT
---

# Architecture Design Review Skill

## Overview

This skill performs comprehensive reviews of system architecture documentation (`architecture.md`) to ensure completeness, consistency, and quality. It validates all aspects of the architecture including stakeholder concerns, quality attributes, C4 model diagrams, architecture decisions (ADRs), deployment design, and alignment with requirements and ground rules.

## When to Use

- Reviewing completed architecture documentation
- Validating architectural decisions before implementation
- Assessing architecture quality and identifying gaps
- Ensuring architecture aligns with requirements and constraints
- Checking C4 model diagram completeness and correctness
- Validating ADRs (Architecture Decision Records)
- Reviewing deployment architecture and infrastructure design
- User mentions: "review architecture", "validate ADRs", "check C4 diagrams", "architecture assessment", "architecture quality check"

## Prerequisites

- **Architecture documentation**:
  - `docs/architecture.md` - Main architecture document (Required)
  - `docs/adr/*.md` - Individual ADR files (Optional)
  - `docs/architecture-overview.md` - High-level summary (Optional)
  - `docs/deployment-guide.md` - Deployment details (Optional)
- **Supporting documents**:
  - `docs/ground-rules.md` - Project constraints (Optional but recommended)
  - `specs/*/spec.md` - Feature specifications (Optional but recommended)
- **Tools**: bash (Unix/Linux/macOS) or PowerShell (Windows) for running prerequisite checks

## Instructions

### Step 1: Check Prerequisites and Locate Architecture Document

Run the prerequisite check script to verify architecture.md exists and identify related documents:

**Bash (Unix/Linux/macOS):**

```bash
cd /path/to/repo
bash skills/architecture-design-review/scripts/check-architecture.sh --json
```

**PowerShell (Windows):**

```powershell
cd C:\path\to\repo
powershell -ExecutionPolicy Bypass -File skills/architecture-design-review/scripts/check-architecture.ps1 -Json
```

Parse the output to extract:

- `ARCHITECTURE_FILE`: Path to architecture.md
- `AVAILABLE_DOCS`: List of available supporting documents
- `ADR_COUNT`: Number of ADR files found

### Step 2: Load Architecture Document and Supporting Context

Read the architecture documentation:

1. **Load architecture.md**:
   - Read entire document structure
   - Identify all sections present
   - Extract all Mermaid diagrams
   - Note any "ACTION REQUIRED" or "TODO" markers

2. **Load supporting documents** (if available):
   - `docs/ground-rules.md` - For constraint validation
   - `specs/*/spec.md` - For requirement traceability
   - `docs/adr/*.md` - For detailed ADR content
   - `docs/deployment-guide.md` - For deployment details

### Step 3: Execute Architecture Review Workflow

Perform comprehensive review following the template structure in `templates/architecture-review-template.md`:

#### Review Phase 1: Document Completeness

Check if all required sections are present and complete:

- [ ] **Executive Summary**: Present and understandable by non-technical stakeholders
- [ ] **Stakeholders**: All stakeholder types identified with concerns
- [ ] **Architectural Drivers**: Business goals, quality attributes, constraints documented
- [ ] **System Context (C4 Level 1)**: Context diagram and system boundaries defined
- [ ] **Container View (C4 Level 2)**: All containers identified with technology choices
- [ ] **Component View (C4 Level 3)**: Critical components documented with responsibilities
- [ ] **Code View (C4 Level 4)**: Code organization and patterns documented
- [ ] **Deployment View**: Infrastructure and deployment topology defined
- [ ] **Architecture Decisions (ADRs)**: Major decisions documented with rationale
- [ ] **Quality Attributes**: Strategies mapped to requirements
- [ ] **Risks & Technical Debt**: Identified with mitigation plans
- [ ] **Appendices**: Glossary and references present

#### Review Phase 2: C4 Model Validation

Validate all C4 diagrams for correctness and completeness:

**System Context Diagram (Level 1):**

- [ ] All user types from specifications are represented
- [ ] All external systems and integrations are identified
- [ ] Mermaid diagram renders correctly
- [ ] System boundaries are clear
- [ ] Relationships show direction and purpose

**Container Diagram (Level 2):**

- [ ] All technical containers are identified (web, API, database, cache, etc.)
- [ ] Technology stack is specified for each container
- [ ] Inter-container communication protocols are defined
- [ ] Mermaid diagram renders correctly
- [ ] Container responsibilities are clear and non-overlapping

**Component Diagram (Level 3):**

- [ ] Critical containers are broken down into components
- [ ] Component responsibilities are clearly defined
- [ ] Component interfaces are documented
- [ ] Interaction patterns are shown
- [ ] Mermaid diagrams render correctly

**Code View (Level 4):**

- [ ] Directory structure is documented
- [ ] Naming conventions are defined
- [ ] Key design patterns are listed
- [ ] Code organization principles are clear

#### Review Phase 3: Architecture Decision Records (ADRs)

Validate each ADR for completeness and quality:

For each ADR, check:

- [ ] **Title**: Clear and descriptive
- [ ] **Status**: Specified (Proposed, Accepted, Deprecated, Superseded)
- [ ] **Context**: Problem/situation is clearly described
- [ ] **Decision**: What was decided is explicit
- [ ] **Rationale**: Why this decision was made is explained
- [ ] **Consequences**: Positive and negative impacts are documented
- [ ] **Alternatives Considered**: Other options are listed with reasons for rejection
- [ ] **Traceability**: References to requirements or constraints

Minimum ADR expectations:

- At least 3-5 major ADRs documented
- Critical decisions covered (architecture style, database choice, API design, deployment strategy, etc.)
- Each ADR follows consistent format

#### Review Phase 4: Quality Attributes & Strategies

Validate quality attribute requirements and strategies:

**Quality Attribute Requirements:**

- [ ] **Performance**: Specific, measurable targets defined (e.g., "< 200ms response time")
- [ ] **Scalability**: Growth targets and scaling dimensions defined
- [ ] **Availability**: Uptime targets and SLA defined (e.g., "99.9% availability")
- [ ] **Security**: Threat model and security requirements documented
- [ ] **Maintainability**: Code quality and testing standards defined
- [ ] **Reliability**: MTBF/MTTR targets defined
- [ ] **Usability**: UX requirements and accessibility standards defined

**Quality Strategies:**

- [ ] Each quality attribute has mapped strategies
- [ ] Strategies are specific and actionable
- [ ] Trade-offs between quality attributes are acknowledged
- [ ] Implementation approach is clear

#### Review Phase 5: Deployment Architecture

Validate deployment design and infrastructure:

- [ ] **Production Topology**: Multi-region, multi-AZ, or single deployment defined
- [ ] **Infrastructure Components**: Compute, storage, networking, security components specified
- [ ] **Deployment Diagram**: Mermaid diagram shows infrastructure layout
- [ ] **CI/CD Pipeline**: Build, test, deploy stages documented
- [ ] **Deployment Strategy**: Blue/green, canary, rolling, or other strategy defined
- [ ] **Infrastructure as Code**: Approach documented (Terraform, CloudFormation, etc.)
- [ ] **Disaster Recovery**: Backup strategy, RTO, RPO defined
- [ ] **Monitoring & Observability**: Logging, metrics, alerting approach defined

#### Review Phase 6: Alignment & Consistency

Check alignment with supporting documents:

**Ground Rules Alignment:**

- [ ] Technical constraints from ground-rules are respected
- [ ] Organizational constraints are addressed
- [ ] Any ground-rule violations are explicitly justified
- [ ] Technology choices comply with approved stack

**Requirements Alignment:**

- [ ] Architecture addresses all feature requirements
- [ ] User stories from specs are traceable to architectural components
- [ ] Non-functional requirements are addressed
- [ ] Integration requirements are covered

**Internal Consistency:**

- [ ] No conflicting statements across sections
- [ ] Terminology is used consistently
- [ ] Diagram elements match textual descriptions
- [ ] Cross-references are accurate

#### Review Phase 7: Risks & Technical Debt

Validate risk management and technical debt documentation:

- [ ] **Identified Risks**: Architecture risks are listed
- [ ] **Risk Assessment**: Probability and impact assessed for each risk
- [ ] **Mitigation Strategies**: Concrete plans to address risks
- [ ] **Technical Debt**: Known debt is documented
- [ ] **Remediation Plans**: Plans to address technical debt
- [ ] **Open Questions**: Unresolved architectural questions listed
- [ ] **Future Considerations**: Evolution and extension paths identified

### Step 4: Generate Architecture Review Report

Create comprehensive review report using `templates/architecture-review-template.md`:

1. **Overall Assessment**:
   - Completeness score (percentage of required sections present)
   - Quality score (subjective assessment of content quality)
   - Critical issues count
   - Recommendations priority list

2. **Findings by Category**:
   - Document Completeness findings
   - C4 Model findings
   - ADR findings
   - Quality Attributes findings
   - Deployment Architecture findings
   - Alignment findings
   - Risk Management findings

3. **Recommendations**:
   - High priority (must address)
   - Medium priority (should address)
   - Low priority (nice to have)

4. **Action Items**:
   - Specific, actionable items to improve architecture
   - Assigned to relevant sections
   - Estimated effort

### Step 5: Save Review Report

Save the review report to the appropriate location:

1. Create review file:
   - Name: `docs/architecture-review-YYYYMMDD.md` (dated for versioning)
   - Or: `docs/reviews/architecture-review-YYYYMMDD.md` if reviews directory exists

2. Include metadata:
   - Review date
   - Reviewer (if known)
   - Architecture document version
   - Documents reviewed

3. Generate commit message: `docs: add architecture review report YYYY-MM-DD`
4. Commit the review report

### Step 6: Report Summary

Provide concise summary including:

- Path to review report
- Overall completeness score
- Number of critical issues
- Number of recommendations
- Top 3-5 priority action items
- Compliance with ground rules (pass/fail)

## Review Checklist Categories

### Document Structure

- All required sections present
- Logical section ordering
- Proper heading hierarchy
- Table of contents (if applicable)
- Consistent formatting

### Content Quality

- Clear and concise writing
- Technical accuracy
- Sufficient detail level
- Appropriate for target audience
- Free of ambiguity

### Diagram Quality

- All diagrams render correctly (Mermaid syntax valid)
- Diagrams are readable and well-organized
- Diagram elements are labeled
- Relationships are clear
- Diagrams support textual content

### Traceability

- Requirements traceable to components
- ADRs reference requirements or constraints
- Quality strategies map to quality attributes
- Components map to features

### Actionability

- Sufficient detail for implementation
- Clear guidance for developers
- Unambiguous technology choices
- Concrete patterns and practices

## Examples

### Example 1: Basic Architecture Review

**Input:**

```bash
bash skills/architecture-design-review/scripts/check-architecture.sh --json
```

**Output:**

```json
{
  "success": true,
  "architecture_file": "/path/to/docs/architecture.md",
  "available_docs": ["architecture.md", "ground-rules.md"],
  "adr_count": 5,
  "specs_count": 3
}
```

**Review Focus:**

- Validate all C4 diagrams
- Check ADR completeness
- Verify ground-rules alignment

### Example 2: Comprehensive Review with Supporting Docs

**Available Documents:**

- `docs/architecture.md`
- `docs/adr/*.md` (7 ADRs)
- `docs/ground-rules.md`
- `specs/*/spec.md` (5 specs)

**Review Includes:**

- Full document completeness check
- ADR validation (all 7)
- Requirements traceability
- Ground rules compliance check
- Quality attributes validation

## Edge Cases

- **Missing architecture.md**: Report error and exit
- **No ADRs found**: Flag as critical issue in review
- **Invalid Mermaid diagrams**: List all diagrams that fail to render
- **Missing ground-rules**: Proceed with review but note limitation
- **No feature specs**: Proceed but note inability to check requirements traceability
- **Multiple architecture files**: Use docs/architecture.md as canonical source
- **Incomplete sections**: Note each incomplete section with severity

## Error Handling

- **Script execution fails**: Report exact error, check working directory and script permissions
- **Invalid JSON from script**: Parse as text and extract file paths manually
- **Architecture file not readable**: Check file permissions and path
- **Mermaid validation fails**: List specific syntax errors for each diagram
- **Missing required sections**: List all missing sections in review report
- **Invalid ADR format**: Note specific formatting issues for each ADR

## Scripts

This skill includes cross-platform scripts for checking architecture documentation:

### Bash Script (Unix/Linux/macOS)

```bash
bash skills/architecture-design-review/scripts/check-architecture.sh --json
```

**Features:**

- Locates architecture.md in docs/ directory
- Counts ADR files in docs/adr/
- Identifies supporting documentation
- Validates Mermaid diagram syntax (basic check)
- JSON and human-readable output

### PowerShell Script (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File skills/architecture-design-review/scripts/check-architecture.ps1 -Json
```

**Features:**

- Locates architecture.md in docs\ directory
- Counts ADR files in docs\adr\
- Identifies supporting documentation
- Validates Mermaid diagram syntax (basic check)
- JSON and human-readable output

### Script Output Format

Both scripts output JSON with:

- `success`: Boolean indicating if architecture.md was found
- `architecture_file`: Path to architecture.md
- `available_docs`: Array of found supporting documents
- `adr_count`: Number of ADR files found
- `specs_count`: Number of feature specs found
- `ground_rules_found`: Boolean indicating if ground-rules.md exists
- `diagrams_found`: Number of Mermaid diagrams in architecture.md
- `error`: Error message if architecture.md not found

## Templates

- `templates/architecture-review-template.md`: Structure for generated review reports

## Guidelines

1. **Be Objective**: Base findings on concrete evidence from the document
2. **Be Specific**: Reference exact sections and line numbers for issues
3. **Be Constructive**: Provide actionable recommendations, not just criticisms
4. **Prioritize**: Distinguish between critical issues and minor improvements
5. **Consider Context**: Architecture decisions may be justified by constraints
6. **Check Completeness**: Missing content is as important as incorrect content
7. **Validate Diagrams**: Ensure all Mermaid diagrams are syntactically valid
8. **Trace Requirements**: Verify architecture addresses all requirements
9. **Assess Quality Attributes**: Ensure quality strategies are concrete and measurable
10. **Review ADRs**: Each major decision should have a well-documented ADR

## Validation

Before finalizing review report, validate:

- [ ] All review checklist items addressed
- [ ] Findings are specific with section references
- [ ] Recommendations are actionable
- [ ] Priority levels assigned to all recommendations
- [ ] Review report follows template structure
- [ ] Overall assessment scores justified
- [ ] Action items are clear and assignable

## Success Criteria

An architecture review is complete when:

- [ ] All sections of architecture.md evaluated
- [ ] All C4 diagrams validated
- [ ] All ADRs reviewed for completeness
- [ ] Quality attributes assessed
- [ ] Deployment architecture validated
- [ ] Alignment with ground-rules checked
- [ ] Alignment with requirements checked
- [ ] Risks and technical debt reviewed
- [ ] Review report generated with findings
- [ ] Recommendations prioritized
- [ ] Action items identified
- [ ] Report committed to repository
