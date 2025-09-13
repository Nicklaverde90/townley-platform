import api from "./api";

export async function postStage(stage: string, payload: any) {
  // Default endpoint; change if your backend differs.
  const { data } = await api.post(`/stages/${stage}`, payload);
  return data;
}