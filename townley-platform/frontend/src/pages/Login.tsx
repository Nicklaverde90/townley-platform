import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Button from '../components/Button';
import FormInput from '../components/FormInput';
import api from '../lib/api';

export default function LoginPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      const res = await api.post('/auth/login', { email, password });
      localStorage.setItem('access_token', res.data.access_token);
      navigate('/');
    } catch (err: any) {
      setError(err?.response?.data?.detail || 'Login failed');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="mx-auto max-w-md p-6 bg-white rounded-2xl shadow">
      <h1 className="text-xl font-semibold mb-4">Sign in</h1>
      {error && <div role="alert" className="mb-3 rounded-lg border border-red-300 bg-red-50 p-3 text-sm">{error}</div>}
      <form onSubmit={handleSubmit} aria-label="Sign in form">
        <FormInput id="email" label="Email" type="email" autoComplete="email" required value={email} onChange={e=>setEmail(e.target.value)} />
        <FormInput id="password" label="Password" type="password" autoComplete="current-password" required value={password} onChange={e=>setPassword(e.target.value)} />
        <Button type="submit" disabled={loading} aria-busy={loading}>{loading ? 'Signing in…' : 'Sign in'}</Button>
      </form>
    </div>
  );
}
