import * as React from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";

type TemplateProps<T extends z.ZodTypeAny> = {
  title: string;
  schema: T;
  defaultValues: z.infer<T>;
  onSubmit: (values: z.infer<T>) => Promise<void> | void;
  submitLabel?: string;
  children?: React.ReactNode; // additional fields
};

export default function TabTemplate<T extends z.ZodTypeAny>({
  title,
  schema,
  defaultValues,
  onSubmit,
  submitLabel = "Save",
  children,
}: TemplateProps<T>) {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<z.infer<T>>({
    resolver: zodResolver(schema),
    defaultValues,
  });

  // Helper to render a text field with label and error
  const Field = ({
    name,
    label,
    type = "text",
    placeholder,
  }: { name: keyof z.infer<T> & string; label: string; type?: string; placeholder?: string }) => (
    <div className="grid gap-1">
      <label htmlFor={name} className="text-sm font-medium">{label}</label>
      <input
        id={name}
        type={type}
        placeholder={placeholder}
        aria-invalid={!!(errors as any)[name]}
        aria-describedby={ (errors as any)[name] ? `${name}-error` : undefined }
        className="rounded-md border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2"
        {...register(name as any)}
      />
      {(errors as any)[name] && (
        <div id={`${name}-error`} role="alert" className="text-sm text-red-600">
          {(errors as any)[name]?.message as string}
        </div>
      )}
    </div>
  );

  return (
    <form
      className="grid gap-4 p-4"
      aria-label={title}
      onSubmit={handleSubmit(async (vals) => { await onSubmit(vals); })}
    >
      <h2 className="text-lg font-semibold">{title}</h2>

      {/* Slot for children to insert custom fields */}
      {children}

      {/* Common fields */}
      <Field name={"operator" as any} label="Operator" />
      <Field name={"timestamp" as any} type="datetime-local" label="Timestamp" />
      <div className="grid gap-1">
        <label htmlFor="notes" className="text-sm font-medium">Notes</label>
        <textarea id="notes" className="min-h-[80px] rounded-md border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2" {...register("notes" as any)} />
        {(errors as any)["notes"] && (
          <div id="notes-error" role="alert" className="text-sm text-red-600">
            {(errors as any)["notes"]?.message as string}
          </div>
        )}
      </div>

      <div className="flex gap-2">
        <button
          type="submit"
          className="rounded-md border px-3 py-2 font-medium hover:bg-gray-50"
          disabled={isSubmitting}
          aria-busy={isSubmitting}
        >
          {submitLabel}
        </button>
      </div>
    </form>
  );
}