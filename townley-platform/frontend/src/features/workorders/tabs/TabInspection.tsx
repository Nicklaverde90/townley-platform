import * as React from "react";
import { z } from "zod";
import TabTemplate from "./TabTemplate";

const schema = z.object({
  operator: z.string().min(1),
  timestamp: z.string().min(1),
  notes: z.string().optional(),
  result: z.enum(["pass", "fail"], { required_error: "Result required" }),
  inspector: z.string().min(1, "Inspector is required"),
});

export type InspectionInput = z.infer<typeof schema>;

export default function TabInspection({ onSubmit }: { onSubmit: (v: InspectionInput) => Promise<void> | void }) {
  return (
    <TabTemplate
      title="Inspection"
      schema={schema}
      defaultValues={{ operator: "", timestamp: "", notes: "", result: "pass", inspector: "" }}
      onSubmit={onSubmit}
    >
      <div className="grid gap-1">
        <label htmlFor="inspector" className="text-sm font-medium">Inspector</label>
        <input id="inspector" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="inspector" />
      </div>
      <div className="grid gap-1">
        <label htmlFor="result" className="text-sm font-medium">Result</label>
        <select id="result" className="rounded-md border px-3 py-2 focus:outline-none focus:ring-2" name="result">
          <option value="pass">Pass</option>
          <option value="fail">Fail</option>
        </select>
      </div>
    </TabTemplate>
  );
}
