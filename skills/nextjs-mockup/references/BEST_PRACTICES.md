# Next.js Best Practices & Notes

Important notes and best practices for creating mockups with Next.js 16, React 19, and Tailwind CSS 4.

## Next.js vs Vite

Next.js includes its own optimized bundler and **does not use Vite**:

- **Development**: Turbopack (Rust-based, extremely fast HMR)
- **Production**: Webpack with Next.js optimizations

### Why Next.js doesn't need Vite

- Next.js has its own highly optimized build system
- Turbopack provides faster dev server than Vite
- Built-in support for Server Components, SSR, and ISR
- Integrated image optimization, routing, and API routes

### Performance comparison

- **Dev server startup**: Turbopack ~50% faster than Vite for large apps
- **HMR speed**: Both are instant (<100ms)
- **Production builds**: Next.js optimized for React specifically

## Latest Versions

Always use latest stable versions. Check npm for updates:

```bash
# Check current versions
npm view next version              # Currently v16.1.0
npm view react version              # Currently v19.0.0
npm view tailwindcss version        # Currently v4.1.0

# Update dependencies
pnpm update
```

**Version ranges in package.json:**

```json
{
  "dependencies": {
    "next": "^16.1.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "devDependencies": {
    "tailwindcss": "^4.1.0"
  }
}
```

## Server vs Client Components

Next.js 16 App Router defaults to **Server Components**. This is a major paradigm shift.

### Server Components (Default)

**When to use:**

- Static content
- Data fetching
- SEO-critical content
- No interactivity needed

**Example:**

```tsx
// app/page.tsx
// No 'use client' directive = Server Component
export default async function Page() {
  const data = await fetch('https://api.example.com/data')
  const json = await data.json()
  
  return <div>{json.title}</div>
}
```

**Benefits:**

- Smaller bundle size (no JS sent to client)
- Direct database access
- Better SEO
- Faster initial page load

### Client Components

**When to use:**

- State (useState, useReducer)
- Effects (useEffect, useLayoutEffect)
- Event handlers (onClick, onChange)
- Browser APIs (localStorage, geolocation)
- Custom hooks that use the above

**Example:**

```tsx
'use client' // Required directive

import { useState } from 'react'

export default function Counter() {
  const [count, setCount] = useState(0)
  
  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  )
}
```

### Best Practices

1. **Start with Server Components** - Only add `'use client'` when needed
2. **Move Client Components down the tree** - Keep parent components as Server Components
3. **Separate data fetching from UI** - Fetch in Server Components, pass to Client Components

**Good pattern:**

```tsx
// app/page.tsx (Server Component)
export default async function Page() {
  const data = await fetchData()
  return <InteractiveUI data={data} />
}

// components/InteractiveUI.tsx (Client Component)
'use client'
export default function InteractiveUI({ data }) {
  const [state, setState] = useState(data)
  // ... interactive logic
}
```

## Tailwind CSS 4

New features and syntax in Tailwind 4:

### CSS Configuration

```css
/* app/globals.css */
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

**No longer needed** (old Tailwind 3 syntax):

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Theme Configuration

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss'

export default {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#3b82f6',
        secondary: '#8b5cf6'
      }
    }
  }
} satisfies Config
```

## Image Optimization

**Always use Next.js `<Image>` component** instead of `<img>` for automatic optimization.

### Basic Usage

```tsx
import Image from 'next/image'

export default function Avatar() {
  return (
    <Image
      src="/avatar.jpg"
      alt="User avatar"
      width={200}
      height={200}
    />
  )
}
```

### Remote Images

```tsx
// next.config.js
module.exports = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
      },
    ],
  },
}

// Component
<Image
  src="https://images.unsplash.com/photo-123"
  alt="Photo"
  width={800}
  height={600}
/>
```

### Responsive Images

```tsx
<Image
  src="/hero.jpg"
  alt="Hero"
  fill // Fills parent container
  className="object-cover"
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  priority // Load immediately (for above-fold images)
/>
```

### Features

- Automatic WebP/AVIF conversion
- Lazy loading by default
- Responsive images with `srcset`
- Blur placeholder support
- Prevents Cumulative Layout Shift (CLS)

## Static vs Dynamic Rendering

### Static Rendering (Default)

Pages are pre-rendered at build time:

```tsx
// app/page.tsx
export default function Page() {
  return <div>Static content</div>
}
```

**Best for:**

- Marketing pages
- Blog posts
- Documentation
- Mockups and demos

### Dynamic Rendering

Pages are rendered on each request:

```tsx
// app/page.tsx
export const dynamic = 'force-dynamic'

export default async function Page() {
  const data = await fetch('https://api.example.com/data', {
    cache: 'no-store'
  })
  return <div>{JSON.stringify(data)}</div>
}
```

**Best for:**

- User-specific content
- Real-time data
- Personalized experiences

### For Mockups

Use **static rendering** with mock data for fastest performance:

```tsx
const mockData = {
  users: [...],
  products: [...],
  stats: [...]
}

export default function Dashboard() {
  return <DashboardUI data={mockData} />
}
```

## Component Library: shadcn/ui

shadcn/ui is **highly recommended** for Next.js mockups because:

### Why shadcn/ui over other libraries

1. **Copy, not install** - Components copied to your project (you own the code)
2. **Full customization** - Modify components as needed
3. **TypeScript native** - Excellent type safety
4. **Accessible** - Built on Radix UI primitives
5. **Tailwind CSS** - Seamless integration

### Installation

```bash
pnpm dlx shadcn@latest init
```

### Adding Components

```bash
# Add specific components
pnpm dlx shadcn@latest add button card table

# Browse all available components
npx shadcn@latest
```

### Usage

```tsx
import { Button } from '@/components/ui/button'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

export default function Example() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Title</CardTitle>
      </CardHeader>
      <CardContent>
        <Button>Click me</Button>
      </CardContent>
    </Card>
  )
}
```

## Rapid Iteration

The skill prioritizes **speed and visual accuracy** over production-ready code.

### Focus areas

- Demonstrating UX/UI concepts quickly
- Visual fidelity to designs
- Interactive prototypes
- Fast iteration with HMR

### Not a priority for mockups

- Production-grade error handling
- Comprehensive test coverage
- Performance optimization
- Security hardening
- Database setup
- Authentication

### Mock Data Strategy

Use placeholder services or static data:

```tsx
// utils/mockData.ts
export const mockUsers = [
  { id: 1, name: 'John Doe', email: 'john@example.com' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
]

// Or use JSONPlaceholder
async function fetchMockData() {
  const res = await fetch('https://jsonplaceholder.typicode.com/users')
  return res.json()
}
```

## Design Fidelity

Match provided designs as closely as possible, but adapt for web best practices:

### Adapt for

- **Accessibility**: WCAG standards, ARIA labels
- **Responsive design**: Mobile, tablet, desktop
- **Browser compatibility**: Modern browsers
- **Touch-friendly interfaces**: Min 44x44px targets
- **Keyboard navigation**: Tab order, focus states

### Don't compromise

- Color contrast ratios (WCAG AA: 4.5:1)
- Text readability (font sizes, line heights)
- Touch target sizes
- Focus indicators

### Tools for checking

- Chrome DevTools Lighthouse
- axe DevTools extension
- WAVE accessibility checker

## Deployment

Vercel (creators of Next.js) offers **free hosting** perfect for mockups.

### One-command deployment

```bash
# Install Vercel CLI
pnpm add -g vercel

# Deploy
vercel

# Deploy to production
vercel --prod
```

### Alternative platforms

**Netlify:**

```bash
pnpm add -g netlify-cli
netlify deploy --prod
```

**Cloudflare Pages:**

- Connect GitHub repo
- Auto-deploys on push
- Edge rendering support

### Build settings

- Build command: `pnpm build`
- Output directory: `.next`
- Node version: 20+

## TypeScript Best Practices

Next.js has excellent TypeScript support out of the box.

### Component Props

```tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
  children: React.ReactNode
  onClick?: () => void
}

export default function Button({ 
  variant = 'primary', 
  size = 'md', 
  children,
  onClick 
}: ButtonProps) {
  return (
    <button onClick={onClick}>
      {children}
    </button>
  )
}
```

### Server Component with Async

```tsx
interface User {
  id: number
  name: string
  email: string
}

export default async function UsersPage() {
  const users: User[] = await fetchUsers()
  
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  )
}
```

### Client Component with State

```tsx
'use client'

import { useState } from 'react'

export default function Counter() {
  const [count, setCount] = useState<number>(0)
  
  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  )
}
```

## Performance Tips

### Code Splitting

```tsx
import dynamic from 'next/dynamic'

// Lazy load heavy components
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <p>Loading...</p>
})
```

### Route Prefetching

```tsx
import Link from 'next/link'

// Automatically prefetches on hover
<Link href="/dashboard" prefetch>
  Dashboard
</Link>
```

### Suspense Boundaries

```tsx
import { Suspense } from 'react'

export default function Page() {
  return (
    <Suspense fallback={<Loading />}>
      <AsyncComponent />
    </Suspense>
  )
}
```

## Common Pitfalls

1. **Using `'use client'` unnecessarily** - Start with Server Components
2. **Not optimizing images** - Always use `<Image>` component
3. **Fetching in Client Components** - Fetch in Server Components when possible
4. **Ignoring accessibility** - Add ARIA labels and keyboard navigation
5. **Hardcoding values** - Use Tailwind theme for consistency

## React 19 Features

New features in React 19 that enhance mockups:

### Actions

```tsx
'use client'

import { useTransition } from 'react'

export default function Form() {
  const [isPending, startTransition] = useTransition()
  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    startTransition(async () => {
      await submitForm(formData)
    })
  }
  
  return (
    <form onSubmit={handleSubmit}>
      <button disabled={isPending}>
        {isPending ? 'Submitting...' : 'Submit'}
      </button>
    </form>
  )
}
```

### use() Hook

```tsx
'use client'

import { use } from 'react'

export default function Component({ dataPromise }) {
  const data = use(dataPromise)
  return <div>{data.title}</div>
}
```

---

## Reference

For main skill instructions and templates, see:

- [`SKILL.md`](../SKILL.md) - Main skill instructions
- [`templates/`](../templates/) - Component templates
- [`EXAMPLES.md`](./EXAMPLES.md) - Detailed examples
