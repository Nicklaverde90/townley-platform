import React from 'react';

type Props = React.ButtonHTMLAttributes<HTMLButtonElement> & { children: React.ReactNode };

export default function Button({ className = '', children, ...rest }: Props) {
  return (
    <button
      className={`inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-medium ring-1 ring-inset ring-neutral-300 hover:bg-neutral-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-600 ${className}`}
      {...rest}
    >
      {children}
    </button>
  );
}
