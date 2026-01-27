# Tasks to GitHub Issues - Examples

Detailed examples showing how to convert task lists from `tasks.md` into GitHub issues with proper formatting, dependencies, and metadata.

## Example 1: Simple Task List

A basic task list with sequential dependencies.

### Input: tasks.md

```markdown
## Tasks

1. Setup database schema (Priority: High, Effort: 2h)
   - Create users table
   - Create posts table
   - Add indexes

2. Implement CRUD API (Priority: High, Effort: 4h)
   - Create endpoint for users
   - Create endpoint for posts
   - Dependencies: Task 1

3. Write API tests (Priority: Medium, Effort: 3h)
   - Test user endpoints
   - Test post endpoints
   - Dependencies: Task 2
```

### Output: GitHub Issues Created

**Issue #101: "Task 1: Setup database schema"**

- **Labels:** `task`, `priority: high`
- **Body:**

  ```markdown
  ## Description
  
  Setup database schema
  
  ## Subtasks
  
  - [ ] Create users table
  - [ ] Create posts table
  - [ ] Add indexes
  
  ## Metadata
  
  - **Priority:** High
  - **Estimated Effort:** 2h
  - **Source:** tasks.md
  - **Task ID:** 1
  ```

**Issue #102: "Task 2: Implement CRUD API"**

- **Labels:** `task`, `priority: high`
- **Body:**

  ```markdown
  ## Description
  
  Implement CRUD API
  
  ## Subtasks
  
  - [ ] Create endpoint for users
  - [ ] Create endpoint for posts
  
  ## Dependencies
  
  This task is blocked by:
  - #101 (Task 1: Setup database schema)
  
  ## Metadata
  
  - **Priority:** High
  - **Estimated Effort:** 4h
  - **Source:** tasks.md
  - **Task ID:** 2
  ```

**Issue #103: "Task 3: Write API tests"**

- **Labels:** `task`, `priority: medium`
- **Body:**

  ```markdown
  ## Description
  
  Write API tests
  
  ## Subtasks
  
  - [ ] Test user endpoints
  - [ ] Test post endpoints
  
  ## Dependencies
  
  This task is blocked by:
  - #102 (Task 2: Implement CRUD API)
  
  ## Metadata
  
  - **Priority:** Medium
  - **Estimated Effort:** 3h
  - **Source:** tasks.md
  - **Task ID:** 3
  ```

### Metadata Tracking

After creation, `.github/issue-tracking.json` is updated:

```json
{
  "feature": "database-api",
  "sync_date": "2026-01-26T10:30:00Z",
  "tasks": [
    {
      "task_id": 1,
      "title": "Setup database schema",
      "github_issue": 101,
      "url": "https://github.com/owner/repo/issues/101"
    },
    {
      "task_id": 2,
      "title": "Implement CRUD API",
      "github_issue": 102,
      "url": "https://github.com/owner/repo/issues/102",
      "depends_on": [101]
    },
    {
      "task_id": 3,
      "title": "Write API tests",
      "github_issue": 103,
      "url": "https://github.com/owner/repo/issues/103",
      "depends_on": [102]
    }
  ]
}
```

---

## Example 2: Complex Task with Detailed Metadata

A comprehensive task with acceptance criteria, technical notes, and multiple labels.

### Input: tasks.md

```markdown
### Task 1: Design Authentication System

**Priority:** Critical
**Estimated Effort:** 8 hours
**Dependencies:** None
**Labels:** backend, security

**Description:**
Design and implement JWT-based authentication system.

**Acceptance Criteria:**
- [ ] User registration with email verification
- [ ] Login with email and password
- [ ] JWT token generation and validation
- [ ] Refresh token mechanism

**Technical Notes:**
- Use bcrypt for password hashing (cost factor: 12)
- Store refresh tokens in Redis with 7-day TTL
- Implement rate limiting on login endpoint
```

### Output: GitHub Issue #201

**Title:** Task 1: Design Authentication System

**Labels:** `task`, `backend`, `security`, `priority: critical`

**Body:**

```markdown
# Task 1: Design Authentication System

## Description

Design and implement JWT-based authentication system.

## Acceptance Criteria

- [ ] User registration with email verification
- [ ] Login with email and password
- [ ] JWT token generation and validation
- [ ] Refresh token mechanism

## Technical Notes

- Use bcrypt for password hashing (cost factor: 12)
- Store refresh tokens in Redis with 7-day TTL
- Implement rate limiting on login endpoint

## Metadata

- **Priority:** Critical
- **Estimated Effort:** 8 hours
- **Labels:** backend, security
- **Feature:** auth-system
- **Source:** tasks.md
- **Task ID:** 1
```

---

## Example 3: Task with Multiple Dependencies

A task that depends on multiple other tasks.

### Input: tasks.md

```markdown
## Tasks

1. Create user model (Priority: High, Effort: 1h)
   
2. Create product model (Priority: High, Effort: 1h)
   
3. Create order model (Priority: High, Effort: 2h)
   - Dependencies: Task 1, Task 2
   
4. Implement checkout flow (Priority: Critical, Effort: 6h)
   - Dependencies: Task 3
```

### Output: GitHub Issues Created

**Issue #301:** Task 1: Create user model

**Issue #302:** Task 2: Create product model

**Issue #303:** Task 3: Create order model

```markdown
## Dependencies

This task is blocked by:
- #301 (Task 1: Create user model)
- #302 (Task 2: Create product model)
```

**Issue #304:** Task 4: Implement checkout flow

```markdown
## Dependencies

This task is blocked by:
- #303 (Task 3: Create order model)
```

### Dependency Graph

```
301 (user model) ─┐
                  ├─> 303 (order model) ─> 304 (checkout flow)
302 (product model) ┘
```

---

## Example 4: Task with Labels and Milestones

### Input: tasks.md

```markdown
### Task 1: Implement Payment Gateway Integration

**Priority:** Critical
**Estimated Effort:** 12 hours
**Milestone:** v2.0
**Labels:** backend, payment, third-party
**Assignee:** @john-doe
**Dependencies:** None

**Description:**
Integrate Stripe payment gateway for subscription billing.

**Acceptance Criteria:**
- [ ] Set up Stripe account and get API keys
- [ ] Implement webhook handlers for payment events
- [ ] Create subscription plans in Stripe dashboard
- [ ] Test payment flow in sandbox environment
- [ ] Add error handling for failed payments
- [ ] Implement payment retry logic
```

### Output: GitHub Issue #401

**Title:** Task 1: Implement Payment Gateway Integration

**Labels:** `task`, `backend`, `payment`, `third-party`, `priority: critical`

**Milestone:** v2.0

**Assignee:** @john-doe

**Body:**

```markdown
# Task 1: Implement Payment Gateway Integration

## Description

Integrate Stripe payment gateway for subscription billing.

## Acceptance Criteria

- [ ] Set up Stripe account and get API keys
- [ ] Implement webhook handlers for payment events
- [ ] Create subscription plans in Stripe dashboard
- [ ] Test payment flow in sandbox environment
- [ ] Add error handling for failed payments
- [ ] Implement payment retry logic

## Metadata

- **Priority:** Critical
- **Estimated Effort:** 12 hours
- **Milestone:** v2.0
- **Labels:** backend, payment, third-party
- **Assignee:** @john-doe
- **Feature:** payment-integration
- **Source:** tasks.md
- **Task ID:** 1
```

---

## Example 5: Task List from Feature Branch

A complete workflow showing tasks.md in a feature branch being synced to GitHub issues.

### Repository Structure

```
my-project/
├── .github/
│   └── issue-tracking.json
├── features/
│   └── user-notifications/
│       ├── tasks.md
│       └── spec.md
└── README.md
```

### Input: features/user-notifications/tasks.md

```markdown
# User Notifications Feature - Tasks

## Implementation Tasks

### Task 1: Design Notification Schema

**Priority:** High
**Estimated Effort:** 3 hours
**Labels:** backend, database

**Description:**
Design and implement database schema for notifications.

**Subtasks:**
- [ ] Create notifications table
- [ ] Add indexes for user_id and created_at
- [ ] Create notification_types table
- [ ] Add foreign key constraints

### Task 2: Implement Notification Service

**Priority:** High
**Estimated Effort:** 6 hours
**Dependencies:** Task 1
**Labels:** backend, service

**Description:**
Create notification service for sending and managing notifications.

**Subtasks:**
- [ ] Create NotificationService class
- [ ] Implement createNotification method
- [ ] Implement getUserNotifications method
- [ ] Implement markAsRead method
- [ ] Add notification batching logic

### Task 3: Build Real-time WebSocket Handler

**Priority:** Medium
**Estimated Effort:** 4 hours
**Dependencies:** Task 2
**Labels:** backend, real-time

**Description:**
Set up WebSocket connections for real-time notification delivery.

**Subtasks:**
- [ ] Configure Socket.io server
- [ ] Implement connection authentication
- [ ] Create notification event emitters
- [ ] Add reconnection handling

### Task 4: Create Frontend Notification UI

**Priority:** Medium
**Estimated Effort:** 5 hours
**Dependencies:** Task 3
**Labels:** frontend, ui

**Description:**
Build notification dropdown and notification center UI.

**Subtasks:**
- [ ] Create NotificationDropdown component
- [ ] Create NotificationItem component
- [ ] Add unread count badge
- [ ] Implement mark all as read
- [ ] Add notification sound toggle
```

### Execution

**Command:**

```bash
# From project root
github copilot: "Use tasks-to-github-issues skill to sync features/user-notifications/tasks.md to GitHub issues"
```

### Output: GitHub Issues Created

**Issue #501: Task 1: Design Notification Schema**

- Labels: `task`, `backend`, `database`, `priority: high`
- Feature: user-notifications

**Issue #502: Task 2: Implement Notification Service**

- Labels: `task`, `backend`, `service`, `priority: high`
- Dependencies: Blocked by #501
- Feature: user-notifications

**Issue #503: Task 3: Build Real-time WebSocket Handler**

- Labels: `task`, `backend`, `real-time`, `priority: medium`
- Dependencies: Blocked by #502
- Feature: user-notifications

**Issue #504: Task 4: Create Frontend Notification UI**

- Labels: `task`, `frontend`, `ui`, `priority: medium`
- Dependencies: Blocked by #503
- Feature: user-notifications

### Updated Tracking File

`.github/issue-tracking.json`:

```json
{
  "feature": "user-notifications",
  "sync_date": "2026-01-26T14:20:00Z",
  "source_file": "features/user-notifications/tasks.md",
  "tasks": [
    {
      "task_id": 1,
      "title": "Design Notification Schema",
      "github_issue": 501,
      "url": "https://github.com/mycompany/my-project/issues/501",
      "labels": ["backend", "database"]
    },
    {
      "task_id": 2,
      "title": "Implement Notification Service",
      "github_issue": 502,
      "url": "https://github.com/mycompany/my-project/issues/502",
      "labels": ["backend", "service"],
      "depends_on": [501]
    },
    {
      "task_id": 3,
      "title": "Build Real-time WebSocket Handler",
      "github_issue": 503,
      "url": "https://github.com/mycompany/my-project/issues/503",
      "labels": ["backend", "real-time"],
      "depends_on": [502]
    },
    {
      "task_id": 4,
      "title": "Create Frontend Notification UI",
      "github_issue": 504,
      "url": "https://github.com/mycompany/my-project/issues/504",
      "labels": ["frontend", "ui"],
      "depends_on": [503]
    }
  ]
}
```

---

## Example 6: Handling Edge Cases

### Task with No Metadata

**Input:**

```markdown
## Tasks

1. Fix login bug
```

**Output: Issue #601**

```markdown
# Task 1: Fix login bug

## Metadata

- **Priority:** (not specified)
- **Estimated Effort:** (not specified)
- **Source:** tasks.md
- **Task ID:** 1
```

### Task with Invalid Dependency Reference

**Input:**

```markdown
## Tasks

1. Task A
   
2. Task B
   - Dependencies: Task 5
```

**Output:**

- Issue #701: Task A (created normally)
- Issue #702: Task B (created with warning comment about invalid dependency)

**Issue #702 body includes:**

```markdown
## Warning

⚠️ This task references an invalid dependency: Task 5 (not found in tasks.md)
```

### Duplicate Task Detection

If `.github/issue-tracking.json` already contains Task 1, the skill will:

1. Check if issue already exists
2. Skip creation with informational message:

   ```
   Task 1 already synced as Issue #101. Skipping duplicate creation.
   ```

3. Optionally offer to update existing issue

---

## Tips for Best Results

1. **Clear task titles** - Use descriptive titles that work well as GitHub issue titles
2. **Explicit dependencies** - Reference tasks by number (e.g., "Dependencies: Task 1, Task 2")
3. **Consistent metadata** - Use the same metadata format across all tasks
4. **Priority levels** - Use standardized priority levels: Critical, High, Medium, Low
5. **Effort estimates** - Use time-based estimates (hours) for clarity
6. **Label organization** - Use consistent label names that match your repository's label scheme
7. **Acceptance criteria** - Use checkbox format `- [ ]` for tracking
8. **Technical notes** - Include implementation details that help developers

---

## Reference

For main skill instructions and task parsing rules, see:

- [`SKILL.md`](../SKILL.md) - Main skill instructions
- [`templates/github-issue.md`](../templates/github-issue.md) - Issue template
