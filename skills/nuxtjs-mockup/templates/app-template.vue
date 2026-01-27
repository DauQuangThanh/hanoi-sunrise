<script setup lang="ts">
/**
 * App Template
 * 
 * Root application component for Nuxt
 * This is the entry point for your app
 */

/**
 * Set global head configuration
 */
useHead({
  titleTemplate: '%s | Site Name',
  meta: [
    { charset: 'utf-8' },
    { name: 'viewport', content: 'width=device-width, initial-scale=1' },
  ],
  link: [
    { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
  ],
})
</script>

<template>
  <div>
    <!-- 
      NuxtLayout renders the layout specified in page meta
      NuxtPage renders the matched page component
    -->
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>

<style>
html {
  scroll-behavior: smooth;
}
</style>
