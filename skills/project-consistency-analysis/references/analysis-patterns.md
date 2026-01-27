# Project Consistency Analysis Reference

## Detection Passes Detailed

### A. Duplication Detection

**Purpose**: Identify redundant requirements that should be consolidated

**Detection Algorithm**:
1. Extract all functional/non-functional requirements
2. Compute textual similarity (TF-IDF or Levenshtein distance)
3. Flag pairs with >70% similarity
4. Group similar requirements together
5. Identify consolidation candidates

**Patterns to Detect**:
- **Exact Duplicates**: Same requirement in multiple sections
- **Near-Duplicates**: Same intent, different wording
- **Overlapping Requirements**: Partial overlap suggesting merge

**Examples**:

**Exact Duplicate**:
- spec.md:L45: "User can upload files"
- spec.md:L120: "User can upload files"
- **Action**: Remove duplicate, keep one

**Near-Duplicate**:
- spec.md:L50: "API response time must be fast"
- spec.md:L200: "System must respond quickly to API calls"
- **Action**: Merge into single measurable requirement

**Overlapping**:
- spec.md:L60: "User can create account"
- spec.md:L75: "User can register with email and password"
- **Action**: Consolidate registration flow

### B. Ambiguity Detection

**Purpose**: Flag vague or unmeasurable requirements

**Vague Adjectives to Flag**:
- Performance: "fast", "quick", "slow", "efficient", "optimal"
- Scalability: "scalable", "large-scale", "massive"
- Security: "secure", "safe", "protected"
- Usability: "intuitive", "user-friendly", "easy", "simple"
- Quality: "robust", "reliable", "stable", "high-quality"
- Appearance: "nice", "clean", "modern", "professional"

**Placeholder Patterns**:
- TODO, TBD, TKTK, ???
- <placeholder>, [to be determined], [fill in]
- "See later", "details coming", "TBD"

**Subjective Measures**:
- "Users will like it"
- "Should be acceptable"
- "Reasonably fast"
- "Good enough"

**Examples**:

**Vague Performance**:
- ❌ "API must be fast"
- ✅ "API response time: p95 < 200ms, p99 < 500ms"

**Vague Security**:
- ❌ "System must be secure"
- ✅ "Data encrypted at rest (AES-256), in transit (TLS 1.3)"

**Placeholder**:
- ❌ "Performance target: TBD"
- ✅ "Performance target: 10,000 requests/second"

### C. Underspecification Detection

**Purpose**: Identify incomplete requirements

**Patterns to Check**:

**Missing Objects**:
- "System must handle..." (handle what?)
- "User can create..." (create what?)
- "API should return..." (return what?)

**Missing Outcomes**:
- "User logs in" (what happens after?)
- "System processes data" (what's the result?)
- "API validates input" (then what?)

**Missing Acceptance Criteria**:
- User story without testable criteria
- Requirement without verification method
- Feature without measurable outcomes

**Missing Error Handling**:
- "Upload file" (what if fails?)
- "Call external API" (what if timeout?)
- "Process payment" (what if declined?)

**Examples**:

**Missing Object**:
- ❌ "User can upload" 
- ✅ "User can upload images (JPG, PNG, max 10MB)"

**Missing Outcome**:
- ❌ "User logs in"
- ✅ "User logs in → redirected to dashboard, session created"

**Missing Criteria**:
- ❌ User Story: "As a user, I want to search"
- ✅ User Story: "As a user, I want to search" + Criteria: "Results in <1s, ranked by relevance"

### D. Ground-Rules Alignment

**Purpose**: Validate compliance with project principles

**Validation Checks**:

**MUST Principles**:
- Extract all "MUST" statements from ground-rules
- Check if any requirement/design violates them
- **All violations are CRITICAL**

**SHOULD Principles**:
- Extract all "SHOULD" statements
- Check for deviations
- **Violations are HIGH severity** (may have justification)

**Prohibited Practices**:
- Check if design uses forbidden technologies
- Check if tasks violate process requirements
- **Violations are CRITICAL**

**Quality Gates**:
- Verify required checkpoints present
- Check if artifacts meet quality standards
- **Missing gates are HIGH severity**

**Examples**:

**Technology Violation**:
- Ground-rule: "MUST use TypeScript"
- design.md: "Implementation in JavaScript"
- **Severity**: CRITICAL
- **Action**: Change to TypeScript or update ground-rule

**Process Violation**:
- Ground-rule: "MUST have E2E tests before deployment"
- tasks.md: No E2E test tasks
- **Severity**: CRITICAL
- **Action**: Add E2E test tasks

**Style Violation**:
- Ground-rule: "SHOULD use functional components"
- design.md: "Use class components"
- **Severity**: HIGH
- **Action**: Justify or change to functional

### E. Coverage Gap Detection

**Purpose**: Ensure all requirements have tasks

**Coverage Algorithm**:
1. Extract all requirements (functional + non-functional)
2. Extract all tasks with descriptions
3. Map tasks to requirements using:
   - Explicit references (IDs, keywords)
   - Semantic similarity
   - Entity/action matching
4. Identify requirements with zero tasks
5. Identify tasks with no requirement mapping

**Mapping Strategies**:

**Explicit References**:
- Task mentions requirement ID: "Implement REQ-AUTH-001"
- Task quotes requirement: "User can reset password"

**Keyword Matching**:
- Requirement: "User authentication"
- Task: "Create login page", "Implement JWT auth"

**Entity Matching**:
- Requirement mentions "Order entity"
- Task: "Create Order model", "Add order database table"

**Examples**:

**Uncovered Requirement**:
- spec.md: "Data must be encrypted at rest"
- tasks.md: No tasks mentioning encryption
- **Severity**: CRITICAL (security requirement)
- **Action**: Add encryption tasks

**Orphan Task**:
- tasks.md: "T050: Refactor UserService"
- No requirement about refactoring
- **Severity**: MEDIUM
- **Action**: Either add requirement or justify task

**Partial Coverage**:
- spec.md: "User can upload, view, delete files"
- tasks.md: Upload and view tasks only
- **Severity**: HIGH
- **Action**: Add delete file task

### F. Inconsistency Detection

**Purpose**: Find contradictions and misalignments

**Terminology Drift**:
- Same concept, different names across files
- Example: "User" (spec) vs "Account" (design) vs "Profile" (tasks)
- **Detection**: Build term frequency map, identify synonyms
- **Severity**: MEDIUM to HIGH depending on impact

**Data Entity Mismatches**:
- Entity in spec not in design (or vice versa)
- Entity fields differ between spec and design
- **Detection**: Extract entity definitions, compare schemas
- **Severity**: HIGH

**Technology Conflicts**:
- spec requires Next.js, design uses Vue.js
- spec says PostgreSQL, design says MongoDB
- **Detection**: Extract technology mentions, check alignment
- **Severity**: CRITICAL

**Task Ordering Issues**:
- Integration test before unit tests
- Database migration before schema design
- Deployment before testing
- **Detection**: Analyze task dependencies, check logical flow
- **Severity**: MEDIUM (if workarounds exist)

**Architecture Misalignment**:
- Design uses REST, architecture.md mandates GraphQL
- Design uses microservices, architecture.md describes monolith
- **Detection**: Compare design against architecture.md
- **Severity**: CRITICAL

**Standards Violations**:
- File names not following standards.md conventions
- Code structure deviating from standards.md
- API endpoints not matching standards.md patterns
- **Detection**: Check design/tasks against standards.md rules
- **Severity**: MEDIUM to HIGH

## Severity Assignment Decision Tree

### CRITICAL Severity

**When to Assign**:
- Violates ground-rules MUST requirement
- Core spec artifact missing (spec.md, design.md, tasks.md)
- Zero coverage for baseline functionality requirement
- Contradictory requirements that block implementation
- Security requirement with no coverage
- Data integrity gap
- Technology conflict (spec vs design)
- Architecture misalignment with non-negotiable pattern

**Impact**: Cannot proceed with implementation safely

**Examples**:
- Ground-rule "MUST use TypeScript" violated
- "User authentication" requirement has no tasks
- spec.md says PostgreSQL, design.md says MongoDB
- No encryption for sensitive user data

### HIGH Severity

**When to Assign**:
- Duplicate requirements causing confusion
- Ambiguous security/performance requirements
- Untestable acceptance criteria
- Non-functional requirement with no coverage
- Standards violations
- Architecture pattern deviations
- Major terminology drift

**Impact**: Should fix before implementation, workarounds risky

**Examples**:
- "API must be fast" (no metrics)
- Two conflicting user stories
- Performance requirement with no measurable target
- Component naming doesn't follow standards.md

### MEDIUM Severity

**When to Assign**:
- Terminology drift not affecting understanding
- Underspecified edge cases
- Coverage gaps in optional features
- Task ordering issues with viable workarounds
- Minor standards deviations
- Cosmetic inconsistencies affecting clarity

**Impact**: Can proceed but recommend fixes

**Examples**:
- "User" vs "Account" used interchangeably
- No error handling specified for optional feature
- Task "T050: Setup CI" could logically come earlier
- File naming slightly off from standards.md pattern

### LOW Severity

**When to Assign**:
- Style/wording improvements
- Minor redundancy not affecting execution
- Optional documentation gaps
- Purely cosmetic inconsistencies
- Suggestions for improvement

**Impact**: Optional improvements, can defer

**Examples**:
- Requirement could be worded more clearly
- Optional logging detail missing
- Minor formatting inconsistency
- Documentation could be more comprehensive

## Report Generation

### Executive Summary Template

```markdown
# Project Consistency Analysis Report

## Executive Summary

**Status**: [Pass / Issues Found / Critical Issues]

**Analyzed Documents**:
- spec.md (X requirements, Y user stories)
- design.md (Z pages, A entities)
- tasks.md (B tasks across C phases)
- ground-rules.md ✓ / architecture.md ✓ / standards.md ✓

**Overall Metrics**:
- Total Requirements: X
- Total Tasks: Y
- Coverage: Z% (requirements with ≥1 task)
- Findings: 🔴 Critical: A, 🟠 High: B, 🟡 Medium: C, ⚪ Low: D

**Key Issues**:
- [Brief summary of top 3 critical/high issues]

**Recommendation**: [Clear to Proceed / Fix High Priority / Must Resolve Critical]
```

### Findings Table Format

```markdown
## Findings

| ID | Category | Severity | Location(s) | Issue Summary | Recommendation |
|----|----------|----------|-------------|---------------|----------------|
| A1 | Ambiguity | 🟠 HIGH | spec.md:L78 | "Fast" unmeasurable | Define concrete metric: p95 < 200ms |
| D1 | Duplication | 🟡 MEDIUM | spec.md:L45, L120 | Duplicate auth requirement | Consolidate into single requirement |
| C1 | Coverage | 🔴 CRITICAL | spec.md:L56 | No tasks for encryption | Add T-ENC-001: Implement AES-256 encryption |
| G1 | Ground-Rules | 🔴 CRITICAL | design.md:L150 | Violates "MUST use TypeScript" | Update design to use TypeScript |
| I1 | Inconsistency | 🔴 CRITICAL | spec:L30 vs design:L70 | Spec: PostgreSQL, Design: MongoDB | Align on single database technology |
```

### Coverage Summary Template

```markdown
## Coverage Analysis

### Requirements with Full Coverage ✅

| Requirement Key | Task Count | Task IDs | Status |
|-----------------|------------|----------|--------|
| user-can-login | 2 | T010, T011 | Complete |
| data-validation | 3 | T015, T016, T017 | Complete |

### Requirements with No Coverage ❌

| Requirement Key | Location | Description | Recommendation |
|-----------------|----------|-------------|----------------|
| data-encryption | spec.md:L56 | Encrypt data at rest | Add implementation and test tasks |
| rate-limiting | spec.md:L92 | API rate limits | Add rate limiter middleware task |

### Orphan Tasks (No Mapped Requirement)

| Task ID | Description | Phase | Recommendation |
|---------|-------------|-------|----------------|
| T050 | Refactor UserService | Phase 2 | Add requirement or justify refactoring |
```

### Metrics Summary Template

```markdown
## Metrics Summary

**Requirements Analysis**:
- Functional Requirements: X
- Non-Functional Requirements: Y
- User Stories: Z
- Total Requirements: X+Y

**Task Analysis**:
- Total Tasks: A
- Phase 1 Tasks: B
- Phase 2 Tasks: C
- Parallel Tasks: D

**Coverage Metrics**:
- Requirements with Tasks: E / Total (Z%)
- Tasks with Requirements: F / Total (Z%)
- Uncovered Requirements: G
- Orphan Tasks: H

**Quality Metrics**:
- Ambiguous Requirements: I
- Duplicate Requirements: J
- Ground-Rules Violations: K
- Inconsistencies: L
- Underspecified Items: M
```

## Next Actions Decision Logic

### Decision Tree

```
IF Critical Issues > 0:
  Status: 🔴 STOP - Must Resolve Critical Issues
  Actions:
    - List all critical issues with fix commands
    - Block implementation until resolved
    - Suggest re-running analysis after fixes

ELSE IF High Issues > 0:
  Status: 🟠 PROCEED WITH CAUTION
  Actions:
    - List high priority issues
    - Suggest fixing before implementation
    - Allow proceeding if justified
    - Recommend re-analysis after fixes

ELSE IF Medium Issues > 0:
  Status: 🟡 PROCEED - Minor Issues Noted
  Actions:
    - List medium priority issues
    - Note as improvements, not blockers
    - Can defer to later phases
    - Optional re-analysis

ELSE:
  Status: ✅ CLEAR TO PROCEED
  Actions:
    - Congratulate on clean analysis
    - Show coverage metrics
    - Suggest starting implementation
    - Provide /phoenix.implement command
```

### Next Actions Template

```markdown
## Next Actions

**Status**: [Icon + Status Message]

### Immediate Actions Required (CRITICAL)

1. **[Issue Title]** (CRITICAL)
   - **Location**: [file:line]
   - **Issue**: [Description]
   - **Action**: [Specific fix]
   - **Command**: [Suggested command or manual edit]

2. **[Issue Title]** (CRITICAL)
   - ...

### Recommended Actions (HIGH)

1. **[Issue Title]** (HIGH)
   - **Location**: [file:line]
   - **Issue**: [Description]
   - **Action**: [Specific fix]

### Optional Improvements (MEDIUM/LOW)

- [Brief list of medium/low issues that can be deferred]

### After Fixes

1. Re-run consistency analysis to verify resolution
2. Proceed to implementation: `/phoenix.implement`
3. Monitor for new issues during development
```

## Remediation Suggestions

When user requests remediation suggestions, provide structured guidance:

### Suggestion Format

```markdown
## Remediation Suggestions for Top Issues

### Issue A1: Ambiguous Performance Requirement

**Location**: `spec.md:L78`

**Current Text**:
```
System must be fast
```

**Suggested Change**:
```
API response time targets:
- p95 latency: < 200ms
- p99 latency: < 500ms
- Throughput: 1000 requests/second
```

**Rationale**: Provides measurable, testable performance criteria that can be validated

---

### Issue D1: Duplicate Requirements

**Locations**: `spec.md:L45`, `spec.md:L120`

**Current Text**:
- L45: "User can authenticate with email and password"
- L120: "System supports email/password login"

**Suggested Change**:
Keep L45, remove L120 (consolidate)

**Rationale**: Same functionality, consolidation reduces ambiguity

---

### Issue C1: Missing Coverage for Encryption

**Location**: `spec.md:L56` (requirement), `tasks.md` (add tasks)

**Current**: No tasks implement "Data encryption at rest" requirement

**Suggested Tasks to Add**:
```markdown
### Phase 1: Security

- [ ] T-SEC-001: Implement AES-256 encryption for user data [P]
  - Encrypt sensitive fields in User and Payment tables
  - Use environment variable for encryption key
  - Add key rotation mechanism

- [ ] T-SEC-002: Add encryption unit tests
  - Test encryption/decryption roundtrip
  - Test key rotation
  - Test encrypted data storage
```

**Rationale**: Security requirement must have implementation tasks
```

## Common Patterns and Heuristics

### Pattern: Technology Stack Mismatch

**Detection**:
- Extract technology mentions: frameworks, databases, languages
- Compare spec vs design vs architecture.md
- Flag any conflicts

**Severity**: CRITICAL (blocks implementation)

**Remediation**: Align all documents on single technology choice

### Pattern: Missing Error Handling

**Detection**:
- Find actions: "upload", "call API", "process", "submit"
- Check if error scenarios specified
- Flag if missing

**Severity**: MEDIUM to HIGH (depending on action criticality)

**Remediation**: Add error handling requirements and tasks

### Pattern: Vague Non-Functional Requirements

**Detection**:
- Find NFRs: performance, security, scalability, availability
- Check for measurable criteria
- Flag if subjective or vague

**Severity**: HIGH

**Remediation**: Add specific, measurable targets

### Pattern: Task Without Requirement

**Detection**:
- Extract task descriptions
- Try to map to requirements
- Flag if no mapping found

**Severity**: MEDIUM

**Remediation**: Either add requirement or justify task (refactoring, tooling)

### Pattern: Terminology Drift

**Detection**:
- Build term frequency map across documents
- Identify synonyms (similar context, different terms)
- Flag inconsistencies

**Severity**: MEDIUM

**Remediation**: Choose canonical term, update all references
