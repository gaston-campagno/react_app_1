const client = require('prom-client');

// Configura el colector de métricas
const collectDefaultMetrics = require('prom-client').collectDefaultMetrics;
collectDefaultMetrics();

// Define un contador de solicitudes
const httpRequestCounter = new client.Counter({
    name: 'http_requests_total',
    help: 'Total number of HTTP requests',
    labelNames: ['method', 'route'],
});

// Middleware para contar las solicitudes
const requestCounterMiddleware = (req, res, next) => {
    httpRequestCounter.inc({ method: req.method, route: req.route ? req.route.path : req.path });
    next();
};

// Exporta las métricas y el middleware
module.exports = {
    metrics: () => client.register.metrics(), // Asegúrate de que esto sea una función
    requestCounterMiddleware,
};