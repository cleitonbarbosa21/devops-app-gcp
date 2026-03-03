#!/bin/bash

# Atualizar sistema
sudo apt-get update

# Aguardar Docker inicializar
sleep 10

# Criar aplicação temporária para demonstração
mkdir -p /tmp/app/public

# Criar Dockerfile
cat > /tmp/app/Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force
COPY . .
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
RUN chown -R nextjs:nodejs /app
USER nextjs
EXPOSE 3000
ENV NODE_ENV=production PORT=3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"
CMD ["node", "server.js"]
EOF

cat > /tmp/app/package.json << 'EOF'
{
  "name": "devops-app-gcp",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": { "start": "node server.js" },
  "dependencies": { "express": "^4.18.2" }
}
EOF

cat > /tmp/app/server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static('public'));

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/info', (req, res) => {
  res.json({
    app: 'DevOps App GCP',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    instance: process.env.HOSTNAME || 'localhost'
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
EOF

cat > /tmp/app/public/index.html << 'EOF'
<!DOCTYPE html>
<html><head><title>DevOps App - GCP</title></head>
<body>
<h1>DevOps App rodando no GCP!</h1>
<p>Aplicação containerizada em VM do Google Compute Engine</p>
<a href="/health">Health Check</a> | <a href="/api/info">Info API</a>
</body></html>
EOF

# Build da imagem
cd /tmp/app
sudo docker build -t devops-app-gcp:v1.0 .

# Executar container
sudo docker run -d \
  --name devops-app \
  --restart unless-stopped \
  -p 80:3000 \
  -p 3000:3000 \
  devops-app-gcp:v1.0

echo "Aplicação iniciada em $(date)" | sudo tee -a /var/log/app-startup.log