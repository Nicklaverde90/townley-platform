import api from "./api";

export interface Me {
  email: string;
  is_admin?: boolean;
  role?: "viewer" | "editor" | "admin";
}

export interface ImportJobStatus {
  id: string;
  status: "queued" | "started" | "finished" | "failed";
  progress: number;
  result?: {
    total: number;
    upserts: number;
    errors: Array<{ line: number; message: string }>;
  };
}

export async function me(): Promise<Me> {
  const resp = await api.get<Me>("/users/me");
  return resp.data;
}

export async function exportWorkOrdersCsv(): Promise<Blob> {
  const resp = await api.get("/workorders/export", { responseType: "blob" });
  return resp.data as Blob;
}

export async function startImportJob(file: File): Promise<string> {
  const form = new FormData();
  form.append("file", file);
  const resp = await api.post<{ job_id: string }>("/workorders/import-async", form, {
    headers: { "Content-Type": "multipart/form-data" },
  });
  return resp.data.job_id;
}

export async function getJobStatus(jobId: string): Promise<ImportJobStatus> {
  const resp = await api.get<ImportJobStatus>(`/jobs/${jobId}`);
  return resp.data;
}

export async function hardDeleteWorkOrder(recordNo: number): Promise<void> {
  await api.delete(`/workorders/${recordNo}/hard-delete`);
}

export function auditStreamUrl(): string {
  const token = localStorage.getItem("access_token");
  const base = "/api/audit/stream";
  const url = new URL(base, window.location.origin);
  if (token) url.searchParams.set("token", token);
  return url.toString();
}
