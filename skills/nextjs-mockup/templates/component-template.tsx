/**
 * Component Template
 * 
 * Reusable component for Next.js mockups
 * Replace ComponentName with your actual component name (PascalCase)
 */

import { cn } from '@/lib/utils';

interface ComponentNameProps {
  /**
   * Main title or heading text
   */
  title: string;
  
  /**
   * Optional description or subtitle
   */
  description?: string;
  
  /**
   * Optional CSS classes
   */
  className?: string;
  
  /**
   * Child elements to render
   */
  children?: React.ReactNode;
}

/**
 * ComponentName - Brief description of what this component does
 * 
 * @example
 * ```tsx
 * <ComponentName 
 *   title="Hello World"
 *   description="This is a demo"
 * />
 * ```
 */
export function ComponentName({
  title,
  description,
  className,
  children,
}: ComponentNameProps) {
  return (
    <div className={cn('p-4 bg-white rounded-lg shadow-sm', className)}>
      <h2 className="text-2xl font-bold text-gray-900">
        {title}
      </h2>
      
      {description && (
        <p className="mt-2 text-gray-600">
          {description}
        </p>
      )}
      
      {children && (
        <div className="mt-4">
          {children}
        </div>
      )}
    </div>
  );
}

/**
 * Variant with client-side interactivity
 * Use this template when you need state or event handlers
 * Add 'use client' directive at the top of the file
 */

// 'use client';
// 
// import { useState } from 'react';
// 
// export function InteractiveComponent() {
//   const [count, setCount] = useState(0);
//   
//   return (
//     <button onClick={() => setCount(count + 1)}>
//       Clicked {count} times
//     </button>
//   );
// }
