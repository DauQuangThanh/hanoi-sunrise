<script setup lang="ts">
/**
 * Page Template
 * 
 * Nuxt 3 page structure with file-based routing
 * Place in pages/ directory (e.g., pages/about.vue for /about route)
 */

/**
 * Set page metadata for SEO
 */
useHead({
  title: 'Page Title | Site Name',
  meta: [
    { name: 'description', content: 'Page description for search engines and social media' },
    { property: 'og:title', content: 'Page Title' },
    { property: 'og:description', content: 'Description for social media sharing' },
    { property: 'og:image', content: '/og-image.jpg' },
  ],
})

/**
 * Define page meta (layout, middleware, etc.)
 */
definePageMeta({
  layout: 'default',
  // middleware: 'auth', // Add if authentication needed
})

/**
 * Component state and methods
 */
const items = ref([
  { id: 1, title: 'Item 1', description: 'Description 1' },
  { id: 2, title: 'Item 2', description: 'Description 2' },
  { id: 3, title: 'Item 3', description: 'Description 3' },
])
</script>

<template>
  <main class="min-h-screen bg-gray-50">
    <!-- Hero Section -->
    <section class="bg-gradient-to-br from-blue-50 to-indigo-100 py-20">
      <div class="container mx-auto px-4 max-w-6xl">
        <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          Page Heading
        </h1>
        <p class="text-xl text-gray-600 max-w-2xl">
          Page description or tagline goes here
        </p>
      </div>
    </section>

    <!-- Main Content -->
    <section class="py-16">
      <div class="container mx-auto px-4 max-w-6xl">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- Content cards -->
          <div
            v-for="item in items"
            :key="item.id"
            class="bg-white p-6 rounded-lg shadow-sm hover:shadow-md transition-shadow"
          >
            <h3 class="text-xl font-semibold text-gray-900 mb-2">
              {{ item.title }}
            </h3>
            <p class="text-gray-600">
              {{ item.description }}
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="bg-blue-600 text-white py-16">
      <div class="container mx-auto px-4 max-w-4xl text-center">
        <h2 class="text-3xl font-bold mb-4">
          Call to Action Heading
        </h2>
        <p class="text-xl mb-8 opacity-90">
          Compelling description or value proposition
        </p>
        <button class="bg-white text-blue-600 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 transition-colors">
          Primary Action
        </button>
      </div>
    </section>
  </main>
</template>

<!--
  Alternative: Dynamic page with route params
  File: pages/blog/[slug].vue
  Route: /blog/:slug
  
  <script setup lang="ts">
  const route = useRoute()
  const slug = route.params.slug
  
  // Fetch data based on slug
  const { data: post } = await useFetch(`/api/posts/${slug}`)
  </script>
  
  <template>
    <div>
      <h1>{{ post.title }}</h1>
      <p>{{ post.content }}</p>
    </div>
  </template>
-->
