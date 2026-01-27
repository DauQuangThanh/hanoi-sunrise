/**
 * Layout Template
 * 
 * Wraps pages with common UI elements (navigation, footer, etc.)
 * Place in app/layout.tsx for root layout or app/[route]/layout.tsx for nested layouts
 */

import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: {
    default: 'Site Name',
    template: '%s | Site Name', // Page title will be prepended
  },
  description: 'Site description for search engines',
  keywords: ['keyword1', 'keyword2', 'keyword3'],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="scroll-smooth">
      <body className={inter.className}>
        {/* Navigation */}
        <header className="sticky top-0 z-50 bg-white border-b border-gray-200">
          <nav className="container mx-auto px-4 h-16 flex items-center justify-between">
            <div className="flex items-center space-x-8">
              <a href="/" className="text-xl font-bold text-gray-900">
                Logo
              </a>
              <div className="hidden md:flex space-x-6">
                <a href="/features" className="text-gray-600 hover:text-gray-900">
                  Features
                </a>
                <a href="/pricing" className="text-gray-600 hover:text-gray-900">
                  Pricing
                </a>
                <a href="/about" className="text-gray-600 hover:text-gray-900">
                  About
                </a>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <button className="text-gray-600 hover:text-gray-900">
                Sign In
              </button>
              <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                Get Started
              </button>
            </div>
          </nav>
        </header>

        {/* Main Content */}
        {children}

        {/* Footer */}
        <footer className="bg-gray-900 text-white py-12">
          <div className="container mx-auto px-4 max-w-6xl">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
              <div>
                <h3 className="font-bold text-lg mb-4">Company</h3>
                <ul className="space-y-2">
                  <li>
                    <a href="/about" className="text-gray-400 hover:text-white">
                      About Us
                    </a>
                  </li>
                  <li>
                    <a href="/careers" className="text-gray-400 hover:text-white">
                      Careers
                    </a>
                  </li>
                  <li>
                    <a href="/contact" className="text-gray-400 hover:text-white">
                      Contact
                    </a>
                  </li>
                </ul>
              </div>
              
              <div>
                <h3 className="font-bold text-lg mb-4">Product</h3>
                <ul className="space-y-2">
                  <li>
                    <a href="/features" className="text-gray-400 hover:text-white">
                      Features
                    </a>
                  </li>
                  <li>
                    <a href="/pricing" className="text-gray-400 hover:text-white">
                      Pricing
                    </a>
                  </li>
                  <li>
                    <a href="/docs" className="text-gray-400 hover:text-white">
                      Documentation
                    </a>
                  </li>
                </ul>
              </div>
              
              <div>
                <h3 className="font-bold text-lg mb-4">Resources</h3>
                <ul className="space-y-2">
                  <li>
                    <a href="/blog" className="text-gray-400 hover:text-white">
                      Blog
                    </a>
                  </li>
                  <li>
                    <a href="/support" className="text-gray-400 hover:text-white">
                      Support
                    </a>
                  </li>
                  <li>
                    <a href="/community" className="text-gray-400 hover:text-white">
                      Community
                    </a>
                  </li>
                </ul>
              </div>
              
              <div>
                <h3 className="font-bold text-lg mb-4">Legal</h3>
                <ul className="space-y-2">
                  <li>
                    <a href="/privacy" className="text-gray-400 hover:text-white">
                      Privacy Policy
                    </a>
                  </li>
                  <li>
                    <a href="/terms" className="text-gray-400 hover:text-white">
                      Terms of Service
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            
            <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
              <p>&copy; {new Date().getFullYear()} Company Name. All rights reserved.</p>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
