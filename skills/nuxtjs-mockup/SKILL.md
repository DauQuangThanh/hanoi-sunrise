---
name: nuxtjs-mockup
description: Creates interactive UI mockups and prototypes using Nuxt 4, Vue 3, and Tailwind CSS 4 with Vite build tool. Builds responsive components, pages, and layouts from design specifications or wireframes. Use when creating mockups, prototypes, UI demos, design implementations, or when user mentions Nuxt prototype, Vue mockup, Tailwind demo, or interactive Vue demo.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "2.0"
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

- **Nuxt 4.3**: Vue.js framework with powerful features
- **Vue 3.5**: Progressive JavaScript framework
- **Tailwind CSS 4.1**: Utility-first CSS with new engine
- **Vite 5.4**: Fast build tool (built into Nuxt 4)
- **TypeScript 5.6**: Type safety and better DX
- **@nuxt/ui**: Fully styled components built on Reka UI (optional)
- **@nuxt/icon**: Icon module with 200,000+ icons from Iconify

**Note:** Nuxt 4 uses Vite as its default build tool for both development and production.

## Instructions

### Phase 1: Project Setup and Initialization

1. **Run prerequisite check:**

   ```bash
   # Bash
   ./skills/nuxtjs-mockup/scripts/check-nuxt-prerequisites.sh --json
   
   # PowerShell
   .\skills\nuxtjs-mockup\scripts\check-nuxt-prerequisites.ps1 -Json
   ```

2. **Parse script output:**
   - `node_version`: Must be 18.0.0 or higher
   - `package_manager`: npm, pnpm, or yarn detected
   - `workspace_root`: Repository root path

3. **Initialize Nuxt 4 project** (if not exists):

   ```bash
   # Using pnpm (recommended)
   pnpm create nuxt@latest mockup
   
   # Or using npx
   npx create nuxt@latest mockup
   
   cd mockup
   ```

4. **Install Tailwind CSS and dependencies:**

   ```bash
   # Install Tailwind CSS 4 with Vite plugin
   pnpm add -D tailwindcss@next @tailwindcss/vite@next
   
   # Install additional utilities
   pnpm add class-variance-authority clsx tailwind-merge
   
   # Install icons (Nuxt icon module)
   pnpm add -D @nuxt/icon
   ```

5. **Configure Nuxt for Tailwind:**

   Update `nuxt.config.ts`:

   ```typescript
   export default defineNuxtConfig({
     modules: ['@nuxt/icon'],
     vite: {
       plugins: [
         require('@tailwindcss/vite')(),
       ],
     },
     css: ['~/assets/css/tailwind.css'],
     devtools: { enabled: true },
   })
   ```

6. **Create Tailwind CSS file:**

   Create `assets/css/tailwind.css`:

   ```css
   @import "tailwindcss";
   ```

7. **Project structure created:**

   ```
   mockup/
   ├── app.vue             # Root component
   ├── nuxt.config.ts      # Nuxt configuration
   ├── tailwind.config.ts  # Tailwind configuration
   ├── tsconfig.json       # TypeScript config
   ├── package.json
   ├── assets/
   │   └── css/
   │       └── tailwind.css
   ├── components/         # Auto-imported components
   │   ├── ui/            # Base UI components
   │   └── custom/        # Custom components
   ├── composables/       # Vue composables
   ├── layouts/           # Layout components
   ├── pages/             # File-based routing
   ├── public/            # Static assets
   └── server/            # API routes (optional)
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

1. **Create base UI components** in `components/ui/`:
   - Use template: `templates/component-template.vue`
   - Follow naming: PascalCase (e.g., `Button.vue`, `Card.vue`)
   - Components are auto-imported by Nuxt
   - Use TypeScript with `<script setup lang="ts">`

2. **Build custom components** in `components/custom/`:

   ```vue
   <!-- HeroSection.vue -->
   <script setup lang="ts">
   interface Props {
     title: string
     subtitle: string
     ctaText: string
   }
   
   const props = defineProps<Props>()
   const emit = defineEmits<{
     ctaClick: []
   }>()
   </script>
   
   <template>
     <section class="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
       <div class="container mx-auto px-4 text-center">
         <h1 class="text-5xl font-bold mb-4">{{ title }}</h1>
         <p class="text-xl text-gray-600 mb-8">{{ subtitle }}</p>
         <button 
           class="btn-primary"
           @click="emit('ctaClick')"
         >
           {{ ctaText }}
         </button>
       </div>
     </section>
   </template>
   ```

3. **Component best practices:**
   - Use `<script setup>` for concise syntax
   - Define props with TypeScript interfaces
   - Use `defineEmits` for custom events
   - Leverage Vue 3 Composition API
   - Auto-import composables from `composables/`

4. **Styling guidelines:**
   - Use Tailwind utility classes
   - Responsive breakpoints: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
   - Dark mode support: `dark:` variant
   - Animation: Use Tailwind animate utilities
   - Extract repeated patterns to custom classes in `assets/css/tailwind.css`

### Phase 4: Page Implementation

1. **Create pages in `pages/` directory:**

   ```
   pages/
   ├── index.vue           # Home (/)
   ├── about.vue           # About (/about)
   ├── features.vue        # Features (/features)
   └── contact.vue         # Contact (/contact)
   ```

2. **Page structure template:**

   ```vue
   <!-- pages/index.vue -->
   <script setup lang="ts">
   useHead({
     title: 'Home - Product Name',
     meta: [
       { name: 'description', content: 'Product description for SEO' }
     ]
   })
   
   const features = [
     { title: 'Feature 1', description: 'Description' },
     { title: 'Feature 2', description: 'Description' },
   ]
   </script>
   
   <template>
     <div>
       <HeroSection 
         title="Welcome to Our Product"
         subtitle="Build amazing things faster"
         cta-text="Get Started"
         @cta-click="handleClick"
       />
       <FeatureGrid :features="features" />
     </div>
   </template>
   ```

3. **Create layouts** in `layouts/` directory:

   ```vue
   <!-- layouts/default.vue -->
   <template>
     <div>
       <Navigation />
       <main>
         <slot />
       </main>
       <Footer />
     </div>
   </template>
   ```

4. **Use layouts in pages:**

   ```vue
   <script setup lang="ts">
   definePageMeta({
     layout: 'default'
   })
   </script>
   ```

### Phase 5: Interactivity and State

1. **Add client-side interactions:**
   - Use Vue 3 reactivity (`ref`, `reactive`, `computed`)
   - Implement form submissions
   - Add modal dialogs
   - Create dropdown menus
   - Toggle states (light/dark theme)

2. **State management approach:**
   - **Local state**: Use `ref()` and `reactive()` for component state
   - **Composables**: Extract reusable logic to `composables/`
   - **Global state**: Use Pinia (if needed for complex apps)
   - **Keep it simple**: Avoid heavy state management for mockups

3. **Example interactive component:**

   ```vue
   <script setup lang="ts">
   const count = ref(0)
   const submitted = ref(false)
   
   const handleSubmit = () => {
     submitted.value = true
     // Mockup: just show success state
   }
   </script>
   
   <template>
     <div v-if="submitted">
       Thank you! We'll be in touch.
     </div>
     <form v-else @submit.prevent="handleSubmit">
       <!-- Form fields -->
       <button type="submit">Submit</button>
     </form>
   </template>
   ```

4. **Use composables for reusable logic:**

   ```typescript
   // composables/useTheme.ts
   export const useTheme = () => {
     const isDark = ref(false)
     
     const toggleTheme = () => {
       isDark.value = !isDark.value
       // Toggle dark class on document
     }
     
     return { isDark, toggleTheme }
   }
   ```

### Phase 6: Navigation and Routing

1. **Navigation component:**

   ```vue
   <!-- components/Navigation.vue -->
   <script setup lang="ts">
   const navigation = [
     { name: 'Home', to: '/' },
     { name: 'Features', to: '/features' },
     { name: 'About', to: '/about' },
     { name: 'Contact', to: '/contact' },
   ]
   </script>
   
   <template>
     <header class="sticky top-0 z-50 bg-white border-b">
       <nav class="container mx-auto px-4 h-16 flex items-center justify-between">
         <NuxtLink to="/" class="text-xl font-bold">
           Logo
         </NuxtLink>
         <div class="flex space-x-6">
           <NuxtLink 
             v-for="item in navigation"
             :key="item.name"
             :to="item.to"
             class="text-gray-600 hover:text-gray-900"
             active-class="text-blue-600 font-semibold"
           >
             {{ item.name }}
           </NuxtLink>
         </div>
       </nav>
     </header>
   </template>
   ```

2. **Programmatic navigation:**

   ```typescript
   const router = useRouter()
   const navigateToPage = () => {
     router.push('/about')
   }
   ```

### Phase 7: Polish and Optimization

1. **Responsive design verification:**
   - Test all breakpoints: mobile (320px+), tablet (768px+), desktop (1024px+)
   - Ensure touch-friendly tap targets (min 44x44px)
   - Check text readability on all screen sizes
   - Verify image scaling and aspect ratios

2. **Performance optimization:**
   - Use `<NuxtImg>` component for optimized images
   - Lazy load components: `defineAsyncComponent`
   - Code splitting automatic with Nuxt
   - Use `<ClientOnly>` for browser-only components

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

### Phase 8: Development Server and Preview

1. **Start development server:**

   ```bash
   pnpm dev
   # or
   npm run dev
   ```

   - Server runs on <http://localhost:3000>
   - Hot module replacement (HMR) enabled via Vite
   - Instant updates on file changes

2. **Create preview build:**

   ```bash
   pnpm build
   pnpm preview
   ```

3. **Share mockup with stakeholders:**

   - **Local network**: Share local IP (e.g., <http://192.168.1.100:3000>)
   - **Deploy to Vercel/Netlify**: `vercel deploy` or `netlify deploy`
   - **Static export**: `nuxt generate` for static hosting

### Phase 9: Documentation and Handoff

1. **Create README.md** for the mockup:

   ```markdown
   # [Project Name] Mockup
   
   Interactive UI prototype built with Nuxt 3, Vue 3, and Tailwind CSS 4.
   
   ## Pages
   - Home: `/`
   - Features: `/features`
   - About: `/about`
   
   ## Running Locally
   \`\`\`bash
   pnpm install
   pnpm dev
   \`\`\`
   
   ## Build for Production
   \`\`\`bash
   pnpm build
   pnpm preview
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

### Common Issues

1. **Node.js Version Mismatch:**
   - Error: Nuxt 3 requires Node.js 18+
   - Action: Upgrade Node.js or use nvm/volta
   - Fix: `nvm install 20 && nvm use 20`

2. **Port Already in Use:**
   - Error: Port 3000 is already in use
   - Action: Kill process or use different port
   - Fix: `PORT=3001 pnpm dev`

3. **Module Not Found:**
   - Error: Cannot find module in components/
   - Action: Check component auto-import
   - Fix: Ensure file is in `components/` directory with proper naming

4. **Tailwind Classes Not Working:**
   - Error: Classes not applying styles
   - Action: Check Tailwind module configuration
   - Fix: Ensure `@nuxtjs/tailwindcss` is in modules array

5. **Hydration Errors:**
   - Error: Hydration mismatch
   - Action: Avoid mismatched client/server rendering
   - Fix: Use `<ClientOnly>` for browser-only code

6. **Build Errors:**
   - Error: Type errors or build failures
   - Action: Fix TypeScript types and imports
   - Fix: Run `pnpm typecheck` and `pnpm lint`

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
