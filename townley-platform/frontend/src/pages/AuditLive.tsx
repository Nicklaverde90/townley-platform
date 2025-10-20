import React from "react";
import { auditStreamUrl } from "../lib/api-admin";

type EventRow = { id:number; ts:string|null; record_no:number|null; action:string; user:string; details?:string|null };

export default function AuditLivePage() {
  const [rows, setRows] = React.useState<EventRow[]>([]);
  const [paused, setPaused] = React.useState(false);
  const [sinceId, setSinceId] = React.useState<number | null>(null);

  React.useEffect(() => {
    if (paused) return;
    const url = new URL(auditStreamUrl());
    if (sinceId) url.searchParams.set("since_id", String(sinceId));
    const es = new EventSource(url.toString(), { withCredentials: false });
    es.onmessage = (ev) => {
      try {
        const payload = JSON.parse(ev.data.replace(/'/g, '"')); // server sends python dict style; be defensive
        setRows((prev) => {
          const next = [...prev, payload];
          if (payload.id) setSinceId(payload.id);
          return next.slice(-500); // keep last 500
        });
      } catch {}
    };
    es.onerror = () => { es.close(); };
    return () => { es.close(); };
  }, [paused, sinceId]);

  return (
    <main className="mx-auto max-w-6xl p-4">
      <header className="mb-3 flex items-center justify-between">
        <h1 className="text-2xl font-bold">Audit Live</h1>
        <div className="flex items-center gap-2">
          <button className="rounded border px-3 py-2" onClick={()=>setPaused(p=>!p)} aria-pressed={paused}>
            {paused ? "Resume" : "Pause"}
          </button>
          <button className="rounded border px-3 py-2" onClick={()=>{ setRows([]); setSinceId(null); }}>
            Clear
          </button>
        </div>
      </header>

      <div className="h-[60vh] overflow-auto rounded border p-2 font-mono text-sm" role="log" aria-live="polite">
        {rows.length === 0 ? <p className="text-gray-500">Waiting for events…</p> : null}
        {rows.map(r => (
          <div key={r.id} className="border-b py-1">
            <span className="text-gray-500">{r.ts ? new Date(r.ts).toLocaleTimeString() : "—"}</span>
            {"  "}
            <strong>{r.action}</strong>
            {"  "}
            <span>record={r.record_no ?? "—"}</span>
            {"  "}
            <span>by={r.user}</span>
            {r.details ? <> — <span>{r.details}</span></> : null}
          </div>
        ))}
      </div>
    </main>
  );
}
