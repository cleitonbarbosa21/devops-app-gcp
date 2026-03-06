const express = require('express');
const path = require('path');
const promClient = require('prom-client');
const app = express();
const PORT = process.env.PORT || 3000;

// Configurar coleta de métricas padrão
promClient.collectDefaultMetrics();

// Criar métricas customizadas
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status'],
  buckets: [0.1, 0.5, 1, 2, 5]
});

const httpRequestTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status']
});

const activeConnections = new promClient.Gauge({
  name: 'active_connections',
  help: 'Number of active connections'
});

// Middleware para métricas
app.use((req, res, next) => {
  const start = Date.now();
  activeConnections.inc();

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    const route = req.route?.path || req.path;
    
    httpRequestDuration.observe(
      { method: req.method, route, status: res.statusCode },
      duration
    );
    
    httpRequestTotal.inc({
      method: req.method,
      route,
      status: res.statusCode
    });
    
    activeConnections.dec();
  });
  
  next();
});

app.use(express.static('public'));

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/api/info', (req, res) => {
  res.json({
    app: 'DevOps App GCP',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    pod: process.env.HOSTNAME || 'localhost'
  });
});

// Endpoint de métricas
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  try {
    const metrics = await promClient.register.metrics();
    res.end(metrics);
  } catch (error) {
    res.status(500).end(error);
  }
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const server = app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
  });
});

module.exports = app;
