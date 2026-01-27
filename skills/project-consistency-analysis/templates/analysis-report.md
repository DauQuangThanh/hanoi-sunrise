# Project Consistency Analysis Report

**Feature:** [Feature Name]  
**Analysis Date:** [YYYY-MM-DD]  
**Analyzer:** [Analyzer Name]  
**Feature Directory:** [path/to/feature]

---

## Executive Summary

**Overall Status:** 🟢 Pass / 🟡 Issues Found / 🔴 Critical Issues

### Key Metrics

| Metric | Value | Status |
|--------|-------|--------|
| Total Requirements | X | - |
| Total Tasks | Y | - |
| Coverage Percentage | Z% | ✅ / ⚠️ / ❌ |
| Critical Issues | A | ✅ / 🔴 |
| High Issues | B | ✅ / ⚠️ |
| Medium Issues | C | ✅ / ⚠️ |
| Low Issues | D | ✅ |

### Findings Summary

- **Critical:** [X] issues - Must resolve before implementation
- **High:** [X] issues - Should resolve before implementation
- **Medium:** [X] issues - Can proceed but recommend fixes
- **Low:** [X] issues - Optional improvements

### Assessment

[Brief 2-3 sentence summary of overall artifact quality and readiness for implementation]

---

## Detailed Findings

### Findings Table

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Ambiguity | HIGH | spec.md:L78 | "System must be fast" lacks measurable criteria | Define concrete performance target (e.g., API responses < 200ms) |
| D1 | Duplication | MEDIUM | spec.md:L45, L120 | Two similar requirements for user authentication | Consolidate into single requirement, keep clearer version |
| U1 | Underspecification | HIGH | spec.md:L92 | "Handle errors" missing error types and strategies | Specify error categories, logging, and user feedback mechanisms |
| G1 | Ground-Rules | CRITICAL | design.md:L150 | Violates "MUST use TypeScript" - specifies JavaScript | Update design to use TypeScript or update ground-rules |
| C1 | Coverage Gap | CRITICAL | spec.md:L56 | No tasks implement data encryption requirement | Add encryption implementation and testing tasks to tasks.md |
| I1 | Inconsistency | HIGH | spec.md:L34 vs design.md:L78 | Technology conflict: Next.js vs Vue.js | Resolve conflict - align spec and design on single framework |

*(Continue for all findings, up to 50 rows. If more than 50, see Overflow Summary below)*

---

## Coverage Analysis

### Requirements Coverage Summary

**Coverage Rate:** [X]% ([Y] of [Z] requirements have associated tasks)

| Requirement Key | Description | Has Tasks? | Task IDs | Severity |
|----------------|-------------|------------|----------|----------|
| user-can-login | User authentication and login | ✅ | T010, T011, T012 | - |
| user-can-register | User registration and onboarding | ✅ | T013, T014 | - |
| data-encryption | Encrypt sensitive data at rest | ❌ | - | 🔴 CRITICAL |
| performance-metrics | Track system performance | ⚠️ | T045 | ⚠️ Partial |
| search-functionality | Full-text search capability | ✅ | T030, T031, T032 | - |

### Uncovered Requirements (Critical)

1. **data-encryption** (spec.md:L56)
   - **Issue:** No implementation tasks for data encryption
   - **Impact:** Security requirement not addressed
   - **Recommendation:** Add tasks for encryption library integration, key management, and testing

2. **audit-logging** (spec.md:L89)
   - **Issue:** Audit logging requirement has no associated tasks
   - **Impact:** Compliance and security tracking missing
   - **Recommendation:** Add tasks for audit log implementation and storage

### Partially Covered Requirements (High)

1. **performance-metrics** (spec.md:L134)
   - **Current Coverage:** 1 task (T045) for basic metrics
   - **Missing:** No tasks for visualization, alerting, or historical tracking
   - **Recommendation:** Add tasks for metrics dashboard and monitoring

### Unmapped Tasks (Tasks Without Requirements)

| Task ID | Description | Issue | Recommendation |
|---------|-------------|-------|----------------|
| T023 | Implement caching layer | No corresponding requirement in spec | Add performance requirement or remove task |
| T037 | Set up CI/CD pipeline | Infrastructure task not in spec | Add to non-functional requirements or tech constraints |

---

## Ground-Rules Alignment

**Ground-Rules Document:** [docs/ground-rules.md exists: Yes / No]  
**Overall Alignment:** ✅ Compliant / ⚠️ Minor Issues / 🔴 Critical Violations

### Critical Violations (All are CRITICAL severity)

1. **Principle:** "MUST use TypeScript for type safety"
   - **Location:** design.md:L150
   - **Violation:** Design specifies plain JavaScript for backend services
   - **Impact:** Type safety requirement not met
   - **Recommendation:** Update design to use TypeScript or formally update ground-rules if principle changed

2. **Principle:** "MUST include unit tests for all business logic"
   - **Location:** tasks.md (missing test tasks)
   - **Violation:** No unit test tasks for authentication module
   - **Impact:** Quality gate not satisfied
   - **Recommendation:** Add unit test tasks for all business logic modules

### Compliant Principles

- ✅ "MUST follow REST API design standards" - Compliant (design.md:L45-89)
- ✅ "MUST implement error logging" - Compliant (tasks.md:T025-T027)
- ✅ "MUST use PostgreSQL for data persistence" - Compliant (design.md:L120)

---

## Duplication Analysis

**Total Duplications Found:** [X]

### High-Priority Duplications

1. **User Authentication Requirements**
   - **Locations:** spec.md:L45-50, spec.md:L120-125
   - **Similarity:** 85%
   - **Issue:** Same authentication flow described twice with slightly different wording
   - **Recommendation:** Consolidate into single requirement in functional requirements section, remove duplicate

2. **Performance Requirements**
   - **Locations:** spec.md:L78, spec.md:L145
   - **Similarity:** 70%
   - **Issue:** Both specify "fast response times" without clear distinction
   - **Recommendation:** Merge into single non-functional requirement with specific metrics

---

## Ambiguity Analysis

**Total Ambiguities Found:** [X]

### High-Severity Ambiguities

1. **Vague Performance Criteria**
   - **Location:** spec.md:L78
   - **Issue:** "System must be fast" - no measurable criteria
   - **Terms:** "fast", "responsive", "quick"
   - **Recommendation:** Replace with: "API endpoints must respond in < 200ms for 95th percentile under normal load"

2. **Unclear Security Requirements**
   - **Location:** spec.md:L103
   - **Issue:** "System must be secure" - no specific security measures
   - **Terms:** "secure", "protected", "safe"
   - **Recommendation:** Specify: Authentication method, authorization model, data encryption, security headers, rate limiting

3. **Unresolved Placeholders**
   - **Location:** design.md:L67
   - **Issue:** "Database schema TODO" - design incomplete
   - **Recommendation:** Complete database schema before implementation

---

## Underspecification Analysis

**Total Underspecifications Found:** [X]

### Critical Underspecifications

1. **Error Handling Strategy**
   - **Location:** spec.md:L92
   - **Issue:** "System must handle errors" - missing types, strategies, user feedback
   - **Missing Details:** Error categories, logging requirements, user-facing messages, retry logic
   - **Recommendation:** Add comprehensive error handling specification

2. **Data Validation Rules**
   - **Location:** spec.md:L115
   - **Issue:** "Validate user input" - no validation rules specified
   - **Missing Details:** Required fields, format constraints, length limits, allowed characters
   - **Recommendation:** Document validation rules for each input field

---

## Inconsistency Analysis

**Total Inconsistencies Found:** [X]

### Critical Inconsistencies

1. **Technology Stack Conflict**
   - **Locations:** spec.md:L34 vs design.md:L78
   - **Issue:** Spec requires Next.js, design specifies Vue.js
   - **Impact:** Cannot proceed with conflicting frameworks
   - **Recommendation:** Align on single framework, update conflicting document

2. **Data Entity Mismatch**
   - **Locations:** spec.md:L145 (UserProfile entity) vs design.md data model (no UserProfile)
   - **Issue:** Entity referenced in requirements but not defined in design
   - **Impact:** Implementation will be missing required functionality
   - **Recommendation:** Add UserProfile entity to design data model

### High-Priority Inconsistencies

1. **Terminology Drift**
   - **Locations:** Throughout spec.md and design.md
   - **Issue:** Same concept called "User" (spec) and "Account" (design)
   - **Impact:** Confusion during implementation
   - **Recommendation:** Standardize on single term (suggest "User") across all documents

2. **Task Ordering Issue**
   - **Location:** tasks.md:T030 (integration task) before tasks.md:T015-T020 (foundational setup)
   - **Issue:** Integration task scheduled before prerequisite components exist
   - **Impact:** Cannot execute tasks in order without manual reordering
   - **Recommendation:** Move integration tasks after foundational setup or add dependency note

---

## Architecture Alignment (if docs/architecture.md exists)

**Architecture Document:** [docs/architecture.md exists: Yes / No]  
**Overall Alignment:** ✅ Compliant / ⚠️ Minor Issues / 🔴 Violations

### Architecture Violations

1. **Unapproved Technology**
   - **Location:** design.md:L89
   - **Issue:** Design uses MongoDB, but architecture.md specifies PostgreSQL only
   - **Impact:** Technology choice violates architectural decision
   - **Recommendation:** Change design to use PostgreSQL or update architecture decision record

2. **Missing Architectural Pattern**
   - **Location:** design.md (component organization)
   - **Issue:** Design doesn't follow layered architecture pattern specified in architecture.md
   - **Impact:** System structure will not match architectural vision
   - **Recommendation:** Restructure design to follow layered architecture

### Architecture Compliance

- ✅ RESTful API design follows architecture.md patterns
- ✅ Microservices boundaries respect architectural decisions
- ⚠️ Caching strategy partially follows architecture (Redis approved but not fully utilized)

---

## Standards Compliance (if docs/standards.md exists)

**Standards Document:** [docs/standards.md exists: Yes / No]  
**Overall Compliance:** ✅ Compliant / ⚠️ Minor Issues / 🔴 Violations

### Standards Violations

1. **Naming Convention Violation**
   - **Location:** tasks.md:T045 (file: UserService.js)
   - **Issue:** File should use kebab-case per standards.md (user-service.js)
   - **Impact:** Inconsistent file naming
   - **Recommendation:** Update file naming to follow kebab-case convention

2. **API Endpoint Naming**
   - **Location:** design.md:L156 (/getUserById)
   - **Issue:** Should use RESTful convention: GET /users/:id per standards.md
   - **Impact:** API design doesn't follow REST standards
   - **Recommendation:** Update endpoint naming to REST conventions

---

## Metrics Summary

### Overall Statistics

- **Total Requirements:** [X]
- **Functional Requirements:** [X]
- **Non-Functional Requirements:** [X]
- **User Stories:** [X]
- **Total Tasks:** [Y]
- **Tasks per Requirement (avg):** [Z]

### Quality Metrics

- **Coverage Rate:** [X]% (requirements with tasks)
- **Ambiguity Rate:** [X]% (ambiguous requirements)
- **Duplication Rate:** [X]% (duplicate requirements)
- **Consistency Score:** [X]% (100% - inconsistency rate)

### Severity Distribution

- **Critical:** [X] findings ([Y]%)
- **High:** [X] findings ([Y]%)
- **Medium:** [X] findings ([Y]%)
- **Low:** [X] findings ([Y]%)

---

## Overflow Summary

*Note: Analysis limited to 50 detailed findings. Additional findings summarized below:*

### Additional Ambiguities ([X] more)

- [X] requirements with vague adjectives
- [X] unresolved placeholders
- [X] subjective acceptance criteria

### Additional Duplications ([X] more)

- [X] near-duplicate requirements
- [X] repeated non-functional requirements

### Additional Minor Issues ([X] more)

- [X] style/wording improvements
- [X] optional documentation gaps
- [X] cosmetic inconsistencies

---

## Next Actions

**Status:** 🔴 Critical Issues / 🟡 Issues to Address / 🟢 Ready to Proceed

### Immediate Actions (Required Before Implementation)

**🔴 Critical Priority:**

1. **Resolve Technology Stack Conflict** (ID: I1)
   - **Action:** Align spec.md:L34 and design.md:L78 on single framework (Next.js or Vue.js)
   - **Command:** Edit conflicting document manually or run `/phoenix.specify` to refine
   - **Estimated Effort:** 30 minutes

2. **Add Missing Encryption Tasks** (ID: C1)
   - **Action:** Add implementation tasks for data encryption requirement (spec.md:L56)
   - **Command:** Edit tasks.md to add T046, T047 for encryption implementation and testing
   - **Estimated Effort:** 15 minutes

3. **Fix Ground-Rules Violation** (ID: G1)
   - **Action:** Update design.md:L150 to use TypeScript instead of JavaScript
   - **Command:** Edit design.md manually or run `/phoenix.design` to regenerate
   - **Estimated Effort:** 1 hour

### High Priority (Should Address Before Implementation)

1. **Resolve Ambiguous Requirements** (IDs: A1, A2, A3)
   - **Action:** Replace vague terms with measurable criteria
   - **Command:** Run `/phoenix.specify` with refinement focus
   - **Estimated Effort:** 2 hours

2. **Fix Task Ordering Issues** (ID: I2)
   - **Action:** Reorder tasks in tasks.md to respect dependencies
   - **Command:** Edit tasks.md manually
   - **Estimated Effort:** 30 minutes

### Medium Priority (Can Proceed But Recommend Fixes)

1. **Consolidate Duplicate Requirements** (IDs: D1, D2)
   - **Action:** Merge duplicate requirements, remove redundancy
   - **Command:** Edit spec.md to consolidate
   - **Estimated Effort:** 1 hour

2. **Standardize Terminology** (ID: I1)
   - **Action:** Use consistent terms across all documents
   - **Command:** Edit spec.md and design.md for terminology alignment
   - **Estimated Effort:** 1 hour

### Low Priority (Optional, Can Defer)

1. **Improve Wording** (IDs: L1, L2, L3)
   - **Action:** Polish language for clarity
   - **Command:** Manual edits to improve readability
   - **Estimated Effort:** 30 minutes

### Recommended Command Sequence

```bash
# 1. Fix critical issues first
# Manual edits to resolve conflicts and add missing tasks

# 2. Refine specifications
/phoenix.specify --focus ambiguity-resolution

# 3. Update design if needed
/phoenix.design --update-architecture

# 4. Re-run analysis to verify
/phoenix.analyze

# 5. Proceed with implementation when clear
/phoenix.implement
```

---

## Remediation Suggestions

### Would you like specific edit recommendations?

**Available remediation options:**

1. **Critical issues only** (3 issues) - Fastest path to implementation
2. **Critical + High issues** (8 issues) - Recommended for quality
3. **All issues** (18 issues) - Complete cleanup

**Response:** [User to select option or decline]

*Note: Remediation suggestions are provided as guidance only. This analysis is read-only and does not modify files automatically.*

---

## Analysis Metadata

**Analysis Duration:** [X] minutes  
**Artifacts Analyzed:**

- spec.md ([X] lines, [Y] requirements)
- design.md ([X] lines, [Y] sections)
- tasks.md ([X] tasks, [Y] phases)
- ground-rules.md (if available)
- architecture.md (if available)
- standards.md (if available)

**Analysis Tool:** Project Consistency Analysis Skill v1.0  
**Generated By:** [Agent/Tool Name]  
**Report Format:** Markdown

---

**Report Complete** | **Status:** [Pass / Issues / Critical] | **Next Steps:** [See Next Actions above]
