# Azure DevOps Work Item Template

This template is used to format task descriptions when creating Azure DevOps work items from tasks.md.

---

## Description

{task.description}

## Acceptance Criteria

{task.acceptance_criteria}

**Checklist:**

- [ ] {criterion_1}
- [ ] {criterion_2}
- [ ] {criterion_3}

## Technical Notes

{task.technical_notes}

**Implementation Details:**

- Architecture: {task.architecture_ref}
- Dependencies: {task.dependencies}
- Estimated Effort: {task.effort}

## Dependencies

### Blocked By

{dependency_list}

### Blocks

{blocked_tasks_list}

## Metadata

**Priority:** {task.priority}
**Effort:** {task.effort}
**Tags:** {task.tags}
**Feature:** {feature_name}
**Source Task:** {task_id}

## Related Documentation

- Architecture: {architecture_link}
- Specification: {spec_link}
- Design: {design_link}
- Tasks: {tasks_link}

---

**Auto-generated from tasks.md** | Last sync: {sync_timestamp}
