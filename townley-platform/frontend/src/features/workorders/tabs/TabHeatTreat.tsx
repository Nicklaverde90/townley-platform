import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  cycle: z.string().min(1, "Cycle name required"),
  hardnessHRC: z.coerce.number().min(1).max(80),
});

export type HeatTreatInput = z.infer<typeof schema>;

export default function TabHeatTreat({ onSubmit }: { onSubmit: (v: HeatTreatInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Heat Treat"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", cycle: "", hardnessHRC: 30 }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="cycle" className="text-sm font-medium">Cycle</label>
        <input id="cycle" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="cycle" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="hardnessHRC" className="text-sm font-medium">Hardness (HRC)</label>
        <input id="hardnessHRC" type="number" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="hardnessHRC" />
      </div>
    </TabTemplate>
  );
}