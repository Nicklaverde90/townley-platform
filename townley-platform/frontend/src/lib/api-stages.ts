import api from "./api";

export type StageName =
  | "Molding"
  | "Pouring"
  | "HeatTreat"
  | "Machining"
  | "Assembly"
  | "Inspection"
  | "Scrap"
  | "Chemistry";

const stageEndpoints: Record<StageName, string> = {
  Molding: "/molding",
  Pouring: "/pouring",
  HeatTreat: "/heattreat",
  Machining: "/machining",
  Assembly: "/assembly",
  Inspection: "/inspection",
  Scrap: "/scrap",
  Chemistry: "/chemistry",
};

export interface StageSubmissionResponse {
  ok: boolean;
  recordNo: number;
  stage: StageName;
  fields: Record<string, unknown>;
}

export async function submitStage(
  stage: StageName,
  payload: Record<string, unknown>
): Promise<StageSubmissionResponse> {
  const endpoint = stageEndpoints[stage];
  const { data } = await api.post<StageSubmissionResponse>(endpoint, payload);
  return data;
}

// Fallback utility for custom stages if needed.
export async function postStage(stage: string, payload: unknown) {
  const { data } = await api.post(`/stages/${stage}`, payload);
  return data;
}
