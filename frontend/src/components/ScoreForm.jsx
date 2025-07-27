import React, { useState, useEffect } from 'react';

export default function ScoreForm({ animalId, onSaved }) {
  const [templates, setTemplates] = useState([]);
  const [templateId, setTemplateId] = useState('');
  const [values, setValues] = useState(''); // JSON string

  useEffect(() => {
    fetch('/api/score-templates')
      .then(res => res.json())
      .then(data => setTemplates(data))
      .catch(() => setTemplates([]));
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    fetch(`/api/animals/${animalId}/score`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ template_id: templateId, values: JSON.parse(values) })
    }).then(() => onSaved());
  };

  return (
    <form onSubmit={handleSubmit}>
      <h3>Assign Score</h3>
      <select value={templateId} onChange={e => setTemplateId(e.target.value)}>
        <option value="">Select breed</option>
        {templates.map(t => (
          <option key={t.id} value={t.id}>{t.name}</option>
        ))}
      </select>
      <input value={values} onChange={e => setValues(e.target.value)} placeholder='{"1": 8, "2": 5}' />
      <button type="submit">Save</button>
    </form>
  );
}
