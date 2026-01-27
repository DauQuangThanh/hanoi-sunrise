---
name: context-assessment
description: Analyze existing codebases to understand architecture, patterns, and conventions before adding new features. Use when assessing brownfield projects, documenting technical architecture, or when the user mentions codebase analysis, architecture review, or technical assessment.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
license: MIT
---

# Context Assessment Skill

## When to Use

- Analyzing existing modern codebases to understand architecture and patterns
- Documenting technical architecture before adding new features
- Creating baseline assessments for brownfield projects
- Understanding coding conventions and standards in existing code
- Calculating technical health scores for project assessment
- Preparing comprehensive context for feature development
- When user mentions "analyze codebase", "assess project", "review architecture"

## Prerequisites

**Required Tools**:

- Git (optional but recommended for branch detection)
- File system access to project repository

**Required Files**:

- Access to project source code
- Optional: `docs/ground-rules.md`, `docs/architecture.md`, `docs/standards.md`

## Instructions

### Step 1: Setup and Initialization

Run the setup script to prepare the assessment environment:

**Bash (macOS/Linux)**:

```bash
cd <SKILL_DIR>/scripts
./setup-context-assessment.sh --json
```

**PowerShell (Windows)**:

```powershell
cd <SKILL_DIR>/scripts
./setup-context-assessment.ps1 -Json
```

The script will:

- Detect repository root
- Create `docs/` directory if needed
- Copy assessment template to `docs/context-assessment.md`
- Return paths in JSON format

**Parse the JSON output** to get:

- `CONTEXT_ASSESSMENT`: Path to the assessment document
- `DOCS_DIR`: Documentation directory
- `REPO_ROOT`: Repository root
- `HAS_GIT`: Whether the project uses Git

### Step 2: Load Existing Context

Before starting the assessment, load any existing documentation:

1. Read `docs/ground-rules.md` (if exists) - project principles
2. Read `docs/architecture.md` (if exists) - existing architecture docs
3. Read `docs/standards.md` (if exists) - coding standards
4. Load the assessment template from `CONTEXT_ASSESSMENT` path

### Step 3: Execute Context Assessment Workflow

Follow the assessment phases systematically:

#### Phase 0: Technology Stack Discovery

1. Identify programming languages and versions (package.json, requirements.txt, etc.)
2. Document frameworks and major libraries
3. Review runtime environments and dependencies
4. Note build tools and package managers

**Output**: Complete "Executive Summary" and "Technology Stack" sections

#### Phase 1: Project Structure Analysis

1. Analyze directory structure and organization
2. Identify architectural layers (presentation, business logic, data)
3. Document entry points (main, API routes, workers)

**Output**: Complete "Project Structure" section with directory tree

#### Phase 2: Architectural Patterns

1. Identify architectural style (monolith, microservices, etc.)
2. Document design patterns (Repository, Factory, etc.)
3. Analyze component relationships and dependencies

**Output**: Complete "Architecture Patterns" section with examples

#### Phase 3: Coding Conventions & Standards

1. Extract naming conventions from actual code
2. Identify code organization patterns
3. Review code quality practices (linting, formatting)
4. Document error handling and logging patterns

**Output**: Complete "Coding Conventions" section with code examples

#### Phase 4: Data Layer Assessment

1. Analyze data models and entity definitions
2. Review data access patterns (ORM, repositories)
3. Document database(s) and caching strategies

**Output**: Complete "Data Layer" section

#### Phase 5: API & Integration Patterns

1. Catalog API endpoints and authentication approach
2. Review integration patterns with external services
3. Document API contracts and error handling

**Output**: Complete "API & Integration Patterns" section

#### Phase 6: Testing Strategy

1. Identify testing frameworks and approaches
2. Review test patterns (mocking, fixtures)
3. Assess test coverage and gaps

**Output**: Complete "Testing Strategy" section

#### Phase 7: Build & Deployment

1. Document build process and commands
2. Review deployment strategy and CI/CD
3. Identify DevOps practices

**Output**: Complete "Build & Deployment" section

#### Phase 8: Technical Health Assessment

1. Calculate technical health score using the formula:

   ```
   Score = (
     Code Quality × 0.30 +
     Architecture × 0.25 +
     Testing × 0.20 +
     Documentation × 0.15 +
     Dependencies × 0.10
   )
   ```

2. Identify strengths and improvement areas
3. Document technical debt hotspots

**Score Interpretation**:

- 80-100: Excellent (well-maintained, easy to extend)
- 60-79: Good (some areas need attention)
- 40-59: Fair (significant technical debt)
- 0-39: Poor (major refactoring needed)

**Output**: Complete "Technical Health Assessment" section with score

#### Phase 9: Feature Integration Readiness

1. Assess readiness for adding new features
2. Document common workflows (adding endpoints, entities, components)
3. Identify constraints (performance, security, compatibility)

**Output**: Complete "Feature Integration Readiness" section

#### Phase 10: Finalization

1. Complete executive summary with key findings
2. Validate all sections are complete
3. Ensure all code examples are from actual codebase
4. Verify consistency with existing documentation

### Step 4: Update Agent Context

After completing the assessment, update agent-specific context files:

**Bash (macOS/Linux)**:

```bash
cd <SKILL_DIR>/scripts
./update-agent-context.sh [agent-type]
```

**PowerShell (Windows)**:

```powershell
cd <SKILL_DIR>/scripts
./update-agent-context.ps1 -AgentType [agent-type]
```

**Supported agent types**: claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, roo, codebuddy, amp, shai, q, bob, jules, qoder, antigravity

**Omit agent type** to update all existing agent files.

### Step 5: Commit Assessment

Create a git commit with the completed assessment:

```bash
git add docs/context-assessment.md
git commit -m "docs: add codebase context assessment"
```

## Examples

### Example 1: Full Stack Application Assessment

**Input**: Analyze Node.js/React e-commerce platform

**Process**:

1. Run setup script → Get assessment template path
2. Identify tech stack → Node.js 18, React 18, PostgreSQL, Express
3. Analyze structure → Monorepo with `packages/api`, `packages/web`
4. Document patterns → REST API, Repository pattern, React hooks
5. Extract conventions → camelCase JS, PascalCase components
6. Assess data layer → Prisma ORM, normalized schema
7. Review APIs → RESTful endpoints, JWT auth
8. Check tests → Jest 85% coverage, Supertest integration tests
9. Calculate health score → 78/100 (Good)
10. Document readiness → High - well-organized, clear patterns

**Output**: Complete `docs/context-assessment.md` with 78/100 health score

### Example 2: Django REST API Assessment

**Input**: Analyze Python Django microservice

**Process**:

1. Run setup script → Get assessment template path
2. Identify tech stack → Python 3.12, Django 5.0, PostgreSQL, Celery
3. Analyze structure → Django apps: `users`, `orders`, `products`
4. Document patterns → DRF viewsets, Celery tasks, signals
5. Extract conventions → snake_case, Django app structure
6. Assess data layer → Django ORM, Redis caching
7. Review APIs → GraphQL + REST, token auth
8. Check tests → pytest 65% coverage, some gaps
9. Calculate health score → 68/100 (Good)
10. Document readiness → Medium - needs more tests

**Output**: Complete `docs/context-assessment.md` with 68/100 health score

## Key Rules

1. **Use Absolute Paths**: All file operations must use absolute paths
2. **Project-Level Scope**: Assessment goes to `docs/context-assessment.md` (not feature-specific)
3. **Focus on Patterns**: Extract patterns and conventions, not exhaustive code listings
4. **Provide Examples**: Every major finding MUST have code examples from actual codebase
5. **Show, Don't Tell**: Extract examples from real code, don't just describe
6. **Align with Existing Docs**: Reference and align with ground-rules, architecture docs
7. **Calculate Score**: Use the technical health scoring formula exactly as specified
8. **Validate Completeness**: Ensure all template sections are addressed
9. **No Placeholders**: Replace all "ACTION REQUIRED" comments with actual findings
10. **One-Time Activity**: Run once per project when first analyzing brownfield codebase

## Technical Health Scoring Formula

```
Technical Health Score (0-100) = (
  Code Quality (0-100) × 0.30 +
  Architecture (0-100) × 0.25 +
  Testing (0-100) × 0.20 +
  Documentation (0-100) × 0.15 +
  Dependencies (0-100) × 0.10
)

Components:
- Code Quality: Linting compliance, complexity, duplication
- Architecture: Pattern consistency, modularity, coupling
- Testing: Coverage percentage, test quality, CI integration
- Documentation: README, API docs, inline comments
- Dependencies: Up-to-date packages, security, licenses
```

## Edge Cases

### Case 1: No Existing Documentation

**Handling**: Create assessment from scratch using only codebase analysis. Focus on observable patterns and conventions in the code itself.

### Case 2: Legacy Codebase with Mixed Patterns

**Handling**: Document multiple patterns found, identify which are current vs. legacy. Note inconsistencies and recommend standardization.

### Case 3: Microservices Architecture

**Handling**: Assess each service separately if needed, or provide high-level architecture with service-specific sections.

### Case 4: Non-Git Repository

**Handling**: Script handles non-git projects. Set `SPECIFY_FEATURE` environment variable if needed for manual feature tracking.

### Case 5: Incomplete Information

**Handling**: Document what is found, note gaps explicitly, recommend areas needing clarification or documentation.

### Case 6: Multiple Languages/Frameworks

**Handling**: Document all technologies, create separate subsections for each major technology stack component.

## Error Handling

### Error: No Source Code Access

**Action**: Cannot proceed. Request access to project repository files.

### Error: Template Not Found

**Action**: Script creates basic assessment file. Manually structure the document using standard sections.

### Error: Cannot Determine Repository Root

**Action**: Manually specify repository root or run from project root directory.

### Error: Missing Design/Spec File

**Action**: Expected for context assessment (doesn't require existing specs). Proceed with codebase analysis only.

### Warning: Low Code Coverage

**Action**: Document actual coverage percentage, note testing gaps, adjust health score accordingly.

### Warning: Outdated Dependencies

**Action**: List outdated packages, check for security vulnerabilities, reduce dependencies score component.

## Success Criteria

Assessment is complete when:

- [ ] Technology stack documented with specific versions
- [ ] Project structure analyzed with clear layer descriptions
- [ ] Architectural patterns identified with code examples
- [ ] Coding conventions extracted from actual code (not assumed)
- [ ] Data layer patterns documented with ORM/schema examples
- [ ] API patterns and contracts documented with endpoint examples
- [ ] Testing strategy assessed with actual coverage metrics
- [ ] Build and deployment process documented with commands
- [ ] Technical health score calculated (0-100) with formula shown
- [ ] Feature integration guidelines provided with workflows
- [ ] Executive summary completed with key findings
- [ ] All "ACTION REQUIRED" placeholders replaced
- [ ] Agent context updated (if applicable)
- [ ] Assessment committed to git

## Scripts

### setup-context-assessment.sh / .ps1

Creates assessment environment and copies template:

```bash
# Bash
cd <SKILL_DIR>/scripts
./setup-context-assessment.sh --json

# PowerShell
cd <SKILL_DIR>/scripts
./setup-context-assessment.ps1 -Json
```

**Returns**: JSON with paths (CONTEXT_ASSESSMENT, DOCS_DIR, REPO_ROOT, HAS_GIT)

### update-agent-context.sh / .ps1

Updates agent-specific context with assessment findings:

```bash
# Bash - Update specific agent
cd <SKILL_DIR>/scripts
./update-agent-context.sh claude

# Bash - Update all agents
cd <SKILL_DIR>/scripts
./update-agent-context.sh

# PowerShell - Update specific agent
cd <SKILL_DIR>/scripts
./update-agent-context.ps1 -AgentType claude

# PowerShell - Update all agents
cd <SKILL_DIR>/scripts
./update-agent-context.ps1
```

## Templates

### context-assessment-template.md

Located at: `<SKILL_DIR>/templates/context-assessment-template.md`

Comprehensive template with sections for:

- Executive Summary
- Technology Stack
- Project Structure
- Architecture Patterns
- Coding Conventions
- Data Layer
- API & Integration Patterns
- Testing Strategy
- Build & Deployment
- Technical Health Assessment
- Feature Integration Readiness
- Appendix

Each section includes detailed prompts and examples.

## Additional Resources

- Template: `<SKILL_DIR>/templates/context-assessment-template.md`
- Setup Script: `<SKILL_DIR>/scripts/setup-context-assessment.sh` (Bash)
- Setup Script: `<SKILL_DIR>/scripts/setup-context-assessment.ps1` (PowerShell)
- Agent Update: `<SKILL_DIR>/scripts/update-agent-context.sh` (Bash)
- Agent Update: `<SKILL_DIR>/scripts/update-agent-context.ps1` (PowerShell)

## Notes

- Run this **once per project** when first analyzing a brownfield codebase
- **Recommended workflow**: Context Assessment → Project Principles → Feature Specification
- The assessment guides how new features should integrate with existing code
- Assessment is stored at project level (`docs/context-assessment.md`), not feature-specific
- Follow up by creating project principles based on assessment findings
- Then use requirements specification skill to add new features aligned with assessed patterns
