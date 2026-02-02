# Command Validation Checklist

Use this checklist to systematically review agent commands before deployment.

## Basic Structure

- [ ] File is in correct directory for target agent
- [ ] File extension is correct (.md or .toml)
- [ ] File name follows conventions (lowercase, hyphens only)
- [ ] File name is descriptive and meaningful
- [ ] File name matches command purpose

## Frontmatter / Metadata

### For Markdown Commands

- [ ] Frontmatter starts with `---`
- [ ] Frontmatter ends with `---`
- [ ] `description` field is present
- [ ] Description is 10-80 characters
- [ ] Description starts with action verb
- [ ] Description is specific and actionable
- [ ] All fields use valid YAML syntax
- [ ] Strings are properly quoted
- [ ] No tabs (use spaces for indentation)

### For TOML Commands

- [ ] `description` field is present
- [ ] Description is properly quoted
- [ ] Description is 10-80 characters
- [ ] `prompt` field is present
- [ ] Prompt uses triple quotes `"""`
- [ ] Valid TOML syntax

### Agent-Specific Fields

**GitHub Copilot:**
- [ ] `mode` field is present (if applicable)
- [ ] Mode format is `project.command-name`
- [ ] Both parts of mode are lowercase

**Cursor:**
- [ ] `glob` pattern is valid (if applicable)
- [ ] Glob pattern matches intended files

**Google Antigravity:**
- [ ] `category` field is present (if applicable)
- [ ] Category is either "rules" or "skills"

## Content Structure

- [ ] Command has clear title (H1 heading)
- [ ] Title matches command name/purpose
- [ ] Only one H1 heading present
- [ ] H2 headings for major sections
- [ ] H3 headings for subsections
- [ ] Logical heading hierarchy (no skipped levels)

## Required Sections

- [ ] Purpose or Overview section present
- [ ] Instructions section present
- [ ] Output Format section present
- [ ] Examples section present (at least 2 examples)
- [ ] Arguments documentation (if command accepts arguments)

## Instructions Quality

- [ ] Instructions are numbered or bulleted
- [ ] Each step is clear and actionable
- [ ] Steps are in logical order
- [ ] No ambiguous language
- [ ] Specific file paths provided when needed
- [ ] Success criteria defined
- [ ] Complex tasks broken into phases
- [ ] Validation checkpoints included

## Output Format

- [ ] Output format is explicitly specified
- [ ] Exact file path is provided
- [ ] File format is stated (Markdown, JSON, YAML, etc.)
- [ ] Required structure/schema is shown
- [ ] Example of output provided
- [ ] All required fields are listed

## Examples

- [ ] At least 2 examples provided
- [ ] Each example has input
- [ ] Each example has expected output
- [ ] Examples cover different scenarios
- [ ] Examples are realistic and helpful
- [ ] Simple and complex cases shown
- [ ] Edge cases included

## Arguments

- [ ] All arguments are documented
- [ ] Required vs optional is marked
- [ ] Types are specified
- [ ] Default values are noted
- [ ] Usage examples are provided
- [ ] Correct argument syntax is used

### Argument Syntax

**For Markdown:**
- [ ] Uses `$ARGUMENTS` (not `{{args}}`)
- [ ] Arguments declaration is present

**For TOML:**
- [ ] Uses `{{args}}` (not `$ARGUMENTS`)
- [ ] Arguments are in prompt string

## Cross-Platform Compatibility

- [ ] Uses forward slashes `/` for paths
- [ ] No backslashes `\` in paths
- [ ] No absolute paths (use relative paths)
- [ ] No platform-specific commands
- [ ] No Windows-style paths (C:\, D:\)
- [ ] No hardcoded Unix paths (/usr/, /home/)

## Content Quality

- [ ] Clear and professional language
- [ ] No spelling errors
- [ ] No grammar errors
- [ ] Consistent formatting throughout
- [ ] Proper Markdown rendering
- [ ] Code blocks are properly fenced
- [ ] Code blocks have language tags
- [ ] Lists are properly formatted

## Error Handling

- [ ] Common errors are documented
- [ ] Error symptoms are described
- [ ] Solutions are provided
- [ ] Edge cases are addressed
- [ ] Validation steps are included
- [ ] Failure scenarios are covered

## Context Awareness

- [ ] References existing project structure
- [ ] Uses project-specific conventions
- [ ] Integrates with existing workflows
- [ ] Mentions related files/commands
- [ ] Follows established patterns

## Completeness

- [ ] All necessary information is included
- [ ] No critical gaps in instructions
- [ ] Prerequisites are listed
- [ ] Dependencies are documented
- [ ] Assumptions are stated
- [ ] Limitations are noted

## Testing

- [ ] Command has been tested with sample input
- [ ] Examples have been verified
- [ ] Output format has been validated
- [ ] Edge cases have been tested
- [ ] Works on target platform(s)
- [ ] No unexpected errors

## Documentation

- [ ] Purpose is clear and understandable
- [ ] Use cases are well-defined
- [ ] Benefits are explained
- [ ] Limitations are documented
- [ ] Related commands are referenced

## Final Review

- [ ] Runs validation script without errors
- [ ] Peer review completed (if applicable)
- [ ] Tested with real scenarios
- [ ] Ready for production use
- [ ] Added to README or documentation

---

## Scoring

Count the number of checked items:

- **90-100%**: Excellent - Ready for deployment
- **75-89%**: Good - Minor improvements needed
- **60-74%**: Fair - Significant improvements needed
- **Below 60%**: Poor - Major revision required

## Notes

Use this space to note specific issues or improvements:

```
[Your notes here]
```
