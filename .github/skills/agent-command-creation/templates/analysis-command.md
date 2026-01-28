---
description: "Analyze codebase for specific aspects and generate detailed report"
---

# Analysis Command Template

## Purpose

Perform comprehensive analysis of a specific aspect in the codebase (security, performance, quality, etc.).

## Context

- Target files/directories: $ARGUMENTS
- Project conventions in: docs/conventions.md
- Existing patterns in relevant codebase sections
- Analysis focus: [security/performance/quality/etc.]

## Instructions

### Phase 1: Discovery

1. Scan the specified files/directories
2. Identify current patterns and practices
3. Document existing approaches
4. Collect relevant metrics

### Phase 2: Analysis

1. Evaluate each instance against best practices
2. Identify issues, anti-patterns, or violations
3. Assess severity levels:
   - **Critical**: Immediate security/stability risks
   - **High**: Significant impact on quality/performance
   - **Medium**: Moderate improvements needed
   - **Low**: Minor optimizations or suggestions
4. Document specific examples with file locations

### Phase 3: Impact Assessment

1. Analyze potential consequences of identified issues
2. Estimate remediation effort (time/complexity)
3. Prioritize findings by severity and impact
4. Consider dependencies and side effects

### Phase 4: Recommendations

1. Provide specific, actionable remediation steps
2. Suggest preventive measures
3. Recommend tools or processes for ongoing monitoring
4. Include code examples where applicable

## Output Format

Create `analysis-[aspect]-[YYYY-MM-DD].md` with:

```markdown
# [Aspect] Analysis Report

**Generated**: [Date]
**Scope**: [Files/directories analyzed]
**Total Issues**: X

## Executive Summary

Brief overview of findings and key recommendations.

## Severity Breakdown

- Critical: X
- High: X
- Medium: X
- Low: X

## Detailed Findings

### Critical Issues

#### [Issue Title]

- **Severity**: Critical
- **Location**: [file:line]
- **Description**: Clear explanation of the issue
- **Impact**: Business and technical consequences
- **Evidence**:
  ```[language]
  [code snippet showing the issue]
  ```

- **Remediation**:
  1. Specific step-by-step fix
  2. Expected outcome
  3. Testing approach
- **Effort**: [Low/Medium/High]

[Repeat for each critical issue]

### High Priority Issues

[Same structure as critical]

### Medium Priority Issues

[Same structure as critical]

### Low Priority Suggestions

[Same structure as critical]

## Metrics

- Files analyzed: X
- Lines of code: X
- Coverage: X%
- Technical debt: X hours

## Recommendations

### Immediate Actions (Critical)

1. [Action item with timeline]
2. [Action item with timeline]

### Short-term Improvements (High)

1. [Action item with timeline]
2. [Action item with timeline]

### Long-term Enhancements (Medium/Low)

1. [Action item]
2. [Action item]

## Preventive Measures

- Process improvements
- Tool recommendations
- Training needs
- Documentation updates

## References

- [Link to standards/guidelines]
- [Related documentation]

```

## Validation Checklist

Before delivering the analysis:

- [ ] All specified files/directories analyzed
- [ ] Issues categorized by severity
- [ ] Specific file locations provided
- [ ] Code examples included
- [ ] Remediation steps are actionable
- [ ] Impact assessment completed
- [ ] Prioritization is clear
- [ ] Metrics are accurate
- [ ] Report is well-formatted

## Examples

### Example 1: Security Analysis

**Input**: `/analyze-security src/auth`

**Output**: Security analysis report identifying vulnerabilities in authentication module with remediation steps.

### Example 2: Performance Analysis

**Input**: `/analyze-performance src/api`

**Output**: Performance analysis report with bottlenecks, optimization opportunities, and implementation guidance.

### Example 3: Code Quality Analysis

**Input**: `/analyze-quality src/`

**Output**: Comprehensive code quality report covering maintainability, complexity, duplication, and best practices adherence.
