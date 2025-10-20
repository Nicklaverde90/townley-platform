import axios from "axios";

const api = axios.create({
  baseURL: "/api",
  withCredentials: false,
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("access_token");
  if (token) {
    config.headers = config.headers ?? {};
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export interface WorkOrder {
  RecordNo: number;
  Status?: string | null;
  Description?: string | null;
  CreatedAt?: string | null;
}

export interface WorkOrderList {
  items: WorkOrder[];
  total: number;
  page: number;
  page_size: number;
  sort_by: "RecordNo" | "CreatedAt";
  sort_dir: "asc" | "desc";
}

export async function getWorkOrders(params: { q?: string; page?: number; page_size?: number; sort_by?: "RecordNo"|"CreatedAt"; sort_dir?: "asc"|"desc" }): Promise<WorkOrderList> {
  const resp = await api.get<WorkOrderList>("/workorders", { params });
  return resp.data;
}

export async function createWorkOrder(body: { Description: string; Status?: string | null }): Promise<WorkOrder> {
  const resp = await api.post<WorkOrder>("/workorders", body);
  return resp.data;
}

export async function updateWorkOrder(recordNo: number, body: { Description?: string; Status?: string | null }): Promise<WorkOrder> {
  const resp = await api.put<WorkOrder>(`/workorders/${recordNo}`, body);
  return resp.data;
}

export default api;
