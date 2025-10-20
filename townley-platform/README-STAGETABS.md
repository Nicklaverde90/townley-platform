StageTabs Frontend Components
=============================

This patch adds accessible, responsive StageTabs components for Work Orders.

Files:
- frontend/src/components/TabsA11y.tsx           # Reusable ARIA-correct Tabs
- frontend/src/features/workorders/tabs/stages.ts # Stage enum/list helpers
- frontend/src/features/workorders/tabs/StageTabs.tsx
- frontend/src/features/workorders/tabs/TabTemplate.tsx
- frontend/src/features/workorders/tabs/TabMolding.tsx
- frontend/src/features/workorders/tabs/TabPouring.tsx
- frontend/src/features/workorders/tabs/TabHeatTreat.tsx
- frontend/src/features/workorders/tabs/TabMachining.tsx
- frontend/src/features/workorders/tabs/TabAssembly.tsx
- frontend/src/features/workorders/tabs/TabInspection.tsx
- frontend/src/features/workorders/tabs/TabScrap.tsx
- frontend/src/features/workorders/tabs/TabChemistry.tsx
- frontend/src/lib/api-stages.ts                  # Optional: posts to /api/stages/{stage}

Optional demo page:
- frontend/src/pages/Stages.tsx                   # Route to test tabs standalone

Usage:
- Mount <StageTabs recordNo={123} /> inside a protected page.
- By default, submit calls POST /api/stages/{stage}. If your backend differs,
  pass a custom onSubmit handler to StageTabs.

Dependencies:
- react-hook-form, zod, @hookform/resolvers, react-router-dom, axios

Install (if needed):
docker compose exec web npm i react-hook-form zod @hookform/resolvers
