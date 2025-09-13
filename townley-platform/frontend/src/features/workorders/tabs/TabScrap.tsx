import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  reason: z.string().min(1, "Reason required"),
  quantity: z.coerce.number().min(1),
});

export type ScrapInput = z.infer<typeof schema>;

export default function TabScrap({ onSubmit }: { onSubmit: (v: ScrapInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Scrap"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", reason: "", quantity: 1 }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="reason" className="text-sm font-medium">Reason</label>
        <input id="reason" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="reason" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="quantity" className="text-sm font-medium">Quantity</label>
        <input id="quantity" type="number" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="quantity" />
      </div>
    </TabTemplate>
  );
}