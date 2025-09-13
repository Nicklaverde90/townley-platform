export const STAGES = [
  "Molding",
  "Pouring",
  "HeatTreat",
  "Machining",
  "Assembly",
  "Inspection",
  "Scrap",
  "Chemistry",
] as const;

export type Stage = typeof STAGES[number];

export function stageToLabel(stage: Stage): string {
  const map: Record<Stage, string> = {
    Molding: "Molding",
    Pouring: "Pouring",
    HeatTreat: "Heat Treat",
    Machining: "Machining",
    Assembly: "Assembly",
    Inspection: "Inspection",
    Scrap: "Scrap",
    Chemistry: "Chemistry",
  };
  return map[stage];
}