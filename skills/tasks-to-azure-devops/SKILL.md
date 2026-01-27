---
name: tasks-to-azure-devops
description: Converts tasks from tasks.md into Azure DevOps work items with dependency ordering and synchronization tracking. Use when syncing task lists to Azure DevOps, creating work items from specifications, or when user mentions Azure DevOps work items, ADO, boards, or task synchronization.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
---

# Tasks to Azure DevOps Work Items

Converts structured tasks from `tasks.md` into Azure DevOps work items in the correct project, maintaining dependencies and tracking synchronization state.

## When to Use

- User wants to create Azure DevOps work items from tasks.md
- Need to sync task lists to Azure DevOps Boards
- Converting project tasks into trackable work items
- User mentions "Azure DevOps", "ADO", "work items", or "boards"
- Creating work items with dependency relationships
- Bulk work item creation from task specifications

## Prerequisites

**Required:**

- Git repository with Azure DevOps remote configured
- `tasks.md` file with structured tasks in the repository
- Azure DevOps MCP server (`ado/azure-devops-mcp`) with authentication
- Git command-line tool

**Azure DevOps Remote Formats:**

- `https://dev.azure.com/{organization}/{project}/_git/{repository}`
- `https://{organization}.visualstudio.com/{project}/_git/{repository}`
- `https://{organization}.visualstudio.com/DefaultCollection/{project}/_git/{repository}`
- `git@ssh.dev.azure.com:v3/{organization}/{project}/{repository}`

**Check Prerequisites:**

```bash
# Bash
./scripts/check-tasks-to-ado-prerequisites.sh

# PowerShell
.\scripts\check-tasks-to-ado-prerequisites.ps1
```

## Instructions

### Phase 1: Setup and Validation

1. **Run prerequisite check script** to validate environment:

   ```bash
   # Bash
   ./scripts/check-tasks-to-ado-prerequisites.sh --json
   
   # PowerShell
   .\scripts\check-tasks-to-ado-prerequisites.ps1 -Json
   ```

2. **Parse script output** to extract:
   - `workspace_root`: Repository root directory
   - `tasks_file`: Path to tasks.md file
   - `ado.organization`: Azure DevOps organization name
   - `ado.project`: Azure DevOps project name
   - `ado.repository`: Repository name
   - `ado.is_azure_devops`: Must be `true`

3. **Verify all required fields** are present:
   - If `success` is `false`, review errors and stop
   - If organization or project is empty, stop and report error
   - If tasks_file is empty, stop and report missing tasks.md

4. **Confirm with user** before creating work items:
   - Show organization: `{organization}`
   - Show project: `{project}`
   - Show number of tasks to be created
   - Get explicit confirmation to proceed

### Phase 2: Task Parsing and Dependency Analysis

1. **Read tasks.md file** and parse task structure:
   - Support structured task format with ID, Title, Description, Dependencies
   - Support simple numbered list format
   - Extract task metadata (priority, effort, labels)

2. **Build dependency graph:**
   - Create adjacency list of task dependencies
   - Identify all "depends on" relationships
   - Detect circular dependencies (error if found)
   - Perform topological sort to determine creation order

3. **Handle dependency errors:**
   - **Circular dependencies**: Report cycle path and stop
   - **Missing dependency targets**: Warn user, ask whether to continue
   - **Self-dependencies**: Remove and warn user

### Phase 3: Work Item Creation

1. **Create work items in topological order:**
   - Start with tasks that have no dependencies
   - For each task in sorted order:
     - Format work item using template (templates/ado-work-item.md)
     - Determine work item type (Task, User Story, Feature)
     - Set title, description, acceptance criteria
     - Add tags/labels from task metadata
     - Call Azure DevOps MCP server: `mcp_ado_wit_create_work_item`

2. **Work Item Creation Parameters:**

   ```json
   {
     "organization": "{organization}",
     "project": "{project}",
     "type": "Task|User Story|Feature",
     "title": "{task.title}",
     "description": "{formatted_description}",
     "tags": "{task.tags}",
     "priority": "{task.priority}",
     "effort": "{task.effort}"
   }
   ```

3. **Track created work items:**
   - Store mapping: task_id → work_item_id
   - Record work item URL
   - Store creation timestamp
   - Note any errors or warnings

4. **Add dependency links:**
   - After all work items created, iterate dependencies
   - For each dependency relationship:
     - Look up parent and child work item IDs
     - Create work item link using Azure DevOps API
     - Link type: "Predecessor-Successor" or "Related"

5. **Handle creation errors:**
   - **API rate limit**: Implement exponential backoff (1s, 2s, 4s, 8s)
   - **Authentication failure**: Stop and report MCP server config issue
   - **Project not found**: Stop and report project mismatch
   - **Invalid work item type**: Use default "Task" and warn
   - **Partial failure**: Continue with remaining items, report failed items

### Phase 4: Metadata Tracking and Sync

1. **Create or update tracking file** `.ado/work-item-tracking.json`:

   ```json
   {
     "last_sync": "2026-01-26T10:30:00Z",
     "organization": "{organization}",
     "project": "{project}",
     "work_items": [
       {
         "task_id": "task-1",
         "work_item_id": 12345,
         "work_item_url": "https://dev.azure.com/{org}/{project}/_workitems/edit/12345",
         "title": "Task title",
         "created_at": "2026-01-26T10:30:00Z",
         "status": "New"
       }
     ],
     "dependencies": [
       {
         "parent_id": 12345,
         "child_id": 12346,
         "link_type": "Predecessor-Successor"
       }
     ]
   }
   ```

2. **Update task metadata** (optional):
   - Add Azure DevOps work item ID to task comments in tasks.md
   - Format: `<!-- ADO: 12345 -->`
   - Include work item URL for easy reference

3. **Generate sync report:**
   - Total tasks processed
   - Successfully created work items
   - Failed work items (with reasons)
   - Dependency links created
   - Warnings or issues encountered

### Phase 5: Commit and Finalization

1. **Stage tracking files:**

   ```bash
   git add .ado/work-item-tracking.json
   ```

2. **Create commit** with semantic prefix:

   ```bash
   git commit -m "chore: sync tasks to Azure DevOps work items
   
   - Created {count} work items in {project}
   - Added dependency links for {dep_count} relationships
   - Organization: {organization}
   - Project: {project}
   - Work items: #{id1}, #{id2}, ...
   
   Tracking file: .ado/work-item-tracking.json"
   ```

3. **Provide summary to user:**
   - Number of work items created
   - Azure DevOps project URL
   - Link to view all work items
   - Any warnings or issues
   - Next steps (e.g., assign work items, update board)

## Success Criteria

- ✅ All tasks from tasks.md converted to Azure DevOps work items
- ✅ Work items created in correct organization and project
- ✅ Dependency relationships established via work item links
- ✅ Tracking file created with complete mapping
- ✅ Changes committed with descriptive message
- ✅ User provided with work item URLs and summary

## Error Handling

### Common Errors

1. **No Azure DevOps Remote:**
   - Error: Git remote is not an Azure DevOps URL
   - Action: Stop and inform user to configure Azure DevOps remote
   - Help: Show supported URL formats and how to add remote

2. **MCP Server Not Available:**
   - Error: Azure DevOps MCP server not responding
   - Action: Stop and provide MCP configuration guidance
   - Help: Link to Azure DevOps MCP server setup documentation

3. **Project Mismatch:**
   - Error: Extracted project doesn't match user's intent
   - Action: Stop and confirm project with user
   - Help: Show detected project and ask for confirmation

4. **Authentication Failure:**
   - Error: MCP server cannot authenticate with Azure DevOps
   - Action: Stop and guide user through authentication setup
   - Help: Provide PAT (Personal Access Token) setup instructions

5. **Circular Dependencies:**
   - Error: Task dependency cycle detected
   - Action: Stop and report cycle path
   - Help: Show which tasks form the cycle and ask user to resolve

6. **Work Item Creation Failure:**
   - Error: Individual work item creation failed
   - Action: Continue with remaining items, track failures
   - Help: Report failed items and reasons at end, allow retry

## Templates

The skill uses the following template:

- **templates/ado-work-item.md**: Template for formatting Azure DevOps work item description from task data

## Scripts

The skill includes prerequisite check scripts:

- **scripts/check-tasks-to-ado-prerequisites.sh**: Bash script to validate environment (Git, Azure DevOps remote, tasks.md)
- **scripts/check-tasks-to-ado-prerequisites.ps1**: PowerShell script for Windows environments

## Examples

### Example 1: Simple Task Conversion

**Input tasks.md:**

```markdown
## Task 1: Setup database schema
Create PostgreSQL database schema for user management.

**Priority:** High
**Effort:** 3 points

## Task 2: Implement user service
Create user service with CRUD operations.

**Dependencies:** Task 1
**Priority:** Medium
**Effort:** 5 points
```

**Workflow:**

1. Run prerequisite check → extracts organization "contoso", project "MyProject"
2. Parse 2 tasks with 1 dependency
3. Topological sort: Task 1 → Task 2
4. Create work item for Task 1 → ID: 12345
5. Create work item for Task 2 → ID: 12346
6. Add Predecessor-Successor link: 12345 → 12346
7. Save tracking file with mappings
8. Commit with message: "chore: sync tasks to Azure DevOps work items"

**Output:**

```
✓ Created 2 work items in project 'MyProject'
✓ Added 1 dependency link
✓ Tracking file saved: .ado/work-item-tracking.json
✓ Changes committed

Work items created:
- #12345: Setup database schema
  https://dev.azure.com/contoso/MyProject/_workitems/edit/12345
- #12346: Implement user service
  https://dev.azure.com/contoso/MyProject/_workitems/edit/12346

View all: https://dev.azure.com/contoso/MyProject/_boards/board/t/MyTeam/Stories
```

### Example 2: Handling Errors

**Scenario:** User has GitHub remote instead of Azure DevOps

**Workflow:**

1. Run prerequisite check
2. Detect remote: `https://github.com/user/repo.git`
3. Check fails: `is_azure_devops: false`
4. Stop with error message

**Output:**

```
✗ Error: Repository remote is not Azure DevOps

Current remote: https://github.com/user/repo.git

This skill requires an Azure DevOps remote. Supported formats:
- https://dev.azure.com/{org}/{project}/_git/{repo}
- https://{org}.visualstudio.com/{project}/_git/{repo}
- git@ssh.dev.azure.com:v3/{org}/{project}/{repo}

To fix:
1. Create Azure DevOps repository
2. Add remote: git remote add ado https://dev.azure.com/org/project/_git/repo
3. Run skill again
```

## Notes

1. **Organization/Project Extraction:** The skill extracts Azure DevOps organization and project from the Git remote URL. Ensure your remote URL is correctly formatted.

2. **Work Item Type Selection:** By default, tasks become "Task" work items. If task metadata includes type information (e.g., "Story", "Feature"), that type will be used instead.

3. **Dependency Links:** Dependencies are created as "Predecessor-Successor" links in Azure DevOps. Parent tasks must be created before child tasks.

4. **Rate Limiting:** Azure DevOps API has rate limits. The skill implements exponential backoff if rate limits are hit.

5. **Idempotency:** The skill checks the tracking file before creating work items. If a task already has a work item ID, it will skip creation (unless forced).

6. **Tracking File Location:** The `.ado/` directory and tracking file should be committed to version control to maintain sync state across team members.

7. **Authentication:** Requires Azure DevOps MCP server to be configured with proper authentication (Personal Access Token or OAuth).

8. **Project Validation:** The skill will ONLY create work items in the project that matches the Git remote. This prevents accidental work item creation in wrong projects.
