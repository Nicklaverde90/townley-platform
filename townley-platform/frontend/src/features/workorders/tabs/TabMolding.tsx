import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1, "Operator is required"),
  timestamp: z.string().min(1, "Timestamp is required"),
  notes: z.string().optional(),
  moldNumber: z.string().min(1, "Mold number is required"),
  sandMix: z.string().optional(),
});

export type MoldingInput = z.infer<typeof schema>;

export default function TabMolding({ onSubmit }: { onSubmit: (v: MoldingInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Molding"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", moldNumber: "", sandMix: "" }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="moldNumber" className="text-sm font-medium">Mold Number</label>
        <input id="moldNumber" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="moldNumber" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="sandMix" className="text-sm font-medium">Sand Mix</label>
        <input id="sandMix" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="sandMix" />
      </div>
    </TabTemplate>
  );
}