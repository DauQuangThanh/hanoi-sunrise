# 🌅 Hanoi Sunrise

## *Build Better Software with AI-Powered Specifications*

**Stop guessing. Start specifying.**  
Turn your ideas into production-ready applications through clear specifications, not trial-and-error coding.

---

## 💡 What is Spec-Driven Development?

**Traditional approach:** Write code first, figure it out as you go.  
**Spec-Driven approach:** Define what you want first, then let AI build it right.

For decades, we treated specifications as throwaway notes—just a formality before the "real" coding began. Spec-Driven Development flips this around: **your specification becomes the blueprint** that directly generates working code, not just a suggestion.

> **Think of it like architecture:** You wouldn't build a house without blueprints. Why build software without clear specifications?

## 🚀 Getting Started

**New to Hanoi Sunrise?** Follow these guides:

| Guide | Description |
| ------- | ------------- |
| 📦 [Installation Guide](installation.md) | Set up Sunrise CLI and prerequisites |
| ⚡ [Quick Start Guide](quickstart.md) | Build your first project in minutes |
| 🔄 [Upgrade Guide](upgrade.md) | Update to the latest version |
| 💻 [Local Development](local-development.md) | Contribute and develop locally |

### Project Workflows

**Choose your workflow based on project type:**

| Workflow | Best For | Timeline |
| ---------- | ---------- |----------|
| 🌱 [Greenfield](greenfield-workflow.md) | New applications from scratch | 2-4 weeks (MVP) |
| 🏗️ [Brownfield](brownfield-workflow.md) | Adding features to existing apps | 1-2 weeks/feature |

---

## 🎯 Available Commands

After installation, you'll have access to these slash commands in your AI assistant:

### Architecture: Commands + Skills

Hanoi Sunrise uses a modular two-layer architecture:

| Layer | Location | Purpose | Example |
| ------- | ---------- | --------- | --------- |
| **Agent Commands** | `agent-commands/` | User-facing slash commands | `/sunrise.specify` |
| **Agent Skills** | `skills/` | Reusable implementation modules | `requirements-specification/` |

When you run `sunrise init`:
- **Commands** are installed to agent-specific folders (`.github/agents/`, `.claude/commands/`, etc.)
- **Skills** are installed to agent-specific skill folders (`.github/skills/`, `.claude/skills/`, etc.)

This separation enables:
- ✅ Command customization without modifying core logic
- ✅ Skill reuse across commands and projects
- ✅ Multi-agent support (20+ AI assistants from a single skill set)

### Core Workflow Commands

Follow this complete workflow for Spec-Driven Development:

| Command | Purpose |
| --------- | ---------- |
| `/sunrise.set-ground-rules` | Set project principles and ground rules (Greenfield) |
| `/sunrise.assess-context` | Analyze existing codebase (Brownfield alternative to set-ground-rules) |
| `/sunrise.specify` | Define requirements and user stories |
| `/sunrise.clarify` | Clarify underspecified areas through structured questioning |
| `/sunrise.architect` | Design system architecture with C4 diagrams |
| `/sunrise.standardize` | Create coding standards and conventions |
| `/sunrise.design` | Create technical implementation plans |
| `/sunrise.taskify` | Break down into actionable tasks |
| `/sunrise.analyze` | Check consistency across specifications |
| `/sunrise.implement` | Execute all tasks and build the feature |

### Product-Level Commands

Run these once per product for end-to-end testing:

| Command | Purpose |
| --------- | ---------- |
| `/sunrise.design-e2e-test` | Design end-to-end test specifications |
| `/sunrise.perform-e2e-test` | Execute end-to-end tests |

### Enhancement Commands

Additional commands for project management and integration:

| Command | Purpose |
| --------- | ---------- |
| `/sunrise.checklist` | Generate quality validation checklists |
| `/sunrise.tasks-to-issues` | Convert tasks to GitHub issues |
| `/sunrise.tasks-to-ado` | Convert tasks to Azure DevOps work items |

---

## 🧩 Agent Skills

Behind each command is a **reusable skill module**. Sunrise includes **18 skills** that work across 20+ AI agents:

<details>
<summary><strong>View All Skills</strong></summary>

| Skill | Powers | Purpose |
| ------- | -------- | --------- |
| `requirements-specification` | `/sunrise.specify` | Feature specs from natural language |
| `requirements-specification-review` | `/sunrise.clarify` | Structured clarification |
| `technical-design` | `/sunrise.design` | Implementation plans |
| `technical-design-review` | `/sunrise.analyze` | Design validation |
| `project-management` | `/sunrise.taskify` | Task breakdown |
| `coding` | `/sunrise.implement` | Feature implementation |
| `architecture-design` | `/sunrise.architect` | System architecture |
| `coding-standards` | `/sunrise.standardize` | Coding conventions |
| `e2e-test-design` | `/sunrise.design-e2e-test` | E2E test specs |
| `project-ground-rules-setup` | `/sunrise.set-ground-rules` | Project principles |
| `context-assessment` | `/sunrise.assess-context` | Codebase analysis |
| `project-consistency-analysis` | `/sunrise.analyze` | Cross-artifact checks |
| `tasks-to-github-issues` | `/sunrise.tasks-to-issues` | GitHub sync |
| `tasks-to-azure-devops` | `/sunrise.tasks-to-ado` | Azure DevOps sync |
| Plus 4 more for code review, commits, and mockups | | |

**Skills are installed to agent-specific folders** like `.github/skills/`, `.claude/skills/`, `.gemini/extensions/`, etc.

</details>

---

## 🎯 Core Philosophy

Spec-Driven Development is built on these principles:

| Principle | What It Means |
| ----------- | --------------- |
| **Intent First** | Define the "*what*" and "*why*" before the "*how*" |
| **Rich Specifications** | Create detailed specs with organizational principles |
| **Step-by-Step** | Improve through multiple steps, not one-shot generation |
| **AI-Powered** | Use advanced AI to interpret specs and generate code |

## 🌟 When to Use This

| Scenario | What You Can Do |
| ---------- | ------------------ |
| **🆕 New Projects** | <ul><li>Start with high-level requirements</li><li>Generate complete specifications</li><li>Plan implementation steps</li><li>Build production-ready apps</li></ul> |
| **🔬 Exploration** | <ul><li>Try different solutions in parallel</li><li>Test multiple tech stacks</li><li>Experiment with UX patterns</li></ul> |
| **🔧 Existing Projects** | <ul><li>Add new features systematically</li><li>Modernize legacy code</li><li>Adapt processes to your needs</li></ul> |

## 🔬 What We're Exploring

Our experiments focus on making Spec-Driven Development work for real teams:

- **🔧 Tech Independence** - Build apps with any tech stack, proving this process works across languages and frameworks
- **🏢 Enterprise Ready** - Support organizational constraints: cloud providers, compliance requirements, design systems
- **👥 User Focused** - Build for different user needs and development styles (from exploratory coding to structured workflows)
- **🔄 Iterative & Creative** - Enable parallel exploration of solutions and robust workflows for modernization

---

## 🤝 Contributing

Want to help improve Hanoi Sunrise? Check our [Contributing Guide](https://github.com/dauquangthanh/hanoi-sunrise/blob/main/CONTRIBUTING.md) to get started.

**Ways to contribute:**

- 🐛 Report bugs or issues
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit code improvements

---

## 💬 Get Help

Need assistance?

- 📖 [Support Guide](https://github.com/dauquangthanh/hanoi-sunrise/blob/main/SUPPORT.md) - Common questions and solutions
- 🐛 [Open an Issue](https://github.com/dauquangthanh/hanoi-sunrise/issues/new) - Report bugs or request features
- 💭 [Discussions](https://github.com/dauquangthanh/hanoi-sunrise/discussions) - Ask questions and share ideas
