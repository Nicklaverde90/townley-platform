import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  carbonPct: z.coerce.number().min(0).max(10),
  manganesePct: z.coerce.number().min(0).max(10),
});

export type ChemistryInput = z.infer<typeof schema>;

export default function TabChemistry({ onSubmit }: { onSubmit: (v: ChemistryInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Chemistry"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", carbonPct: 0.3, manganesePct: 0.8 }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="carbonPct" className="text-sm font-medium">Carbon (%)</label>
        <input id="carbonPct" type="number" step="0.01" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="carbonPct" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="manganesePct" className="text-sm font-medium">Manganese (%)</label>
        <input id="manganesePct" type="number" step="0.01" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="manganesePct" />
      </div>
    </TabTemplate>
  );
}