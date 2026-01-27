/**
 * Page Template
 * 
 * Next.js App Router page structure
 * Place in app/ directory (e.g., app/about/page.tsx for /about route)
 */

import type { Metadata } from 'next';

/**
 * Page metadata for SEO
 * This will be used for <title>, <meta>, and Open Graph tags
 */
export const metadata: Metadata = {
  title: 'Page Title | Site Name',
  description: 'Page description for search engines and social media',
  openGraph: {
    title: 'Page Title',
    description: 'Description for social media sharing',
    images: ['/og-image.jpg'],
  },
};

/**
 * Main page component
 * Server Component by default (no 'use client' needed unless you need interactivity)
 */
export default function PageName() {
  return (
    <main className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-50 to-indigo-100 py-20">
        <div className="container mx-auto px-4 max-w-6xl">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            Page Heading
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl">
            Page description or tagline goes here
          </p>
        </div>
      </section>

      {/* Main Content */}
      <section className="py-16">
        <div className="container mx-auto px-4 max-w-6xl">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Content cards or components */}
            {[1, 2, 3].map((item) => (
              <div
                key={item}
                className="bg-white p-6 rounded-lg shadow-sm hover:shadow-md transition-shadow"
              >
                <h3 className="text-xl font-semibold text-gray-900 mb-2">
                  Card Title {item}
                </h3>
                <p className="text-gray-600">
                  Card description or content goes here
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-blue-600 text-white py-16">
        <div className="container mx-auto px-4 max-w-4xl text-center">
          <h2 className="text-3xl font-bold mb-4">
            Call to Action Heading
          </h2>
          <p className="text-xl mb-8 opacity-90">
            Compelling description or value proposition
          </p>
          <button className="bg-white text-blue-600 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 transition-colors">
            Primary Action
          </button>
        </div>
      </section>
    </main>
  );
}

/**
 * Alternative: Dynamic page with params
 * Use this when you need URL parameters (e.g., /blog/[slug])
 */

// interface PageProps {
//   params: {
//     slug: string;
//   };
//   searchParams: {
//     [key: string]: string | string[] | undefined;
//   };
// }
//
// export default function DynamicPage({ params, searchParams }: PageProps) {
//   return (
//     <main>
//       <h1>Slug: {params.slug}</h1>
//     </main>
//   );
// }
