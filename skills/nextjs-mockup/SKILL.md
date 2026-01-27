---
name: nextjs-mockup
description: Creates interactive UI mockups and prototypes using Next.js 16, React 19, and Tailwind CSS 4. Builds responsive components, pages, and layouts from design specifications or wireframes. Use when creating mockups, prototypes, UI demos, design implementations, or when user mentions Next.js prototype, Tailwind mockup, interactive demo, or UI prototype.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "2.0"
---

# Next.js Mockup Skill

Creates interactive UI mockups and prototypes using the latest Next.js (v16), React (v19), and Tailwind CSS (v4) stack. Transforms design specifications, wireframes, or user stories into functional, responsive web interfaces.

## When to Use

- Creating interactive UI mockups from designs
- Building clickable prototypes for user testing
- Implementing design specifications quickly
- Demonstrating UI concepts to stakeholders
- Rapid prototyping before full implementation
- Creating proof-of-concept interfaces
- User mentions: "create mockup", "Next.js prototype", "Tailwind demo", "interactive UI", "design implementation"

## Prerequisites

**Required:**

- Node.js 18.18+ (20+ recommended for Next.js 16)
- npm 9+ or pnpm 8+ package manager
- Design specification or wireframe (digital or description)

**Optional but Recommended:**

- Design system documentation
- Brand guidelines (colors, typography, spacing)
- Asset files (logos, images, icons)
- User flow diagrams

**Check Prerequisites:**

```bash
# Bash
./skills/nextjs-mockup/scripts/check-nextjs-prerequisites.sh

# PowerShell
.\skills\nextjs-mockup\scripts\check-nextjs-prerequisites.ps1
```

## Technology Stack

**Latest Versions (January 2026):**

- **Next.js 16.1**: React framework with App Router
- **React 19**: Latest with Server Components
- **Tailwind CSS 4.1**: Utility-first CSS with new engine
- **TypeScript 5.6**: Type safety and better DX
- **shadcn/ui**: Accessible component primitives (latest)
- **Lucide React**: Modern icon library

**Note:** Next.js uses its own optimized bundler (Turbopack in development, production webpack) and doesn't require Vite.

## Instructions

### Phase 1: Project Setup and Initialization

1. **Run prerequisite check:**

   ```bash
   # Bash
   ./skills/nextjs-mockup/scripts/check-nextjs-prerequisites.sh --json
   
   # PowerShell
   .\skills\nextjs-mockup\scripts\check-nextjs-prerequisites.ps1 -Json
   ```

2. **Parse script output:**
   - `node_version`: Must be 18.0.0 or higher
   - `package_manager`: npm or pnpm detected
   - `workspace_root`: Repository root path

3. **Initialize Next.js project** (if not exists):

   ```bash
   # Using pnpm (recommended)
   pnpm create next-app@latest mockup --typescript --tailwind --app --no-src-dir --import-alias "@/*"
   
   # Or using npm
   npx create-next-app@latest mockup --typescript --tailwind --app --no-src-dir --import-alias "@/*"
   ```

4. **Install additional dependencies:**

   ```bash
   cd mockup
   
   # UI components and utilities
   pnpm add lucide-react class-variance-authority clsx tailwind-merge
   
   # shadcn/ui (copy component files, don't install as package)
   pnpm dlx shadcn@latest init
   ```

5. **Project structure created:**

   ```

   mockup/
   ├── app/
   │   ├── layout.tsx          # Root layout
   │   ├── page.tsx            # Home page
   │   └── globals.css         # Global styles
   ├── components/
   │   ├── ui/                 # shadcn components
   │   └── custom/             # Custom components
   ├── lib/
   │   └── utils.ts            # Utility functions
   ├── public/                 # Static assets
   ├── tailwind.config.ts      # Tailwind configuration
   ├── tsconfig.json           # TypeScript config
   └── package.json
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
   Layout (Root)
   ├── Navigation
   ├── Hero
   ├── Features
   │   ├── FeatureCard
   │   └── FeatureGrid
   ├── CTA
   └── Footer
   ```

### Phase 3: Component Development

1. **Create base components using shadcn/ui:**

   ```bash
   # Add commonly used components
   pnpm dlx shadcn@latest add button
   pnpm dlx shadcn@latest add card
   pnpm dlx shadcn@latest add input
   pnpm dlx shadcn@latest add dialog
   pnpm dlx shadcn@latest add dropdown-menu
   ```

2. **Build custom components** in `components/custom/`:
   - Use template: `templates/component-template.tsx`
   - Follow naming: PascalCase (e.g., `HeroSection.tsx`)
   - Include TypeScript interfaces for props
   - Add JSDoc comments for documentation

3. **Component structure template:**

   ```typescript
   /**
    * HeroSection - Landing page hero with CTA
    * @param title - Main headline text
    * @param subtitle - Supporting text
    * @param ctaText - Call to action button text
    */
   interface HeroSectionProps {
     title: string;
     subtitle: string;
     ctaText: string;
     onCtaClick?: () => void;
   }
   
   export function HeroSection({ title, subtitle, ctaText, onCtaClick }: HeroSectionProps) {
     return (
       <section className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
         {/* Component implementation */}
       </section>
     );
   }
   ```

4. **Styling guidelines:**
   - Use Tailwind utility classes
   - Responsive breakpoints: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
   - Dark mode support: `dark:` variant
   - Animation: Use Tailwind animate utilities
   - Extract repeated patterns to custom classes in `globals.css`

### Phase 4: Page Implementation

1. **Create pages in `app/` directory:**

   ```
   app/
   ├── page.tsx              # Home (/)
   ├── about/page.tsx        # About (/about)
   ├── features/page.tsx     # Features (/features)
   └── contact/page.tsx      # Contact (/contact)
   ```

2. **Page structure template:**

   ```typescript
   import { HeroSection } from '@/components/custom/HeroSection';
   import { FeatureGrid } from '@/components/custom/FeatureGrid';
   
   export default function Home() {
     return (
       <main>
         <HeroSection 
           title="Welcome to Our Product"
           subtitle="Build amazing things faster"
           ctaText="Get Started"
         />
         <FeatureGrid features={features} />
       </main>
     );
   }
   ```

3. **Implement navigation:**
   - Create `components/custom/Navigation.tsx`
   - Add to root `app/layout.tsx`
   - Include responsive mobile menu
   - Support active link highlighting

4. **Add metadata for SEO:**

   ```typescript
   // In page.tsx
   export const metadata = {
     title: 'Product Name - Tagline',
     description: 'Product description for SEO',
   };
   ```

### Phase 5: Interactivity and State

1. **Add client-side interactions:**
   - Mark components with `'use client'` directive when needed
   - Implement form submissions
   - Add modal dialogs
   - Create dropdown menus
   - Toggle states (light/dark theme)

2. **State management approach:**
   - **Local state**: Use React `useState` for component-specific state
   - **Shared state**: Use React Context for theme, auth status
   - **Form state**: Use controlled components
   - **Keep it simple**: Avoid heavy state management for mockups

3. **Example interactive component:**

   ```typescript
   'use client';
   
   import { useState } from 'react';
   import { Button } from '@/components/ui/button';
   
   export function ContactForm() {
     const [submitted, setSubmitted] = useState(false);
     
     const handleSubmit = (e: React.FormEvent) => {
       e.preventDefault();
       setSubmitted(true);
       // Mockup: just show success state
     };
     
     return submitted ? (
       <div>Thank you! We'll be in touch.</div>
     ) : (
       <form onSubmit={handleSubmit}>
         {/* Form fields */}
       </form>
     );
   }
   ```

### Phase 6: Polish and Optimization

1. **Responsive design verification:**
   - Test all breakpoints: mobile (320px+), tablet (768px+), desktop (1024px+)
   - Ensure touch-friendly tap targets (min 44x44px)
   - Check text readability on all screen sizes
   - Verify image scaling and aspect ratios

2. **Performance optimization:**
   - Use Next.js Image component for all images
   - Enable font optimization (automatically handled by Next.js)
   - Minimize client-side JavaScript
   - Use Server Components by default (App Router)

3. **Accessibility checks:**
   - Semantic HTML elements (`<header>`, `<nav>`, `<main>`, `<footer>`)
   - ARIA labels for interactive elements
   - Keyboard navigation support
   - Color contrast ratios (WCAG AA minimum)
   - Alt text for all images

4. **Browser testing:**
   - Chrome/Edge (latest)
   - Firefox (latest)
   - Safari (latest)
   - Mobile browsers (iOS Safari, Chrome Android)

### Phase 7: Development Server and Preview

1. **Start development server:**

   ```bash
   pnpm dev
   # or
   npm run dev
   ```

   - Server runs on <http://localhost:3000>
   - Hot reload enabled for instant updates

2. **Create preview build** (optional):

   ```bash
   pnpm build
   pnpm start
   ```

3. **Share mockup with stakeholders:**
   - **Local network**: Share local IP (e.g., <http://192.168.1.100:3000>)
   - **Deploy to Vercel**: `vercel deploy` (free for mockups)
   - **Export static**: Configure static export if needed

### Phase 8: Documentation and Handoff

1. **Create README.md** for the mockup:

   ```markdown
   # [Project Name] Mockup
   
   Interactive UI prototype built with Next.js 16 and Tailwind CSS 4.
   
   ## Pages
   - Home: `/`
   - Features: `/features`
   - About: `/about`
   
   ## Running Locally
   \`\`\`bash
   pnpm install
   pnpm dev
   \`\`\`
   
   ## Components
   - HeroSection: Landing hero with CTA
   - FeatureGrid: Feature showcase grid
   - ContactForm: Contact form with validation
   ```

2. **Document design decisions:**
   - Color palette and rationale
   - Typography choices
   - Component patterns used
   - Any deviations from original design

3. **Provide handoff assets:**
   - Component library overview
   - Style guide (if created)
   - Asset sources and licensing
   - Next steps for full implementation

## Success Criteria

- ✅ Next.js project initialized with latest versions
- ✅ All designed pages/views implemented
- ✅ Responsive design works on mobile, tablet, desktop
- ✅ Interactive elements function correctly
- ✅ Consistent styling using Tailwind CSS
- ✅ Components are reusable and well-organized
- ✅ Development server runs without errors
- ✅ Mockup is viewable and shareable

## Error Handling

### Common Issues

1. **Node.js Version Mismatch:**
   - Error: Next.js 15 requires Node.js 18+
   - Action: Upgrade Node.js or use nvm/volta
   - Fix: `nvm install 20 && nvm use 20`

2. **Port Already in Use:**
   - Error: Port 3000 is already in use
   - Action: Kill process or use different port
   - Fix: `PORT=3001 pnpm dev`

3. **Module Not Found:**
   - Error: Cannot find module '@/components/...'
   - Action: Check import alias configuration
   - Fix: Verify `tsconfig.json` paths match

4. **Tailwind Classes Not Working:**
   - Error: Classes not applying styles
   - Action: Check Tailwind config content paths
   - Fix: Ensure `tailwind.config.ts` includes correct paths

5. **Hydration Errors:**
   - Error: Hydration failed because initial UI doesn't match
   - Action: Avoid mismatched client/server rendering
   - Fix: Use `useEffect` for browser-only code

6. **Build Errors:**
   - Error: Type errors or ESLint violations
   - Action: Fix TypeScript types and linting issues
   - Fix: Run `pnpm lint` and `pnpm type-check`

## Templates

The skill provides these templates:

- **templates/component-template.tsx**: Reusable component boilerplate
- **templates/page-template.tsx**: Next.js page structure
- **templates/layout-template.tsx**: Layout wrapper
- **templates/tailwind.config.ts**: Tailwind configuration with theme
- **templates/globals.css**: Global styles and custom classes

## Scripts

Prerequisite check scripts:

- **scripts/check-nextjs-prerequisites.sh**: Bash script for Node.js, npm/pnpm validation
- **scripts/check-nextjs-prerequisites.ps1**: PowerShell script for Windows

## Examples

For detailed examples including landing pages, dashboards, and e-commerce catalogs with complete code, see [`references/EXAMPLES.md`](references/EXAMPLES.md).

## Notes

For important notes about Next.js bundling, Server/Client Components, TypeScript, deployment, and best practices, see [`references/BEST_PRACTICES.md`](references/BEST_PRACTICES.md).

Key highlights:

- Next.js 16 uses Turbopack (dev) and Webpack (production) - **not Vite**
- Server Components by default, use `'use client'` only when needed
- Always use `<Image>` component for automatic optimization
- shadcn/ui recommended (copies components to your project)
- Deploy to Vercel with one command for free hosting
