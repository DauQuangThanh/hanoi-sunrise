# Next.js Mockup Examples

Detailed examples of UI mockups created with Next.js 16, React 19, and Tailwind CSS 4.

## Example 1: Landing Page Mockup

**Input:** "Create a landing page for a SaaS product with hero, features, pricing, and footer"

### Workflow

1. **Check prerequisites** → Node.js 20.10, pnpm 8.15
2. **Initialize Next.js project:**

   ```bash
   pnpm create next-app@latest saas-landing --typescript --tailwind --app --no-src-dir
   cd saas-landing
   ```

3. **Install shadcn/ui:**

   ```bash
   pnpm dlx shadcn@latest init
   pnpm dlx shadcn@latest add button card
   ```

4. **Create components** in `components/custom/`:
   - `HeroSection.tsx` - Hero with CTA buttons
   - `FeatureGrid.tsx` - 3-column feature showcase
   - `PricingTable.tsx` - 3-tier pricing cards
   - `Footer.tsx` - Links and social media
5. **Build main page** (`app/page.tsx`):

   ```tsx
   import HeroSection from '@/components/custom/HeroSection'
   import FeatureGrid from '@/components/custom/FeatureGrid'
   import PricingTable from '@/components/custom/PricingTable'
   import Footer from '@/components/custom/Footer'
   
   export default function Home() {
     return (
       <main>
         <HeroSection />
         <FeatureGrid />
         <PricingTable />
         <Footer />
       </main>
     )
   }
   ```

6. **Add responsive breakpoints** using Tailwind's responsive classes
7. **Test on mobile and desktop** viewports
8. **Start dev server:**

   ```bash
   pnpm dev
   ```

### Component Details

**HeroSection.tsx:**

```tsx
'use client'

import { Button } from '@/components/ui/button'

export default function HeroSection() {
  const scrollToPricing = () => {
    document.getElementById('pricing')?.scrollIntoView({ behavior: 'smooth' })
  }

  return (
    <section className="bg-gradient-to-r from-blue-600 to-purple-600 text-white py-20">
      <div className="container mx-auto px-4 text-center">
        <h1 className="text-5xl font-bold mb-6">
          Build Amazing Products Faster
        </h1>
        <p className="text-xl mb-8 max-w-2xl mx-auto">
          The all-in-one platform for modern teams to collaborate, design, and ship products that users love.
        </p>
        <div className="flex gap-4 justify-center">
          <Button size="lg" className="bg-white text-blue-600 hover:bg-gray-100">
            Start Free Trial
          </Button>
          <Button size="lg" variant="outline" onClick={scrollToPricing} className="border-white text-white hover:bg-white/10">
            See Pricing
          </Button>
        </div>
      </div>
    </section>
  )
}
```

**FeatureGrid.tsx:**

```tsx
import { Card, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'

const features = [
  { icon: '⚡', title: 'Lightning Fast', description: 'Built with performance in mind from day one' },
  { icon: '🔒', title: 'Secure by Default', description: 'Enterprise-grade security for your data' },
  { icon: '🎨', title: 'Beautiful Design', description: 'Pixel-perfect UI that users will love' },
  { icon: '📱', title: 'Mobile First', description: 'Optimized for all devices and screen sizes' },
  { icon: '🚀', title: 'Easy Deploy', description: 'Deploy to production in seconds' },
  { icon: '💬', title: '24/7 Support', description: 'Always here to help when you need us' }
]

export default function FeatureGrid() {
  return (
    <section className="py-20 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-4xl font-bold text-center mb-12">
          Everything You Need
        </h2>
        <div className="grid md:grid-cols-3 gap-8">
          {features.map((feature) => (
            <Card key={feature.title}>
              <CardHeader>
                <div className="text-4xl mb-4">{feature.icon}</div>
                <CardTitle>{feature.title}</CardTitle>
                <CardDescription>{feature.description}</CardDescription>
              </CardHeader>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
}
```

### Result

Fully interactive landing page mockup with:

- Smooth scrolling navigation
- Responsive design (mobile, tablet, desktop)
- Fast HMR with Next.js dev server
- Running at `localhost:3000`

---

## Example 2: Dashboard Mockup

**Input:** "Create an admin dashboard with sidebar navigation, stats cards, and data table"

### Workflow

1. **Initialize Next.js project**
2. **Install shadcn/ui components:**

   ```bash
   pnpm dlx shadcn@latest add button card table badge sidebar
   ```

3. **Create dashboard layout** (`app/dashboard/layout.tsx`):

   ```tsx
   import Sidebar from '@/components/custom/Sidebar'
   
   export default function DashboardLayout({
     children,
   }: {
     children: React.ReactNode
   }) {
     return (
       <div className="flex h-screen">
         <Sidebar />
         <main className="flex-1 overflow-y-auto p-8">
           {children}
         </main>
       </div>
     )
   }
   ```

4. **Build sidebar component** (`components/custom/Sidebar.tsx`):

   ```tsx
   'use client'
   
   import { useState } from 'react'
   import Link from 'next/link'
   import { Button } from '@/components/ui/button'
   
   const menuItems = [
     { icon: '🏠', label: 'Dashboard', path: '/dashboard' },
     { icon: '👥', label: 'Users', path: '/dashboard/users' },
     { icon: '📊', label: 'Analytics', path: '/dashboard/analytics' },
     { icon: '⚙️', label: 'Settings', path: '/dashboard/settings' }
   ]
   
   export default function Sidebar() {
     const [isOpen, setIsOpen] = useState(true)
   
     return (
       <aside className={`${isOpen ? 'w-64' : 'w-20'} bg-gray-900 text-white transition-all duration-300`}>
         <div className="p-4">
           <Button onClick={() => setIsOpen(!isOpen)} variant="ghost" className="w-full">
             {isOpen ? '←' : '→'}
           </Button>
         </div>
         <nav className="p-4">
           {menuItems.map((item) => (
             <Link key={item.path} href={item.path} className="flex items-center gap-3 p-3 rounded hover:bg-gray-800">
               <span className="text-2xl">{item.icon}</span>
               {isOpen && <span>{item.label}</span>}
             </Link>
           ))}
         </nav>
       </aside>
     )
   }
   ```

5. **Create dashboard page** (`app/dashboard/page.tsx`) with stats and data table
6. **Add interactivity** with React hooks and state management
7. **Test responsive behavior**

### Dashboard Components

**Stats Cards:**

```tsx
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

const stats = [
  { label: 'Total Users', value: '12,345', change: '+12%', trend: 'up' },
  { label: 'Revenue', value: '$54,321', change: '+8%', trend: 'up' },
  { label: 'Active Sessions', value: '1,234', change: '-3%', trend: 'down' },
  { label: 'Conversion Rate', value: '3.24%', change: '+0.4%', trend: 'up' }
]

export default function StatsCards() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      {stats.map((stat) => (
        <Card key={stat.label}>
          <CardHeader>
            <CardTitle className="text-sm text-gray-500">{stat.label}</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-end justify-between">
              <p className="text-3xl font-bold">{stat.value}</p>
              <span className={`text-sm font-medium ${stat.trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
                {stat.change}
              </span>
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  )
}
```

**Data Table with Sorting:**

```tsx
'use client'

import { useState, useMemo } from 'react'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Badge } from '@/components/ui/badge'

interface User {
  id: number
  name: string
  email: string
  role: string
  status: 'Active' | 'Inactive'
}

const users: User[] = [
  { id: 1, name: 'John Doe', email: 'john@example.com', role: 'Admin', status: 'Active' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com', role: 'User', status: 'Active' },
  { id: 3, name: 'Bob Johnson', email: 'bob@example.com', role: 'User', status: 'Inactive' }
]

export default function UsersTable() {
  const [sortBy, setSortBy] = useState<keyof User>('name')
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('asc')

  const sortedUsers = useMemo(() => {
    return [...users].sort((a, b) => {
      const aValue = a[sortBy]
      const bValue = b[sortBy]
      const modifier = sortOrder === 'asc' ? 1 : -1
      return aValue > bValue ? modifier : -modifier
    })
  }, [sortBy, sortOrder])

  const toggleSort = (column: keyof User) => {
    if (sortBy === column) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')
    } else {
      setSortBy(column)
      setSortOrder('asc')
    }
  }

  return (
    <div className="bg-white rounded-lg shadow">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead onClick={() => toggleSort('name')} className="cursor-pointer hover:bg-gray-50">
              Name {sortBy === 'name' && (sortOrder === 'asc' ? '↑' : '↓')}
            </TableHead>
            <TableHead>Email</TableHead>
            <TableHead>Role</TableHead>
            <TableHead>Status</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {sortedUsers.map((user) => (
            <TableRow key={user.id} className="hover:bg-gray-50">
              <TableCell className="font-medium">{user.name}</TableCell>
              <TableCell>{user.email}</TableCell>
              <TableCell>{user.role}</TableCell>
              <TableCell>
                <Badge variant={user.status === 'Active' ? 'default' : 'secondary'}>
                  {user.status}
                </Badge>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  )
}
```

### Result

Interactive dashboard mockup with:

- Collapsible sidebar navigation
- Real-time stats cards
- Sortable data table
- Server and client components optimized
- Fully responsive design

---

## Example 3: E-commerce Product Catalog

**Input:** "Create a product catalog with filtering, search, and cart functionality"

### Key Features

- Product grid with optimized images
- Category filters (sidebar or top nav)
- Search bar with instant results
- Add to cart with quantity selector
- Cart preview with total
- Responsive grid (1 col mobile, 2-3 col tablet, 4 col desktop)

### Implementation Highlights

**Product Card Component:**

```tsx
'use client'

import Image from 'next/image'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'

interface Product {
  id: number
  name: string
  price: number
  image: string
  category: string
}

interface ProductCardProps {
  product: Product
  onAddToCart: (product: Product) => void
}

export default function ProductCard({ product, onAddToCart }: ProductCardProps) {
  return (
    <Card className="hover:shadow-lg transition-shadow">
      <CardContent className="p-4">
        <div className="relative w-full h-64 mb-4">
          <Image
            src={product.image}
            alt={product.name}
            fill
            className="object-cover rounded"
          />
        </div>
        <h3 className="text-lg font-semibold mb-2">{product.name}</h3>
        <div className="flex items-center justify-between">
          <span className="text-2xl font-bold text-blue-600">${product.price}</span>
          <Button onClick={() => onAddToCart(product)}>
            Add to Cart
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
```

**Filtering Logic:**

```tsx
'use client'

import { useState, useMemo } from 'react'

export default function ProductCatalog() {
  const [products, setProducts] = useState<Product[]>([...]) // Mock data
  const [selectedCategory, setSelectedCategory] = useState('all')
  const [searchQuery, setSearchQuery] = useState('')

  const filteredProducts = useMemo(() => {
    let filtered = products

    if (selectedCategory !== 'all') {
      filtered = filtered.filter(p => p.category === selectedCategory)
    }

    if (searchQuery) {
      filtered = filtered.filter(p =>
        p.name.toLowerCase().includes(searchQuery.toLowerCase())
      )
    }

    return filtered
  }, [products, selectedCategory, searchQuery])

  return (
    // Product grid with filters
  )
}
```

---

## Tips for Successful Mockups

### Performance Optimization

- Use Next.js `<Image>` for automatic image optimization
- Implement lazy loading with `loading="lazy"`
- Use Server Components by default, Client Components only when needed
- Implement pagination for long lists

### Accessibility

- Use semantic HTML (`<nav>`, `<main>`, `<article>`)
- Add ARIA labels to interactive elements
- Ensure keyboard navigation works
- Test with screen readers

### Responsive Design

- Mobile-first approach with Tailwind
- Test breakpoints: 320px, 768px, 1024px, 1440px
- Use `container` class for max-width constraints
- Consider touch targets on mobile (min 44x44px)

### Server vs Client Components

- **Server Components** (default): Static content, data fetching, no interactivity
- **Client Components** (`'use client'`): State, effects, event handlers, browser APIs

---

## Reference

For templates and main skill instructions, see:

- [`templates/`](../templates/) - Component and configuration templates
- [`SKILL.md`](../SKILL.md) - Main skill instructions
