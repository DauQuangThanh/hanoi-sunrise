---
name: architecture-design
description: Create comprehensive system architecture documentation for products using C4 model diagrams, ADRs, and quality attribute strategies. Use when designing product architecture, creating architecture documentation, or when the user mentions architecture design, system design, C4 diagrams, or architectural decisions.
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
license: MIT
---

# Architecture Design Skill

## When to Use

- Creating comprehensive system architecture documentation for products
- Designing product-level architecture with C4 model diagrams
- Documenting architectural decisions (ADRs)
- Defining quality attribute requirements and strategies
- Planning deployment architecture and infrastructure
- When user mentions "design architecture", "system architecture", "C4 diagrams"
- Before creating feature-level implementation plans
- After creating feature specifications and ground rules

## Prerequisites

**Required Tools**:

- Git (recommended for version control)
- File system access to project repository

**Required Files**:

- `docs/ground-rules.md` - Project principles and constraints
- Feature specifications in `specs/*/spec.md` (at least one recommended)

**Optional**:

- Existing architecture documentation to update

## Instructions

### Step 0: Specification and Requirements Gathering

**⚠️ IMPORTANT: Always request specification documents before starting architecture design.**

1. **Request specification documents:**
   - Ask the user to provide requirements specifications, feature documentation, or product requirements
   - Request any relevant documentation: PRD (Product Requirements Document), feature specs, user stories, or business requirements
   - If no formal documentation exists, ask the user to describe:
     - The product or system to be architected
     - Key features and functionalities
     - Expected users and stakeholders
     - Business goals and objectives
     - Technical constraints or preferences
     - Performance and scalability requirements
     - Security and compliance needs

2. **Verify ground rules exist:**
   - Check if `docs/ground-rules.md` exists in the project
   - If missing, recommend creating it first using the `project-ground-rules-setup` skill
   - Ground rules are essential for architecture design

3. **Review and confirm understanding:**
   - Summarize the requirements back to the user
   - Clarify any ambiguities or missing details
   - Confirm the scope and expected architecture deliverables
   - Identify what needs to be designed (new system, system enhancement, specific components)

4. **Only proceed to Step 1 after:**
   - Specification documents are provided and reviewed
   - Ground rules file exists or creation is confirmed
   - Requirements are clearly understood
   - User confirms readiness to start architecture design

### Step 1: Setup and Initialization

Run the setup script to prepare the architecture environment:

**Bash (macOS/Linux)**:

```bash
cd <SKILL_DIR>/scripts
./setup-architect.sh --json
```

**PowerShell (Windows)**:

```powershell
cd <SKILL_DIR>/scripts
./setup-architect.ps1 -Json
```

The script will:

- Detect repository root
- Create `docs/` and `docs/adr/` directories
- Copy architecture template to `docs/architecture.md`
- Find all feature specifications
- Return paths and metadata in JSON format

**Parse the JSON output** to get:

- `ARCH_DOC`: Path to the architecture document
- `DOCS_DIR`: Documentation directory
- `ADR_DIR`: Architecture Decision Records directory
- `SPECS_DIR`: Feature specifications directory
- `SPEC_COUNT`: Number of feature specs found
- `FEATURE_SPECS`: Array of spec file paths
- `PRODUCT_NAME`: Product/project name
- `GROUND_RULES`: Path to ground rules file

### Step 2: Load Existing Context

Before starting architecture design, load existing project context:

1. Read `docs/ground-rules.md` - Project principles, constraints, conventions
2. Read all feature specifications from `FEATURE_SPECS` array
3. Load the architecture template from `ARCH_DOC` path
4. Review any existing architecture documentation

### Step 3: Execute Architecture Design Workflow

Follow the architecture design phases systematically:

#### Phase 0: Architecture Analysis & Stakeholder Identification

**Goal**: Understand requirements and stakeholders

1. **Analyze feature specifications**:
   - Read all `specs/*/spec.md` files
   - Extract common patterns and requirements
   - Identify system boundaries
   - List all external integrations mentioned

2. **Identify stakeholders** from ground-rules and specs:
   - End users and their concerns
   - Development team requirements
   - Operations team needs
   - Security and compliance requirements
   - Business stakeholders

3. **Extract architectural drivers**:
   - Business goals from feature specs
   - Quality attributes (performance, scalability, security)
   - Technical constraints from ground-rules
   - Organizational constraints
   - Assumptions and dependencies

**Output**: Complete sections "Executive Summary" and "Architecture Snapshot"

#### Phase 1: System Design & C4 Model

**Goal**: Create visual architecture using C4 model

**Prerequisites**: Phase 0 complete

Create four levels of architecture diagrams using Mermaid format. See [references/c4-and-adr-guide.md](references/c4-and-adr-guide.md) for detailed C4 model guidance, diagram examples, and when to use each level.

1. **System Context (C4 Level 1)**: User types, external systems, system boundaries
2. **Container View (C4 Level 2)**: Technical containers, technology stack, communication protocols
3. **Component View (C4 Level 3)**: Component breakdown for critical containers
4. **Code View (C4 Level 4)**: Optional - directory structure, design patterns

**Output**: Complete "System Overview (C4)" section with all Mermaid diagrams

#### Phase 2: Deployment & Infrastructure Design

**Goal**: Design production deployment architecture

**Prerequisites**: Phase 1 complete

Design deployment topology, CI/CD pipeline, and disaster recovery. See [references/c4-and-adr-guide.md](references/c4-and-adr-guide.md) for deployment architecture patterns (single-region, multi-region active-passive, multi-region active-active).

1. **Deployment architecture**: Environment topology, infrastructure components, multi-AZ setup
2. **CI/CD pipeline**: Build/test/deploy stages, deployment strategy, IaC approach
3. **Disaster recovery**: Backup strategy, RTO/RPO, recovery procedures

**Output**: Complete "Deployment Summary" section

#### Phase 3: Architecture Decisions & Quality Strategies

**Goal**: Document decisions and quality attribute strategies

**Prerequisites**: Phase 2 complete

Document ADRs for major architectural choices and map quality strategies to requirements. See [references/c4-and-adr-guide.md](references/c4-and-adr-guide.md) for:
- Detailed ADR template and examples
- When to create ADRs
- Quality attribute strategies (performance, scalability, availability, security, maintainability)
- Common architecture patterns (event-driven, API gateway, CQRS, strangler fig)

1. **Document ADRs**: For each major decision, include context, decision, rationale, consequences, alternatives
2. **Map quality strategies**: Performance, scalability, availability, security, maintainability
3. **Identify risks**: Architecture risks, technical debt, open questions

**Output**: Complete "Architecture Decisions (ADR Log)", "Quality Attributes", and "Risks & Technical Debt" sections

#### Phase 4: Agent Checklist & Finalization

**Goal**: Create actionable guidance for agents and validate completeness

**Prerequisites**: Phase 3 complete

1. **Complete Agent Checklist**:
   - **Inputs**: Payloads, headers, authentication requirements
   - **Outputs**: JSON schemas, status codes, response formats
   - **Public APIs**: List endpoints with HTTP methods
   - **Events**: Event names, payload schemas, topics/queues
   - **Data Contracts**: Key tables/fields, indexes, relationships
   - **SLOs**: Latency targets, availability targets
   - **Secrets**: Secret sources, rotation policies
   - **Config**: Environment variables, feature flags
   - **Failure Modes**: Timeouts, retries, idempotency requirements
   - **Security**: Roles, scopes, token TTLs

2. **Generate supplementary documents** (if needed):
   - `docs/architecture-overview.md` - High-level summary for stakeholders
   - `docs/deployment-guide.md` - Detailed deployment instructions
   - `docs/adr/` - Individual ADR files for version control

3. **Validation**:
   - Ensure all sections are complete
   - Verify all Mermaid diagrams render correctly
   - Check that all "ACTION REQUIRED" comments are addressed
   - Validate consistency with ground-rules
   - Confirm quality targets are measurable and specific

### Step 4: Update Agent Context

After completing the architecture, update agent-specific context files:

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

### Step 5: Commit Architecture

Create a git commit with the completed architecture:

```bash
git add docs/architecture.md docs/adr/
git commit -m "docs: add system architecture documentation"
```

### Step 6: Quality Review (Recommended)

**After completing the architecture, it's highly recommended to run a quality review:**

1. **Run the architecture-design-review skill** to validate:
   - Alignment with ground rules and project goals
   - Technical feasibility and scalability
   - Completeness of architectural decisions
   - Clarity of component descriptions
   - Proper documentation of trade-offs

2. **Address any findings** from the review before proceeding to feature specifications

3. **If issues found**, update the architecture and repeat validation

**Next Steps:**
- If review passes, proceed to create feature specifications using `requirements-specification` skill
- Use `coding-standards` skill to establish code conventions
- Use `technical-design` skill for individual feature implementation planning

## Examples

### Example 1: E-Commerce Platform Architecture

**Input**: Design architecture for e-commerce platform with 3 feature specs (user management, product catalog, checkout)

**Process**:

1. Run setup script → Get architecture template and 3 specs
2. Analyze specs → Extract: user auth, product search, payment gateway
3. Identify stakeholders → End users, admins, payment provider, analytics
4. Create C4 Context → Users, Admin, System, Stripe, Google Analytics
5. Design Containers → React SPA, Node.js API, PostgreSQL, Redis, RabbitMQ
6. Define Components → Auth service, Product service, Order service, Payment service
7. Plan deployment → AWS ECS, Multi-AZ, CloudFront CDN, RDS Multi-AZ
8. Document ADRs → Microservices (scalability), PostgreSQL (ACID), Redis (caching)
9. Define quality targets → 95% < 200ms, 99.9% uptime, PCI DSS compliance
10. Complete agent checklist → REST endpoints, JWT auth, event schemas

**Output**: Complete `docs/architecture.md` with C4 diagrams and 5 ADRs

### Example 2: SaaS Analytics Platform

**Input**: Design architecture for multi-tenant analytics platform

**Process**:

1. Run setup script → Get template, ground rules, 4 specs
2. Analyze requirements → Multi-tenancy, real-time dashboards, data export
3. Identify drivers → Performance (sub-second queries), Scalability (1M+ events/sec)
4. Create C4 diagrams → Context (users, data sources), Containers (Kafka, Druid, React)
5. Design deployment → Kubernetes on AWS EKS, horizontal pod autoscaling
6. Document ADRs → Event-driven architecture, Apache Druid (OLAP), tenant isolation
7. Define strategies → Sharding by tenant_id, columnar storage, query caching
8. Risk assessment → Data lake performance, multi-tenancy security
9. Complete checklist → GraphQL API, event schemas, SLOs (p95 < 100ms)

**Output**: Complete architecture with deployment diagrams and security model

## Key Rules

1. **Use Absolute Paths**: All file operations must use absolute paths
2. **Product-Level Scope**: Architecture goes to `docs/architecture.md` (product-level, NOT feature-level)
3. **Mermaid Diagrams Required**: All diagrams MUST use Mermaid format embedded in markdown
4. **ADRs Are Mandatory**: Every major architectural decision MUST have an ADR
5. **Measurable Targets**: Quality attribute targets must be specific and measurable (not "fast", but "95% < 200ms")
6. **Respect Ground Rules**: Ground-rules constraints MUST be respected; violations must be justified
7. **Reference Specs**: Document which feature specs influenced each architectural decision
8. **Concrete Values**: Use concrete numbers, versions, URLs (not placeholders)
9. **Non-Technical Summary**: Executive Summary must be understandable for business stakeholders
10. **One Architecture Per Product**: This is product-level, not feature-level planning

## Architecture Decision Record (ADR) Format

See [references/c4-and-adr-guide.md](references/c4-and-adr-guide.md) for detailed ADR template with complete example.

Each ADR should include:
- **Status**, **Date**, **Deciders**
- **Context**: Issue prompting decision
- **Decision**: Chosen approach
- **Rationale**: Why this choice
- **Consequences**: Positive and negative impacts
- **Alternatives Considered**: Other options and why rejected

## Edge Cases

### Case 1: No Feature Specifications Yet

**Handling**: Create architecture based on ground-rules and user input only. Focus on high-level system design. Update architecture after feature specs are created.

### Case 2: Updating Existing Architecture

**Handling**: Read existing `docs/architecture.md`, preserve existing ADRs, add new sections for changes. Create new ADRs for new decisions. Mark superseded ADRs appropriately.

### Case 3: Microservices vs Monolith Decision

**Handling**: Consider: team size, deployment frequency, scalability needs, organizational structure. Document decision in ADR with clear rationale. Default to monolith for small teams unless specific drivers require microservices.

### Case 4: Multiple Deployment Targets

**Handling**: Document primary deployment target in main architecture. Create separate deployment sections for each target (cloud, on-premise, hybrid). Note differences and constraints.

### Case 5: Legacy System Integration

**Handling**: Document legacy systems in C4 Context diagram. Create ADR for integration approach (API gateway, message queue, ETL). Note risks and migration strategies in technical debt section.

### Case 6: Compliance Requirements

**Handling**: Document compliance requirements (GDPR, HIPAA, PCI DSS) in Architecture Snapshot. Add security controls to Quality Attributes section. Create ADRs for compliance-driven decisions. Include audit logging and data protection strategies.

## Error Handling

### Error: No Ground Rules File

**Action**: Cannot proceed without ground-rules. Prompt user to create project principles first using project-ground-rules-setup skill or equivalent.

### Error: Template Not Found

**Action**: Script creates basic architecture file. Manually structure document using standard sections from skill documentation.

### Error: Mermaid Diagram Syntax Error

**Action**: Validate Mermaid syntax using online editor (mermaid.live). Fix syntax errors. Test rendering in markdown preview.

### Warning: No Feature Specifications

**Action**: Can proceed but architecture will be high-level. Recommend creating feature specifications first for more detailed architecture.

### Warning: Incomplete ADRs

**Action**: Ensure each ADR has all required sections (Context, Decision, Rationale, Consequences, Alternatives). Don't leave placeholders.

### Warning: Non-Measurable Quality Targets

**Action**: Replace vague targets ("fast", "scalable") with specific metrics ("95% < 200ms", "10k concurrent users"). Use industry standards as reference.

## Success Criteria

Architecture design is complete when:

- [ ] Executive Summary is clear and understandable for business stakeholders
- [ ] Architecture Snapshot lists concrete constraints and quality targets
- [ ] C4 Context diagram shows all user types and external systems
- [ ] C4 Container diagram shows all major containers with technology choices
- [ ] C4 Component diagram shows key components for critical containers
- [ ] Deployment Summary includes runtime, regions, CI/CD, secrets management
- [ ] At least 3-5 ADRs document major architectural decisions
- [ ] Each ADR includes Context, Decision, Rationale, Consequences, Alternatives
- [ ] Quality Attributes section has measurable targets for each attribute
- [ ] Quality strategies map to specific quality attribute requirements
- [ ] Risks identified with impact assessment and mitigation strategies
- [ ] Agent Checklist is complete with concrete values (not placeholders)
- [ ] All Mermaid diagrams render correctly
- [ ] All "ACTION REQUIRED" comments are replaced with actual content
- [ ] Ground-rules constraints are respected and documented
- [ ] Architecture committed to git

## Scripts

### setup-architect.sh / .ps1

Creates architecture environment and copies template:

```bash
# Bash
cd <SKILL_DIR>/scripts
./setup-architect.sh --json

# PowerShell
cd <SKILL_DIR>/scripts
./setup-architect.ps1 -Json
```

**Returns**: JSON with paths (ARCH_DOC, DOCS_DIR, ADR_DIR, SPECS_DIR, SPEC_COUNT, FEATURE_SPECS, PRODUCT_NAME, GROUND_RULES)

### update-agent-context.sh / .ps1

Updates agent-specific context with architecture decisions:

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

### arch-template.md

Located at: `<SKILL_DIR>/templates/arch-template.md`

Streamlined architecture template with sections for:

- Executive Summary
- Architecture Snapshot
- System Overview (C4 Model with Mermaid diagrams)
- Deployment Summary
- Architecture Decisions (ADR Log)
- Quality Attributes (Targets & Strategies)
- Risks & Technical Debt
- Agent Checklist

Optimized for AI agent consumption with concrete values and minimal fluff.

## Additional Resources

- Template: `<SKILL_DIR>/templates/arch-template.md`
- Setup Script: `<SKILL_DIR>/scripts/setup-architect.sh` (Bash)
- Setup Script: `<SKILL_DIR>/scripts/setup-architect.ps1` (PowerShell)
- Agent Update: `<SKILL_DIR>/scripts/update-agent-context.sh` (Bash)
- Agent Update: `<SKILL_DIR>/scripts/update-agent-context.ps1` (PowerShell)
- C4 Model: <https://c4model.com/>
- Mermaid Live Editor: <https://mermaid.live/>
- ADR Templates: <https://github.com/joelparkerhenderson/architecture-decision-record>

## Notes

- This is **product-level architecture**, not feature-level implementation plans
- Run this AFTER creating feature specs and ground-rules
- Run this BEFORE creating feature implementation plans
- The architecture guides ALL subsequent feature implementation
- Treat `docs/architecture.md` as a living document that evolves with the product
- Update architecture when adding major features or making significant changes
- Use feature-level design skill for individual feature implementation plans
- Architecture should align with ground-rules principles and constraints
