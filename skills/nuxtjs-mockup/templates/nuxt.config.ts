/**
 * Nuxt Configuration Template
 * 
 * Main configuration file for Nuxt 4 project
 * https://nuxt.com/docs/api/configuration/nuxt-config
 */
export default defineNuxtConfig({
  /**
   * Development tools
   */
  devtools: { enabled: true },

  /**
   * Modules
   * Add Nuxt modules here
   */
  modules: [
    '@nuxt/icon',
    // '@nuxt/image', // Uncomment for image optimization
    // '@nuxt/ui', // Uncomment for pre-built UI components
    // '@pinia/nuxt', // Uncomment for state management
  ],

  /**
   * Vite configuration
   * Tailwind CSS 4 uses the Vite plugin instead of the Nuxt module
   */
  vite: {
    plugins: [
      require('@tailwindcss/vite')(),
    ],
  },

  /**
   * CSS files
   * Import global CSS including Tailwind
   */
  css: [
    '~/assets/css/tailwind.css',
  ],
  },

  /**
   * App configuration
   */
  app: {
    head: {
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1',
      title: 'Site Name',
      meta: [
        { name: 'description', content: 'Site description' }
      ],
    },
  },

  /**
   * Runtime config
   * Public config is exposed to the client
   */
  runtimeConfig: {
    // Private keys (server-side only)
    apiSecret: '',
    
    // Public keys (exposed to client)
    public: {
      apiBase: '/api',
    },
  },

  /**
   * TypeScript configuration
   */
  typescript: {
    strict: true,
    typeCheck: true,
  },

  /**
   * Vite configuration
   * Nuxt 3 uses Vite by default
   */
  vite: {
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: '@use "@/assets/scss/variables.scss" as *;'
        }
      }
    }
  },

  /**
   * Build configuration
   */
  build: {
    // Build options
  },

  /**
   * Development server configuration
   */
  devServer: {
    port: 3000,
    host: '0.0.0.0', // Listen on all network interfaces
  },

  /**
   * Auto-import configuration
   */
  imports: {
    dirs: [
      // Auto-import from these directories
      'composables',
      'utils',
    ]
  },

  /**
   * Components configuration
   */
  components: [
    {
      path: '~/components',
      pathPrefix: false, // Remove path prefix from component names
    }
  ],

  /**
   * Experimental features
   */
  experimental: {
    // Enable experimental features here
    payloadExtraction: false,
    viewTransition: true, // Enable View Transitions API
  },

  /**
   * Compatibility date
   */
  compatibilityDate: '2024-01-26',
})
