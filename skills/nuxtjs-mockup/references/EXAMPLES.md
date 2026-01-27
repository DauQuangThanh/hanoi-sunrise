# Nuxt.js Mockup Examples

Detailed examples of UI mockups created with Nuxt 4, Vue 3, and Tailwind CSS 4.

## Example 1: Landing Page Mockup

**Input:** "Create a landing page for a SaaS product with hero, features, pricing, and footer"

### Workflow

1. **Check prerequisites** → Node.js 20.10, pnpm 8.15
2. **Initialize Nuxt 4 project:**

   ```bash
   pnpm create nuxt@latest mockup
   cd mockup
   ```

3. **Install Tailwind CSS 4:**

   ```bash
   pnpm add -D tailwindcss@next @tailwindcss/vite@next
   ```

4. **Configure nuxt.config.ts** with Tailwind Vite plugin:

   ```typescript
   export default defineNuxtConfig({
     vite: {
       plugins: [
         require('@tailwindcss/vite')()
       ]
     }
   })
   ```

5. **Create components:**
   - `components/custom/HeroSection.vue` - Hero with CTA buttons
   - `components/custom/FeatureGrid.vue` - 3-column feature showcase
   - `components/custom/PricingTable.vue` - 3-tier pricing cards
   - `components/Footer.vue` - Links and social media
6. **Create index page** (`pages/index.vue`):

   ```vue
   <template>
     <div>
       <HeroSection />
       <FeatureGrid />
       <PricingTable />
       <Footer />
     </div>
   </template>
   ```

7. **Add responsive breakpoints** using Tailwind's responsive classes
8. **Test on mobile and desktop** viewports
9. **Start dev server:**

   ```bash
   pnpm dev
   ```

### Component Details

**HeroSection.vue:**

```vue
<script setup lang="ts">
const scrollToPricing = () => {
  document.getElementById('pricing')?.scrollIntoView({ behavior: 'smooth' })
}
</script>

<template>
  <section class="bg-gradient-to-r from-blue-600 to-purple-600 text-white py-20">
    <div class="container mx-auto px-4 text-center">
      <h1 class="text-5xl font-bold mb-6">
        Build Amazing Products Faster
      </h1>
      <p class="text-xl mb-8 max-w-2xl mx-auto">
        The all-in-one platform for modern teams to collaborate, design, and ship products that users love.
      </p>
      <div class="flex gap-4 justify-center">
        <button class="bg-white text-blue-600 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100">
          Start Free Trial
        </button>
        <button @click="scrollToPricing" class="border-2 border-white px-8 py-3 rounded-lg font-semibold hover:bg-white/10">
          See Pricing
        </button>
      </div>
    </div>
  </section>
</template>
```

**FeatureGrid.vue:**

```vue
<script setup lang="ts">
const features = [
  { icon: '⚡', title: 'Lightning Fast', description: 'Built with performance in mind from day one' },
  { icon: '🔒', title: 'Secure by Default', description: 'Enterprise-grade security for your data' },
  { icon: '🎨', title: 'Beautiful Design', description: 'Pixel-perfect UI that users will love' },
  { icon: '📱', title: 'Mobile First', description: 'Optimized for all devices and screen sizes' },
  { icon: '🚀', title: 'Easy Deploy', description: 'Deploy to production in seconds' },
  { icon: '💬', title: '24/7 Support', description: 'Always here to help when you need us' }
]
</script>

<template>
  <section class="py-20 bg-gray-50">
    <div class="container mx-auto px-4">
      <h2 class="text-4xl font-bold text-center mb-12">
        Everything You Need
      </h2>
      <div class="grid md:grid-cols-3 gap-8">
        <div v-for="feature in features" :key="feature.title" class="bg-white p-6 rounded-lg shadow-md">
          <div class="text-4xl mb-4">{{ feature.icon }}</div>
          <h3 class="text-xl font-semibold mb-2">{{ feature.title }}</h3>
          <p class="text-gray-600">{{ feature.description }}</p>
        </div>
      </div>
    </div>
  </section>
</template>
```

### Result

Fully interactive landing page mockup with:

- Smooth scrolling navigation
- Responsive design (mobile, tablet, desktop)
- Vite HMR for instant updates
- Running at `localhost:3000`

---

## Example 2: Dashboard Mockup

**Input:** "Create an admin dashboard with sidebar navigation, stats cards, and data table"

### Workflow

1. **Initialize Nuxt 4 project**
2. **Install Tailwind 4** with Vite plugin
3. **Install icon module:**

   ```bash
   pnpm add @nuxt/icon
   ```

4. **Create dashboard layout** (`layouts/dashboard.vue`):
   - Sidebar with collapsible menu
   - Main content area
   - Header with user menu
5. **Build sidebar component** (`components/Sidebar.vue`):

   ```vue
   <script setup lang="ts">
   const isSidebarOpen = ref(true)
   const toggleSidebar = () => isSidebarOpen.value = !isSidebarOpen.value
   
   const menuItems = [
     { icon: 'heroicons:home', label: 'Dashboard', path: '/dashboard' },
     { icon: 'heroicons:users', label: 'Users', path: '/users' },
     { icon: 'heroicons:chart-bar', label: 'Analytics', path: '/analytics' },
     { icon: 'heroicons:cog', label: 'Settings', path: '/settings' }
   ]
   </script>
   ```

6. **Create dashboard page** (`pages/dashboard/index.vue`):
   - Stats cards showing KPIs
   - Data table with mock data
   - Charts using composables
7. **Add interactivity:**
   - Sidebar toggle with Vue ref
   - Sortable table with computed properties
   - Filter controls with v-model
8. **Apply dark mode** support using Tailwind's dark mode
9. **Test responsive behavior** on mobile and tablet

### Dashboard Components

**Stats Cards:**

```vue
<script setup lang="ts">
const stats = [
  { label: 'Total Users', value: '12,345', change: '+12%', trend: 'up' },
  { label: 'Revenue', value: '$54,321', change: '+8%', trend: 'up' },
  { label: 'Active Sessions', value: '1,234', change: '-3%', trend: 'down' },
  { label: 'Conversion Rate', value: '3.24%', change: '+0.4%', trend: 'up' }
]
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
    <div v-for="stat in stats" :key="stat.label" class="bg-white p-6 rounded-lg shadow">
      <p class="text-gray-500 text-sm mb-1">{{ stat.label }}</p>
      <div class="flex items-end justify-between">
        <p class="text-3xl font-bold">{{ stat.value }}</p>
        <span :class="stat.trend === 'up' ? 'text-green-600' : 'text-red-600'" class="text-sm font-medium">
          {{ stat.change }}
        </span>
      </div>
    </div>
  </div>
</template>
```

**Data Table with Sorting:**

```vue
<script setup lang="ts">
const users = ref([
  { id: 1, name: 'John Doe', email: 'john@example.com', role: 'Admin', status: 'Active' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com', role: 'User', status: 'Active' },
  { id: 3, name: 'Bob Johnson', email: 'bob@example.com', role: 'User', status: 'Inactive' }
])

const sortBy = ref('name')
const sortOrder = ref<'asc' | 'desc'>('asc')

const sortedUsers = computed(() => {
  return [...users.value].sort((a, b) => {
    const aValue = a[sortBy.value]
    const bValue = b[sortBy.value]
    const modifier = sortOrder.value === 'asc' ? 1 : -1
    return aValue > bValue ? modifier : -modifier
  })
})

const toggleSort = (column: string) => {
  if (sortBy.value === column) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = column
    sortOrder.value = 'asc'
  }
}
</script>

<template>
  <div class="bg-white rounded-lg shadow overflow-hidden">
    <table class="min-w-full divide-y divide-gray-200">
      <thead class="bg-gray-50">
        <tr>
          <th @click="toggleSort('name')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
            Name
            <Icon v-if="sortBy === 'name'" :name="sortOrder === 'asc' ? 'heroicons:chevron-up' : 'heroicons:chevron-down'" class="inline w-4 h-4" />
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <tr v-for="user in sortedUsers" :key="user.id" class="hover:bg-gray-50">
          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ user.name }}</td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ user.email }}</td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ user.role }}</td>
          <td class="px-6 py-4 whitespace-nowrap">
            <span :class="user.status === 'Active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'" class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full">
              {{ user.status }}
            </span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
```

### Result

Interactive dashboard mockup with:

- Collapsible sidebar navigation
- Real-time stats cards
- Sortable data table
- Smooth transitions and animations
- Vue 3 reactivity for instant updates
- Dark mode support
- Fully responsive design

---

## Example 3: E-commerce Product Catalog

**Input:** "Create a product catalog with filtering, search, and cart functionality"

### Key Features

- Product grid with image, title, price
- Category filters (sidebar or top nav)
- Search bar with instant results
- Add to cart with quantity selector
- Cart preview with total
- Responsive grid (1 col mobile, 2-3 col tablet, 4 col desktop)

### Implementation Highlights

**Product Card Component:**

```vue
<script setup lang="ts">
interface Product {
  id: number
  name: string
  price: number
  image: string
  category: string
}

const props = defineProps<{ product: Product }>()
const emit = defineEmits<{ addToCart: [product: Product] }>()
</script>

<template>
  <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-shadow">
    <img :src="product.image" :alt="product.name" class="w-full h-64 object-cover" />
    <div class="p-4">
      <h3 class="text-lg font-semibold mb-2">{{ product.name }}</h3>
      <div class="flex items-center justify-between">
        <span class="text-2xl font-bold text-blue-600">${{ product.price }}</span>
        <button @click="emit('addToCart', product)" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          Add to Cart
        </button>
      </div>
    </div>
  </div>
</template>
```

**Filtering Logic:**

```vue
<script setup lang="ts">
const products = ref<Product[]>([...]) // Mock data
const selectedCategory = ref('all')
const searchQuery = ref('')

const filteredProducts = computed(() => {
  let filtered = products.value
  
  if (selectedCategory.value !== 'all') {
    filtered = filtered.filter(p => p.category === selectedCategory.value)
  }
  
  if (searchQuery.value) {
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }
  
  return filtered
})
</script>
```

---

## Tips for Successful Mockups

### Performance Optimization

- Use `<NuxtImg>` for automatic image optimization
- Lazy load images with `loading="lazy"`
- Use `v-show` instead of `v-if` for frequently toggled elements
- Implement virtual scrolling for long lists

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

### Design System

- Define color palette in `tailwind.config.ts`
- Create reusable component library
- Maintain consistent spacing scale
- Use Tailwind's design tokens

---

## Reference

For templates and main skill instructions, see:

- [`templates/`](../templates/) - Component and configuration templates
- [`SKILL.md`](../SKILL.md) - Main skill instructions
