<script setup lang="ts">
/**
 * Layout Template
 * 
 * Wraps pages with common UI elements (navigation, footer, etc.)
 * Place in layouts/default.vue for default layout or layouts/custom.vue for named layouts
 */

/**
 * Navigation items
 */
const navigation = [
  { name: 'Home', to: '/' },
  { name: 'Features', to: '/features' },
  { name: 'Pricing', to: '/pricing' },
  { name: 'About', to: '/about' },
]

/**
 * Footer links organized by category
 */
const footerLinks = {
  company: [
    { name: 'About Us', to: '/about' },
    { name: 'Careers', to: '/careers' },
    { name: 'Contact', to: '/contact' },
  ],
  product: [
    { name: 'Features', to: '/features' },
    { name: 'Pricing', to: '/pricing' },
    { name: 'Documentation', to: '/docs' },
  ],
  resources: [
    { name: 'Blog', to: '/blog' },
    { name: 'Support', to: '/support' },
    { name: 'Community', to: '/community' },
  ],
  legal: [
    { name: 'Privacy Policy', to: '/privacy' },
    { name: 'Terms of Service', to: '/terms' },
  ],
}

const currentYear = new Date().getFullYear()
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <!-- Navigation -->
    <header class="sticky top-0 z-50 bg-white border-b border-gray-200">
      <nav class="container mx-auto px-4 h-16 flex items-center justify-between">
        <div class="flex items-center space-x-8">
          <NuxtLink to="/" class="text-xl font-bold text-gray-900">
            Logo
          </NuxtLink>
          <div class="hidden md:flex space-x-6">
            <NuxtLink
              v-for="item in navigation"
              :key="item.name"
              :to="item.to"
              class="text-gray-600 hover:text-gray-900 transition-colors"
              active-class="text-blue-600 font-semibold"
            >
              {{ item.name }}
            </NuxtLink>
          </div>
        </div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-600 hover:text-gray-900">
            Sign In
          </button>
          <button class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
            Get Started
          </button>
        </div>
      </nav>
    </header>

    <!-- Main Content -->
    <div class="flex-grow">
      <slot />
    </div>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-12 mt-auto">
      <div class="container mx-auto px-4 max-w-6xl">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 class="font-bold text-lg mb-4">Company</h3>
            <ul class="space-y-2">
              <li v-for="link in footerLinks.company" :key="link.name">
                <NuxtLink 
                  :to="link.to" 
                  class="text-gray-400 hover:text-white transition-colors"
                >
                  {{ link.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 class="font-bold text-lg mb-4">Product</h3>
            <ul class="space-y-2">
              <li v-for="link in footerLinks.product" :key="link.name">
                <NuxtLink 
                  :to="link.to" 
                  class="text-gray-400 hover:text-white transition-colors"
                >
                  {{ link.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 class="font-bold text-lg mb-4">Resources</h3>
            <ul class="space-y-2">
              <li v-for="link in footerLinks.resources" :key="link.name">
                <NuxtLink 
                  :to="link.to" 
                  class="text-gray-400 hover:text-white transition-colors"
                >
                  {{ link.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 class="font-bold text-lg mb-4">Legal</h3>
            <ul class="space-y-2">
              <li v-for="link in footerLinks.legal" :key="link.name">
                <NuxtLink 
                  :to="link.to" 
                  class="text-gray-400 hover:text-white transition-colors"
                >
                  {{ link.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>
        </div>
        
        <div class="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
          <p>&copy; {{ currentYear }} Company Name. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>
