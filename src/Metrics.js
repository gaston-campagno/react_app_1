import React, { useEffect, useState } from 'react';

const Metrics = () => {
  const [metrics, setMetrics] = useState('');

  useEffect(() => {
    fetch('/metrics')
      .then(response => response.text())
      .then(data => setMetrics(data))
      .catch(error => console.error('Error fetching metrics:', error));
  }, []);

  return (
    <pre>{metrics}</pre>
  );
};

export default Metrics;
