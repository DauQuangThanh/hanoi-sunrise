---
name: tasks-to-github-issues
description: Converts project tasks from tasks.md into actionable GitHub issues with proper dependency ordering and metadata tracking. Use when creating GitHub issues from task lists, syncing tasks to issue tracker, managing project tasks, or when user mentions tasks to issues, GitHub sync, issue creation, or task tracking.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-26"
---

# Tasks to GitHub Issues Skill

## Overview

This skill converts tasks from `tasks.md` files into actionable GitHub issues in the project repository. It parses task definitions, maintains dependency relationships, creates issues with proper formatting, and commits tracking metadata for issue synchronization.

The skill ensures tasks are only created as issues in the correct GitHub repository by validating the Git remote URL before proceeding.

## When to Use

Activate this skill when:

- Converting task lists to GitHub issues
- Syncing project tasks to issue tracker
- Creating issues from feature task breakdowns
- Setting up GitHub project management from task documentation
- User mentions: "create GitHub issues", "sync tasks", "convert tasks to issues", "GitHub issue creation", "task tracking"

**Timing**: Run this AFTER tasks.md is created (typically after running the `taskify` command or creating task breakdown documentation).

## Prerequisites

**Required:**

- `tasks.md` file in feature directory (contains task list)
- Git repository with GitHub remote
- Git installed and configured
- GitHub repository access (for creating issues)

**Optional:**

- Existing issue tracking metadata (for updates)

**Validation:**

Use the prerequisite checking scripts to verify required files and configuration:

**Bash (macOS/Linux):**

```bash
skills/tasks-to-github-issues/scripts/check-tasks-to-issues-prerequisites.sh
```

**PowerShell (Windows):**

```powershell
.\skills\tasks-to-github-issues\scripts\check-tasks-to-issues-prerequisites.ps1
```

**JSON Output (for parsing):**

```bash
skills/tasks-to-github-issues/scripts/check-tasks-to-issues-prerequisites.sh --json
.\skills\tasks-to-github-issues\scripts\check-tasks-to-issues-prerequisites.ps1 -Json
```

**What the scripts check:**

- Presence of `tasks.md` file
- Git repository initialization
- GitHub remote URL configured
- Git command availability

## Instructions

### Setup Phase

1. **Run prerequisite script** to detect required files and configuration:
   - Execute the appropriate script for your platform
   - Parse JSON output to get file paths and repository info
   - Verify `tasks.md` exists
   - Verify Git remote is a GitHub URL
   - Extract repository owner and name from remote URL

2. **Parse repository information** from Git remote:

   ```bash
   git config --get remote.origin.url
   ```

   **Expected formats:**
   - HTTPS: `https://github.com/owner/repo.git`
   - SSH: `git@github.com:owner/repo.git`

   **Extract:**
   - Repository owner (e.g., `owner`)
   - Repository name (e.g., `repo`)

3. **Verify GitHub access**:
   - Confirm you have permission to create issues in the repository
   - If using GitHub MCP server, ensure it's configured with proper authentication

4. **Prepare issue tracking**:
   - Create `.github/` directory if it doesn't exist
   - Prepare to store issue tracking metadata

### Phase 1: Task Parsing

**Goal**: Parse tasks.md and extract task definitions with dependencies.

1. **Read tasks.md file**:
   - Parse the entire file
   - Identify task sections (typically markdown headers or numbered lists)
   - Extract task metadata

2. **Parse task structure**:

   **Expected task format in tasks.md:**

   ```markdown
   ## Tasks
   
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
   
   ---
   
   ### Task 2: Create User Dashboard
   
   **Priority:** Medium
   **Estimated Effort:** 3 hours
   **Dependencies:** Task 1
   
   **Description:**
   Create a dashboard page showing user information and recent activity.
   
   **Acceptance Criteria:**
   - [ ] Dashboard displays user name and email
   - [ ] Shows last 10 activities
   - [ ] Accessible only when authenticated
   ```

   **Alternative format (simple list):**

   ```markdown
   ## Tasks
   
   1. Implement User Authentication (Priority: High, Effort: 5h)
      - User can login with email and password
      - JWT token is returned on successful login
      - Token expires after 24 hours
      - Dependencies: None
   
   2. Create User Dashboard (Priority: Medium, Effort: 3h)
      - Dashboard displays user information
      - Shows recent activity
      - Dependencies: Task 1
   ```

3. **Extract task attributes**:

   For each task, extract:
   - **Title**: Task name (from header or list item)
   - **Description**: Main task description text
   - **Priority**: High, Medium, Low (default: Medium if not specified)
   - **Estimated Effort**: Time estimate (e.g., "5 hours", "2 days")
   - **Dependencies**: References to other tasks (by number or name)
   - **Acceptance Criteria**: Checklist of requirements
   - **Technical Notes**: Implementation guidance
   - **Labels**: Relevant labels (feature, bug, enhancement, etc.)

4. **Build dependency graph**:
   - Map task dependencies
   - Identify task ordering based on dependencies
   - Detect circular dependencies (error if found)
   - Create topologically sorted task list

5. **Validate task structure**:
   - Ensure all referenced dependencies exist
   - Check for missing required fields (at minimum: title)
   - Verify task numbering is sequential (if numbered)

**Output**: Structured task list with dependencies resolved

### Phase 2: Issue Creation

**Goal**: Create GitHub issues for each task in dependency order.

1. **Prepare issue content** using template:

   Use the GitHub issue template from `templates/github-issue.md` to format each task as an issue.

   **Issue structure:**

   ```markdown
   ## Description
   
   [Task description]
   
   ## Acceptance Criteria
   
   - [ ] [Criterion 1]
   - [ ] [Criterion 2]
   - [ ] [Criterion 3]
   
   ## Technical Notes
   
   [Technical implementation guidance]
   
   ## Dependencies
   
   - Blocked by: #[issue-number] ([task-name])
   
   ## Metadata
   
   - **Priority:** [High/Medium/Low]
   - **Estimated Effort:** [effort]
   - **Feature:** [feature-name]
   - **Source:** tasks.md
   ```

2. **Determine issue labels**:

   **Default labels:**
   - `task` - Always applied to task-created issues
   - `feature` - If task is part of feature development
   - Priority labels: `priority: high`, `priority: medium`, `priority: low`
   - Effort labels: `effort: small`, `effort: medium`, `effort: large`

   **Custom labels** (from task metadata):
   - `backend`, `frontend`, `database`, `api`, etc.
   - `bug`, `enhancement`, `documentation`

3. **Create issues in dependency order**:

   **Important**: Create issues in topologically sorted order so that dependencies can be referenced.

   **For each task:**

   a. **Prepare issue data:**

   ```javascript
   {
     title: "Task 1: Implement User Authentication",
     body: [formatted issue content from template],
     labels: ["task", "feature", "priority: high", "backend"],
     assignees: [], // Optional
     milestone: null // Optional
   }
   ```

   b. **Create issue via GitHub MCP server:**

   ```typescript
   // Use GitHub MCP server tool: issue_write
   await mcp.github.issue_write({
     method: 'create',
     owner: repoOwner,
     repo: repoName,
     title: issueData.title,
     body: issueData.body,
     labels: issueData.labels
   })
   ```

   c. **Capture issue number:**
   - Store the created issue number
   - Map task ID to issue number for dependency linking

   d. **Update dependent task references:**
   - If subsequent tasks depend on this task, update their issue bodies to reference the created issue number
   - Example: "Blocked by: #42 (Implement User Authentication)"

4. **Handle errors gracefully**:

   **If issue creation fails:**
   - Log the error with task details
   - Continue creating remaining issues
   - Report all failures at the end
   - Do NOT commit tracking metadata if any issues failed

   **Common errors:**
   - **Rate limit exceeded**: Wait and retry with exponential backoff
   - **Authentication failed**: Verify GitHub credentials and permissions
   - **Invalid label**: Create label first or skip if not critical
   - **Network error**: Retry up to 3 times

5. **Link dependent issues**:

   After all issues are created:
   - Update issue bodies to include dependency links
   - Add comments to dependent issues referencing blockers
   - Optionally update issue descriptions with dependency graph

**Output**: GitHub issues created for all tasks with proper dependency links

### Phase 3: Metadata Tracking

**Goal**: Record issue creation metadata for future synchronization.

1. **Create issue tracking file**:

   **File location**: `.github/issue-tracking.json`

   **Structure:**

   ```json
   {
     "sync_date": "2026-01-26T10:30:00Z",
     "source_file": "features/user-auth/tasks.md",
     "repository": "owner/repo",
     "tasks_to_issues": {
       "task-1": {
         "task_title": "Implement User Authentication",
         "issue_number": 42,
         "issue_url": "https://github.com/owner/repo/issues/42",
         "created_at": "2026-01-26T10:30:00Z",
         "labels": ["task", "feature", "priority: high"],
         "dependencies": []
       },
       "task-2": {
         "task_title": "Create User Dashboard",
         "issue_number": 43,
         "issue_url": "https://github.com/owner/repo/issues/43",
         "created_at": "2026-01-26T10:31:00Z",
         "labels": ["task", "feature", "priority: medium"],
         "dependencies": [42]
       }
     },
     "summary": {
       "total_tasks": 2,
       "issues_created": 2,
       "issues_failed": 0
     }
   }
   ```

2. **Update tasks.md with issue links** (optional):

   Add issue references to tasks.md for easy cross-referencing:

   ```markdown
   ### Task 1: Implement User Authentication
   
   **GitHub Issue:** [#42](https://github.com/owner/repo/issues/42)
   
   **Priority:** High
   ...
   ```

3. **Create summary report**:

   Generate a summary of the sync operation:

   ```markdown
   # Task to GitHub Issue Sync Report
   
   **Date:** 2026-01-26 10:30:00
   **Repository:** owner/repo
   **Source:** features/user-auth/tasks.md
   
   ## Summary
   
   - **Total Tasks:** 2
   - **Issues Created:** 2
   - **Issues Failed:** 0
   
   ## Created Issues
   
   - #42: Task 1: Implement User Authentication (Priority: High)
   - #43: Task 2: Create User Dashboard (Priority: Medium)
   
   ## Dependencies
   
   - Issue #43 depends on #42
   ```

### Phase 4: Commit Changes

**Goal**: Commit tracking metadata to version control.

1. **Stage tracking files**:

   ```bash
   git add .github/issue-tracking.json
   git add features/*/tasks.md  # If updated with issue links
   ```

2. **Generate commit message**:

   **Format**: `chore: sync tasks to GitHub issues`

   **Full message example:**

   ```
   chore: sync tasks to GitHub issues
   
   - Created 2 GitHub issues from tasks.md
   - Feature: user-auth
   - Issues: #42, #43
   - Tracked in .github/issue-tracking.json
   ```

3. **Commit changes**:

   ```bash
   git commit -m "chore: sync tasks to GitHub issues

   - Created 2 GitHub issues from tasks.md
   - Feature: user-auth
   - Issues: #42, #43
   - Tracked in .github/issue-tracking.json"
   ```

4. **Verify commit**:
   - Check that commit was successful
   - Verify tracking file is included
   - Confirm commit message follows convention

**Output**: Changes committed to version control with tracking metadata

## Success Criteria

The tasks-to-github-issues process is complete when:

- [ ] All tasks from tasks.md are parsed successfully
- [ ] Dependencies are correctly identified and ordered
- [ ] GitHub issues are created for all tasks
- [ ] Issue numbers are captured and tracked
- [ ] Dependent issues reference blocker issues
- [ ] Issue tracking metadata is saved to `.github/issue-tracking.json`
- [ ] Changes are committed with appropriate message
- [ ] No tasks failed to create issues (or failures are documented)
- [ ] Repository owner and name match Git remote

## Error Handling

**Common Errors and Solutions:**

1. **Error**: `tasks.md not found`
   - **Cause**: No task file exists
   - **Action**: Run `taskify` command to create tasks.md first

2. **Error**: `Not a GitHub repository`
   - **Cause**: Git remote is not a GitHub URL
   - **Action**: This skill only works with GitHub repositories. Use manual issue creation for other platforms.

3. **Error**: `GitHub authentication failed`
   - **Cause**: No GitHub credentials or invalid token
   - **Action**: Configure GitHub MCP server with valid authentication token

4. **Error**: `Circular dependency detected`
   - **Cause**: Task A depends on Task B, and Task B depends on Task A
   - **Action**: Fix tasks.md to remove circular dependency

5. **Error**: `Rate limit exceeded`
   - **Cause**: Too many API requests to GitHub
   - **Action**: Wait for rate limit reset (check headers for reset time) and retry

6. **Error**: `Issue creation failed for task X`
   - **Cause**: Network error, invalid data, or API error
   - **Action**: Log the error, skip the task, report at the end. Do not commit tracking metadata.

## Templates

Use the provided template for GitHub issue formatting:

**Template Location**: `templates/github-issue.md`

The template provides a structured format for converting tasks to issues with all necessary sections.

## Scripts

### Prerequisite Checking

**Bash (macOS/Linux):**

```bash
skills/tasks-to-github-issues/scripts/check-tasks-to-issues-prerequisites.sh
```

**PowerShell (Windows):**

```powershell
.\skills\tasks-to-github-issues\scripts\check-tasks-to-issues-prerequisites.ps1
```

**JSON Output:**

```bash
skills/tasks-to-github-issues/scripts/check-tasks-to-issues-prerequisites.sh --json
```

**Output includes:**

- `tasks_file`: Path to tasks.md
- `git_remote`: GitHub repository URL
- `repo_owner`: Repository owner
- `repo_name`: Repository name
- `is_github`: Boolean indicating if remote is GitHub

## Examples

For detailed examples including simple task lists, complex tasks with metadata, multiple dependencies, labels, milestones, and edge cases, see [`references/EXAMPLES.md`](references/EXAMPLES.md).

Quick reference:

- **Example 1:** Simple 3-task list with sequential dependencies
- **Example 2:** Complex task with acceptance criteria and technical notes
- **Example 3:** Task with multiple dependencies and dependency graph
- **Example 4:** Task with labels, milestones, and assignees
- **Example 5:** Complete workflow from feature branch to GitHub issues
- **Example 6:** Edge cases (missing metadata, invalid dependencies, duplicates)

## Notes

- **GitHub only**: This skill only works with GitHub repositories. For GitLab, Bitbucket, or other platforms, manual issue creation is required.
- **Authentication required**: Ensure GitHub MCP server is configured with proper authentication before running.
- **Dependency order**: Issues are created in dependency order to allow proper cross-referencing.
- **Idempotency**: Running this skill multiple times will create duplicate issues. Check `.github/issue-tracking.json` to see if tasks have already been synced.
- **Rate limits**: GitHub has API rate limits. For large task lists (>50 tasks), the skill may need to pause and retry.
- **Label creation**: If labels don't exist in the repository, they will be skipped unless the skill has permission to create labels.
- **Issue updates**: This skill creates new issues. For updating existing issues, manual updates are required.

## Additional Resources

For more detailed guidance, see:

- `templates/github-issue.md` - GitHub issue template
- GitHub Issues API documentation: <https://docs.github.com/en/rest/issues>
- GitHub MCP Server documentation
- Agent Skills specification - For skill creation best practices

## Version History

- **v1.0** (2026-01-26): Initial release
  - Task parsing from tasks.md
  - GitHub issue creation with dependencies
  - Metadata tracking
  - Cross-platform prerequisite checking scripts
