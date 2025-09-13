import { Routes, Route, Link } from 'react-router-dom'
import Dashboard from './pages/Dashboard'
import WorkOrders from './pages/WorkOrders'
export default function App(){
  return (
    <div className="min-h-screen">
      <header className="border-b bg-white">
        <div className="mx-auto max-w-6xl px-4 py-3 flex items-center gap-6">
          <h1 className="text-xl font-semibold">Townley</h1>
          <nav className="flex gap-4 text-sm">
            <Link to="/">Dashboard</Link>
            <Link to="/workorders">Work Orders</Link>
          </nav>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-6">
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/workorders" element={<WorkOrders />} />
        </Routes>
      </main>
    </div>
  )
}
