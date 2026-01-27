<script setup lang="ts">
/**
 * Component Template
 * 
 * Reusable Vue component for Nuxt mockups
 * Replace ComponentName with your actual component name (PascalCase)
 */

interface Props {
  /**
   * Main title or heading text
   */
  title: string
  
  /**
   * Optional description or subtitle
   */
  description?: string
  
  /**
   * Optional CSS classes
   */
  className?: string
}

const props = defineProps<Props>()

/**
 * Define custom events if needed
 */
const emit = defineEmits<{
  click: []
}>()
</script>

<template>
  <div :class="['p-4 bg-white rounded-lg shadow-sm', className]">
    <h2 class="text-2xl font-bold text-gray-900">
      {{ title }}
    </h2>
    
    <p v-if="description" class="mt-2 text-gray-600">
      {{ description }}
    </p>
    
    <div v-if="$slots.default" class="mt-4">
      <slot />
    </div>
  </div>
</template>

<!--
  Example usage:
  
  <ComponentName 
    title="Hello World"
    description="This is a demo"
  >
    <p>Child content goes here</p>
  </ComponentName>
-->

<!--
  Variant with reactive state:
  
  <script setup lang="ts">
  import { ref } from 'vue'
  
  const count = ref(0)
  
  const increment = () => {
    count.value++
  }
  </script>
  
  <template>
    <button @click="increment">
      Clicked {{ count }} times
    </button>
  </template>
-->
