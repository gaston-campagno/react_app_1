const express = require('express');
const { metrics, requestCounterMiddleware } = require('../metrics/metrics');

const app = express();
const port = 4000;

// Usa el middleware para contar las solicitudes
app.use(requestCounterMiddleware);

// Define la ruta para las métricas
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', 'text/plain; version=0.0.4; charset=utf-8');
    
    try {
        const metricData = await metrics(); // Espera la resolución de la promesa
        res.end(metricData); // Envía los datos de métricas
    } catch (error) {
        console.error('Error al obtener métricas:', error);
        res.status(500).send('Error al obtener métricas');
    }
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});

