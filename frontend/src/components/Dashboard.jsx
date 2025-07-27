import React, { useEffect, useState } from 'react';

export default function Dashboard() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch('/api/dashboard')
      .then(res => res.json())
      .then(setData)
      .catch(() => setData(null));
  }, []);

  if (!data) return <p>Loading...</p>;

  return (
    <div>
      <h2>Dashboard</h2>
      <p>Total animals: {data.animals}</p>
      <p>Total alerts: {data.alerts}</p>
      <p>Average score: {data.average_score}</p>
      <button onClick={() => {
        fetch('/api/reports', { method: 'POST' });
      }}>Generate PDF Report</button>
    </div>
  );
}
