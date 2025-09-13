import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  assemblyLine: z.string().min(1, "Assembly line required"),
  quantity: z.coerce.number().min(1),
});

export type AssemblyInput = z.infer<typeof schema>;

export default function TabAssembly({ onSubmit }: { onSubmit: (v: AssemblyInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Assembly"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", assemblyLine: "", quantity: 1 }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="assemblyLine" className="text-sm font-medium">Assembly Line</label>
        <input id="assemblyLine" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="assemblyLine" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="quantity" className="text-sm font-medium">Quantity</label>
        <input id="quantity" type="number" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="quantity" />
      </div>
    </TabTemplate>
  );
}