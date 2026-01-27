# Nuxt.js Mockup Setup Guide

This document provides detailed setup instructions and configuration for Nuxt.js mockup projects.

## Technology Stack Details

**Latest Versions (January 2026):**

- **Nuxt 4.3**: Vue.js framework with powerful features
- **Vue 3.5**: Progressive JavaScript framework
- **Tailwind CSS 4.1**: Utility-first CSS with new engine
- **Vite 5.4**: Fast build tool (built into Nuxt 4)
- **TypeScript 5.6**: Type safety and better DX
- **@nuxt/ui**: Fully styled components built on Reka UI (optional)
- **@nuxt/icon**: Icon module with 200,000+ icons from Iconify

**Note:** Nuxt 4 uses Vite as its default build tool for both development and production.

## Project Setup Steps

### 1. Initialize Nuxt 4 Project

```bash
# Using pnpm (recommended)
pnpm create nuxt@latest mockup

# Or using npx
npx create nuxt@latest mockup

cd mockup
```

### 2. Install Tailwind CSS and Dependencies

```bash
# Install Tailwind CSS 4 with Vite plugin
pnpm add -D tailwindcss@next @tailwindcss/vite@next

# Install additional utilities
pnpm add class-variance-authority clsx tailwind-merge

# Install icons (Nuxt icon module)
pnpm add -D @nuxt/icon
```

### 3. Configure Nuxt for Tailwind

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

### 4. Create Tailwind CSS File

Create `assets/css/tailwind.css`:

```css
@import "tailwindcss";
```

### 5. Project Structure

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

## Component Development Patterns

### Base UI Component Template

```vue
<!-- components/ui/Button.vue -->
<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'outline'
  size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md'
})
</script>

<template>
  <button 
    :class="[
      'btn',
      `btn-${variant}`,
      `btn-${size}`
    ]"
  >
    <slot />
  </button>
</template>
```

### Custom Component Template

```vue
<!-- components/custom/HeroSection.vue -->
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

### Component Best Practices

- Use `<script setup>` for concise syntax
- Define props with TypeScript interfaces
- Use `defineEmits` for custom events
- Leverage Vue 3 Composition API
- Auto-import composables from `composables/`

## Page Structure Templates

### Basic Page Template

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

### Layout Template

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

### Using Layouts in Pages

```vue
<script setup lang="ts">
definePageMeta({
  layout: 'default'
})
</script>
```

## Navigation Component

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

## Interactivity Patterns

### Local State Management

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

### Reusable Composables

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

### Programmatic Navigation

```typescript
const router = useRouter()
const navigateToPage = () => {
  router.push('/about')
}
```

## Styling Guidelines

### Tailwind Utility Classes

- Use Tailwind utility classes for all styling
- Responsive breakpoints: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
- Dark mode support: `dark:` variant
- Animation: Use Tailwind animate utilities
- Extract repeated patterns to custom classes in `assets/css/tailwind.css`

### Color Palette Configuration

```typescript
// tailwind.config.ts
colors: {
  primary: {
    50: '#f0f9ff',
    500: '#3b82f6',
    900: '#1e3a8a',
  },
  // ... more colors
}
```

## Development and Deployment

### Development Server

```bash
pnpm dev
# or
npm run dev
```

- Server runs on <http://localhost:3000>
- Hot module replacement (HMR) enabled via Vite
- Instant updates on file changes

### Preview Build

```bash
pnpm build
pnpm preview
```

### Deployment Options

**Deploy to Vercel:**
```bash
vercel deploy
```

**Deploy to Netlify:**
```bash
netlify deploy
```

**Static Export:**
```bash
nuxt generate
```

### Sharing Mockup

- **Local network**: Share local IP (e.g., <http://192.168.1.100:3000>)
- **Cloud deployment**: Use Vercel, Netlify, or Cloudflare Pages
- **Static hosting**: Generate static site and host anywhere

## Error Handling

### Common Issues and Solutions

#### 1. Node.js Version Mismatch

- **Error**: Nuxt 3 requires Node.js 18+
- **Action**: Upgrade Node.js or use nvm/volta
- **Fix**: `nvm install 20 && nvm use 20`

#### 2. Port Already in Use

- **Error**: Port 3000 is already in use
- **Action**: Kill process or use different port
- **Fix**: `PORT=3001 pnpm dev`

#### 3. Module Not Found

- **Error**: Cannot find module in components/
- **Action**: Check component auto-import
- **Fix**: Ensure file is in `components/` directory with proper naming

#### 4. Tailwind Classes Not Working

- **Error**: Classes not applying styles
- **Action**: Check Tailwind module configuration
- **Fix**: Ensure `@nuxtjs/tailwindcss` is in modules array

#### 5. Hydration Errors

- **Error**: Hydration mismatch
- **Action**: Avoid mismatched client/server rendering
- **Fix**: Use `<ClientOnly>` for browser-only code

#### 6. Build Errors

- **Error**: Type errors or build failures
- **Action**: Fix TypeScript types and imports
- **Fix**: Run `pnpm typecheck` and `pnpm lint`

## Performance Optimization

### Image Optimization

```vue
<NuxtImg 
  src="/hero.jpg" 
  alt="Hero image"
  width="1200"
  height="600"
  loading="lazy"
/>
```

### Lazy Loading Components

```typescript
const HeavyComponent = defineAsyncComponent(() => 
  import('~/components/HeavyComponent.vue')
)
```

### Client-Only Components

```vue
<ClientOnly>
  <BrowserOnlyComponent />
</ClientOnly>
```

## Accessibility Guidelines

- Use semantic HTML elements (`<header>`, `<nav>`, `<main>`, `<footer>`)
- Add ARIA labels for interactive elements
- Support keyboard navigation
- Ensure color contrast ratios (WCAG AA minimum)
- Add alt text for all images
- Test with screen readers

## Responsive Design Checklist

- [ ] Test mobile (320px+)
- [ ] Test tablet (768px+)
- [ ] Test desktop (1024px+)
- [ ] Touch-friendly tap targets (min 44x44px)
- [ ] Text readability on all screen sizes
- [ ] Image scaling and aspect ratios
- [ ] Navigation works on mobile
- [ ] Forms are usable on small screens
