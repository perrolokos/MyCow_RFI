import React, { useState } from 'react';

export default function AnimalForm({ onSaved }) {
  const [tag, setTag] = useState('');
  const [breed, setBreed] = useState('');
  const [birthDate, setBirthDate] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    // In a real app, post to the API
    fetch('/api/animals', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ tag, breed, birth_date: birthDate })
    }).then(() => onSaved());
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Add Animal</h2>
      <input value={tag} onChange={e => setTag(e.target.value)} placeholder="Tag" />
      <input value={breed} onChange={e => setBreed(e.target.value)} placeholder="Breed" />
      <input type="date" value={birthDate} onChange={e => setBirthDate(e.target.value)} />
      <button type="submit">Save</button>
    </form>
  );
}
