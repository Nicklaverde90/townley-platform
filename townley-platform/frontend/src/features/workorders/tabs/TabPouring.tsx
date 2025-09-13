import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  temperatureC: z.coerce.number().min(400, "Too low").max(1800, "Too high"),
  ladleId: z.string().min(1, "Ladle ID required"),
});

export type PouringInput = z.infer<typeof schema>;

export default function TabPouring({ onSubmit }: { onSubmit: (v: PouringInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Pouring"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", temperatureC: 1500, ladleId: "" }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="temperatureC" className="text-sm font-medium">Temperature (°C)</label>
        <input id="temperatureC" type="number" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="temperatureC" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="ladleId" className="text-sm font-medium">Ladle ID</label>
        <input id="ladleId" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="ladleId" />
      </div>
    </TabTemplate>
  );
}