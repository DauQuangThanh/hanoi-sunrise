---
name: tasks-to-github-issues
description: Converts project tasks from tasks.md into actionable GitHub issues with proper dependency ordering and metadata tracking. Use when creating GitHub issues from task lists, syncing tasks to issue tracker, managing project tasks, or when user mentions tasks to issues, GitHub sync, issue creation, or task tracking.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
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

**Goal**: Parse tasks.md and extract task definitions with dependencies. See [references/workflow-details.md](references/workflow-details.md) for detailed task format examples and parsing strategies.

1. **Read tasks.md file** and parse structure (headers, lists, or tables)
2. **Parse task structure**: Extract title, description, priority, effort, dependencies, acceptance criteria, technical notes, labels
3. **Extract task attributes** for each task
4. **Build dependency graph**: Map dependencies, create topologically sorted list, detect circular dependencies
5. **Validate task structure**: Check dependencies exist, verify required fields, check task numbering

**Supported Formats**: Structured headers, numbered lists, table format

**Output**: Structured task list with dependencies resolved

### Phase 2: Issue Creation

**Goal**: Create GitHub issues for each task in dependency order. See [references/workflow-details.md](references/workflow-details.md) for:
- Issue body template generation
- Label mapping rules
- Dependency linking strategy
- API call patterns
- Error handling strategies

1. **Prepare issue content** using template from `templates/github-issue.md`
2. **Determine issue labels**: Default labels (task, feature, priority, effort) + custom labels
3. **Create issues in dependency order**:
   - Prepare issue data (title, body, labels)
   - Create via GitHub MCP: `mcp.github.issue_write()`
   - Capture issue numbers and map to task IDs
   - Update dependent task references
4. **Handle errors gracefully**: Log errors, continue with remaining issues, report failures
5. **Link dependent issues**: Update issue bodies with dependency links after all created

**Output**: GitHub issues created for all tasks with proper dependency links

### Phase 3: Metadata Tracking

**Goal**: Record issue creation metadata for future synchronization. See [references/workflow-details.md](references/workflow-details.md) for complete JSON schema and field descriptions.

1. **Create issue tracking file** at `.github/issue-tracking.json` with: sync_date, source_file, repository info, tasks_to_issues mapping, summary
2. **Update tasks.md with issue links** (optional): Add GitHub issue references
3. **Create summary report**: Total tasks, issues created/failed, dependencies

### Phase 4: Commit Changes

**Goal**: Commit tracking metadata to version control. See [references/workflow-details.md](references/workflow-details.md) for commit message format examples.

1. **Stage tracking files**: `git add .github/issue-tracking.json` (and updated tasks.md if modified)
2. **Generate commit message**: Format `chore: sync tasks to GitHub issues` with details
3. **Commit changes** with full message including created issues and feature name
4. **Verify commit**: Check success, verify tracking file included, confirm message format

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

See [references/workflow-details.md](references/workflow-details.md) for detailed error handling strategies including rate limits, authentication, partial failures, and circular dependencies.

**Common Errors:**

1. **tasks.md not found**: Run taskify command to create tasks.md first
2. **Not a GitHub repository**: Skill only works with GitHub repositories
3. **GitHub authentication failed**: Configure GitHub MCP server with valid token
4. **Circular dependency detected**: Fix tasks.md to remove cycle
5. **Rate limit exceeded**: Wait for reset time and retry
6. **Issue creation failed**: Log error, skip task, report at end, don't commit tracking metadata

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
