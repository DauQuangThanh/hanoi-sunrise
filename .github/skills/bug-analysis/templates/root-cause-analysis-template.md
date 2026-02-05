# Root Cause Analysis: [Issue Title]

**RCA ID:** RCA-[ID]  
**Related Bug:** [BUG-ID]  
**Date:** YYYY-MM-DD  
**Analyst:** [Name]  
**Severity:** Critical | High | Medium | Low

---

## Executive Summary

[2-3 sentence summary of the issue, root cause, and resolution]

---

## Incident Timeline

| Time (UTC) | Event |
|------------|-------|
| YYYY-MM-DD HH:MM | Issue first reported |
| YYYY-MM-DD HH:MM | Investigation started |
| YYYY-MM-DD HH:MM | Root cause identified |
| YYYY-MM-DD HH:MM | Fix implemented |
| YYYY-MM-DD HH:MM | Issue resolved |

**Total Duration:** [XX hours/days]

---

## Problem Statement

### What Happened?

[Detailed description of the problem]

### When Did It Start?

[Date and time, or "Unknown"]

### How Was It Discovered?

- [ ] User report
- [ ] Automated monitoring
- [ ] Internal testing
- [ ] Production incident
- [ ] Other: [specify]

---

## Impact Assessment

### Users Affected

- **Number:** [Count or percentage]
- **Segments:** [Which user groups]
- **Duration:** [How long were they affected]

### Business Impact

- **Revenue:** [Dollar impact if applicable]
- **Operations:** [Operational disruption]
- **Reputation:** [Customer satisfaction impact]

### Technical Impact

- **Systems Affected:** [List systems/services]
- **Data Integrity:** [Any data corruption or loss]
- **Performance:** [System degradation metrics]

---

## The Five Whys Analysis

### Why did the problem occur?

**Why #1:** [First level cause]

**Why #2:** [Deeper cause]

**Why #3:** [Even deeper cause]

**Why #4:** [Root cause emerging]

**Why #5:** [Fundamental root cause]

---

## Root Cause

### Primary Root Cause

[The fundamental reason the issue occurred]

**Category:**

- [ ] Code defect
- [ ] Configuration error
- [ ] Infrastructure issue
- [ ] Process failure
- [ ] Human error
- [ ] External dependency
- [ ] Design flaw

### Contributing Factors

1. [Factor 1]
2. [Factor 2]
3. [Factor 3]

### Why Wasn't This Caught Earlier?

- **Testing gaps:** [What tests were missing]
- **Monitoring gaps:** [What monitoring was missing]
- **Review gaps:** [What review processes failed]

---

## Technical Deep Dive

### System Architecture

```
[Diagram or description of affected system components]
```

### Code Analysis

**Problematic Code:**

```language
[Paste the buggy code]
```

**Issue:** [Explain what's wrong with the code]

### Sequence of Events

1. [Event 1 leading to the issue]
2. [Event 2]
3. [Event 3]
4. [Final event that triggered the problem]

### Data Flow

```
[Diagram showing how data flows and where it broke]
```

---

## Resolution

### Immediate Fix

**What was done:**
[Description of the quick fix applied]

**When deployed:**
YYYY-MM-DD HH:MM

**Verification:**
[How the fix was verified]

### Permanent Solution

**Implementation:**
[Description of the long-term fix]

**Code changes:**

```diff
- [Old code]
+ [New code]
```

**Testing:**

- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Manual testing completed

---

## Preventive Measures

### Short-term Actions (1-2 weeks)

1. **Action:** [What to do]
   - **Owner:** [Name]
   - **Due Date:** YYYY-MM-DD
   - **Status:** Not Started | In Progress | Complete

2. **Action:** [What to do]
   - **Owner:** [Name]
   - **Due Date:** YYYY-MM-DD
   - **Status:** Not Started | In Progress | Complete

### Long-term Actions (1-3 months)

1. **Action:** [What to do]
   - **Owner:** [Name]
   - **Due Date:** YYYY-MM-DD
   - **Status:** Not Started | In Progress | Complete

2. **Action:** [What to do]
   - **Owner:** [Name]
   - **Due Date:** YYYY-MM-DD
   - **Status:** Not Started | In Progress | Complete

### Process Improvements

- **Testing:** [What testing improvements are needed]
- **Monitoring:** [What monitoring to add]
- **Documentation:** [What documentation to update]
- **Training:** [What training is needed]

---

## Lessons Learned

### What Went Well?

1. [Positive aspect 1]
2. [Positive aspect 2]

### What Could Be Improved?

1. [Improvement area 1]
2. [Improvement area 2]

### Key Takeaways

1. [Lesson 1]
2. [Lesson 2]
3. [Lesson 3]

---

## Similar Past Incidents

| Date | Issue | Similarity | Outcome |
|------|-------|------------|---------|
| YYYY-MM-DD | [Issue] | [How similar] | [How resolved] |

---

## Verification and Sign-off

### Verification Checklist

- [ ] Root cause clearly identified
- [ ] Impact fully assessed
- [ ] Immediate fix deployed and verified
- [ ] Preventive measures defined and assigned
- [ ] Documentation updated
- [ ] Stakeholders notified
- [ ] Lessons learned captured

### Approvals

- **Technical Lead:** [Name] - [Date]
- **Product Manager:** [Name] - [Date]
- **Engineering Manager:** [Name] - [Date]

---

## Attachments

- [Link to related bug reports]
- [Link to monitoring dashboards]
- [Link to code changes/PR]
- [Link to incident reports]

---

## Follow-up Review

**Review Date:** YYYY-MM-DD (30 days after resolution)

**Status of Preventive Measures:**
[Review whether all actions were completed]

**Recurrence Check:**
[Has the issue occurred again?]
