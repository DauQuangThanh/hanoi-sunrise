# Agent Skill Patterns

## Overview

Reusable patterns for creating different types of agent skills. Use these templates to accelerate skill development.

## Pattern Categories

1. **Analysis Skills**: Evaluate, review, or assess content
2. **Generation Skills**: Create new content or artifacts
3. **Transformation Skills**: Convert or modify existing content
4. **Workflow Skills**: Guide through multi-step processes
5. **Tool Skills**: Execute specific tools or commands
6. **Integration Skills**: Connect with external systems

---

## Pattern 1: Analysis Skill

**Use when**: Skill evaluates, reviews, or assesses content for quality, compliance, or specific criteria.

### Structure Template

```markdown
---
name: analysis-skill-name
description: "Analyzes [SUBJECT] for [CRITERIA_1], [CRITERIA_2], and [CRITERIA_3]. Use when reviewing [CONTEXT], performing [ACTIVITY], or when user mentions [KEYWORDS]."
---

# Analysis Skill Name

## Overview
[What gets analyzed and what criteria are evaluated]

## When to Use
- Reviewing [specific scenarios]
- Assessing [quality aspects]
- Evaluating [compliance requirements]

## Analysis Criteria

### 1. [Criterion Name]
- Check for [specific aspect]
- Look for [patterns or issues]
- Rate as [rating system]

### 2. [Criterion Name]
- Evaluate [another aspect]
- Identify [problems]
- Score using [metric]

## Output Format

**Analysis Report:**
````

\# Analysis Results

## Summary

[Overall assessment]

## Findings

### [Criterion 1]

- Finding: [description]
- Severity: [High/Medium/Low]
- Recommendation: [action]

### [Criterion 2]

...

````

## Examples

**Input:** [Example content to analyze]

**Output:**
```

[Sample analysis report]

```
```

### Real Example: Code Security Analyzer

```markdown
---
name: code-security-analyzer
description: "Analyzes code for security vulnerabilities including SQL injection, XSS, and authentication issues. Use when reviewing code security, conducting security audits, or when user mentions vulnerabilities, security concerns, or code review."
---

# Code Security Analyzer

## Analysis Criteria

### 1. Injection Vulnerabilities
- SQL injection patterns
- Command injection risks
- LDAP injection vectors

### 2. Authentication & Authorization
- Weak authentication mechanisms
- Missing authorization checks
- Session management issues

### 3. Data Exposure
- Sensitive data in logs
- Hardcoded credentials
- Insecure data storage

## Output Format

**Security Analysis Report:**
````

\# Security Analysis

## Summary

[X] Critical, [Y] High, [Z] Medium, [W] Low severity issues found

## Critical Issues

1. SQL Injection in user_login.py:45
   - Risk: Database compromise
   - Recommendation: Use parameterized queries

...

````
```

---

## Pattern 2: Generation Skill

**Use when**: Skill creates new content, documents, or code from specifications or requirements.

### Structure Template

```markdown
---
name: generation-skill-name
description: "Generates [OUTPUT_TYPE] from [INPUT_TYPE] with [FEATURES]. Use when creating [CONTEXTS], or when user mentions [KEYWORDS]."
---

# Generation Skill Name

## Overview
[What this skill generates and from what inputs]

## When to Use
- Creating [new artifacts]
- Generating [documentation]
- Producing [outputs]

## Input Requirements

**Required:**
- [Input element 1]
- [Input element 2]

**Optional:**
- [Optional element]

## Generation Process

### Step 1: Parse Input
[How to extract information from input]

### Step 2: Generate Structure
[How to organize the output]

### Step 3: Populate Content
[How to fill in details]

### Step 4: Format Output
[How to structure final result]

## Output Format

[Detailed specification of generated output]

## Examples

**Input:**
```

[Sample input]

```

**Output:**
```

[Generated result]

```
```

### Real Example: API Documentation Generator

```markdown
---
name: api-documentation-generator
description: "Generates comprehensive API documentation from code with endpoints, parameters, authentication details, and examples. Use when creating API docs, documenting REST APIs, or when user mentions API documentation, OpenAPI, or swagger."
---

# API Documentation Generator

## Input Requirements

**Required:**
- Source code with API endpoints
- HTTP methods and routes
- Request/response schemas

**Optional:**
- Authentication requirements
- Rate limiting info
- Example requests

## Generation Process

### Step 1: Extract Endpoints
Scan code for:
- Route decorators (@app.route, @get, etc.)
- HTTP methods
- Path parameters

### Step 2: Parse Parameters
For each endpoint, identify:
- Path parameters
- Query parameters
- Request body schema
- Headers

### Step 3: Generate Documentation
Create structured documentation:

```markdown
## GET /api/users/{id}

**Description**: Retrieves user by ID

**Parameters:**
- `id` (path, required): User identifier

**Response:** 200 OK
\```json


  "email": "john@example.com"


**Errors:**
- 404: User not found
- 401: Unauthorized
```

---

## Pattern 3: Transformation Skill

**Use when**: Skill converts content from one format to another or modifies existing content.

### Structure Template

```markdown
---
name: transformation-skill-name
description: "Transforms [INPUT_FORMAT] to [OUTPUT_FORMAT] with [FEATURES]. Use for [CONVERSIONS], or when user mentions [KEYWORDS]."
---

# Transformation Skill Name

## Overview
[What formats are converted and what transformations are applied]

## Supported Transformations

### [Input Format] → [Output Format]
- Conversion rules
- Handling of special cases
- Mapping specifications

## Transformation Process

### Step 1: Validate Input
[Input validation steps]

### Step 2: Parse Source Format
[How to extract data]

### Step 3: Transform Data
[Transformation rules]

### Step 4: Generate Output Format
[Output generation steps]

## Examples

**Input ([Format]):**
```

[Sample input]

```

**Output ([Format]):**
```

[Transformed output]

```
```

### Real Example: CSV to JSON Converter

```markdown
---
name: csv-to-json-converter
description: "Converts CSV files to JSON format with schema validation and data type inference. Use for data format conversion, API data preparation, or when user mentions CSV to JSON, data transformation, or format conversion."
---

# CSV to JSON Converter

## Supported Transformations

### CSV → JSON Array
Converts CSV rows to JSON array of objects

### CSV → JSON Objects
Converts CSV to nested JSON structure

## Transformation Process

### Step 1: Detect CSV Structure
- Identify delimiter (comma, semicolon, tab)
- Detect header row
- Infer column data types

### Step 2: Parse CSV
- Read rows
- Handle escaped values
- Process empty cells

### Step 3: Transform to JSON
- Map headers to keys
- Convert data types (string → number, boolean)
- Handle null values

### Step 4: Generate Output
Choose format:
- Array: `[{obj1}, {obj2}, ...]`
- Object: `{"key1": {obj1}, "key2": {obj2}}`

## Examples

**Input (CSV):**
```csv
id,name,age,active
1,Alice,30,true
2,Bob,25,false
```

**Output (JSON Array):**

```json
[
  {"id": 1, "name": "Alice", "age": 30, "active": true},
  {"id": 2, "name": "Bob", "age": 25, "active": false}
]
```

```

---

## Pattern 4: Workflow Skill

**Use when**: Skill guides through a multi-step process or complex procedure.

### Structure Template

```markdown
---
name: workflow-skill-name
description: "Guides through [PROCESS] including [PHASE_1], [PHASE_2], and [PHASE_3]. Use for [ACTIVITIES], or when user mentions [KEYWORDS]."
---

# Workflow Skill Name

## Overview
[What process is guided and what phases are involved]

## Prerequisites
- [Required setup]
- [Access or permissions needed]
- [Tools required]

## Workflow Phases

### Phase 1: [Phase Name]
**Objective:** [What this phase accomplishes]

**Steps:**
1. [Action 1]
   - Details...
2. [Action 2]
   - Details...

**Validation:**
- [ ] [Check 1]
- [ ] [Check 2]

### Phase 2: [Phase Name]
[Similar structure]

### Phase 3: [Phase Name]
[Similar structure]

## Post-Workflow

**Verification:**
- [ ] [Final check 1]
- [ ] [Final check 2]

**Cleanup:**
- [Cleanup action 1]
- [Cleanup action 2]
```

### Real Example: Deployment Workflow

```markdown
---
name: deployment-workflow
description: "Guides through complete deployment process including pre-deployment checks, building, deploying, and post-deployment verification. Use for application deployments, release management, or when user mentions deploy, release, or production deployment."
---

# Deployment Workflow

## Prerequisites
- Git repository with source code
- CI/CD pipeline configured
- Deployment credentials set
- Access to production environment

## Workflow Phases

### Phase 1: Pre-Deployment Checks
**Objective:** Ensure code is ready for deployment

**Steps:**
1. Run test suite: `npm test`
   - All tests must pass
   - Code coverage ≥ 80%

2. Review pending PRs
   - All PRs merged or closed
   - No open critical issues

3. Update version
   - Bump version: `npm version patch`
   - Update CHANGELOG.md

**Validation:**
- [ ] All tests passing
- [ ] No pending PRs
- [ ] Version updated

### Phase 2: Build
**Objective:** Create production build

**Steps:**
1. Install dependencies: `npm ci`
2. Build production bundle: `npm run build`
3. Run security audit: `npm audit --production`

**Validation:**
- [ ] Build completed successfully
- [ ] No critical vulnerabilities

### Phase 3: Deploy
**Objective:** Deploy to production

**Steps:**
1. Create git tag: `git tag v1.0.0`
2. Push tag: `git push origin v1.0.0`
3. Deploy: `./scripts/deploy.sh production`
4. Wait for deployment completion

**Validation:**
- [ ] Deployment successful
- [ ] Application responding

### Phase 4: Post-Deployment
**Objective:** Verify deployment and monitor

**Steps:**
1. Run smoke tests: `./scripts/smoke-test.sh`
2. Check application health: `curl https://api.example.com/health`
3. Monitor error rates for 15 minutes
4. Update documentation

**Validation:**
- [ ] Smoke tests passing
- [ ] Health check OK
- [ ] Error rates normal

## Rollback Procedure

If issues detected:
1. Execute rollback: `./scripts/rollback.sh`
2. Notify team
3. Investigate issues
4. Plan corrective deployment
```

---

## Pattern 5: Tool Skill

**Use when**: Skill wraps or orchestrates a specific tool or command-line utility.

### Structure Template

```markdown
---
name: tool-skill-name
description: "Executes [TOOL] for [PURPOSES]. Use when [SCENARIOS], or when user mentions [KEYWORDS]."
---

# Tool Skill Name

## Overview
[What tool is used and what it accomplishes]

## Prerequisites
- [Tool name] version [X.X]+
- [Dependencies]

## Installation

[Installation instructions]

## Usage

### Basic Usage
```bash
[tool-command] [basic-args]
```

### Advanced Usage

```bash
[tool-command] [advanced-args]
```

## Common Tasks

### Task 1: [Task Name]

**Command:**

```bash
[specific-command]
```

**Explanation:** [What it does]

### Task 2: [Task Name]

[Similar structure]

## Troubleshooting

**Issue:** [Common problem]
**Solution:** [How to fix]

```

### Real Example: Git Workflow Tool

```markdown
---
name: git-workflow
description: "Executes Git operations for branching, committing, merging, and resolving conflicts. Use for version control tasks, managing branches, or when user mentions git, version control, branches, or merges."
---

# Git Workflow

## Prerequisites
- Git 2.0+
- Configured user.name and user.email

## Common Tasks

### Task 1: Create Feature Branch
**Command:**
```bash
git checkout -b feature/new-feature
```

**Explanation:** Creates and switches to new feature branch

### Task 2: Commit Changes

**Command:**

```bash
git add .
git commit -m "feat: add new feature"
```

**Explanation:** Stages and commits changes with conventional commit message

### Task 3: Update from Main

**Command:**

```bash
git checkout main
git pull origin main
git checkout feature/new-feature
git merge main
```

**Explanation:** Keeps feature branch up to date with main

### Task 4: Push Branch

**Command:**

```bash
git push -u origin feature/new-feature
```

**Explanation:** Pushes branch to remote and sets up tracking

```

---

## Pattern 6: Integration Skill

**Use when**: Skill connects with external APIs, services, or systems.

### Structure Template

```markdown
---
name: integration-skill-name
description: "Integrates with [SERVICE] for [PURPOSES]. Use when [SCENARIOS], or when user mentions [KEYWORDS]."
---

# Integration Skill Name

## Overview
[What service is integrated and what operations are supported]

## Prerequisites
- [Service] account
- API key or credentials
- Network access to [service]

## Configuration

### Setup
1. Obtain API key from [service]
2. Set environment variable:
   ```bash
   export SERVICE_API_KEY="your-key-here"
   ```

## Operations

### Operation 1: [Operation Name]

**Purpose:** [What it does]

**Request:**

```http
GET /api/endpoint HTTP/1.1
Host: api.service.com
Authorization: Bearer $API_KEY
```

**Response:**

```json
{
  "data": "..."
}
```

### Operation 2: [Operation Name]

[Similar structure]

## Error Handling

**Error Code:** 401
**Meaning:** Unauthorized
**Action:** Check API key validity

```

### Real Example: GitHub Integration

```markdown
---
name: github-integration
description: "Integrates with GitHub API for repository management, pull requests, issues, and workflows. Use when working with GitHub repositories, managing PRs, or when user mentions GitHub API, repositories, or pull requests."
---

# GitHub Integration

## Prerequisites
- GitHub account
- Personal access token with repo scope
- `curl` or `gh` CLI tool

## Configuration

### Setup GitHub CLI
```bash
gh auth login
```

## Operations

### Operation 1: List Pull Requests

**Purpose:** Retrieve open PRs for repository

**Command:**

```bash
gh pr list --repo owner/repo --state open
```

**Output:**

```
#123  Fix bug in authentication  feature/auth-fix  author
#124  Add new API endpoint       feature/api       author
```

### Operation 2: Create Issue

**Purpose:** Create new issue in repository

**Command:**

```bash
gh issue create \
  --repo owner/repo \
  --title "Bug: Authentication fails" \
  --body "Description of the issue"
```

### Operation 3: Merge Pull Request

**Purpose:** Merge approved PR

**Command:**

```bash
gh pr merge 123 --merge --delete-branch
```

## Error Handling

**Error:** "authentication required"
**Action:** Run `gh auth login` to authenticate

**Error:** "resource not found"
**Action:** Verify repository name and access permissions

```

---

## Combining Patterns

Some skills combine multiple patterns. For example:

### Analysis + Generation

Analyze code → Generate report

### Transformation + Validation

Convert format → Validate output

### Workflow + Tool

Guide process → Execute commands at each step

**Example: Code Review Workflow**
```markdown
# Code Review Workflow

## Phase 1: Analysis (Analysis Pattern)
- Review code quality
- Check security
- Assess performance

## Phase 2: Generate Report (Generation Pattern)
- Create structured report
- Include findings
- Add recommendations

## Phase 3: Create Issue (Integration Pattern)
- Post findings to GitHub
- Assign reviewers
- Set labels
```

---

## Choosing the Right Pattern

1. **What is the primary purpose?**
   - Evaluate → Analysis
   - Create → Generation
   - Convert → Transformation
   - Guide → Workflow
   - Execute → Tool
   - Connect → Integration

2. **Does it fit multiple patterns?**
   - Use primary pattern as base
   - Incorporate secondary patterns as needed

3. **Is there a similar example?**
   - Start with closest pattern
   - Adapt to specific needs

---

## Pattern Selection Guide

| Task | Pattern | Example |
|------|---------|---------|
| Review code | Analysis | code-security-analyzer |
| Create docs | Generation | api-documentation-generator |
| Convert format | Transformation | csv-to-json-converter |
| Guide deployment | Workflow | deployment-workflow |
| Execute git | Tool | git-workflow |
| Call GitHub API | Integration | github-integration |
| Audit + Report | Analysis + Generation | security-audit |
| Process + Validate | Transformation + Tool | data-processor |

---

## Tips for Using Patterns

1. **Start with template**: Copy pattern structure
2. **Customize for domain**: Replace placeholders with specific content
3. **Add examples**: Include concrete use cases
4. **Document edge cases**: Address special situations
5. **Keep focused**: Don't combine too many patterns
6. **Validate structure**: Ensure follows specification

---

**Remember**: These patterns are starting points. Adapt them to your specific needs while maintaining consistency with the Agent Skills specification.
