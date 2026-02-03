---
description: "Create detailed specification from user requirements"
---

# Feature Specification

## Purpose

Generate a comprehensive specification document for a new feature based on user requirements. This command helps translate high-level ideas into detailed, implementable specifications.

## Context

This command should be used early in the development process, before design or implementation begins. It requires a clear understanding of the feature's purpose and user needs.

## Instructions

### Phase 1: Gather Requirements

1. Analyze the feature description from $ARGUMENTS
2. Identify the target users and their needs
3. List functional and non-functional requirements
4. Determine success criteria

### Phase 2: Create Specification

1. Create a new file in `specs/[feature-name].md`
2. Document feature overview and objectives
3. Write detailed user stories
4. Specify technical requirements
5. Define API contracts if applicable
6. Include testing criteria

### Phase 3: Review and Validate

1. Verify all requirements are addressed
2. Check for conflicts with existing features
3. Ensure technical feasibility
4. Validate against project standards

## Output Format

Create `specs/[feature-name].md` with the following structure:

```markdown
# [Feature Name]

## Overview
[Brief description of the feature]

## User Stories
- As a [user type], I want to [action] so that [benefit]
- As a [user type], I want to [action] so that [benefit]

## Functional Requirements
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

## Non-Functional Requirements
- Performance: [criteria]
- Security: [criteria]
- Scalability: [criteria]

## Technical Specifications
- Architecture: [description]
- Data models: [description]
- APIs: [description]

## Testing Criteria
- Unit tests: [description]
- Integration tests: [description]
- Acceptance criteria: [list]

## Dependencies
- [Internal dependency 1]
- [External dependency 2]

## Timeline
- Estimated effort: [hours/days]
- Key milestones: [list]
```

## Examples

### Example 1: Simple Feature

**Input:** `/specify Create a user profile page with avatar upload`

**Output:** File `specs/user-profile.md` containing:

- User stories for viewing and editing profile
- Requirements for avatar upload (size, format, storage)
- Technical specs for profile API endpoints
- Security considerations for file uploads
- Testing criteria for profile functionality

### Example 2: Complex Feature

**Input:** `/specify Build a real-time collaborative document editor`

**Output:** File `specs/collaborative-editor.md` containing:

- User stories for multi-user editing
- Real-time synchronization requirements
- WebSocket protocol specifications
- Conflict resolution strategy
- Performance requirements for 100+ concurrent users
- Architecture diagram description
- Comprehensive testing strategy

## Arguments

$ARGUMENTS - Natural language description of the feature to specify

## Edge Cases

### Case 1: Vague Requirements

If the feature description is too vague, ask clarifying questions:

- Who are the target users?
- What problem does this solve?
- What are the key use cases?

### Case 2: Overly Complex Feature

If the feature is too large, suggest breaking it into smaller features:

- Identify core functionality
- Propose phases or milestones
- Recommend MVP scope

### Case 3: Conflicting Requirements

If requirements conflict with existing features:

- Document the conflict
- Propose resolution options
- Highlight tradeoffs

## Validation

Before considering the specification complete:

- [ ] All user stories are clear and testable
- [ ] Technical requirements are specific
- [ ] API contracts are fully defined
- [ ] Testing criteria cover all functionality
- [ ] Dependencies are identified
- [ ] Success metrics are measurable
