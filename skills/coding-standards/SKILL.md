---
name: coding-standards
description: Generates comprehensive coding standards and conventions documentation covering UI naming (mandatory for frontend), code naming, file structure, API design, database conventions, testing, Git workflow, documentation standards, and code style guide. Use when creating product-level standards, establishing coding conventions, standardizing development practices, or when user mentions standards, conventions, style guide, naming conventions, or code quality guidelines.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last-updated: "2026-01-27"
---

# Coding Standards Generation Skill

## Overview

This skill generates comprehensive coding standards and conventions documentation for an entire product. It creates a standards document (`docs/standards.md`) that covers all aspects of development: UI naming conventions (mandatory for frontend projects), code naming, file and directory structure, API design, database conventions, testing standards, Git workflow, documentation standards, and code style guide.

The skill performs best practices research specific to the project's technology stack and generates enforcement configurations (.editorconfig, linter configs) along with quick reference guides.

## When to Use

Activate this skill when:

- Creating product-level coding standards and conventions
- Establishing naming conventions for UI components, code, APIs, and databases
- Standardizing development practices across the team
- Defining file structure and project organization standards
- Setting up code quality and style guidelines
- Creating enforcement configurations for linters and formatters
- User mentions: "standards", "conventions", "style guide", "naming conventions", "code quality", "best practices"

**Timing**: Run this AFTER ground-rules and architecture are defined, but BEFORE creating feature implementation plans.

## Prerequisites

**Required Files:**

- `docs/ground-rules.md` - Project principles and constraints
- `docs/architecture.md` - Technology stack and architectural decisions (highly recommended)

**Optional Files:**

- `specs/*/spec.md` - Feature specifications for naming pattern analysis
- Existing `docs/standards.md` - For updates to existing standards

**Validation:**

Use the prerequisite checking scripts to verify required files exist:

**Bash (macOS/Linux):**

```bash
scripts/check-standards-prerequisites.sh
```

**PowerShell (Windows):**

```powershell
.\scripts\check-standards-prerequisites.ps1
```

**JSON Output (for parsing):**

```bash
scripts/check-standards-prerequisites.sh --json
.\scripts\check-standards-prerequisites.ps1 -Json
```

**What the scripts check:**

- Presence of `docs/ground-rules.md` (required)
- Presence of `docs/architecture.md` (recommended)
- Presence of feature specifications in `specs/`
- Existing `docs/standards.md` (for updates)

## Instructions

### Setup Phase

1. **Run prerequisite script** to detect required files:
   - Execute the appropriate script for your platform
   - Parse JSON output to get file paths
   - Verify `ground-rules.md` exists (required)
   - Note if `architecture.md` exists (highly recommended for tech stack context)

2. **Read context files** in order:
   - **MUST READ**: `docs/ground-rules.md` for project principles
   - **MUST READ IF EXISTS**: `docs/architecture.md` for technology stack
   - **READ ALL**: Feature specs from `specs/*/spec.md` for naming pattern analysis
   - **READ IF EXISTS**: Existing `docs/standards.md` for updates

3. **Create docs/ directory** if it doesn't exist:

   ```bash
   mkdir -p docs
   ```

4. **Prepare standards template** location: `docs/standards.md`

### Phase 0: Standards Analysis & Best Practices Research

**Goal**: Analyze project context and research technology-specific best practices.

1. **Analyze project context**:
   - Parse `architecture.md` to identify:
     - Programming languages (Python, Java, TypeScript, Go, etc.)
     - Backend frameworks (Django, Spring Boot, Express, etc.)
     - Frontend frameworks (React, Vue, Angular, Svelte, etc.)
     - Database systems (PostgreSQL, MongoDB, MySQL, etc.)
     - API protocols (REST, GraphQL, gRPC, etc.)
     - Testing frameworks (Jest, Pytest, JUnit, etc.)

2. **Detect UI layer presence** (critical for Phase 1):
   - **Check architecture.md** for frontend frameworks:
     - React, Vue, Angular, Svelte, Solid
     - React Native, Flutter, SwiftUI, Xamarin
     - HTML/CSS/JavaScript
   - **Check repository structure** for UI directories:
     - `src/components/`, `src/ui/`, `frontend/`, `client/`
     - `lib/widgets/`, `Views/`, `screens/`
   - **Check feature specs** for UI requirements:
     - UI mockups, wireframes, component specifications
     - User interface descriptions, screen flows
   - **Determine project type**:
     - ✅ **Frontend/UI project**: Has UI layer → Phase 1 is MANDATORY
     - ❌ **Backend-only**: No UI layer → Phase 1 documents "N/A"

3. **Research best practices** for each detected technology:
   - **For UI frameworks**: "{framework} component naming conventions best practices"
     - Example: "React component naming conventions", "Vue composable naming"
   - **For backend languages**: "{language} naming conventions style guide"
     - Example: "Python PEP 8 naming conventions", "Java naming conventions"
   - **For databases**: "{database} naming conventions best practices"
     - Example: "PostgreSQL table naming conventions", "MongoDB collection naming"
   - **For APIs**: "RESTful API naming conventions", "GraphQL schema naming"
   - **For design systems**: "{design system} naming conventions"
     - Example: "Material Design naming", "Bootstrap class naming"

4. **Research domain-specific conventions**:
   - Web applications: Component naming, CSS class naming, accessibility attributes
   - Mobile applications: Screen naming, view controller naming, navigation patterns
   - API services: Endpoint naming, HTTP methods, status codes, error formats
   - Desktop applications: Window naming, event handler naming, command patterns

**Output**:

- Section 1 (Introduction) drafted with project context
- Technology stack identified
- UI layer presence determined
- Best practices research completed for all technologies

### Phase 1: UI Naming Convention Standards

**Prerequisites:** Phase 0 complete, UI layer presence determined

**CRITICAL RULE**:

- ✅ **If frontend/UI project**: This phase is MANDATORY and must be comprehensive
- ❌ **If backend-only project**: Document "N/A - No UI layer" and skip to Phase 2

**Applicability Check**:

- ✅ REQUIRED: Web apps, mobile apps, desktop GUI apps, design systems, component libraries
- ❌ SKIP: Pure REST APIs, CLI tools, background services, data pipelines

**If UI project, document comprehensively:**

1. **Component/Widget naming** - Name format (PascalCase/kebab-case), Props/Attributes (camelCase), Event handlers (handle*/on*), State variables
2. **CSS/Styling naming** - Methodology (BEM/utility/semantic), ID rules, CSS-in-JS, Style files
3. **File naming for UI** - Component files, Style files, Test files, Story files
4. **Directory structure** - Component patterns, Asset organization, Shared components
5. **Accessibility naming** - ARIA attributes, Roles, Label associations, Landmarks
6. **Framework-specific** - React (hooks, Context, HOC), Vue (composables, directives), Angular (services, pipes), Native mobile
7. **Do's and Don'ts** - Clear examples vs cryptic anti-patterns
8. **Common anti-patterns** - Generic names, inconsistent casing, missing semantics

**For detailed examples and patterns, see:** [`references/ui-naming-patterns.md`](references/ui-naming-patterns.md)

**If backend-only project:**

- Document: "## 2. UI Naming Conventions\n\n**N/A** - This project has no UI layer."

**Output**: Section 2 (UI Naming Conventions) - comprehensive for UI projects, or "N/A" for backend-only

### Phase 2: Code Naming Convention Standards

**Prerequisites:** Phase 1 complete

**Goal**: Define naming conventions for all code elements (variables, functions, classes, modules).

Document the following categories:

1. **Variable naming** - Local variables (camelCase/snake_case), Constants (SCREAMING_SNAKE_CASE), Global variables, Class/Instance variables
2. **Function/Method naming** - Verb-based descriptive names, Getter/Setter conventions, Boolean function prefixes (is/has/should/can), Constructor naming
3. **Class/Type naming** - Classes (PascalCase, noun-based), Interfaces (with/without 'I' prefix), Enums, Type aliases, Generic parameters
4. **Module/Package naming** - Module names (language-specific format), Package hierarchies, Namespace conventions, Import aliases

**For detailed examples and language-specific patterns, see:** [`references/code-naming-patterns.md`](references/code-naming-patterns.md)

**Output**: Section 3 (Code Naming Conventions) completed with language-specific examples

### Phase 3: File, Directory & Project Structure Standards

**Prerequisites:** Phase 2 complete

**Goal**: Define file naming and directory organization standards.

Document the following:

1. **File naming** - Source code files (match class/module name), Test files (suffix/prefix), Configuration files (lowercase), Documentation files (uppercase)
2. **Directory structure** - Source organization (feature-based vs layer-based), Test directory structure, Asset/config/docs directories
3. **Project structure patterns** - Monorepo vs multi-repo criteria, Shared code organization, Build output directories, Vendor code

**For detailed examples and structure patterns, see:** [`references/file-api-patterns.md`](references/file-api-patterns.md)

**Output**: Section 4 (File and Directory Structure) completed with project-specific patterns

### Phase 4: API, Database & Integration Standards

**Prerequisites:** Phase 3 complete

**Goal**: Define API design and database naming standards.

Document based on project's integration patterns:

1. **REST API standards** (if applicable) - Endpoint naming (plural nouns), HTTP methods usage, Query parameters, Request/Response structure, Error formats, Versioning
2. **GraphQL standards** (if applicable) - Type naming (PascalCase), Field naming (camelCase), Query/Mutation naming, Input type naming
3. **Database conventions** (if applicable) - Table names (plural, snake_case), Column names (singular), Primary/Foreign keys, Index naming, Constraint naming, View/Procedure naming

**For detailed examples and patterns, see:** [`references/file-api-patterns.md`](references/file-api-patterns.md)

**Output**: Section 5 (API and Database Standards) completed with applicable patterns

### Phase 5: Testing, Git, Documentation & Code Style Standards

**Prerequisites:** Phase 4 complete

**Goal**: Define testing conventions, Git workflow, documentation, and code quality standards in a unified phase.

Document these comprehensive standards:

1. **Testing Standards**:
   - Test naming (should_expect_when_condition pattern), File naming (.test., .spec.), Coverage targets (80% minimum)
   - Test organization (AAA pattern), Framework-specific patterns (Jest, Pytest, JUnit, Go testing)

2. **Git Workflow**:
   - Branch naming (feat/, fix/, chore/), Commit messages (Conventional Commits format), PR/MR templates, Tag naming (semantic versioning)

3. **Documentation**:
   - README structure, Code comments (when/why not what), Docstrings/JSDoc format, API documentation (OpenAPI/Swagger)

4. **Code Style & Quality**:
   - Formatting (indentation, line length, brace style), Import organization (standard→third-party→local)
   - Quality limits (complexity <10, function length <50 lines, file length <500 lines)
   - Linting tools by language (ESLint, Pylint, Checkstyle, golint), Formatter configs (Prettier, Black, gofmt)

**Output**: Sections 6-10 (Testing, Git, Documentation, Code Quality, Code Style) completed

### Phase 6: Finalization & Quick Reference Guides

**Prerequisites:** Phase 5 complete

**Goal**: Generate enforcement configurations and quick reference guides.

1. **Generate enforcement configs** - `.editorconfig`, Linter configs (`.eslintrc.js`, `.pylintrc`, etc.), Formatter configs (`.prettierrc`, `pyproject.toml`), Pre-commit hooks (Husky, pre-commit)

       ```python
       # Standard library
       import os
       import sys
       
       # Third-party
       import requests
       import pandas as pd
       
       # Local
       from .models import User
       from .services import UserService
       ```

2. **Code quality standards**:
   - Complexity limits (cyclomatic <10, cognitive <15)
   - Length limits (functions <50 lines, files <500 lines)
   - Duplication thresholds (<3% duplicate code)
   - Code smell detection (long parameters >5, deep nesting >4, God classes >500 lines/20 methods)

3. **Linting and formatting tools**:
   - Linter configs per language (ESLint/.eslintrc.js, Pylint/.pylintrc, Checkstyle/checkstyle.xml, golint, RuboCop/.rubocop.yml)
   - Formatter configs (Prettier/.prettierrc.json, Black/pyproject.toml, gofmt, google-java-format, rustfmt/rustfmt.toml)
   - Pre-commit hooks (Husky for JS, pre-commit for Python, lefthook) to run linters/formatters before commit

**Output**: Section 10 (Code Style Guide) completed with language-specific configurations

### Phase 6: Finalization & Quick Reference Guides

**Prerequisites:** Phase 5 complete

**Goal**: Generate enforcement configurations, quick reference guides, and finalize standards document.

1. **Generate enforcement tool configurations**:

   - **`.editorconfig`** (cross-editor settings) with charset, EOL, indentation rules per file type
   - **Linter configuration files** (`.eslintrc.js`, `.pylintrc`, etc.) based on project languages with naming and style rules
   - **Formatter configuration files** (`.prettierrc.json`, `pyproject.toml`) with line length, indentation settings
   - **Pre-commit hook scripts** (`.husky/pre-commit` or `.pre-commit-config.yaml`) to run linters, formatters, and tests

2. **Create quick reference guides**:

   - **`docs/standards-cheatsheet.md`**: One-page condensed reference with naming conventions, code style, Git workflow, testing standards
   - **`docs/ui-naming-quick-ref.md`** (if UI project): UI-specific quick reference for components, CSS, event handlers, state

3. **Validate standards document**:
   - Ensure all sections complete: Introduction, UI Naming (if applicable), Code Naming, File Structure, API/Database (if applicable), Testing, Git, Documentation, Code Style
   - Check consistency with architecture.md and ground-rules.md
   - Verify all examples use project-specific technologies
   - Ensure UI naming conventions are detailed (MANDATORY for frontend/UI projects)

4. **Output file locations**: `docs/standards.md` (main document), `docs/standards-cheatsheet.md` (quick reference), `docs/ui-naming-quick-ref.md` (if UI), `.editorconfig`, linter configs, formatter configs, pre-commit hooks

**Output**: Complete `docs/standards.md`, quick reference guides, enforcement configurations

## Success Criteria

The standards document is complete and ready when:

- [ ] **UI naming conventions** are comprehensive and detailed (MANDATORY for frontend/UI projects)
- [ ] For backend-only projects, Section 2 documents "N/A - No UI layer"
- [ ] All code elements have naming conventions defined with examples
- [ ] File/directory structure documented with project-specific patterns
- [ ] API/database standards specified (if applicable)
- [ ] Testing standards documented with coverage requirements
- [ ] Git workflow and commit message conventions defined
- [ ] Documentation standards specified with templates
- [ ] Code style guide complete with formatting rules
- [ ] All conventions have concrete, language-specific examples using project technologies
- [ ] Enforcement tool configurations generated
- [ ] Quick reference guides created
- [ ] Standards consistent with architecture.md and ground-rules.md
- [ ] `docs/standards.md` committed with "docs: add coding standards" message

## Error Handling

**Common Errors and Solutions:**

1. **Error**: `ground-rules.md not found`
   - **Cause**: Required ground-rules file missing
   - **Action**: Create `docs/ground-rules.md` with project principles first, or specify the correct path

2. **Error**: `architecture.md not found`
   - **Cause**: Recommended architecture file missing
   - **Action**: Create `docs/architecture.md` with technology stack, or proceed with limited context (will need manual tech stack input)

3. **Error**: UI naming section incomplete for frontend project
   - **Cause**: UI project detected but UI naming conventions not detailed
   - **Action**: Expand Section 2 with all required UI naming elements (components, props, CSS, files, accessibility, framework-specific)

4. **Error**: Naming conventions conflict with ground-rules
   - **Cause**: Proposed standards violate ground-rules constraints
   - **Action**: Review ground-rules.md and align standards, or update ground-rules if principle changed

5. **Error**: Examples don't match project tech stack
   - **Cause**: Used generic examples instead of project-specific technologies
   - **Action**: Re-read architecture.md, replace examples with actual project languages/frameworks

## Templates

Use the provided template for standards document generation:

**Template Location**: `templates/standards-document.md`

The template includes:

- Complete document structure with all sections
- Placeholder guidance for each section
- Example formats for naming conventions
- Research prompt suggestions
- Enforcement configuration templates

## Examples

For detailed examples including full-stack web applications, backend APIs, mobile apps, and microservices, see [`references/EXAMPLES.md`](references/EXAMPLES.md).

## Notes

- **Product-level standards**: This skill creates standards for the ENTIRE product, not individual features
- **Run timing**: Execute AFTER ground-rules and architecture, BEFORE feature design/implementation
- **UI naming is critical**: For frontend/UI projects, UI naming conventions MUST be comprehensive - this is non-negotiable
- **Backend-only exception**: Only skip detailed UI naming if project has NO UI layer (pure APIs, CLI, workers)
- **Technology-specific**: All examples and configurations must match the project's actual tech stack
- **Consistency**: Standards must align with ground-rules.md and architecture.md
- **Enforcement**: Standards should be enforced through automated tools (linters, formatters, pre-commit hooks)
- **Living document**: Update standards.md as the project evolves and new patterns emerge
- **Team review**: Consider having the team review and approve standards before full enforcement
- **Incremental adoption**: Can adopt standards gradually (start with naming, then add code style, then enforcement)

## Additional Resources

For more detailed guidance, see:

- `templates/standards-document.md` - Complete standards document template with all sections
- Agent Skills specification - For skill creation best practices
- Project ground-rules - For understanding project principles
- Project architecture - For technology stack context

## Version History

- **v1.0** (2026-01-26): Initial release
  - Complete 7-phase standards generation workflow
  - UI naming conventions (mandatory for frontend)
  - Code, file, API, database, testing, Git, documentation standards
  - Code quality and style guide
  - Enforcement configurations and quick reference guides
