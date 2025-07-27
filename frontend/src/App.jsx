import React, { useState } from 'react';
import Login from './components/Login.jsx';
import ProtectedRoute from './components/ProtectedRoute.jsx';
import AnimalList from './components/AnimalList.jsx';
import AnimalForm from './components/AnimalForm.jsx';
import AnimalDetail from './components/AnimalDetail.jsx';
import Dashboard from './components/Dashboard.jsx';
import AlertsList from './components/AlertsList.jsx';
import TrendGraph from './components/TrendGraph.jsx';

export default function App() {
  const [authenticated, setAuthenticated] = useState(false);
  const [selectedId, setSelectedId] = useState(null);
  const [refresh, setRefresh] = useState(false);

  return (
    <div className="container">
      <ProtectedRoute isAuthenticated={authenticated}>
        <Dashboard />
        <TrendGraph />
        <AlertsList />
        <h1>Animals</h1>
        {!selectedId && (
          <>
            <AnimalForm onSaved={() => setRefresh(!refresh)} />
            <AnimalList key={refresh} onSelect={setSelectedId} />
          </>
        )}
        {selectedId && (
          <AnimalDetail id={selectedId} onBack={() => setSelectedId(null)} />
        )}
      </ProtectedRoute>
      {!authenticated && <Login onLogin={() => setAuthenticated(true)} />}
    </div>
  );
}
