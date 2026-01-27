---
name: nuxtjs-mockup
description: Creates interactive UI mockups and prototypes using Nuxt 4, Vue 3, and Tailwind CSS 4 with Vite build tool. Builds responsive components, pages, and layouts from design specifications or wireframes. Use when creating mockups, prototypes, UI demos, design implementations, or when user mentions Nuxt prototype, Vue mockup, Tailwind demo, or interactive Vue demo.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "2.0"
  last-updated: "2026-01-27"
---

# Nuxt.js Mockup Skill

Creates interactive UI mockups and prototypes using the latest Nuxt 4 (Vue 3 framework) and Tailwind CSS 4 stack with Vite build tool. Transforms design specifications, wireframes, or user stories into functional, responsive web interfaces.

## When to Use

- Creating interactive UI mockups from designs
- Building clickable prototypes for user testing
- Implementing design specifications quickly with Vue.js
- Demonstrating UI concepts to stakeholders
- Rapid prototyping before full implementation
- Creating proof-of-concept Vue interfaces
- User mentions: "create mockup", "Nuxt prototype", "Vue demo", "Tailwind mockup", "interactive UI"

## Prerequisites

**Required:**

- Node.js 18.0.0+ (20+ recommended for Nuxt 4)
- npm 9+ or pnpm 8+ or yarn 1.22+ package manager
- Design specification or wireframe (digital or description)

**Optional but Recommended:**

- Design system documentation
- Brand guidelines (colors, typography, spacing)
- Asset files (logos, images, icons)
- User flow diagrams

**Check Prerequisites:**

```bash
# Bash
./skills/nuxtjs-mockup/scripts/check-nuxt-prerequisites.sh

# PowerShell
.\skills\nuxtjs-mockup\scripts\check-nuxt-prerequisites.ps1
```

## Technology Stack

**Latest Versions (January 2026):**
- Nuxt 4.3, Vue 3.5, Tailwind CSS 4.1, Vite 5.4, TypeScript 5.6

See [references/setup-guide.md](references/setup-guide.md#technology-stack-details) for complete version details and features.

## Instructions

### Phase 0: Specification and Requirements Gathering

**⚠️ IMPORTANT: Always request specification documents before starting implementation.**

1. **Request specification documents:**
   - Ask the user to provide design specifications, wireframes, or requirements documents
   - Request any relevant documentation: UI/UX designs, mockups, user stories, or feature descriptions
   - If no formal documentation exists, ask the user to describe:
     - Target pages or screens to be created
     - Key UI components needed
     - User interactions and flows
     - Branding guidelines (colors, fonts, style preferences)
     - Any example references or inspiration

2. **Review and confirm understanding:**
   - Summarize the requirements back to the user
   - Clarify any ambiguities or missing details
   - Confirm the scope and expected deliverables
   - Ask about any technical constraints or preferences

3. **Only proceed to Phase 1 after:**
   - Specification documents are provided and reviewed
   - Requirements are clearly understood
   - User confirms readiness to start implementation

### Phase 1: Project Setup and Initialization

See [references/setup-guide.md](references/setup-guide.md#project-setup-steps) for complete setup instructions including:

- Running prerequisite checks
- Initializing Nuxt 4 project
- Installing Tailwind CSS and dependencies
- Configuring Nuxt and Tailwind
- Project structure creation

**Quick Start:**

```bash
# Check prerequisites
./skills/nuxtjs-mockup/scripts/check-nuxt-prerequisites.sh

# Create project
pnpm create nuxt@latest mockup
cd mockup

# Install Tailwind CSS 4
pnpm add -D tailwindcss@next @tailwindcss/vite@next @nuxt/icon
```

### Phase 2: Design Analysis and Planning

1. **Analyze design input:**
   - **If design file exists**: Extract components, layout, colors, typography
   - **If wireframe**: Identify sections, interactions, navigation
   - **If description**: Parse requirements, features, user flows

2. **Create component inventory:**
   - List all UI components needed (buttons, cards, forms, etc.)
   - Identify reusable patterns
   - Note interactive elements (modals, dropdowns, tabs)
   - Map page structure and routing

3. **Define color palette** (from brand guidelines or generate):

   ```typescript
   // Example palette in tailwind.config.ts
   colors: {
     primary: {
       50: '#f0f9ff',
       500: '#3b82f6',
       900: '#1e3a8a',
     },
     // ... more colors
   }
   ```

4. **Plan component hierarchy:**

   ```
   Default Layout
   ├── Navigation
   ├── Hero
   ├── Features
   │   ├── FeatureCard
   │   └── FeatureGrid
   ├── CTA
   └── Footer
   ```

### Phase 3: Component Development

See [references/setup-guide.md](references/setup-guide.md#component-development-patterns) for complete component templates and best practices.

**Key Points:**
- Create base UI components in `components/ui/`
- Build custom components in `components/custom/`
- Use `<script setup>` with TypeScript
- Components are auto-imported by Nuxt
- Follow naming conventions (PascalCase)

### Phase 4: Page Implementation

See [references/setup-guide.md](references/setup-guide.md#page-structure-templates) for page templates and layout patterns.

**Key Points:**
- Create pages in `pages/` directory (file-based routing)
- Use layouts from `layouts/` directory
- Add SEO meta tags with `useHead()`
- Implement navigation with `<NuxtLink>`

### Phase 5: Interactivity and State

See [references/setup-guide.md](references/setup-guide.md#interactivity-patterns) for state management and composables.

**Key Points:**
- Use Vue 3 reactivity (`ref`, `reactive`, `computed`)
- Create composables for reusable logic
- Implement form submissions and interactions
- Keep state management simple for mockups

### Phase 6: Navigation and Routing

See [references/setup-guide.md](references/setup-guide.md#navigation-component) for navigation component template.

**Key Points:**
- Create navigation component with routes
- Use `<NuxtLink>` for client-side navigation
- Add active state styling
- Support mobile navigation patterns

### Phase 7: Polish and Optimization

See [references/setup-guide.md](references/setup-guide.md#performance-optimization) for optimization techniques.

**Checklist:**
- [ ] Responsive design tested (mobile, tablet, desktop)
- [ ] Performance optimized (lazy loading, image optimization)
- [ ] Accessibility checked (ARIA, keyboard nav, contrast)
- [ ] Browser testing completed

### Phase 8: Development Server and Preview

See [references/setup-guide.md](references/setup-guide.md#development-and-deployment) for deployment options.

**Commands:**
```bash
pnpm dev              # Start development server
pnpm build            # Build for production
pnpm preview          # Preview production build
nuxt generate         # Generate static site
```

### Phase 9: Documentation and Handoff

**Create README.md** with project overview, setup instructions, and component documentation.

**Document design decisions** and provide handoff assets for production implementation.

## Additional Resources

- [references/setup-guide.md](references/setup-guide.md) - Complete setup and development guide
- [references/EXAMPLES.md](references/EXAMPLES.md) - Detailed examples (landing pages, dashboards, e-commerce)
- [references/BEST_PRACTICES.md](references/BEST_PRACTICES.md) - Best practices and notes

## Success Criteria

- ✅ Nuxt 3 project initialized with latest versions
- ✅ Vite build tool configured and working
- ✅ All designed pages/views implemented
- ✅ Responsive design works on mobile, tablet, desktop
- ✅ Interactive elements function correctly
- ✅ Consistent styling using Tailwind CSS
- ✅ Components are reusable and well-organized
- ✅ Development server runs without errors
- ✅ Mockup is viewable and shareable

## Error Handling

See [references/setup-guide.md](references/setup-guide.md#error-handling) for complete error handling guide covering:

**Common Issues:**
- Node.js version mismatch
- Port already in use
- Module not found
- Tailwind classes not working
- Hydration errors
- Build errors

## Templates

The skill provides these templates:

- **templates/component-template.vue**: Reusable Vue component boilerplate
- **templates/page-template.vue**: Nuxt page structure
- **templates/layout-template.vue**: Layout wrapper
- **templates/app-template.vue**: Root app component
- **templates/tailwind.config.ts**: Tailwind configuration with theme
- **templates/tailwind.css**: Global styles and custom classes
- **templates/nuxt.config.ts**: Nuxt configuration template

## Scripts

Prerequisite check scripts:

- **scripts/check-nuxt-prerequisites.sh**: Bash script for Node.js, npm/pnpm/yarn validation
- **scripts/check-nuxt-prerequisites.ps1**: PowerShell script for Windows

## Examples

For detailed examples including landing pages, dashboards, and e-commerce catalogs with complete code, see [`references/EXAMPLES.md`](references/EXAMPLES.md).

## Notes

For important notes about Vite integration, auto-imports, TypeScript, deployment, and best practices, see [`references/BEST_PRACTICES.md`](references/BEST_PRACTICES.md).

Key highlights:

- Nuxt 4 uses Vite as default build tool with `@tailwindcss/vite` plugin
- Auto-imports for components, composables, and Vue APIs
- File-based routing in `pages/` directory
- Use `<script setup>` Composition API syntax
- TypeScript support out of the box
- Deploy to Vercel, Netlify, or Cloudflare Pages with zero config
