import React from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";

const schema = z.object({
  Description: z.string().min(1, "Description is required").max(1000),
  Status: z.string().optional(),
});
export type WorkOrderFormValues = z.infer<typeof schema>;

interface Props {
  initial?: Partial<WorkOrderFormValues>;
  onSubmit: (values: WorkOrderFormValues) => Promise<void> | void;
  submitLabel?: string;
}

export default function WorkOrderForm({ initial, onSubmit, submitLabel = "Save" }: Props) {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<WorkOrderFormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      Description: initial?.Description ?? "",
      Status: initial?.Status ?? "",
    }
  });

  return (
    <form onSubmit={handleSubmit(async (v) => { await onSubmit(v); })} className="space-y-3">
      <div>
        <label htmlFor="desc" className="mb-1 block font-medium">Description</label>
        <textarea id="desc" rows={4} className="w-full rounded-md border px-3 py-2" {...register("Description")} />
        {errors.Description && <p role="alert" className="mt-1 text-sm text-red-600">{errors.Description.message}</p>}
      </div>
      <div>
        <label htmlFor="status" className="mb-1 block font-medium">Status</label>
        <input id="status" type="text" className="w-full rounded-md border px-3 py-2" {...register("Status")} />
        {errors.Status && <p role="alert" className="mt-1 text-sm text-red-600">{errors.Status.message}</p>}
      </div>
      <div className="flex justify-end gap-2">
        <button type="submit" className="rounded-md bg-black px-4 py-2 text-white disabled:opacity-50" aria-busy={isSubmitting}>
          {submitLabel}
        </button>
      </div>
    </form>
  );
}
