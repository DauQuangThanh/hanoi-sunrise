---
name: bug-analysis
description: Systematically analyzes bugs, creates structured bug reports, identifies root causes, and proposes solutions with risk assessment. Use when investigating errors, debugging application issues, analyzing crashes, documenting failures, or when user mentions bugs, errors, crashes, debugging, failures, or broken functionality. Does not implement fixes.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "2.1"
  last_updated: "2026-02-05"
---

# Bug Analysis Skill

## Overview

This skill provides systematic approaches for analyzing bugs, documenting issues, identifying root causes, and proposing solutions. It helps create comprehensive bug reports and guides through structured debugging workflows.

## When to Use

- User reports a bug or unexpected behavior
- Application crashes or throws errors
- Intermittent or hard-to-reproduce issues
- Need to investigate system failures
- User mentions: "bug", "error", "crash", "doesn't work", "broken", "failure"
- Performance degradation or resource issues
- Integration or compatibility problems
- **Focus**: Analysis, documentation, and solution proposal (not implementation)

## Prerequisites

- Access to application logs
- Ability to reproduce the issue (when possible)
- Version control system (git) for tracking changes
- Basic understanding of the application architecture

## Instructions

### Step 1: Initial Bug Triage

1. **Gather Initial Information**
   - What is the expected behavior?
   - What is the actual behavior?
   - When did the issue first appear?
   - How frequently does it occur?

2. **Classify Severity**
   - **Critical**: System crash, data loss, security vulnerability
   - **High**: Major feature broken, significant impact
   - **Medium**: Feature partially broken, workaround available
   - **Low**: Minor issue, cosmetic problem

3. **Document Environment**
   - Operating system and version
   - Application version
   - Browser/runtime version (if applicable)
   - Dependencies and their versions

### Step 2: Reproduce the Issue

1. **Create Reproduction Steps**
   - List exact steps to trigger the bug
   - Note any specific conditions required
   - Identify minimum reproduction case

2. **Verify Consistency**
   - Test on different environments
   - Try with different data sets
   - Check for timing-related issues

3. **Document Reproduction Rate**
   - Always reproducible?
   - Intermittent (percentage)?
   - Specific conditions only?

### Step 3: Analyze Root Cause

1. **Review Error Messages**
   - Examine stack traces
   - Check error logs
   - Look for exception details

2. **Investigate Code Changes**
   - When was it last working?
   - What changed between working and broken states?
   - Review recent commits using git

3. **Identify Affected Components**
   - Which modules/files are involved?
   - Are there shared dependencies?
   - Is it frontend, backend, or integration?

4. **Check Common Causes**
   - Null/undefined values
   - Race conditions
   - Memory leaks
   - Incorrect assumptions
   - Edge cases not handled

### Step 4: Document Findings

1. **Create Bug Report**
   - Use the bug report template (see templates/)
   - Include all reproduction steps
   - Attach relevant logs/screenshots
   - Document the root cause analysis

2. **Add Technical Details**
   - Stack traces
   - Relevant code snippets
   - Configuration details
   - Environment specifications

### Step 5: Propose Solutions

1. **Identify Fix Options**
   - Quick fix vs. proper solution
   - Workaround availability
   - Impact on other components

2. **Assess Risk**
   - Breaking changes?
   - Side effects?
   - Testing requirements

3. **Prioritize Solutions**
   - Urgency vs. complexity
   - Resource availability
   - Long-term maintainability

## Examples

### Example 1: Application Crash

**Input:**

```
User reports: "App crashes when clicking Submit button on the contact form"
```

**Analysis Process:**

1. Reproduce: Click Submit on contact form → App crashes
2. Check console: `TypeError: Cannot read property 'email' of undefined`
3. Review code: Form validation assumes `user` object exists
4. Root cause: User object not initialized when not logged in
5. Solution: Add null check before accessing user properties

**Output:**

- Bug report created in `specs/bugs/001-contact-form-crash.md`
- Root cause: Missing null check
- Fix: Add `if (user && user.email)` guard clause
- Priority: High (blocks core functionality)

### Example 2: Performance Degradation

**Input:**

```
"Application has become slow over the past week, page loads take 5+ seconds"
```

**Analysis Process:**

1. Check performance metrics: Database queries increased 10x
2. Review recent changes: New feature added with N+1 query problem
3. Profile database: Identify inefficient queries
4. Root cause: Missing eager loading for related data
5. Solution: Add `.includes()` to load related records in single query

**Output:**

- Performance analysis in `specs/bugs/002-slow-page-load.md`
- Root cause: N+1 query problem
- Fix: Optimize database queries with eager loading
- Priority: High (impacts all users)

## Edge Cases

### Intermittent Issues

If bug cannot be consistently reproduced:

1. Document all attempted reproduction methods
2. Add logging/instrumentation to capture more data
3. Monitor for patterns (time of day, specific users, etc.)
4. Consider race conditions or timing-dependent bugs

### Environment-Specific Bugs

If bug only occurs in specific environments:

1. Compare environment configurations
2. Check for version mismatches
3. Review environment variables
4. Test in staging environment

### Legacy Code Issues

If bug is in undocumented legacy code:

1. Start by understanding the intended behavior
2. Add tests to document current behavior
3. Carefully analyze dependencies
4. Consider refactoring alongside bug fix

## Best Practices

1. **Always document your analysis** - Create detailed bug reports for future reference
2. **Test the fix thoroughly** - Ensure no regression and cover edge cases
3. **Update tests** - Add test cases for the bug to prevent recurrence
4. **Communicate status** - Keep stakeholders informed throughout the process
5. **Learn from bugs** - Update documentation and share learnings with the team
6. **Prioritize correctly** - Balance urgency with proper investigation time
7. **Version control** - Use git bisect for finding when bugs were introduced

## Error Handling

### Cannot Reproduce Bug

1. Request more information from reporter:
   - Detailed steps
   - Screenshots/screen recordings
   - Browser console logs
   - Network tab information

2. Try different approaches:
   - Different user accounts
   - Different data sets
   - Clear cache/cookies
   - Incognito/private mode

### Unclear Root Cause

1. Add instrumentation:
   - Console logging
   - Debugging breakpoints
   - Performance profiling

2. Simplify the problem:
   - Create minimal reproduction
   - Remove unrelated code
   - Isolate the issue

3. Seek expert help:
   - Consult with domain experts
   - Review with senior developers
   - Check community forums

## Scripts

This skill includes Python automation scripts for bug analysis tasks.

### Generate Bug Report

Creates a new bug report from the template.

**Usage:**

```bash
python3 scripts/create_bug_report.py <bug_id> <title>
```

**Example:**

```bash
python3 scripts/create_bug_report.py 001 "Contact form crashes on submit"
```

### Analyze Git History

Analyzes git history and blame information for a specific file.

**Usage:**

```bash
python3 scripts/analyze_git_history.py <file_path> [--limit <number>]
```

**Example:**

```bash
python3 scripts/analyze_git_history.py src/components/ContactForm.tsx --limit 5
```

## Additional Resources

- See `templates/bug-report-template.md` for structured bug report format
- See `templates/root-cause-analysis-template.md` for RCA documentation
- See `references/debugging-checklist.md` for systematic debugging approach
