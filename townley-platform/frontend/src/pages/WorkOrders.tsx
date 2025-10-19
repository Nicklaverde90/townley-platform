import React from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import DataTable from "../components/DataTable";
import { getWorkOrders } from "../lib/api";
import type { WorkOrder } from "../lib/api";
import { exportWorkOrdersCsv, startImportJob, getJobStatus, hardDeleteWorkOrder } from "../lib/api-admin";

export default function WorkOrdersPage() {
  const [q, setQ] = React.useState<string>("");
  const [page, setPage] = React.useState<number>(1);
  const [jobId, setJobId] = React.useState<string | null>(null);
  const [jobStatus, setJobStatus] = React.useState<{progress:number; status:string; result?:any} | null>(null);
  const pageSize = 10;
  const qc = useQueryClient();

  const { data, isFetching, isError, error, refetch } = useQuery({
    queryKey: ["workorders", q, page],
    queryFn: () => getWorkOrders({ q: q || undefined, page, page_size: pageSize }),
    keepPreviousData: true,
  });

  const total = data?.total ?? 0;
  const lastPage = Math.max(1, Math.ceil(total / pageSize));

  React.useEffect(() => {
    if (page > lastPage) setPage(lastPage);
  }, [lastPage, page]);

  // Poll job status when jobId is present
  React.useEffect(() => {
    let timer: any;
    const poll = async () => {
      if (!jobId) return;
      const s = await getJobStatus(jobId);
      setJobStatus({ progress: s.progress, status: s.status, result: s.result });
      if (s.status === "finished" || s.status === "failed") return;
      timer = setTimeout(poll, 1000);
    };
    poll();
    return () => timer && clearTimeout(timer);
  }, [jobId]);

  const exportCsv = async () => {
    const blob = await exportWorkOrdersCsv();
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "workorders.csv";
    a.click();
    window.URL.revokeObjectURL(url);
  };

  const importMutation = useMutation({
    mutationFn: async (file: File) => {
      const id = await startImportJob(file);
      setJobId(id);
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (rn: number) => {
      await hardDeleteWorkOrder(rn);
    },
    onSuccess: async () => {
      await qc.invalidateQueries({ queryKey: ["workorders"] });
    }
  });

  return (
    <main className="mx-auto max-w-6xl p-4">
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <h1 className="text-2xl font-bold">Work Orders</h1>
        <div className="flex w-full max-w-xl items-center gap-2">
          <label htmlFor="search" className="sr-only">Search</label>
          <input
            id="search"
            type="search"
            className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2"
            placeholder="Search by RecordNo or Description"
            value={q}
            onChange={(e) => { setPage(1); setQ(e.target.value); }}
            aria-label="Search work orders"
          />
          <button
            className="rounded-lg border px-3 py-2 font-medium hover:bg-gray-50"
            onClick={() => refetch()}
            aria-busy={isFetching}
          >
            Search
          </button>
          <button
            className="rounded-lg border px-3 py-2 font-medium hover:bg-gray-50"
            onClick={exportCsv}
          >
            Export CSV
          </button>
          <label className="rounded-lg border px-3 py-2 font-medium hover:bg-gray-50 cursor-pointer">
            Import CSV
            <input
              type="file"
              accept=".csv,text/csv"
              className="sr-only"
              onChange={(e) => {
                const f = e.target.files?.[0];
                if (f) importMutation.mutate(f);
              }}
            />
          </label>
        </div>
      </div>

      {jobId && (
        <div className="mb-4 rounded-md border p-3" role="status" aria-live="polite">
          <p className="font-medium">Import job: {jobStatus?.status ?? "queued"}</p>
          <div className="mt-2 h-3 w-full rounded bg-gray-200">
            <div className="h-3 rounded bg-blue-500" style={{ width: `${jobStatus?.progress ?? 0}%` }} />
          </div>
          {jobStatus?.result && (
            <p className="mt-2 text-sm text-gray-700">
              Imported {jobStatus.result.upserts}/{jobStatus.result.total}. {jobStatus.result.errors.length} errors.
            </p>
          )}
        </div>
      )}

      {isError && (
        <div role="alert" className="mb-3 rounded-md border border-red-200 bg-red-50 p-3 text-red-700">
          {(error as Error)?.message || "Failed to load work orders."}
        </div>
      )}

      <section aria-busy={isFetching}>
        <DataTable<WorkOrder>
          caption="List of work orders"
          columns={[
            { key: "record", header: "RecordNo", accessor: (r) => <span className="font-mono">{r.RecordNo}</span> },
            { key: "status", header: "Status", accessor: (r) => r.Status || "—" },
            { key: "desc", header: "Description", accessor: (r) => r.Description || "—" },
            { key: "actions", header: "Actions", accessor: (r) => (
              <button
                className="rounded-md border px-2 py-1 text-sm hover:bg-gray-50"
                onClick={() => {
                  if (confirm(`Hard-delete work order ${r.RecordNo}? This cannot be undone.`)) {
                    deleteMutation.mutate(r.RecordNo);
                  }
                }}
              >
                Delete
              </button>
            )},
          ]}
          data={data?.items ?? []}
          emptyMessage={q ? "No matching work orders." : "No work orders yet."}
        />

        <nav className="mt-4 flex items-center justify-between" aria-label="Pagination">
          <p className="text-sm text-gray-600">
            Page <span className="font-semibold">{page}</span> of <span className="font-semibold">{lastPage}</span> — {total} total
          </p>
          <div className="flex gap-2">
            <button className="rounded-md border px-3 py-1 disabled:opacity-50" onClick={() => setPage(1)} disabled={page <= 1}>First</button>
            <button className="rounded-md border px-3 py-1 disabled:opacity-50" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page <= 1}>Prev</button>
            <button className="rounded-md border px-3 py-1 disabled:opacity-50" onClick={() => setPage((p) => Math.min(lastPage, p + 1))} disabled={page >= lastPage}>Next</button>
            <button className="rounded-md border px-3 py-1 disabled:opacity-50" onClick={() => setPage(lastPage)} disabled={page >= lastPage}>Last</button>
          </div>
        </nav>
      </section>
    </main>
  );
}
