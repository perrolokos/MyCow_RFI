import React, { useEffect, useState } from 'react';

export default function AlertsList() {
  const [alerts, setAlerts] = useState([]);

  useEffect(() => {
    fetch('/api/alerts')
      .then(res => res.json())
      .then(data => setAlerts(data))
      .catch(() => setAlerts([]));
  }, []);

  return (
    <div>
      <h3>Recent Alerts</h3>
      <ul>
        {alerts.map(alert => (
          <li key={alert.id}>{alert.message}</li>
        ))}
      </ul>
    </div>
  );
}
