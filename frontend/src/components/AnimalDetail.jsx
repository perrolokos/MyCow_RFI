import React, { useEffect, useState } from 'react';
import ScoreForm from './ScoreForm.jsx';
import TrendGraph from './TrendGraph.jsx';
import AlertsList from './AlertsList.jsx';

export default function AnimalDetail({ id, onBack }) {
  const [animal, setAnimal] = useState(null);
  const [score, setScore] = useState(null);

  useEffect(() => {
    if (!id) return;
    fetch(`/api/animals/${id}`)
      .then(res => res.json())
      .then(data => setAnimal(data))
      .catch(() => setAnimal(null));

    fetch(`/api/animals/${id}/score`)
      .then(res => res.json())
      .then(data => setScore(data))
      .catch(() => setScore(null));
  }, [id]);

  if (!animal) return <p>Loading...</p>;

  return (
    <div>
      <button onClick={onBack}>Back</button>
      <h2>Animal Detail</h2>
      <p>Tag: {animal.tag}</p>
      <p>Breed: {animal.breed}</p>
      <p>Birth Date: {animal.birth_date}</p>
      {score && <p>Score: {score.total}</p>}
      <ScoreForm animalId={id} onSaved={() => {
        fetch(`/api/animals/${id}/score`)
          .then(res => res.json())
          .then(data => setScore(data));
      }} />
      <TrendGraph />
      <AlertsList />
    </div>
  );
}
