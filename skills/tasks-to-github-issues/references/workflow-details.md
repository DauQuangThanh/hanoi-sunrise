# Tasks to GitHub Issues - Workflow Details

## Task Parsing Patterns

### Supported Task Formats

#### Format 1: Structured Headers

```markdown
### Task 1: Implement User Authentication

**Priority:** High
**Estimated Effort:** 5 hours
**Dependencies:** None

**Description:**
Implement JWT-based authentication for the API.

**Acceptance Criteria:**
- [ ] User can login with email and password
- [ ] JWT token is returned on successful login
- [ ] Token expires after 24 hours

**Technical Notes:**
- Use bcrypt for password hashing
- Store tokens in Redis with TTL
```

**Parsing Strategy:**
1. Extract heading text as title
2. Parse metadata from **bold** labels
3. Extract description from paragraph after metadata
4. Parse acceptance criteria from checklist
5. Extract technical notes from remaining content

#### Format 2: Simple Numbered List

```markdown
## Tasks

1. Implement User Authentication (Priority: High, Effort: 5h)
   - User can login with email and password
   - JWT token is returned on successful login
   - Dependencies: None

2. Create User Dashboard (Priority: Medium, Effort: 3h)
   - Dashboard displays user information
   - Dependencies: Task 1
```

**Parsing Strategy:**
1. Extract number and title from list item
2. Parse inline metadata from parentheses
3. Extract acceptance criteria from sub-bullets
4. Identify dependencies from "Dependencies:" line

#### Format 3: Table Format

```markdown
| ID | Task | Priority | Effort | Dependencies |
|----|------|----------|--------|--------------|
| T1 | Implement User Authentication | High | 5h | None |
| T2 | Create User Dashboard | Medium | 3h | T1 |
```

**Parsing Strategy:**
1. Parse table rows
2. Extract each column by header
3. Map dependencies using ID column

### Dependency Formats

**Explicit References:**
- "Dependencies: Task 1, Task 3"
- "Depends on: T001, T003"
- "Blocked by: Implement Authentication"

**Implicit References:**
- "After user authentication is complete..."
- "Requires database schema from Task 2"

**Dependency Resolution:**
1. Extract all explicit dependency declarations
2. Map task names/IDs to task objects
3. Build dependency graph (adjacency list)
4. Perform topological sort
5. Detect cycles (error if found)

## GitHub Issue Creation Workflow

### Issue Body Template Generation

```markdown
## Description

[Task description text]

## Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Technical Notes

[Implementation guidance]

## Dependencies

[If has dependencies:]
- Blocked by: #[issue-number] ([task-name])
- Blocked by: #[issue-number] ([task-name])

[If no dependencies:]
No blocking dependencies.

## Metadata

- **Priority:** [High/Medium/Low]
- **Estimated Effort:** [effort]
- **Feature:** [feature-name]
- **Source:** tasks.md
- **Task ID:** [original-task-id]

---

_This issue was automatically created from tasks.md on [date]_
```

### Label Mapping Rules

**Priority Labels:**
- `priority: high` ← Priority: High
- `priority: medium` ← Priority: Medium (default)
- `priority: low` ← Priority: Low

**Effort Labels:**
- `effort: small` ← 1-3 hours
- `effort: medium` ← 4-8 hours
- `effort: large` ← >8 hours or multiple days

**Category Labels:**
- `task` ← Always applied
- `feature` ← If part of feature development
- `backend` ← If mentions API, server, database
- `frontend` ← If mentions UI, component, page
- `testing` ← If mentions tests, QA, validation
- `documentation` ← If mentions docs, README, guides
- `devops` ← If mentions deployment, CI/CD, infrastructure

**Custom Labels:**
- Extract from task metadata
- Validate against existing repo labels
- Create if doesn't exist (if permissions allow)

### Dependency Linking Strategy

**Phase 1: Initial Creation (Without Dependencies)**

1. Create issues in topological order
2. Store mapping: task_id → issue_number
3. Leave dependency sections as placeholders

**Phase 2: Update with Dependencies**

1. For each created issue with dependencies:
   - Lookup dependency task IDs in mapping
   - Get corresponding issue numbers
   - Format dependency section
   - Update issue body via API

2. Use GitHub issue references:
   - `#42` for same repository
   - `owner/repo#42` for cross-repository (if supported)

3. Add visual dependency markers:
   - "🔒 Blocked by: #42 (Implement Authentication)"
   - "⚠️ Requires: #38, #40"

### API Call Patterns

**Creating Issue:**

```typescript
const issue = await mcp.github.issue_write({
  method: 'create',
  owner: 'acme-corp',
  repo: 'project-alpha',
  title: 'Task 1: Implement User Authentication',
  body: issueBodyMarkdown,
  labels: ['task', 'feature', 'priority: high', 'backend']
});

// Capture: issue.number, issue.url
```

**Updating Issue with Dependencies:**

```typescript
await mcp.github.issue_write({
  method: 'update',
  owner: 'acme-corp',
  repo: 'project-alpha',
  issue_number: 43,
  body: updatedBodyWithDependencies
});
```

**Adding Dependency Comment:**

```typescript
await mcp.github.add_issue_comment({
  owner: 'acme-corp',
  repo: 'project-alpha',
  issue_number: 43,
  body: 'This issue depends on #42 being completed first.'
});
```

## Metadata Tracking Schema

### Issue Tracking JSON Structure

```json
{
  "version": "1.0",
  "sync_date": "2026-01-26T10:30:00Z",
  "source_file": "features/user-auth/tasks.md",
  "repository": {
    "owner": "acme-corp",
    "name": "project-alpha",
    "url": "https://github.com/acme-corp/project-alpha"
  },
  "feature": {
    "name": "user-auth",
    "branch": "1-user-auth",
    "spec_file": "features/user-auth/spec.md"
  },
  "tasks_to_issues": {
    "task-1": {
      "task_id": "task-1",
      "task_title": "Implement User Authentication",
      "issue_number": 42,
      "issue_url": "https://github.com/acme-corp/project-alpha/issues/42",
      "created_at": "2026-01-26T10:30:00Z",
      "priority": "high",
      "effort": "5 hours",
      "labels": ["task", "feature", "priority: high", "backend"],
      "dependencies": [],
      "dependents": ["task-2"]
    },
    "task-2": {
      "task_id": "task-2",
      "task_title": "Create User Dashboard",
      "issue_number": 43,
      "issue_url": "https://github.com/acme-corp/project-alpha/issues/43",
      "created_at": "2026-01-26T10:31:00Z",
      "priority": "medium",
      "effort": "3 hours",
      "labels": ["task", "feature", "priority: medium", "frontend"],
      "dependencies": [42],
      "dependents": []
    }
  },
  "summary": {
    "total_tasks": 2,
    "issues_created": 2,
    "issues_updated": 2,
    "issues_failed": 0,
    "labels_created": 0,
    "labels_skipped": 0
  },
  "errors": []
}
```

### Task-to-Issue Mapping

**Purpose**: Enable future synchronization and updates

**Key Fields:**
- `task_id`: Original task identifier from tasks.md
- `issue_number`: GitHub issue number
- `issue_url`: Direct link to issue
- `dependencies`: Array of issue numbers this task depends on
- `dependents`: Array of task IDs that depend on this task

**Use Cases:**
1. **Status Sync**: Check if tasks.md changes require issue updates
2. **Duplicate Prevention**: Avoid creating duplicate issues
3. **Dependency Updates**: Update issue dependencies if tasks.md changes
4. **Cross-Reference**: Link tasks.md to GitHub issues

## Error Handling Strategies

### Rate Limit Handling

**Detection:**
```typescript
if (error.status === 403 && error.headers['x-ratelimit-remaining'] === '0') {
  // Rate limit exceeded
  const resetTime = error.headers['x-ratelimit-reset'];
  const waitSeconds = resetTime - Math.floor(Date.now() / 1000);
  // Wait and retry
}
```

**Strategy:**
1. Check rate limit headers before bulk operations
2. If close to limit, pause between requests
3. If exceeded, wait for reset time
4. Implement exponential backoff for retries

**Limits:**
- Authenticated: 5000 requests/hour
- Unauthenticated: 60 requests/hour

### Authentication Errors

**Detection:**
- Status 401: Invalid credentials
- Status 403: Insufficient permissions

**Actions:**
1. Verify GitHub MCP server configuration
2. Check token scopes include `repo` and `issues:write`
3. Confirm repository access permissions
4. Re-authenticate if token expired

### Partial Failure Handling

**Scenario:** 3 out of 10 issues fail to create

**Strategy:**
1. Continue creating remaining issues
2. Log all failures with task details
3. Do NOT commit tracking metadata (incomplete state)
4. Report failed tasks at the end
5. Provide manual remediation steps

**Recovery Report:**
```markdown
## Partial Failure Report

**Issues Created:** 7/10
**Issues Failed:** 3

### Failed Tasks

1. **Task 5: Setup Database Migration**
   - Error: Network timeout (500ms)
   - Action: Retry manually or re-run sync

2. **Task 7: Configure CI/CD Pipeline**
   - Error: Label 'devops' not found and cannot create
   - Action: Create label manually or remove from task

3. **Task 9: Deploy to Production**
   - Error: Rate limit exceeded
   - Action: Wait 15 minutes and re-run sync
```

### Circular Dependency Detection

**Algorithm:**
1. Build directed graph of task dependencies
2. Perform depth-first search (DFS)
3. Track visited nodes and recursion stack
4. If node already in recursion stack, cycle detected

**Error Message:**
```
Error: Circular dependency detected

Cycle: Task 3 → Task 5 → Task 7 → Task 3

Fix: Remove one dependency edge from tasks.md:
- Option 1: Remove "Task 3 depends on Task 7"
- Option 2: Remove "Task 5 depends on Task 7"
- Option 3: Remove "Task 7 depends on Task 3"
```

## Commit Message Format

### Standard Format

```
chore: sync tasks to GitHub issues

- Created [N] GitHub issues from tasks.md
- Feature: [feature-name]
- Issues: #[num1], #[num2], #[num3], ...
- Tracked in .github/issue-tracking.json
```

### Examples

**Success (All Created):**
```
chore: sync tasks to GitHub issues

- Created 5 GitHub issues from tasks.md
- Feature: user-authentication
- Issues: #42, #43, #44, #45, #46
- Tracked in .github/issue-tracking.json
```

**Partial Success:**
```
chore: sync tasks to GitHub issues (partial)

- Created 7/10 GitHub issues from tasks.md
- Feature: payment-processing
- Issues: #50-#56
- Failed: 3 tasks (see report)
- Tracked in .github/issue-tracking.json
```

**Update (Re-sync):**
```
chore: update GitHub issues from tasks.md

- Updated 3 existing issues
- Created 2 new issues
- Feature: user-profile
- Issues modified: #60, #61, #62
- Issues created: #70, #71
- Tracked in .github/issue-tracking.json
```

## Best Practices

### Before Running

1. **Review tasks.md**: Ensure all tasks are well-defined
2. **Check dependencies**: Verify no circular dependencies
3. **Validate labels**: Check if custom labels exist in repo
4. **Test authentication**: Confirm GitHub access works
5. **Review existing issues**: Check if tasks already have issues

### During Execution

1. **Monitor progress**: Watch for API errors or rate limits
2. **Capture issue numbers**: Store mapping for dependencies
3. **Log all operations**: Track successes and failures
4. **Handle errors gracefully**: Continue on non-critical errors

### After Completion

1. **Verify all issues created**: Check GitHub repo
2. **Validate dependencies**: Ensure dependency links are correct
3. **Review tracking file**: Confirm metadata is accurate
4. **Commit changes**: Add tracking file to version control
5. **Update tasks.md**: Optionally add issue links to tasks

### Maintenance

1. **Sync periodically**: Re-run when tasks.md changes significantly
2. **Clean up closed issues**: Remove from tracking file
3. **Update dependencies**: Adjust issue dependencies if tasks change
4. **Archive old tracking**: Keep history of previous syncs

## Troubleshooting

### Issue: "Tasks already synced"

**Detection:** Check `.github/issue-tracking.json` for existing mapping

**Options:**
1. Skip sync (issues already exist)
2. Update existing issues with new data
3. Force re-create (will create duplicates)

**Recommended:** Use update mode or manual verification

### Issue: "Label not found"

**Cause:** Custom label doesn't exist in repository

**Solutions:**
1. Create label manually in GitHub repo
2. Remove label from task metadata
3. Enable label creation (if permissions allow)
4. Use default labels only

### Issue: "Dependency task not found"

**Cause:** Task references non-existent task ID

**Solutions:**
1. Fix tasks.md to reference correct task
2. Remove invalid dependency
3. Add missing task to tasks.md

### Issue: "Authentication expired"

**Cause:** GitHub token expired or invalid

**Solutions:**
1. Refresh GitHub authentication token
2. Re-configure GitHub MCP server
3. Verify token has required scopes
