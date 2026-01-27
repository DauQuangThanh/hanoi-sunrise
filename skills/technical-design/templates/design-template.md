# Implementation Plan: [Feature Name]

**Date**: [YYYY-MM-DD]  
**Author**: [Name/Team]  
**Status**: Draft | In Review | Approved  
**Branch**: [feature-branch-name]

---

## Executive Summary

[Brief 2-3 sentence overview of what this feature does and why it's being implemented]

**Key Deliverables**:

- [ ] Design document
- [ ] Research findings
- [ ] Data models
- [ ] API contracts
- [ ] Quickstart guide

**Timeline Estimate**: [X weeks/days]

---

## 1. Feature Context

### 1.1 Feature Specification

**Location**: [Path to feature spec or requirements document]

**Summary**: [Brief summary of the feature requirements]

**Functional Requirements**:

1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

**Non-Functional Requirements**:

- **Performance**: [Performance criteria]
- **Security**: [Security requirements]
- **Scalability**: [Scalability needs]
- **Availability**: [Availability requirements]

### 1.2 User Stories / Use Cases

1. **[User Story 1]**
   - As a [role]
   - I want to [action]
   - So that [benefit]
   - Acceptance Criteria: [criteria]

2. **[User Story 2]**
   - As a [role]
   - I want to [action]
   - So that [benefit]
   - Acceptance Criteria: [criteria]

---

## 2. Technical Context

### 2.1 Current System Overview

**Existing Architecture**: [Brief description or reference to architecture.md]

**Technology Stack**:

- Frontend: [technologies]
- Backend: [technologies]
- Database: [technologies]
- Infrastructure: [technologies]

**Integration Points**: [List systems this feature will integrate with]

### 2.2 Technical Requirements Analysis

**Known Technical Details**:

- [Technical detail 1]
- [Technical detail 2]

**Areas Requiring Clarification**:

- **NEEDS CLARIFICATION**: [Unknown 1]
- **NEEDS CLARIFICATION**: [Unknown 2]
- **NEEDS CLARIFICATION**: [Unknown 3]

**Dependencies**:

- [External library/service 1]
- [Internal system/module 1]

**Constraints**:

- [Constraint 1: e.g., must use existing auth system]
- [Constraint 2: e.g., response time < 200ms]

---

## 3. Ground-Rules Check

### 3.1 Applicable Ground Rules

**From**: `docs/ground-rules.md`

| Ground Rule | Compliance Status | Notes |
|-------------|------------------|-------|
| [Rule 1] | ✅ Compliant / ⚠️ Exception Needed / ❌ Violation | [Explanation] |
| [Rule 2] | ✅ Compliant / ⚠️ Exception Needed / ❌ Violation | [Explanation] |
| [Rule 3] | ✅ Compliant / ⚠️ Exception Needed / ❌ Violation | [Explanation] |

### 3.2 Exception Requests

**[Exception 1]** (if needed):

- **Ground Rule**: [Rule being violated]
- **Justification**: [Why exception is necessary]
- **Mitigation**: [How risks will be mitigated]
- **Approval**: [Pending/Approved by X]

---

## 4. Architecture Alignment

**Reference**: `docs/architecture.md` (if exists)

### 4.1 Relevant Architectural Patterns

- **Pattern 1**: [Pattern name] - [How it applies to this feature]
- **Pattern 2**: [Pattern name] - [How it applies to this feature]

### 4.2 Architecture Decision Records (ADRs)

| ADR | Decision | Impact on This Feature |
|-----|----------|------------------------|
| [ADR-001] | [Decision summary] | [How it affects this design] |
| [ADR-002] | [Decision summary] | [How it affects this design] |

### 4.3 Consistency Check

- [ ] Follows established architectural patterns
- [ ] Compatible with technology stack
- [ ] Aligns with deployment architecture
- [ ] Consistent with data architecture
- [ ] Follows API design standards

---

## 5. Phase 0: Research & Decisions

**Status**: Not Started | In Progress | Completed

**Research Document**: `design/research/research.md`

### 5.1 Research Tasks

- [ ] [Research task 1: Resolve NEEDS CLARIFICATION item]
- [ ] [Research task 2: Investigate best practices for X]
- [ ] [Research task 3: Evaluate integration patterns]

### 5.2 Key Decisions Summary

| Decision | Chosen Option | Rationale | See Details |
|----------|---------------|-----------|-------------|
| [Decision 1] | [Option chosen] | [Brief reason] | [Link to research.md section] |
| [Decision 2] | [Option chosen] | [Brief reason] | [Link to research.md section] |

### 5.3 Technology Choices

- **[Technology/Library 1]**: [Version] - [Why chosen]
- **[Technology/Library 2]**: [Version] - [Why chosen]

**All NEEDS CLARIFICATION Resolved**: ✅ Yes / ❌ No (if No, return to research)

---

## 6. Phase 1: Data Model

**Status**: Not Started | In Progress | Completed

**Data Model Document**: `design/data-model.md`

### 6.1 Entity Summary

| Entity | Description | Key Relationships |
|--------|-------------|------------------|
| [Entity 1] | [Brief description] | [Related to Entity X, Y] |
| [Entity 2] | [Brief description] | [Related to Entity A, B] |

### 6.2 State Machines (if applicable)

**[Entity Name] States**:

- [State 1] → [State 2] (on [event])
- [State 2] → [State 3] (on [event])

### 6.3 Data Validation Rules

**[Entity 1]**:

- [Field 1]: [Validation rule]
- [Field 2]: [Validation rule]

---

## 7. Phase 1: API Contracts

**Status**: Not Started | In Progress | Completed

**Contract Location**: `design/contracts/`

### 7.1 API Endpoints Summary

| Endpoint | Method | Purpose | Contract File |
|----------|--------|---------|--------------|
| `/api/[resource]` | POST | [Purpose] | `contracts/[resource]-create.yaml` |
| `/api/[resource]` | GET | [Purpose] | `contracts/[resource]-list.yaml` |
| `/api/[resource]/:id` | GET | [Purpose] | `contracts/[resource]-get.yaml` |
| `/api/[resource]/:id` | PUT | [Purpose] | `contracts/[resource]-update.yaml` |
| `/api/[resource]/:id` | DELETE | [Purpose] | `contracts/[resource]-delete.yaml` |

### 7.2 Authentication & Authorization

- **Authentication Method**: [JWT / OAuth / API Key / etc.]
- **Authorization Model**: [RBAC / ABAC / etc.]
- **Required Permissions**: [List permissions needed]

### 7.3 Error Handling Strategy

| Error Scenario | HTTP Status | Error Code | Response Format |
|----------------|-------------|------------|-----------------|
| [Scenario 1] | [Status] | [Code] | [Format] |
| [Scenario 2] | [Status] | [Code] | [Format] |

---

## 8. Implementation Approach

**Quickstart Guide**: `design/quickstart.md`

### 8.1 High-Level Steps

1. [Step 1: e.g., Set up database schema]
2. [Step 2: e.g., Implement core business logic]
3. [Step 3: e.g., Create API endpoints]
4. [Step 4: e.g., Add authentication/authorization]
5. [Step 5: e.g., Implement frontend components]

### 8.2 Key Files/Modules to Create

- `[path/to/module1]` - [Purpose]
- `[path/to/module2]` - [Purpose]
- `[path/to/module3]` - [Purpose]

### 8.3 Key Files/Modules to Modify

- `[path/to/existing-file1]` - [What changes needed]
- `[path/to/existing-file2]` - [What changes needed]

### 8.4 Testing Strategy

**Unit Tests**:

- [Test category 1]
- [Test category 2]

**Integration Tests**:

- [Test scenario 1]
- [Test scenario 2]

**E2E Tests**:

- [User flow 1]
- [User flow 2]

---

## 9. Risk Assessment

| Risk | Probability | Impact | Mitigation Strategy |
|------|-------------|--------|---------------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [How to mitigate] |
| [Risk 2] | High/Med/Low | High/Med/Low | [How to mitigate] |

---

## 10. Open Questions

- [ ] **[Question 1]**: [Details] - Assigned to: [Name] - Due: [Date]
- [ ] **[Question 2]**: [Details] - Assigned to: [Name] - Due: [Date]

---

## 11. Design Review Notes

**Reviewers**: [Names]  
**Review Date**: [Date]

**Feedback**:

1. [Feedback item 1]
2. [Feedback item 2]

**Action Items**:

- [ ] [Action 1]
- [ ] [Action 2]

---

## 12. Approval

- [ ] Technical Lead: [Name] - Date: [Date]
- [ ] Architecture Review: [Name] - Date: [Date]
- [ ] Security Review (if needed): [Name] - Date: [Date]

**Status**: ✅ Approved / ⚠️ Conditionally Approved / ❌ Changes Required

---

## 13. Related Documents

- Feature Specification: [Link]
- Architecture Documentation: [Link to architecture.md]
- Ground Rules: [Link to ground-rules.md]
- Research Findings: [Link to research.md]
- Data Model: [Link to data-model.md]
- API Contracts: [Link to contracts/]
- Quickstart Guide: [Link to quickstart.md]

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| [Date] | 1.0 | [Name] | Initial draft |
| [Date] | 1.1 | [Name] | [Changes] |
