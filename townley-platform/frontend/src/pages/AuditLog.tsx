import React from "react";
import DataTable from "../components/DataTable";
import api from "../lib/api";

type Row = { id: number; ts: string; record_no: number | null; action: string; user: string; details?: string | null };
type Resp = { items: Row[]; total: number; page: number; page_size: number };

const PRESETS = [
  { key: "today", label: "Today" },
  { key: "7d", label: "Last 7 days" },
  { key: "30d", label: "Last 30 days" },
  { key: "month", label: "This month" },
  { key: "custom", label: "Custom" },
] as const;

function presetToRange(key: string): { start?: string; end?: string } {
  const now = new Date();
  const end = now.toISOString();
  if (key === "today") {
    const start = new Date(now.getFullYear(), now.getMonth(), now.getDate()).toISOString();
    return { start, end };
  }
  if (key === "7d") {
    const start = new Date(now.getTime() - 7 * 86400000).toISOString();
    return { start, end };
  }
  if (key === "30d") {
    const start = new Date(now.getTime() - 30 * 86400000).toISOString();
    return { start, end };
  }
  if (key === "month") {
    const start = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
    return { start, end };
  }
  return {};
}

export default function AuditLogPage() {
  const [preset, setPreset] = React.useState<string>(() => localStorage.getItem("audit_preset") || "7d");
  const [start, setStart] = React.useState<string>(() => localStorage.getItem("audit_start") || "");
  const [end, setEnd] = React.useState<string>(() => localStorage.getItem("audit_end") || "");
  const [action, setAction] = React.useState<string>(() => localStorage.getItem("audit_action") || "");
  const [recordNo, setRecordNo] = React.useState<string>(() => localStorage.getItem("audit_recordno") || "");
  const [page, setPage] = React.useState<number>(1);
  const pageSize = 20;
  const [data, setData] = React.useState<Resp | null>(null);
  const [busy, setBusy] = React.useState(false);
  const [err, setErr] = React.useState<string | null>(null);

  React.useEffect(() => {
    if (preset !== "custom") {
      const r = presetToRange(preset);
      setStart(r.start || "");
      setEnd(r.end || "");
    }
  }, [preset]);

  const load = async () => {
    setBusy(true); setErr(null);
    try {
      const params: any = { page, page_size: pageSize };
      if (start) params.start = start;
      if (end) params.end = end;
      if (action) params.action = action;
      if (recordNo) params.record_no = recordNo;
      const resp = await api.get<Resp>("/audit/workorders", { params });
      setData(resp.data);
    } catch (e: any) {
      setErr(e.message || "Failed to load audit.");
    } finally { setBusy(false); }
  };

  React.useEffect(() => { load(); /* eslint-disable-next-line */ }, [preset, start, end, action, recordNo, page]);

  React.useEffect(() => {
    localStorage.setItem("audit_preset", preset);
    localStorage.setItem("audit_start", start);
    localStorage.setItem("audit_end", end);
    localStorage.setItem("audit_action", action);
    localStorage.setItem("audit_recordno", recordNo);
  }, [preset, start, end, action, recordNo]);

  const exportCsv = async () => {
    const params: any = {};
    if (start) params.start = start;
    if (end) params.end = end;
    if (action) params.action = action;
    if (recordNo) params.record_no = recordNo;
    const qs = new URLSearchParams(params).toString();
    const link = document.createElement("a");
    link.href = `/api/audit/workorders/export?${qs}`;
    link.download = "audit.csv";
    link.click();
  };

  return (
    <main className="mx-auto max-w-6xl p-4">
      <h1 className="mb-3 text-2xl font-bold">Audit Log</h1>

      <fieldset className="mb-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4" aria-busy={busy}>
        <legend className="sr-only">Filters</legend>
        <div>
          <label htmlFor="preset" className="block text-sm font-medium">Date preset</label>
          <select id="preset" value={preset} onChange={(e)=>{ setPage(1); setPreset(e.target.value); }} className="mt-1 w-full rounded border px-2 py-1">
            {PRESETS.map(p => <option key={p.key} value={p.key}>{p.label}</option>)}
          </select>
        </div>
        <div>
          <label htmlFor="start" className="block text-sm font-medium">Start (ISO)</label>
          <input id="start" value={start} onChange={(e)=>{ setPage(1); setStart(e.target.value); }} className="mt-1 w-full rounded border px-2 py-1" placeholder="YYYY-MM-DDTHH:mm:ssZ" disabled={preset!=="custom"} />
        </div>
        <div>
          <label htmlFor="end" className="block text-sm font-medium">End (ISO)</label>
          <input id="end" value={end} onChange={(e)=>{ setPage(1); setEnd(e.target.value); }} className="mt-1 w-full rounded border px-2 py-1" placeholder="YYYY-MM-DDTHH:mm:ssZ" disabled={preset!=="custom"} />
        </div>
        <div>
          <label htmlFor="action" className="block text-sm font-medium">Action</label>
          <input id="action" value={action} onChange={(e)=>{ setPage(1); setAction(e.target.value); }} className="mt-1 w-full rounded border px-2 py-1" placeholder="create|update|delete|import" />
        </div>
        <div>
          <label htmlFor="record" className="block text-sm font-medium">RecordNo</label>
          <input id="record" value={recordNo} onChange={(e)=>{ setPage(1); setRecordNo(e.target.value); }} className="mt-1 w-full rounded border px-2 py-1" placeholder="12345" />
        </div>
        <div className="flex items-end gap-2">
          <button onClick={load} className="rounded border px-3 py-2">Apply</button>
          <button onClick={exportCsv} className="rounded border px-3 py-2">Export CSV</button>
        </div>
      </fieldset>

      {err && <div role="alert" className="mb-3 rounded border border-red-200 bg-red-50 p-3 text-red-700">{err}</div>}

      <DataTable<Row>
        caption="Audit entries"
        columns={[
          { key: "id", header: "ID", accessor: r => <span className="font-mono">{r.id}</span> },
          { key: "ts", header: "Timestamp", accessor: r => new Date(r.ts).toLocaleString() },
          { key: "record_no", header: "RecordNo", accessor: r => r.record_no ?? "—" },
          { key: "action", header: "Action", accessor: r => r.action },
          { key: "user", header: "User", accessor: r => r.user },
          { key: "details", header: "Details", accessor: r => r.details || "—" },
        ]}
        data={data?.items ?? []}
      />

      <nav className="mt-4 flex items-center justify-between" aria-label="Pagination">
        <p className="text-sm text-gray-600">
          Page <span className="font-semibold">{data?.page ?? 1}</span> of <span className="font-semibold">{Math.max(1, Math.ceil((data?.total ?? 0) / (data?.page_size ?? 20)) )}</span> — {data?.total ?? 0} total
        </p>
        <div className="flex gap-2">
          <button className="rounded border px-3 py-1" onClick={()=>setPage(1)}>First</button>
          <button className="rounded border px-3 py-1" onClick={()=>setPage(p=>Math.max(1,p-1))}>Prev</button>
          <button className="rounded border px-3 py-1" onClick={()=>setPage(p=>p+1)}>Next</button>
        </div>
      </nav>
    </main>
  );
}
