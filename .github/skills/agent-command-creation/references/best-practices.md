# Agent Command Creation Best Practices

Comprehensive best practices for creating high-quality agent commands across all supported platforms.

## General Principles

### 1. Clarity and Specificity

**Always be explicit about intent and expected outcomes.**

✅ **Good**:
> "Analyze the current codebase for security vulnerabilities, focusing on SQL injection, XSS, and authentication flaws. Provide a ranked list with severity levels and remediation steps."

❌ **Bad**:
> "Help with code"

**Why**: The good example is specific, actionable, and defines clear outcomes. The bad example is too vague.

### 2. Single Responsibility

**Each command should have one clear purpose.**

✅ **Good**: Separate commands for:

- `analyze-security.md` - Security analysis only
- `analyze-performance.md` - Performance analysis only
- `analyze-quality.md` - Quality analysis only

❌ **Bad**: One monolithic command:

- `analyze-everything.md` - Does security, performance, quality all in one

**Why**: Single-purpose commands are easier to maintain, test, and understand.

### 3. Composition Over Monoliths

**Design commands to work together, not in isolation.**

✅ **Good**: Chain commands

```bash
/specify feature-name     # Create specification
/implement specs/feature.md  # Implement from spec
/validate src/feature/    # Validate implementation
```

❌ **Bad**: One massive command that tries to do everything

**Why**: Composition provides flexibility and reusability.

## Naming Conventions

### Command Names

**Pattern**: `[verb]-[noun].md` or `[verb]-[noun].toml`

✅ **Good Examples**:

- `analyze-security.md` - Clear action + target
- `generate-tests.md` - Obvious purpose
- `validate-code.md` - Specific function
- `review-pr.md` - Concise and descriptive

❌ **Bad Examples**:

- `do-stuff.md` - Too vague
- `SecurityAnalysis.md` - Capital letters
- `analyze_security.md` - Underscores
- `cmd1.md` - Not descriptive
- `the-big-analyzer.md` - Too wordy

### Mode Names (GitHub Copilot)

**Pattern**: `project.command-name`

✅ **Good Examples**:

- `vinh.specify` - Project prefix + action
- `myapp.review` - Clear project association
- `project.validate` - Standard format

❌ **Bad Examples**:

- `specify` - Missing project prefix
- `vinh_specify` - Underscore instead of dot
- `VINH.SPECIFY` - Capital letters

## Description Writing

### Structure

**Pattern**: `[Action verb] [object] [optional: method/constraint]`

**Length**: Under 80 characters when possible

✅ **Good Examples**:

- "Analyze codebase for security vulnerabilities and generate report"
- "Create detailed specification from user requirements"
- "Generate comprehensive unit tests for specified code"
- "Validate code against project standards and best practices"

❌ **Bad Examples**:

- "This command does some analysis stuff" - Too vague
- "Helper function for various things" - No clear action
- "A really comprehensive and detailed analyzer that looks at your code and finds all sorts of different issues" - Too long

### Tips

1. **Start with action verb**: analyze, create, generate, validate, review, implement
2. **Include outcome**: "and generate report", "with remediation steps"
3. **Be specific**: Don't just say "check code", say "analyze security vulnerabilities"
4. **Keep it concise**: Aim for 10-15 words

## Command Structure

### Essential Sections

Every command should include:

#### 1. Purpose Section

Explains what the command does and when to use it.

```markdown
## Purpose

Analyze the codebase for security vulnerabilities including SQL injection,
XSS, authentication flaws, and insecure dependencies. Use this command
before production releases or after major code changes.
```

#### 2. Context Section

Describes what information is needed.

```markdown
## Context

- Target files/directories: $ARGUMENTS
- Security standards: docs/security-standards.md
- Previous audit results: docs/audits/
- OWASP Top 10 guidelines
```

#### 3. Instructions Section

Step-by-step guidance for the AI.

```markdown
## Instructions

### Phase 1: Discovery
1. Scan specified files/directories
2. Identify potential vulnerabilities
3. Categorize by type (SQL injection, XSS, etc.)

### Phase 2: Analysis
1. Assess severity (Critical, High, Medium, Low)
2. Determine exploitability
3. Estimate impact

### Phase 3: Reporting
1. Generate detailed report
2. Provide remediation steps
3. Prioritize by risk
```

#### 4. Output Format Section

Specifies expected results.

```markdown
## Output Format

Create `security-audit-[date].md` with:

- Executive summary
- Vulnerability breakdown by severity
- Detailed findings with code examples
- Remediation recommendations
- Compliance checklist
```

#### 5. Examples Section (Optional but Recommended)

Provides concrete usage examples.

```markdown
## Examples

Basic usage:
/analyze-security src/auth

Multiple directories:
/analyze-security src/auth src/api

With specific focus:
/analyze-security src/ # All source files
```

## Phase-Based Commands

For complex tasks, break into phases with clear checkpoints.

### Structure

```markdown
### Phase 1: [Name]
**Entry Criteria**: [What must be true to start]
**Steps**:
1. Step one
2. Step two
**Exit Criteria**: [What must be true to finish]
**Output**: [What this phase produces]

### Phase 2: [Name]
**Entry Criteria**: [Dependencies on Phase 1]
**Steps**:
1. Step one
2. Step two
**Exit Criteria**: [Completion requirements]
**Output**: [Deliverables]
```

### Example

```markdown
### Phase 1: Analysis
**Entry Criteria**: Specification file exists
**Steps**:
1. Read specification
2. Review existing code
3. Identify integration points
**Exit Criteria**: Analysis document complete
**Output**: `analysis-[feature].md`

### Phase 2: Implementation
**Entry Criteria**: Analysis approved
**Steps**:
1. Create file structure
2. Implement core logic
3. Add error handling
**Exit Criteria**: All tests passing
**Output**: Implemented feature code
```

## Validation and Quality Gates

### Include Checklists

```markdown
## Quality Gates

Before marking as complete:
- [ ] All requirements implemented
- [ ] Tests passing (coverage > 80%)
- [ ] Code follows standards
- [ ] Documentation updated
- [ ] Security review passed
- [ ] Performance benchmarks met
```

### Validation Sections

```markdown
## Validation

Check these requirements:
✓ Description is clear and under 80 characters
✓ File name follows naming convention
✓ All required sections present
✓ Correct argument syntax
✓ Output format specified
✓ Examples provided
```

## Error Handling

### Guide the AI on Error Scenarios

```markdown
## Error Handling

### If specification file not found:
1. Check common locations (specs/, docs/, .docs/)
2. List available specification files
3. Ask user for correct path

### If dependencies missing:
1. List required dependencies
2. Provide installation command
3. Wait for confirmation before proceeding

### If validation fails:
1. Report specific failures
2. Provide remediation guidance
3. Offer to fix automatically if possible
```

## Platform-Specific Best Practices

### Markdown-Based Platforms

```markdown
✅ Use clear hierarchy with ##, ###, ####
✅ Use bullet lists for steps
✅ Use numbered lists for sequences
✅ Include code blocks with language tags
✅ Use $ARGUMENTS for user input
```

### TOML-Based Platforms

```toml
✅ Keep description single-line
✅ Use triple quotes for prompt
✅ Escape special characters in strings
✅ Use {{args}} for user input
✅ Test TOML syntax validity
```

### GitHub Copilot Specific

```markdown
✅ Include mode field for slash commands
✅ Use pattern: project.command-name
✅ Keep mode names lowercase
✅ Test in VS Code with Copilot
```

### Cursor Specific

```markdown
✅ Consider .mdc format for auto-trigger rules
✅ Use glob patterns for file matching
✅ Test rule activation logic
```

## Prompt Engineering Techniques

### 1. Chain-of-Thought

Encourage step-by-step reasoning:

```markdown
Think through this systematically:

1. **First**, understand the overall context
2. **Then**, analyze each component
3. **Next**, identify patterns or issues
4. **After that**, propose solutions
5. **Finally**, validate your approach

Think out loud as you work through each step.
```

### 2. Role-Based Prompting

Assign expertise:

```markdown
You are a senior security engineer with 15 years of experience in:
- OWASP Top 10 vulnerabilities
- Penetration testing
- Secure code review
- Cryptography

Approach this task from that perspective.
```

### 3. Few-Shot Learning

Provide examples:

```markdown
## Example 1: Valid Pattern

✅ Good:
\`\`\`typescript
const user = await User.findById(userId);
if (!user) throw new NotFoundError();
\`\`\`

## Example 2: Anti-Pattern

❌ Bad:
\`\`\`typescript
const user = await User.findById(userId);
return user.name; // Can crash if user is null
\`\`\`

Now analyze: $ARGUMENTS
```

## Testing Your Commands

### Manual Testing Checklist

```yaml
✓ Command creates/finds correct files
✓ Arguments are properly received
✓ Output format is correct
✓ Error handling works
✓ Examples are accurate
✓ Works on all target platforms
```

### Test Scenarios

1. **Happy path**: Normal usage with valid inputs
2. **Edge cases**: Empty inputs, special characters, very long inputs
3. **Error conditions**: Missing files, invalid arguments, permission issues
4. **Multiple invocations**: Can command be run multiple times safely?

## Documentation Standards

### Inline Comments

```markdown
# Command Name

<!-- This command performs X. It should be used when Y. -->
<!-- Author: [Name] -->
<!-- Last Updated: [Date] -->

## Purpose
[Explanation...]
```

### Usage Documentation

Always include:

```markdown
## Usage

/command-name [required-arg] [optional-arg]

## Arguments

- `required-arg`: Description (required)
- `optional-arg`: Description (optional, default: value)

## Examples

Basic:
/command-name value

Advanced:
/command-name value --option
```

## Common Pitfalls

### ❌ Pitfall 1: Ambiguous Instructions

**Bad**:

```markdown
Analyze the code and fix issues.
```

**Good**:

```markdown
1. Scan code for TypeScript errors
2. Identify patterns violating ESLint rules
3. For each issue, provide:
   - Location (file:line)
   - Problem description
   - Suggested fix with code example
```

### ❌ Pitfall 2: Missing Output Specification

**Bad**:

```markdown
Generate a report.
```

**Good**:

```markdown
Create `analysis-report.md` with:
- Summary (3-5 sentences)
- Metrics table (issues by severity)
- Detailed findings (one section per issue)
- Recommendations (prioritized list)
```

### ❌ Pitfall 3: Wrong Argument Syntax

**Bad** (Markdown platform):

```markdown
Target: {{args}}  # WRONG - This is TOML syntax
```

**Good**:

```markdown
Target: $ARGUMENTS  # CORRECT for Markdown
```

### ❌ Pitfall 4: No Validation

**Bad**: Command doesn't check if it succeeded

**Good**:

```markdown
## Validation

After completion, verify:
- [ ] All files created
- [ ] Tests passing
- [ ] No linting errors
- [ ] Documentation updated
```

### ❌ Pitfall 5: Monolithic Commands

**Bad**: One command tries to do everything

**Good**: Break into focused commands that compose

## Maintenance

### Versioning

Consider adding version info:

```markdown
---
description: "Command description"
version: 1.2.0
last_updated: 2026-01-28
---
```

### Change Log

Document significant changes:

```markdown
## Change Log

### v1.2.0 (2026-01-28)
- Added error handling for missing files
- Improved output formatting
- Added validation checklist

### v1.1.0 (2026-01-15)
- Initial release
```

## Additional Resources

For more information, see the other files in this skill:

- `platform-matrix.md` - Complete platform support matrix with folder configurations
- `argument-syntax-guide.md` - Comprehensive argument syntax reference for all platforms
- `cross-platform-scripts.md` - Guide for developing cross-platform automation scripts
- `../templates/` - Ready-to-use command templates for different scenarios
- `../SKILL.md` - Main skill instructions with step-by-step guidance
