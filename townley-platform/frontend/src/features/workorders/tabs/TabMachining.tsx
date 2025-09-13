import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  machineId: z.string().min(1, "Machine ID required"),
  toolUsed: z.string().optional(),
});

export type MachiningInput = z.infer<typeof schema>;

export default function TabMachining({ onSubmit }: { onSubmit: (v: MachiningInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Machining"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", machineId: "", toolUsed: "" }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="machineId" className="text-sm font-medium">Machine ID</label>
        <input id="machineId" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="machineId" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="toolUsed" className="text-sm font-medium">Tool Used</label>
        <input id="toolUsed" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="toolUsed" />
      </div>
    </TabTemplate>
  );
}