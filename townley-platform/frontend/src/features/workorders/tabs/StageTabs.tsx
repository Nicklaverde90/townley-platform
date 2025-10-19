import React from "react";
import { Tabs } from "../../../components/TabsA11y";
import { submitStage } from "../../../lib/api-stages";
import type { StageName } from "../../../lib/api-stages";
import TabMolding from "./TabMolding";
import TabPouring from "./TabPouring";
import TabHeatTreat from "./TabHeatTreat";
import TabMachining from "./TabMachining";
import TabAssembly from "./TabAssembly";
import TabInspection from "./TabInspection";
import TabScrap from "./TabScrap";
import TabChemistry from "./TabChemistry";

type Props = {
  recordNo: number;
  onSubmitted?: (args: { stage: StageName; recordNo: number; ok: boolean }) => void;
};

const stages: { name: StageName; element: (recordNo: number, onSubmit: (data:any)=>Promise<void>) => React.ReactNode }[] = [
  { name: "Molding",    element: (r, on) => <TabMolding recordNo={r} onSubmit={on} /> },
  { name: "Pouring",    element: (r, on) => <TabPouring recordNo={r} onSubmit={on} /> },
  { name: "HeatTreat",  element: (r, on) => <TabHeatTreat recordNo={r} onSubmit={on} /> },
  { name: "Machining",  element: (r, on) => <TabMachining recordNo={r} onSubmit={on} /> },
  { name: "Assembly",   element: (r, on) => <TabAssembly recordNo={r} onSubmit={on} /> },
  { name: "Inspection", element: (r, on) => <TabInspection recordNo={r} onSubmit={on} /> },
  { name: "Scrap",      element: (r, on) => <TabScrap recordNo={r} onSubmit={on} /> },
  { name: "Chemistry",  element: (r, on) => <TabChemistry recordNo={r} onSubmit={on} /> },
];

export default function StageTabs({ recordNo, onSubmitted }: Props) {
  const [active, setActive] = React.useState(0);

  async function handleSubmit(stage: StageName, fields: Record<string, any>) {
    const payload = { recordNo, ...fields };
    const res = await submitStage(stage, payload);
    onSubmitted?.({ stage, recordNo, ok: !!res?.ok });
  }

  return (
    <section aria-label="Work order stages" className="w-full">
      <Tabs labels={stages.map((s) => s.name)} value={active} onChange={setActive}>
        {stages.map((s) => (
          <Tabs.Panel key={s.name}>
            {s.element(recordNo, (data) => handleSubmit(s.name, data))}
          </Tabs.Panel>
        ))}
      </Tabs>
    </section>
  );
}
