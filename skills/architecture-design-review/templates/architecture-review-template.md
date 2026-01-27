# Architecture Review Report

> **Review Date**: [YYYY-MM-DD]  
> **Architecture Document**: docs/architecture.md  
> **Reviewer**: [Name or AI Agent]  
> **Document Version**: [Version or Git Commit]

## Executive Summary

**Overall Completeness**: [X]% (Y of Z required sections present)  
**Overall Quality**: [Excellent / Good / Fair / Poor]  
**Critical Issues**: [N]  
**High Priority Recommendations**: [N]  
**Medium Priority Recommendations**: [N]  
**Low Priority Recommendations**: [N]

**Compliance Status**:

- Ground Rules Alignment: [Pass / Fail / N/A]
- Requirements Coverage: [Pass / Fail / N/A]
- C4 Model Completeness: [Pass / Fail]
- ADR Quality: [Pass / Fail]

**Key Findings**:

1. [Major finding #1]
2. [Major finding #2]
3. [Major finding #3]

---

## Review Scope

**Documents Reviewed**:

- `docs/architecture.md`
- `docs/adr/*.md` ([N] ADRs)
- `docs/ground-rules.md` [Yes / No]
- `specs/*/spec.md` ([N] specifications)
- Other: [List any other documents]

**Review Focus Areas**:

- [x] Document Completeness
- [x] C4 Model Validation
- [x] Architecture Decision Records (ADRs)
- [x] Quality Attributes & Strategies
- [x] Deployment Architecture
- [x] Alignment with Ground Rules
- [x] Alignment with Requirements
- [x] Risk Management

---

## Detailed Findings

### 1. Document Completeness

**Status**: [Complete / Incomplete / Partially Complete]

**Required Sections Present**:

- [ ] Executive Summary
- [ ] Stakeholders
- [ ] Architectural Drivers
- [ ] System Context View (C4 Level 1)
- [ ] Container View (C4 Level 2)
- [ ] Component View (C4 Level 3)
- [ ] Code View (C4 Level 4)
- [ ] Deployment View
- [ ] Architecture Decision Records
- [ ] Quality Attributes
- [ ] Risks & Technical Debt
- [ ] Appendices

**Missing Sections**: [List any missing sections]

**Findings**:

- [Finding 1]: [Description and impact]
- [Finding 2]: [Description and impact]

**Recommendations**:

- [Priority] [Action item for missing or incomplete sections]

---

### 2. C4 Model Validation

**Status**: [Complete / Incomplete / Invalid]

#### System Context Diagram (Level 1)

**Present**: [Yes / No]  
**Renders Correctly**: [Yes / No]

**Findings**:

- [ ] All user types from specifications are represented
- [ ] All external systems identified
- [ ] System boundaries are clear
- [ ] Relationships show direction and purpose

**Issues**:

- [Issue 1]: [Description]
- [Issue 2]: [Description]

**Recommendations**:

- [Priority] [Specific improvement]

#### Container Diagram (Level 2)

**Present**: [Yes / No]  
**Renders Correctly**: [Yes / No]

**Findings**:

- [ ] All technical containers identified
- [ ] Technology stack specified for each container
- [ ] Inter-container communication protocols defined
- [ ] Container responsibilities are clear

**Issues**:

**Recommendations**:

- [Priority] [Specific improvement]

#### Component Diagram (Level 3)

**Present**: [Yes / No]  
**Renders Correctly**: [Yes / No]

**Findings**:

- [ ] Critical containers broken down into components
- [ ] Component responsibilities defined
- [ ] Component interfaces documented
- [ ] Interaction patterns shown

**Issues**:

**Recommendations**:

- [Priority] [Specific improvement]

#### Code View (Level 4)

**Present**: [Yes / No / Partial]

**Findings**:

- [ ] Directory structure documented
- [ ] Naming conventions defined
- [ ] Key design patterns listed
- [ ] Code organization principles clear

**Issues**:

**Recommendations**:

- [Priority] [Specific improvement]

**Diagram Quality Summary**:

- Total Diagrams Expected: [N]
- Total Diagrams Present: [N]
- Diagrams Rendering Correctly: [N]
- Diagrams with Syntax Errors: [N]

---

### 3. Architecture Decision Records (ADRs)

**ADRs Found**: [N]  
**Expected Minimum**: 3-5  
**Status**: [Sufficient / Insufficient]

**ADR Quality Checklist**:

For each ADR, evaluate:

- [ ] Title is clear and descriptive
- [ ] Status is specified
- [ ] Context describes the problem
- [ ] Decision is explicit
- [ ] Rationale explains why
- [ ] Consequences are documented
- [ ] Alternatives are listed

**ADR Inventory**:

| ADR# | Title | Status | Quality |
|------|-------|--------|---------|
| 001 | [Title] | [Accepted/Proposed/etc.] | [Good/Fair/Poor] |
| 002 | [Title] | [Status] | [Quality] |
| ... | ... | ... | ... |

**Critical Decisions Covered**:

- [ ] Architecture style (monolith, microservices, etc.)
- [ ] Database choice and data architecture
- [ ] API design and communication patterns
- [ ] Deployment strategy
- [ ] Security architecture
- [ ] Frontend technology and architecture

**Missing Critical ADRs**:

- [Decision area that should have an ADR but doesn't]

**Findings**:

- [Finding 1]: [Description of ADR quality issue]
- [Finding 2]: [Description]

**Recommendations**:

- [Priority] [Specific ADR to add or improve]

---

### 4. Quality Attributes & Strategies

**Status**: [Well-Defined / Partially Defined / Poorly Defined]

#### Quality Attribute Requirements

**Performance**:

- [ ] Specific, measurable targets defined
- [ ] Response time requirements: [Specified / Not Specified]
- [ ] Throughput requirements: [Specified / Not Specified]

**Scalability**:

- [ ] Growth targets defined
- [ ] Scaling dimensions identified (users, data, transactions)

**Availability**:

- [ ] Uptime target specified (e.g., 99.9%)
- [ ] SLA defined

**Security**:

- [ ] Threat model documented
- [ ] Security requirements specified

**Maintainability**:

- [ ] Code quality standards defined
- [ ] Testing requirements specified

**Reliability**:

- [ ] MTBF/MTTR targets defined
- [ ] Error handling strategy documented

**Usability**:

- [ ] UX requirements specified
- [ ] Accessibility standards referenced

#### Quality Strategies

**Findings**:

- [ ] Each quality attribute has mapped strategies
- [ ] Strategies are specific and actionable
- [ ] Trade-offs are acknowledged
- [ ] Implementation approach is clear

**Issues**:

- [Issue 1]: [Quality attribute without strategy]
- [Issue 2]: [Vague or unmeasurable requirement]

**Recommendations**:

- [Priority] [Specific improvement to quality attributes or strategies]

---

### 5. Deployment Architecture

**Status**: [Complete / Incomplete / Unclear]

**Deployment Design Checklist**:

- [ ] Production topology defined (multi-region, multi-AZ, single)
- [ ] Infrastructure components specified (compute, storage, networking)
- [ ] Deployment diagram present and renders correctly
- [ ] CI/CD pipeline documented
- [ ] Deployment strategy defined (blue/green, canary, rolling)
- [ ] Infrastructure as Code approach documented
- [ ] Disaster recovery strategy defined (backup, RTO, RPO)
- [ ] Monitoring and observability approach defined

**Findings**:

- [Finding 1]: [Description]

**Recommendations**:

- [Priority] [Specific improvement to deployment architecture]

---

### 6. Alignment & Consistency

#### Ground Rules Alignment

**Ground Rules Document Found**: [Yes / No]

**Findings**:

- [ ] Technical constraints are respected
- [ ] Organizational constraints are addressed
- [ ] Technology choices comply with approved stack
- [ ] Violations are explicitly justified

**Issues**:

- [Issue 1]: [Constraint violation or misalignment]

**Compliance Status**: [Pass / Fail / N/A]

#### Requirements Alignment

**Feature Specifications Found**: [N]

**Findings**:

- [ ] Architecture addresses all feature requirements
- [ ] User stories are traceable to components
- [ ] Non-functional requirements are addressed
- [ ] Integration requirements are covered

**Issues**:

- [Issue 1]: [Requirement not addressed]
- [Issue 2]: [Component without requirement traceability]

**Coverage Status**: [Complete / Partial / Insufficient]

#### Internal Consistency

**Findings**:

- [ ] No conflicting statements across sections
- [ ] Terminology used consistently
- [ ] Diagram elements match textual descriptions
- [ ] Cross-references are accurate

**Issues**:

- [Issue 1]: [Inconsistency or conflict]

**Recommendations**:

- [Priority] [Specific alignment improvement]

---

### 7. Risk Management & Technical Debt

**Status**: [Well-Documented / Partially Documented / Not Documented]

#### Architecture Risks

**Risks Identified**: [N]

**Risk Assessment Checklist**:

- [ ] Architecture risks are listed
- [ ] Probability and impact assessed for each
- [ ] Mitigation strategies defined

**Findings**:

- [Finding 1]: [Description of risk management issue]

#### Technical Debt

**Technical Debt Items**: [N]

**Findings**:

- [ ] Known debt is documented
- [ ] Remediation plans exist
- [ ] Priority assigned to debt items

**Open Questions**: [N]

**Future Considerations**: [Documented / Not Documented]

**Recommendations**:

- [Priority] [Specific improvement to risk or debt documentation]

---

## Prioritized Recommendations

### Critical (Must Address)

1. **[Recommendation Title]**
   - **Finding**: [What's wrong or missing]
   - **Impact**: [Why this matters]
   - **Action**: [Specific steps to resolve]
   - **Section**: [Where in architecture.md]

2. **[Recommendation Title]**
   - **Finding**: [Description]
   - **Impact**: [Impact description]
   - **Action**: [Specific action]
   - **Section**: [Section reference]

### High Priority (Should Address)

1. **[Recommendation Title]**
   - **Finding**: [Description]
   - **Impact**: [Impact description]
   - **Action**: [Specific action]
   - **Section**: [Section reference]

### Medium Priority (Good to Address)

1. **[Recommendation Title]**
   - **Finding**: [Description]
   - **Impact**: [Impact description]
   - **Action**: [Specific action]
   - **Section**: [Section reference]

### Low Priority (Nice to Have)

1. **[Recommendation Title]**
   - **Finding**: [Description]
   - **Impact**: [Impact description]
   - **Action**: [Specific action]
   - **Section**: [Section reference]

---

## Action Items

| Priority | Action | Section | Effort | Assignee |
|----------|--------|---------|--------|----------|
| Critical | [Action description] | [Section] | [S/M/L] | [TBD] |
| High | [Action description] | [Section] | [S/M/L] | [TBD] |
| Medium | [Action description] | [Section] | [S/M/L] | [TBD] |
| Low | [Action description] | [Section] | [S/M/L] | [TBD] |

**Effort Estimates**: S = Small (< 1 day), M = Medium (1-3 days), L = Large (> 3 days)

---

## Conclusion

**Overall Assessment**: [Summary paragraph of architecture quality]

**Strengths**:

- [Strength 1]
- [Strength 2]
- [Strength 3]

**Areas for Improvement**:

- [Area 1]
- [Area 2]
- [Area 3]

**Recommended Next Steps**:

1. [Step 1]
2. [Step 2]
3. [Step 3]

**Approval Status**: [Approved / Approved with Conditions / Revisions Required]

---

## Appendix

### Review Methodology

This review was conducted following the architecture-design-review skill guidelines, evaluating:

- Document completeness against required sections
- C4 model diagrams for correctness and completeness
- ADRs for quality and coverage of critical decisions
- Quality attributes for specificity and measurability
- Deployment architecture for production readiness
- Alignment with ground rules and requirements
- Risk management and technical debt documentation

### Glossary

[Any terms or abbreviations used in the review]

### References

- [Architecture document path]
- [Ground rules document path]
- [Feature specifications paths]
- [Related documents]

---

*Review generated by architecture-design-review skill*
