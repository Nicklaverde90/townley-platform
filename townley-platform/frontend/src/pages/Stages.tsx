import * as React from "react";
import StageTabs from "../features/workorders/tabs/StageTabs";

export default function StagesPage() {
  const [recordNo, setRecordNo] = React.useState<number>(1001);
  return (
    <main className="mx-auto max-w-6xl p-4">
      <h1 className="mb-4 text-2xl font-bold">Stages (Demo)</h1>
      <div className="mb-4 flex items-end gap-2">
        <label htmlFor="rec" className="text-sm font-medium">RecordNo</label>
        <input id="rec" type="number" className="rounded-md border px-3 py-2" value={recordNo} onChange={(e)=>setRecordNo(parseInt(e.target.value || "0"))} />
      </div>
      <StageTabs recordNo={recordNo} />
    </main>
  );
}