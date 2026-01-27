# Nuxt.js Best Practices & Notes

Important notes and best practices for creating mockups with Nuxt 4, Vue 3, and Tailwind CSS 4.

## Vite Integration

Nuxt 4 uses Vite as its default build tool. Tailwind CSS 4 is integrated via the `@tailwindcss/vite` plugin. Vite provides:

- **Instant HMR**: See changes immediately without full page reload
- **Fast builds**: Optimized for development and production
- **Native ESM**: Modern module system for better performance
- **Plugin ecosystem**: Rich collection of Vite plugins

**Configuration in nuxt.config.ts:**

```typescript
export default defineNuxtConfig({
  vite: {
    plugins: [
      require('@tailwindcss/vite')()
    ]
  }
})
```

## Version Management

Always use latest stable versions. Check npm for updates:

```bash
# Check current versions
npm view nuxt version              # Currently v4.3.0
npm view vue version                # Currently v3.5.0
npm view tailwindcss@next version   # Currently v4.1.0

# Update dependencies
pnpm update
```

**Version ranges in package.json:**

- Use `^` for minor/patch updates: `"nuxt": "^4.3.0"`
- Pin exact versions for critical deps: `"@tailwindcss/vite": "4.1.0"`

## Auto-imports

Nuxt automatically imports components, composables, and Vue APIs. No explicit imports needed!

**Automatically imported:**

```vue
<script setup lang="ts">
// No imports needed for these:
const count = ref(0)                    // Vue ref
const router = useRouter()              // Nuxt composable
const route = useRoute()                // Nuxt composable
const { data } = useFetch('/api/data')  // Nuxt composable

// Components are also auto-imported:
// <MyComponent /> - no import statement required
</script>
```

**Custom auto-imports:**

Configure in `nuxt.config.ts`:

```typescript
export default defineNuxtConfig({
  imports: {
    dirs: [
      'composables',
      'utils',
      'stores'
    ]
  }
})
```

## File-based Routing

Pages in the `pages/` directory automatically become routes. No manual route configuration needed.

**File structure → Routes:**

```
pages/
├── index.vue           → /
├── about.vue           → /about
├── users/
│   ├── index.vue       → /users
│   ├── [id].vue        → /users/:id (dynamic)
│   └── settings.vue    → /users/settings
└── [...slug].vue       → catch-all route
```

**Dynamic parameters:**

```vue
<!-- pages/users/[id].vue -->
<script setup lang="ts">
const route = useRoute()
const userId = route.params.id

// Or use definePageMeta for type safety
definePageMeta({
  validate: (route) => {
    return /^\d+$/.test(route.params.id as string)
  }
})
</script>
```

## Composition API

Prefer `<script setup>` syntax for cleaner, more concise components.

**Old Options API (avoid):**

```vue
<script>
export default {
  data() {
    return { count: 0 }
  },
  methods: {
    increment() {
      this.count++
    }
  }
}
</script>
```

**Modern Composition API (preferred):**

```vue
<script setup lang="ts">
const count = ref(0)
const increment = () => count.value++
</script>
```

**Benefits:**

- Better TypeScript support
- More readable and maintainable
- Easier to extract logic into composables
- Less boilerplate code

## Image Optimization

Use `<NuxtImg>` component from `@nuxt/image` module instead of `<img>` for automatic optimization.

**Installation:**

```bash
pnpm add @nuxt/image
```

**Usage:**

```vue
<template>
  <!-- Regular img (not optimized) -->
  <img src="/images/hero.jpg" alt="Hero" />
  
  <!-- NuxtImg (optimized) -->
  <NuxtImg src="/images/hero.jpg" alt="Hero" width="800" height="600" />
  
  <!-- With responsive sizes -->
  <NuxtImg 
    src="/images/hero.jpg" 
    alt="Hero"
    sizes="sm:100vw md:50vw lg:400px"
    :quality="80"
  />
</template>
```

**Features:**

- Automatic format conversion (WebP, AVIF)
- Lazy loading by default
- Responsive images with `sizes`
- Built-in blur placeholder

## Static vs SSR

Mockups can be static (nuxt generate) or server-rendered. For demos, static export is often sufficient.

**Static generation:**

```bash
# Build static site
pnpm generate

# Output in .output/public/
# Can deploy to any static host
```

**Server-side rendering:**

```bash
# Build SSR app
pnpm build

# Start production server
node .output/server/index.mjs
```

**When to use each:**

- **Static**: Marketing sites, portfolios, documentation
- **SSR**: Apps with user-specific content, SEO requirements, real-time data

## Component Libraries

Consider using **@nuxt/ui** for pre-built, accessible components built on Reka UI and Tailwind CSS.

**Installation:**

```bash
pnpm add @nuxt/ui
```

**Configuration:**

```typescript
export default defineNuxtConfig({
  modules: ['@nuxt/ui']
})
```

**Usage:**

```vue
<template>
  <UButton color="primary" size="lg">Click me</UButton>
  <UCard>
    <template #header>Card Title</template>
    <p>Card content</p>
  </UCard>
  <UModal v-model="isOpen">Modal content</UModal>
</template>
```

**Benefits:**

- Fully styled and accessible
- Dark mode support
- Customizable with Tailwind
- TypeScript support

## Icons

Use `@nuxt/icon` module which provides access to 200,000+ icons from Iconify.

**Installation:**

```bash
pnpm add @nuxt/icon
```

**Usage:**

```vue
<template>
  <!-- Heroicons -->
  <Icon name="heroicons:home" />
  <Icon name="heroicons:user-circle" class="w-6 h-6 text-blue-600" />
  
  <!-- Material Design Icons -->
  <Icon name="mdi:github" />
  
  <!-- Font Awesome -->
  <Icon name="fa6-brands:twitter" />
  
  <!-- Custom size and color -->
  <Icon name="heroicons:sparkles" class="w-8 h-8 text-yellow-500" />
</template>
```

**Icon search:** Browse available icons at [icones.js.org](https://icones.js.org/)

## Rapid Iteration

The skill prioritizes speed and visual accuracy over production-ready code.

**Focus areas:**

- Demonstrating UX/UI concepts quickly
- Visual fidelity to designs
- Interactive prototypes
- Vite's instant feedback

**Not a priority for mockups:**

- Production-grade error handling
- Comprehensive test coverage
- Performance optimization
- Security hardening

## Design Fidelity

Match provided designs as closely as possible, but adapt for web best practices:

**Adapt for:**

- Accessibility (WCAG standards)
- Responsive design (mobile, tablet, desktop)
- Browser compatibility
- Touch-friendly interfaces
- Keyboard navigation

**Don't compromise:**

- Color accessibility (contrast ratios)
- Text readability (font sizes, line heights)
- Touch target sizes (min 44x44px)

## Deployment

All major platforms support Nuxt 4 with zero-config deployments.

**Vercel:**

```bash
# Install Vercel CLI
pnpm add -g vercel

# Deploy
vercel
```

**Netlify:**

```bash
# Install Netlify CLI
pnpm add -g netlify-cli

# Deploy
netlify deploy --prod
```

**Cloudflare Pages:**

- Connect GitHub repo
- Auto-deploys on push
- Edge rendering support

**Build settings:**

- Build command: `pnpm generate` (static) or `pnpm build` (SSR)
- Output directory: `.output/public` (static) or `.output` (SSR)

## TypeScript

Nuxt 4 has excellent TypeScript support out of the box.

**No configuration needed:**

```typescript
// nuxt.config.ts is TypeScript by default
export default defineNuxtConfig({
  typescript: {
    strict: true,  // Enable strict mode
    typeCheck: true  // Type check on build
  }
})
```

**Component props with TypeScript:**

```vue
<script setup lang="ts">
interface Props {
  title: string
  count?: number
  items: Array<{ id: number; name: string }>
}

const props = withDefaults(defineProps<Props>(), {
  count: 0
})
</script>
```

**Benefits:**

- Catch errors at compile time
- Better IDE autocomplete
- Refactoring confidence
- Self-documenting code

## Tailwind CSS 4

The new Vite plugin approach simplifies configuration.

**CSS file (`assets/css/tailwind.css`):**

```css
/* New syntax for Tailwind 4 */
@import "tailwindcss";

/* Custom utilities */
@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}

/* Custom components */
@layer components {
  .btn {
    @apply px-4 py-2 rounded font-semibold;
  }
}
```

**No longer needed:**

```css
/* Old Tailwind 3 syntax (don't use) */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Configuration:**

```typescript
// tailwind.config.ts
export default {
  theme: {
    extend: {
      colors: {
        primary: '#3b82f6',
        secondary: '#8b5cf6'
      }
    }
  }
}
```

## Performance Tips

**Lazy loading:**

```vue
<template>
  <!-- Lazy load heavy components -->
  <LazyHeavyComponent v-if="shouldShow" />
</template>
```

**Prefetching:**

```vue
<template>
  <!-- Prefetch route on hover -->
  <NuxtLink to="/about" prefetch>About</NuxtLink>
</template>
```

**Virtual scrolling for long lists:**

```bash
pnpm add vue-virtual-scroller
```

## Common Pitfalls

1. **Hydration mismatches**: Avoid different rendering on client/server
   - Use `<ClientOnly>` for browser-only code

2. **Not using composables**: Extract reusable logic
   - Create custom composables in `composables/` directory

3. **Ignoring accessibility**: Always test with keyboard and screen readers

4. **Hardcoding values**: Use Tailwind theme values for consistency

5. **Over-nesting components**: Keep component hierarchy shallow

---

## Reference

For main skill instructions and templates, see:

- [`SKILL.md`](../SKILL.md) - Main skill instructions
- [`templates/`](../templates/) - Component templates
- [`EXAMPLES.md`](./EXAMPLES.md) - Detailed examples
