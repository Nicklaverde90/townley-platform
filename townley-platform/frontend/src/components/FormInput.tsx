import React from 'react';

type Props = React.InputHTMLAttributes<HTMLInputElement> & {
  label: string;
  id: string;
};

export default function FormInput({ id, label, className = '', ...rest }: Props) {
  return (
    <div className="mb-3">
      <label htmlFor={id} className="block text-sm font-medium text-neutral-800 mb-1">{label}</label>
      <input
        id={id}
        className={`w-full rounded-lg border border-neutral-300 bg-white px-3 py-2 text-sm shadow-sm focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-600 ${className}`}
        {...rest}
      />
    </div>
  );
}
