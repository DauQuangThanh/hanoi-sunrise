# ⚡ Quick Start Guide

**Build your first project with Spec-Driven Development in 9 steps.**

> **Note:** All scripts come in both Bash (`.sh`) and PowerShell (`.ps1`) versions. Sunrise CLI automatically picks the right one for your system unless you specify `--script sh|ps`.

---

## 🎯 The Workflow

Follow this order for best results:

> **💡 Automatic Version Control:** All Sunrise commands automatically generate appropriate git commit messages and commit changes upon completion using semantic commit prefixes (`docs:`, `feat:`, `test:`, `chore:`).

| Step | Command | Purpose |
| ------ | --------- |----------|
| 1️⃣ | `/sunrise.set-ground-rules` | Set ground rules (or use `/sunrise.assess-context` for existing projects) |
| 2️⃣ | `/sunrise.specify` | Define requirements |
| 3️⃣ | `/sunrise.clarify` | Clarify unclear requirements |
| 4️⃣ | `/sunrise.architect` | Design system architecture |
| 5️⃣ | `/sunrise.standardize` | Create coding standards |
| 6️⃣ | `/sunrise.design` | Create implementation plan |
| 7️⃣ | `/sunrise.taskify` | Break down into tasks |
| 8️⃣ | `/sunrise.analyze` | Validate consistency and coverage |
| 9️⃣ | `/sunrise.implement` | Build it! |

> **💡 Smart Context:** Sunrise automatically detects your active feature from your Git branch (like `001-feature-name`). To work on different features, just switch branches.

### 🧩 Behind the Scenes: Commands + Skills

Sunrise uses a modular architecture:

- **Agent Commands** (`agent-commands/`) - The `/sunrise.*` slash commands you use
- **Agent Skills** (`skills/`) - Reusable modules that power the commands (18 total)

When you run `sunrise init`, both are installed to your project in agent-specific folders:
- Commands → `.github/agents/`, `.claude/commands/`, `.gemini/commands/`, etc.
- Skills → `.github/skills/`, `.claude/skills/`, `.gemini/extensions/`, etc.

This design supports 20+ AI agents from a single codebase while keeping commands customizable and skills reusable.

---

## 🎭 Role-Based Agents

---

## 🚀 Let's Build Something

### Step 1: Install Sunrise

Run this in your terminal:

```bash
# Create a new project
uvx --from git+https://github.com/dauquangthanh/hanoi-sunrise.git sunrise init <PROJECT_NAME>

# OR work in current directory
uvx --from git+https://github.com/dauquangthanh/hanoi-sunrise.git sunrise init .
```

**Want a specific script type?**

```bash
# Force PowerShell
uvx --from git+https://github.com/dauquangthanh/hanoi-sunrise.git sunrise init <PROJECT_NAME> --script ps

# Force Bash
uvx --from git+https://github.com/dauquangthanh/hanoi-sunrise.git sunrise init <PROJECT_NAME> --script sh
```

---

### Step 2: Set Your Rules

In your AI agent, use the `/sunrise.set-ground-rules` command to set project principles:

```bash
/sunrise.set-ground-rules This project follows a "Library-First" approach. All features must be implemented as standalone libraries first. We use TDD strictly. We prefer functional programming patterns.
```

**What this does:** Creates ground rules that guide all future development decisions.

---

### Step 3: Write Your Specification

Describe **what** you want (not **how** to build it):

```bash
/sunrise.specify Build a photo organizer app. Albums are grouped by date and can be reorganized by drag-and-drop. Each album shows photos in a tile view. No nested albums allowed.
```

**Focus on:** User needs, features, and behavior—skip tech stack details for now.

### Step 4: Design System Architecture *(Optional)*

Document your overall system design (do this once per product):

```bash
/sunrise.architect Document the system architecture including C4 diagrams, microservices design, and technology stack decisions.
```

---

### Step 5: Set Coding Standards *(Optional)*

Create team coding conventions (do this once per product):

```bash
/sunrise.standardize Create comprehensive coding standards for TypeScript and React, including naming conventions and best practices.
```

---

### Step 6: Refine Your Spec *(Optional)*

Clarify any unclear requirements:

```bash
/sunrise.clarify Focus on security and performance requirements.
```

---

### Step 7: Create Technical Design

Now specify **how** to build it (tech stack and architecture):

```bash
/sunrise.design Use Vite with minimal libraries. Stick to vanilla HTML, CSS, and JavaScript. Store metadata in local SQLite. No image uploads.
```

**What to include:** Tech stack, frameworks, libraries, database choices, architecture patterns.

---

### Step 8: Break Down & Build

**Create tasks:**

```bash
/sunrise.taskify
```

**Validate the plan (optional):**

```bash
/sunrise.analyze
```

**Build it:**

```bash
/sunrise.implement
```

**What happens:** Your AI agent executes all tasks in order, building your application according to the plan.

---

## 📖 Complete Example: Building Taskify

**Project:** A team productivity platform with Kanban boards.

### 1. Set Ground Rules

```bash
/sunrise.set-ground-rules Taskify is "Security-First". Validate all user inputs. Use microservices architecture. Document all code thoroughly.
```

### 2. Define Requirements

```bash
/sunrise.specify Build Taskify, a team productivity platform. Users can create projects, add team members, assign tasks, comment, and move tasks between Kanban boards. Start with 5 predefined users: 1 product manager and 4 engineers. Create 3 sample projects. Use standard Kanban columns: To Do, In Progress, In Review, Done. No login required for this initial version.
```

### 3. Refine with Details

```bash
/sunrise.clarify For task cards: users can change status by dragging between columns, leave unlimited comments, and assign tasks to any user. Show a user picker on launch. Clicking a user shows their projects. Clicking a project opens the Kanban board. Highlight tasks assigned to current user in different color. Users can edit/delete only their own comments.
```

### 4. Validate Specification

```bash
/sunrise.checklist
```

### 5. Create Technical Plan

```bash
/sunrise.design Use .NET Aspire with Postgres database. Frontend: Blazor server with drag-and-drop and real-time updates. Create REST APIs for projects, tasks, and notifications.
```

### 6. Validate and Build

```bash
/sunrise.analyze
/sunrise.implement
```

---

## 🎯 Key Principles

| Principle | What It Means |
| ----------- | --------------- |
| **Be Explicit** | Clearly describe what and why you're building |
| **Skip Tech Early** | Don't worry about tech stack during specification |
| **Iterate** | Refine specs before implementation |
| **Validate First** | Check the plan before coding |
| **Let AI Work** | Trust the agent to handle implementation details |

---

## 📚 Next Steps

**Learn more:**

- 📖 [Complete Methodology](../spec-driven.md) - Deep dive into the full process
- 🔍 [More Examples](../templates) - Explore sample projects
- 💻 [Source Code](https://github.com/dauquangthanh/hanoi-sunrise) - Contribute to the project

**Get help:**

- 🐛 [Report Issues](https://github.com/dauquangthanh/hanoi-sunrise/issues/new) - Found a bug?
- 💬 [Ask Questions](https://github.com/dauquangthanh/hanoi-sunrise/discussions) - Need help?
