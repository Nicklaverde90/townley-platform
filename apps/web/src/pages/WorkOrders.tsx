import { useState } from 'react'
import { useWorkOrder, useCreateWorkOrder } from '../api/hooks/useWorkOrder'
export default function WorkOrders(){
  const [id, setId] = useState<number>(1)
  const { data, isLoading, error } = useWorkOrder(id)
  const createMut = useCreateWorkOrder()
  return (
    <div className="space-y-4">
      <h2 className="text-lg font-medium">Work Orders</h2>
      <div className="flex items-center gap-2">
        <input className="border px-2 py-1" type="number" value={id} onChange={e=>setId(Number(e.target.value))} />
      </div>
      {isLoading && <p>Loading...</p>}
      {error && <p className="text-red-600">Error loading work order.</p>}
      {data && <pre className="bg-neutral-100 p-3 rounded text-sm overflow-auto">{JSON.stringify(data, null, 2)}</pre>}
      <hr />
      <button className="border px-3 py-1"
        onClick={()=>createMut.mutate({ WorkOrderNo: 'WO-1001', PartNo: 'PART-ABC', QtyRequired: 1 })}>
        Create Sample Work Order
      </button>
    </div>
  )
}
