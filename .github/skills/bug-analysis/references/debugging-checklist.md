# Debugging Checklist

A systematic approach to identifying and resolving software bugs. Follow this checklist to ensure thorough debugging coverage.

---

## Phase 1: Initial Assessment

### Understand the Problem

- [ ] Read the bug report thoroughly
- [ ] Understand the expected vs. actual behavior
- [ ] Identify the severity and priority
- [ ] Note the environment (OS, browser, device, etc.)
- [ ] Check when the issue was first observed
- [ ] Determine if this is a regression or new feature bug

### Gather Context

- [ ] Review recent code changes (git log, PR history)
- [ ] Check related issues or bug reports
- [ ] Review application/system logs
- [ ] Examine error messages and stack traces
- [ ] Identify affected components/modules
- [ ] Note any patterns (time-based, user-specific, etc.)

---

## Phase 2: Reproduction

### Set Up Environment

- [ ] Match the reported environment exactly
- [ ] Use the same browser/device/OS version
- [ ] Apply the same configuration settings
- [ ] Use similar data if possible

### Reproduce the Issue

- [ ] Follow reproduction steps exactly as reported
- [ ] Document your reproduction attempt
- [ ] Try edge cases and variations
- [ ] Note the reproduction rate (100%, 50%, intermittent)
- [ ] Record any error messages or unexpected behavior
- [ ] Capture screenshots/videos if helpful

### Simplify the Reproduction

- [ ] Create a minimal reproduction case
- [ ] Remove unnecessary steps
- [ ] Isolate the problem to specific components
- [ ] Create a test case or script

---

## Phase 3: Investigation

### Code Review

- [ ] Locate the relevant code section
- [ ] Review recent changes to this code
- [ ] Check for obvious errors (typos, logic flaws)
- [ ] Review related functions/methods
- [ ] Check for proper error handling
- [ ] Verify input validation
- [ ] Look for race conditions or timing issues

### Use Debugging Tools

- [ ] Set breakpoints at key locations
- [ ] Step through code execution
- [ ] Inspect variable values at each step
- [ ] Watch expressions and conditions
- [ ] Check call stack
- [ ] Monitor memory usage
- [ ] Profile performance if relevant

### Check Dependencies

- [ ] Verify all dependencies are up to date
- [ ] Check for known issues in libraries
- [ ] Review dependency change logs
- [ ] Test with different dependency versions
- [ ] Check for conflicting dependencies

### Review Data Flow

- [ ] Trace data from input to output
- [ ] Verify data transformations
- [ ] Check database queries
- [ ] Review API calls and responses
- [ ] Validate data serialization/deserialization

---

## Phase 4: Root Cause Analysis

### Apply the 5 Whys

- [ ] Why did the problem occur? (First level)
- [ ] Why did that happen? (Second level)
- [ ] Why did that happen? (Third level)
- [ ] Why did that happen? (Fourth level)
- [ ] Why did that happen? (Root cause)

### Common Bug Patterns

**Logic Errors:**

- [ ] Off-by-one errors
- [ ] Incorrect conditional logic
- [ ] Missing edge case handling
- [ ] Improper loop conditions

**State Management:**

- [ ] Uninitialized variables
- [ ] Stale cached data
- [ ] Race conditions
- [ ] Improper state transitions

**Data Issues:**

- [ ] Type mismatches
- [ ] Null/undefined values
- [ ] Invalid data formats
- [ ] Character encoding problems

**Integration Issues:**

- [ ] API version mismatches
- [ ] Breaking changes in dependencies
- [ ] Network timeouts
- [ ] Authentication/authorization failures

**Environment Issues:**

- [ ] Configuration differences
- [ ] Missing environment variables
- [ ] File system permissions
- [ ] Resource limitations

---

## Phase 5: Solution Development

### Plan the Fix

- [ ] Identify all affected code locations
- [ ] Consider multiple solution approaches
- [ ] Evaluate pros and cons of each approach
- [ ] Choose the best approach
- [ ] Plan for backward compatibility if needed
- [ ] Consider performance implications

### Implement the Fix

- [ ] Write clean, readable code
- [ ] Follow project coding standards
- [ ] Add comments explaining the fix
- [ ] Handle edge cases
- [ ] Add proper error handling
- [ ] Update related documentation

### Write Tests

- [ ] Create a test that fails before the fix
- [ ] Verify the test passes after the fix
- [ ] Add regression tests
- [ ] Test edge cases
- [ ] Test error conditions
- [ ] Run existing test suite

---

## Phase 6: Verification

### Test the Fix

- [ ] Test the exact reproduction case
- [ ] Test related functionality
- [ ] Test edge cases
- [ ] Test in multiple environments
- [ ] Perform smoke testing
- [ ] Run automated test suite

### Performance Check

- [ ] Measure performance impact
- [ ] Check memory usage
- [ ] Verify no resource leaks
- [ ] Test under load if applicable

### Code Review

- [ ] Self-review the changes
- [ ] Request peer review
- [ ] Address review feedback
- [ ] Verify coding standards compliance

---

## Phase 7: Documentation

### Update Bug Report

- [ ] Document the root cause
- [ ] Explain the solution
- [ ] Note any workarounds
- [ ] Update status and severity
- [ ] Link to code changes/PR

### Update Documentation

- [ ] Update user documentation if needed
- [ ] Update developer documentation
- [ ] Add to troubleshooting guide if applicable
- [ ] Update changelog
- [ ] Document any configuration changes

### Knowledge Sharing

- [ ] Share lessons learned with team
- [ ] Update team wiki or knowledge base
- [ ] Document debugging techniques used
- [ ] Note any useful debugging tools discovered

---

## Phase 8: Prevention

### Identify Prevention Measures

- [ ] Determine why the bug wasn't caught earlier
- [ ] Identify gaps in testing
- [ ] Identify gaps in code review
- [ ] Identify gaps in monitoring

### Implement Safeguards

- [ ] Add automated tests
- [ ] Add validation checks
- [ ] Add logging/monitoring
- [ ] Add alerts for similar issues
- [ ] Update code review checklist
- [ ] Share patterns to avoid with team

---

## Common Debugging Techniques

### Print/Log Debugging

```python
# Example: Add logging
import logging
logging.debug(f"Variable x = {x}, y = {y}")
```

### Binary Search Debugging

- [ ] Comment out half the code
- [ ] Determine which half has the bug
- [ ] Repeat until isolated

### Rubber Duck Debugging

- [ ] Explain the problem aloud
- [ ] Walk through the code line by line
- [ ] Often reveals the issue

### Bisect Git History

```bash
# Find when bug was introduced
git bisect start
git bisect bad  # Current version has bug
git bisect good <commit>  # Known good commit
# Test each commit git bisect marks
```

### Diff Comparison

- [ ] Compare working vs. broken versions
- [ ] Review all changes between versions
- [ ] Identify suspicious changes

---

## Tools by Language/Platform

### JavaScript/TypeScript

- [ ] Chrome DevTools / Firefox DevTools
- [ ] VS Code debugger
- [ ] `console.log`, `console.table`, `debugger`
- [ ] React DevTools / Vue DevTools
- [ ] Network tab for API calls

### Python

- [ ] `pdb` (Python debugger)
- [ ] `print()` statements
- [ ] `logging` module
- [ ] `traceback` module
- [ ] VS Code debugger
- [ ] PyCharm debugger

### Java

- [ ] IntelliJ IDEA debugger
- [ ] Eclipse debugger
- [ ] `System.out.println()`
- [ ] Logging frameworks (SLF4J, Log4j)
- [ ] JVM profilers

### General Tools

- [ ] Git bisect for historical bugs
- [ ] curl/Postman for API testing
- [ ] Database clients for query testing
- [ ] Log aggregation tools (ELK, Splunk)
- [ ] APM tools (New Relic, DataDog)

---

## When You're Stuck

### Take a Break

- [ ] Step away for 15-30 minutes
- [ ] Get fresh air or coffee
- [ ] Work on something else briefly

### Get Help

- [ ] Explain the problem to a colleague
- [ ] Pair program with someone
- [ ] Post on internal team chat
- [ ] Search Stack Overflow
- [ ] Check GitHub issues
- [ ] Review documentation again

### Start Fresh

- [ ] Clear all assumptions
- [ ] Re-read the bug report
- [ ] Verify reproduction steps again
- [ ] Question your understanding

### Try Different Approaches

- [ ] Work backward from the error
- [ ] Work forward from the input
- [ ] Add more logging/debugging
- [ ] Simplify the test case further

---

## Red Flags

Watch out for these common pitfalls:

- [ ] ⚠️ Making assumptions without verification
- [ ] ⚠️ Fixing symptoms instead of root cause
- [ ] ⚠️ Changing multiple things at once
- [ ] ⚠️ Not testing the fix thoroughly
- [ ] ⚠️ Skipping code review
- [ ] ⚠️ Not adding tests for the fix
- [ ] ⚠️ Not documenting the solution
- [ ] ⚠️ Introducing new bugs while fixing old ones

---

## Success Criteria

Before closing the bug:

- [ ] ✅ Bug is consistently reproducible before the fix
- [ ] ✅ Bug is NOT reproducible after the fix
- [ ] ✅ Root cause is clearly understood
- [ ] ✅ Fix is implemented following best practices
- [ ] ✅ Tests are added and passing
- [ ] ✅ Code is reviewed and approved
- [ ] ✅ Documentation is updated
- [ ] ✅ Similar issues are prevented
- [ ] ✅ Stakeholders are notified
