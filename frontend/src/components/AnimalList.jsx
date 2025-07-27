import React, { useEffect, useState } from 'react';

export default function AnimalList({ onSelect }) {
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    // In a real app, fetch from the API
    fetch('/api/animals')
      .then(res => res.json())
      .then(data => setAnimals(data))
      .catch(() => setAnimals([]));
  }, []);

  return (
    <div>
      <h2>Animals</h2>
      <table>
        <thead>
          <tr>
            <th>Tag</th>
            <th>Breed</th>
          </tr>
        </thead>
        <tbody>
          {animals.map(animal => (
            <tr key={animal.id} onClick={() => onSelect(animal.id)}>
              <td>{animal.tag}</td>
              <td>{animal.breed}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
