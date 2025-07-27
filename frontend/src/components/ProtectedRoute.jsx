import React from 'react';

export default function ProtectedRoute({ isAuthenticated, children }) {
  if (!isAuthenticated) {
    return <p>Please log in to continue.</p>;
  }
  return children;
}
