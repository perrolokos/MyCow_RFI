import React, { useEffect, useRef } from 'react';

export default function TrendGraph() {
  const canvasRef = useRef(null);

  useEffect(() => {
    const ctx = canvasRef.current.getContext('2d');
    ctx.fillStyle = '#eee';
    ctx.fillRect(0,0,300,150);
    ctx.fillStyle = '#333';
    ctx.fillText('Trend graph placeholder', 50, 75);
  }, []);

  return <canvas ref={canvasRef} width="300" height="150" />;
}
