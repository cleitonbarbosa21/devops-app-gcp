# 🚀 Descomplicando a Stack DevOps no Google Cloud Platform

> **DevOps: A Ponte entre o Código e o Deploy**

---

## 📑 Índice

- [Sobre o Treinamento](#-sobre-o-treinamento)
- [Pré-requisitos](#-pré-requisitos)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Quick Start](#-quick-start)
- [Dia 1: Docker e Containerização](#-dia-1-docker-e-containerização)
- [Dia 2: Terraform e Infrastructure as Code](#-dia-2-terraform-e-infrastructure-as-code)
- [Dia 3: Kubernetes no GKE](#-dia-3-kubernetes-no-gke)
- [Dia 4: CI/CD Pipeline](#-dia-4-cicd-pipeline-com-github-actions)
- [Dia 5: Monitoramento](#-dia-5-monitoramento-com-prometheus-e-grafana)
- [Dia 6: Service Mesh com Istio](#-dia-6-service-mesh-com-istio)
- [Comandos Úteis](#-comandos-úteis)
- [Troubleshooting](#-troubleshooting)
- [Limpeza de Recursos](#-limpeza-de-recursos)
- [Próximos Passos](#-próximos-passos)

---

## 📖 Sobre o Treinamento

Este é um **treinamento prático e imersivo** que ensina como construir e gerenciar uma pipeline completa de DevOps no Google Cloud Platform. Você aprenderá desde a conteinerização até o deploy automatizado em Kubernetes, passando por Infrastructure as Code com Terraform, monitoramento com Prometheus e Grafana, e overview de microserviços com Service Mesh e Istio.

### 🎯 O que você vai aprender

- 🐳 **Conteinerização com Docker**
- 🏗️ **Infrastructure as Code com Terraform**
- ☸️ **Orquestração com Kubernetes no GKE**
- 📊 **Monitoramento e observabilidade com Prometheus e Grafana**
- 🔄 **CI/CD com GitHub Actions**
- 🕸️ **Microserviços com Service Mesh e Istio**

### 👥 Para quem é este treinamento

- **Desenvolvedores** que querem entender o ciclo de vida de suas aplicações
- **Profissionais de Infraestrutura** que desejam modernizar suas práticas
- **Profissionais de TI** buscando conhecimentos em DevOps

---

## ⚙️ Pré-requisitos

### 📚 Conhecimento

- ✅ **Linux e linha de comando** (obrigatório)
- 📘 **Docker** (desejável)
- 📘 **Programação básica** (desejável)
- 📘 **Terraform e Kubernetes** (desejável)

### 🛠️ Ferramentas Necessárias

| Ferramenta | Descrição | Link |
|------------|-----------|------|
| **Google Cloud Platform Account** | Conta na plataforma de nuvem do Google | [Criar conta](https://cloud.google.com/) |
| **Google Cloud CLI (gcloud)** | Interface de linha de comando para GCP | [Download](https://cloud.google.com/sdk/docs/install) |
| **kubectl** | Cliente de linha de comando para Kubernetes | [Instalação](https://kubernetes.io/docs/tasks/tools/) |
| **Docker Desktop** | Plataforma de containerização | [Download](https://www.docker.com/products/docker-desktop) |
| **Istio CLI (istioctl)** | Interface para service mesh Istio | Instalado via script no tutorial |
| **Terraform** | Ferramenta de Infrastructure as Code | [Download](https://www.terraform.io/downloads) |
| **Node.js** (versão 18+) | Runtime JavaScript para aplicação exemplo | [Download](https://nodejs.org/) |
| **Git** | Sistema de controle de versão | [Download](https://git-scm.com/) |
| **Conta GitHub** | Plataforma para CI/CD pipelines | [Criar conta](https://github.com/) |

---

## 📁 Estrutura do Projeto

```
devops-app-gcp/
├── .github/
│   └── workflows/
│       ├── ci.yml              # Pipeline de CI
│       └── cd.yml              # Pipeline de CD
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── monitoring/
│   ├── namespace.yaml
│   ├── prometheus-config.yaml
│   ├── prometheus.yaml
│   └── grafana.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── kubernetes.tf
│   └── startup-script.sh
├── istio/
│   ├── gateway.yaml
│   ├── virtual-service.yaml
│   ├── destination-rule.yaml
│   └── peer-authentication.yaml
├── public/
│   └── index.html
├── tests/
│   └── app.test.js
├── Dockerfile
├── package.json
├── server.js
└── README.md
```

---

## ⚡ Quick Start

### 1️⃣ Clone o repositório

```bash
git clone https://github.com/camilla-m/devops-app-gcp.git
cd devops-app-gcp
```

### 2️⃣ Configure o ambiente

```bash
# Instalar dependências
npm install

# Configurar GCP
gcloud auth login
export PROJECT_ID="seu-projeto-$(date +%s)"
gcloud projects create $PROJECT_ID
gcloud config set project $PROJECT_ID

# Habilitar APIs necessárias
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

### 3️⃣ Build da aplicação

```bash
# Build da imagem Docker
docker build -t devops-app-gcp:v1.0 .

# Testar localmente
docker run -p 3000:3000 devops-app-gcp:v1.0
```

### 4️⃣ Deploy da infraestrutura

```bash
cd terraform
terraform init
terraform apply
```

---

## 📦 Dia 1: Docker e Containerização

### 🎯 Objetivos
- Entender containerização
- Criar Dockerfile otimizado
- Executar aplicação em container

### 📄 Aplicação Base

#### `package.json`

```json
{
  "name": "devops-app-gcp",
  "version": "1.0.0",
  "description": "Aplicação de exemplo para treinamento DevOps no GCP",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

#### `server.js`

```javascript
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

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

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
```

#### `public/index.html`

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps App - GCP</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 40px; 
            background: #f5f5f5; 
        }
        .container { 
            max-width: 600px; 
            margin: 0 auto; 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        .status { 
            padding: 10px; 
            border-radius: 4px; 
            margin: 10px 0; 
        }
        .healthy { 
            background: #d4edda; 
            color: #155724; 
            border: 1px solid #c3e6cb; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>DevOps App no GCP</h1>
        <p>Esta aplicação demonstra o pipeline completo DevOps no Google Cloud Platform.</p>
        
        <div class="status healthy">
            <strong>Status:</strong> Aplicação funcionando corretamente!
        </div>
        
        <h3>Endpoints disponíveis:</h3>
        <ul>
            <li><a href="/health">/health</a> - Health check</li>
            <li><a href="/api/info">/api/info</a> - Informações da aplicação</li>
        </ul>
        
        <script>
            fetch('/api/info')
                .then(response => response.json())
                .then(data => {
                    document.querySelector('.container').innerHTML += 
                        `<div class="status healthy">
                            <strong>Versão:</strong> ${data.version}<br>
                            <strong>Ambiente:</strong> ${data.environment}<br>
                            <strong>Pod/Host:</strong> ${data.pod}
                        </div>`;
                });
        </script>
    </div>
</body>
</html>
```

### 🐳 Dockerfile Otimizado

```dockerfile
# Usar imagem oficial Node.js LTS
FROM node:18-alpine

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependências
COPY package*.json ./

# Instalar dependências
RUN npm ci --only=production && npm cache clean --force

# Copiar código da aplicação
COPY . .

# Criar usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Mudar propriedade dos arquivos
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expor porta
EXPOSE 3000

# Definir variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Comando para iniciar a aplicação
CMD ["node", "server.js"]
```

### 💻 Comandos Docker

```bash
# Build e execução
npm install
docker build -t devops-app-gcp:v1.0 .
docker run -d --name app -p 3000:3000 devops-app-gcp:v1.0

# Debugging
docker logs app
docker exec -it app sh

# Limpeza
docker stop app && docker rm app
```

---

## 🏗️ Dia 2: Terraform e Infrastructure as Code

### 🎯 Objetivos
- Provisionar infraestrutura com código
- Criar VPC, subnets e firewall rules
- Deploy de VMs e cluster GKE

### 📄 Arquivos Terraform

#### `terraform/variables.tf`

```hcl
variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região do GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona do GCP"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Tipo da máquina"
  type        = string
  default     = "e2-micro"
}
```

#### `terraform/main.tf`

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.84"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Rede VPC
resource "google_compute_network" "vpc_network" {
  name                    = "devops-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "devops-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Firewall rules
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "3000", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# Instância da VM
resource "google_compute_instance" "app_server" {
  name         = "devops-app-server"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["web-server"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    
    access_config {
      # IP público efêmero
    }
  }

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
```

#### `terraform/outputs.tf`

```hcl
output "instance_ip" {
  description = "IP público da instância"
  value       = google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip
}

output "app_url" {
  description = "URL da aplicação"
  value       = "http://${google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip}"
}

output "cluster_name" {
  description = "Nome do cluster GKE"
  value       = google_container_cluster.devops_cluster.name
}

output "cluster_location" {
  description = "Localização do cluster"
  value       = google_container_cluster.devops_cluster.location
}
```

#### `terraform/terraform.tfvars`

```hcl
project_id = "SEU_PROJECT_ID_AQUI"
region     = "us-central1"
zone       = "us-central1-a"
```

### 💻 Comandos Terraform

```bash
# Navegar para diretório terraform
cd terraform

# Inicializar Terraform
terraform init

# Planejar mudanças
terraform plan

# Aplicar infraestrutura
terraform apply

# Testar aplicação
APP_IP=$(terraform output -raw instance_ip)
curl http://$APP_IP/health
```

---

## ☸️ Dia 3: Kubernetes no GKE

### 🎯 Objetivos
- Criar cluster GKE com Terraform
- Deploy de aplicação no Kubernetes
- Configurar LoadBalancer e Ingress

### 📄 Cluster GKE no Terraform

#### `terraform/kubernetes.tf`

```hcl
# Cluster GKE
resource "google_container_cluster" "devops_cluster" {
  name     = "devops-cluster"
  location = var.region

  node_locations = [
    "${var.region}-a",
    "${var.region}-b"
  ]

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# Node Pool
resource "google_container_node_pool" "devops_nodes" {
  name       = "devops-node-pool"
  location   = var.region
  cluster    = google_container_cluster.devops_cluster.name
  node_count = 2

  node_config {
    preemptible  = true  # Custos reduzidos
    machine_type = "e2-medium"
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["gke-node"]
  }
  
  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
```

### 📄 Kubernetes Manifests

#### `k8s/namespace.yaml`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: devops-app
  labels:
    name: devops-app
```

#### `k8s/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-app
  namespace: devops-app
  labels:
    app: devops-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: devops-app
  template:
    metadata:
      labels:
        app: devops-app
    spec:
      containers:
      - name: devops-app
        image: gcr.io/PROJECT_ID/devops-app-gcp:v1.0  # Substituir PROJECT_ID
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "3000"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi" 
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
```

#### `k8s/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: devops-app-service
  namespace: devops-app
  labels:
    app: devops-app
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
    name: http
  selector:
    app: devops-app
```

#### `k8s/ingress.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: devops-app-ingress
  namespace: devops-app
  annotations:
    kubernetes.io/ingress.class: "gce"
spec:
  rules:
  - http:
      paths:
      - path: /*
        pathType: ImplementationSpecific
        backend:
          service:
            name: devops-app-service
            port:
              number: 80
```

### 💻 Deploy no GKE

```bash
# Aplicar mudanças no Terraform
terraform apply

# Configurar kubectl
gcloud container clusters get-credentials devops-cluster --region=us-central1

# Verificar conexão
kubectl cluster-info

# Build e push da imagem para Container Registry
docker tag devops-app-gcp:v1.0 gcr.io/$PROJECT_ID/devops-app-gcp:v1.0
docker push gcr.io/$PROJECT_ID/devops-app-gcp:v1.0

# Atualizar manifests com PROJECT_ID correto
sed -i "s/PROJECT_ID/$PROJECT_ID/g" k8s/deployment.yaml

# Aplicar manifests
kubectl apply -f k8s/

# Verificar deployments
kubectl get all -n devops-app

# Obter IP externo do LoadBalancer
kubectl get service devops-app-service -n devops-app

# Aguardar IP externo e testar
EXTERNAL_IP=$(kubectl get service devops-app-service -n devops-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl http://$EXTERNAL_IP/health
```

---

## 🔄 Dia 4: CI/CD Pipeline com GitHub Actions

### 🎯 Objetivos
- Configurar GitHub Actions
- Automatizar testes e build
- Deploy automático no GKE

### 🔐 Configuração do Service Account

```bash
# 1. Criar service account
gcloud iam service-accounts create github-actions \
  --description="Service account for GitHub Actions CI/CD" \
  --display-name="GitHub Actions Bot"

# 2. Atribuir permissões necessárias
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.developer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.writer"

# 3. Gerar chave JSON
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com
```

### 🔑 Configuração de Secrets no GitHub

No repositório GitHub, configure os seguintes secrets em `Settings > Secrets and variables > Actions`:

| Secret Name | Valor |
|-------------|-------|
| `GCP_SA_KEY` | Conteúdo do arquivo JSON da chave |
| `GCP_PROJECT_ID` | ID do projeto GCP |
| `GKE_CLUSTER` | Nome do cluster GKE |
| `GKE_ZONE` | Zona do cluster |

### 📄 Pipeline de CI

#### `.github/workflows/ci.yml`

```yaml
name: Continuous Integration

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  NODE_VERSION: '18'

jobs:
  test:
    name: Test Application
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
    
    - name: Install dependencies
      run: |
        npm ci
        npm install --save-dev @eslint/js
    
    - name: Run linting
      run: npm run lint
    
    - name: Run unit tests only
      run: npm run test:unit
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      if: success()

  security:
    name: Security Scan
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Run security audit
      run: npm audit --audit-level high
    
    - name: Scan for secrets
      uses: trufflesecurity/trufflehog@main
      with:
        path: ./
        base: main

  docker:
    name: Build and Test Docker Image
    runs-on: ubuntu-latest
    needs: [test, security]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Build Docker image
      uses: docker/build-push-action@v5
      with:
        context: .
        load: true
        tags: devops-app-gcp:test
        cache-from: type=gha
        cache-to: type=gha,mode=max
    
    - name: Test Docker image
      run: |
        docker run -d --name test-app -p 3000:3000 devops-app-gcp:test
        sleep 10
        curl -f http://localhost:3000/health || exit 1
        curl -f http://localhost:3000/api/info || exit 1
        docker stop test-app
        docker rm test-app
```

### 📄 Pipeline de CD

#### `.github/workflows/cd.yml`

```yaml
name: Deploy to GKE

on:
  push:
    branches: [ main ]
  workflow_dispatch:

env:
  PROJECT_ID: ${{ secrets.GCP_PROJECT_ID }}
  GKE_CLUSTER: ${{ secrets.GKE_CLUSTER }}
  GKE_ZONE: ${{ secrets.GKE_ZONE }}
  DEPLOYMENT_NAME: devops-app
  IMAGE: devops-app-gcp
  NAMESPACE: devops-app

jobs:
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Authenticate to Google Cloud
      uses: google-github-actions/auth@v2
      with:
        credentials_json: ${{ secrets.GCP_SA_KEY }}
    
    - name: Setup Google Cloud CLI
      uses: google-github-actions/setup-gcloud@v1
      with:
        service_account_key: ${{ secrets.GCP_SA_KEY }}
        project_id: ${{ secrets.GCP_PROJECT_ID }}
        export_default_credentials: true
    
    - name: Configure Docker for Artifact Registry
      run: |
        gcloud auth configure-docker us-central1-docker.pkg.dev
        gcloud auth configure-docker gcr.io
    
    - name: Get GKE credentials
      run: |
        gcloud container clusters get-credentials ${{ secrets.GKE_CLUSTER }} \
          --zone=${{ secrets.GKE_ZONE }} \
          --project=${{ secrets.GCP_PROJECT_ID }}
    
    - name: Build Docker image
      run: |
        docker build -t gcr.io/$PROJECT_ID/$IMAGE:$GITHUB_SHA \
          -t gcr.io/$PROJECT_ID/$IMAGE:latest .
    
    - name: Push Docker image
      run: |
        docker push gcr.io/$PROJECT_ID/$IMAGE:$GITHUB_SHA
        docker push gcr.io/$PROJECT_ID/$IMAGE:latest

    - name: Install GKE gcloud auth plugin
      run: |
        gcloud components install gke-gcloud-auth-plugin
        export USE_GKE_GCLOUD_AUTH_PLUGIN=True

    - name: Deploy to GKE
      run: |
        kubectl set image deployment/$DEPLOYMENT_NAME \
          $DEPLOYMENT_NAME=gcr.io/$PROJECT_ID/$IMAGE:$GITHUB_SHA \
          -n $NAMESPACE
        kubectl rollout status deployment/$DEPLOYMENT_NAME \
          -n $NAMESPACE --timeout=300s
        kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME
    
    - name: Run smoke tests
      run: |
        EXTERNAL_IP=$(kubectl get service devops-app-service -n $NAMESPACE \
          -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        
        for i in {1..30}; do
          if [ ! -z "$EXTERNAL_IP" ]; then
            break
          fi
          echo "Aguardando IP externo... ($i/30)"
          sleep 10
          EXTERNAL_IP=$(kubectl get service devops-app-service -n $NAMESPACE \
            -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        done
        
        if [ -z "$EXTERNAL_IP" ]; then
          echo "ERRO: IP externo não foi atribuído"
          exit 1
        fi
        
        curl -f --max-time 10 http://$EXTERNAL_IP/health
        curl -f --max-time 10 http://$EXTERNAL_IP/api/info
        echo "Deploy realizado com sucesso!"
```

---

## 📊 Dia 5: Monitoramento com Prometheus e Grafana

### 🎯 Objetivos
- Instrumentar aplicação com métricas
- Deploy do Prometheus
- Criar dashboards no Grafana

### 📄 Instrumentação da Aplicação

Atualize o `server.js` para incluir métricas Prometheus:

```javascript
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
```

### 📄 Configuração do Prometheus

#### `monitoring/namespace.yaml`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
  labels:
    name: monitoring
```

#### `monitoring/prometheus-config.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s

    rule_files:
      - "alert_rules.yml"

    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']

      - job_name: 'devops-app'
        kubernetes_sd_configs:
          - role: endpoints
            namespaces:
              names:
                - devops-app
        relabel_configs:
          - source_labels: [__meta_kubernetes_service_name]
            action: keep
            regex: devops-app-service
          - source_labels: [__meta_kubernetes_endpoint_port_name]
            action: keep
            regex: http

      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
          - role: node
        relabel_configs:
          - action: labelmap
            regex: __meta_kubernetes_node_label_(.+)

  alert_rules.yml: |
    groups:
      - name: devops-app-alerts
        rules:
          - alert: HighErrorRate
            expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
            for: 2m
            labels:
              severity: warning
            annotations:
              summary: "High error rate detected"
              description: "Error rate is {{ $value }} requests per second"

          - alert: HighLatency
            expr: histogram_quantile(0.95, http_request_duration_seconds_bucket) > 0.5
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High latency detected"
              description: "95th percentile latency is {{ $value }}s"

          - alert: PodDown
            expr: up{job="devops-app"} == 0
            for: 1m
            labels:
              severity: critical
            annotations:
              summary: "Pod is down"
              description: "Pod {{ $labels.instance }} is down"
```

#### `monitoring/prometheus.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
  labels:
    app: prometheus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: prometheus
      containers:
      - name: prometheus
        image: prom/prometheus:v2.45.0
        args:
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--storage.tsdb.path=/prometheus/'
          - '--web.console.libraries=/etc/prometheus/console_libraries'
          - '--web.console.templates=/etc/prometheus/consoles'
          - '--storage.tsdb.retention.time=200h'
          - '--web.enable-lifecycle'
          - '--web.enable-admin-api'
        ports:
        - containerPort: 9090
          name: web
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus
        - name: prometheus-storage
          mountPath: /prometheus
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            cpu: 200m
            memory: 512Mi
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
      - name: prometheus-storage
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
  labels:
    app: prometheus
spec:
  type: LoadBalancer
  ports:
  - port: 9090
    targetPort: 9090
    name: web
  selector:
    app: prometheus
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitoring
```

#### `monitoring/grafana.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:10.2.0
        ports:
        - containerPort: 3000
        env:
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: "admin"
        - name: GF_INSTALL_PLUGINS
          value: "grafana-kubernetes-app"
        volumeMounts:
        - name: grafana-storage
          mountPath: /var/lib/grafana
        - name: grafana-config
          mountPath: /etc/grafana/provisioning
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
      volumes:
      - name: grafana-storage
        emptyDir: {}
      - name: grafana-config
        configMap:
          name: grafana-config
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
spec:
  type: LoadBalancer
  ports:
  - port: 3000
    targetPort: 3000
  selector:
    app: grafana
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-config
  namespace: monitoring
data:
  datasources.yml: |
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: http://prometheus:9090
        isDefault: true
  
  dashboards.yml: |
    apiVersion: 1
    providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        updateIntervalSeconds: 10
        options:
          path: /var/lib/grafana/dashboards
```

### 💻 Deploy do Monitoramento

```bash
# Deploy do monitoring stack
kubectl apply -f monitoring/

# Verificar pods
kubectl get pods -n monitoring

# Obter IPs externos
kubectl get services -n monitoring

# Acessar Grafana (admin/admin)
GRAFANA_IP=$(kubectl get service grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Grafana: http://$GRAFANA_IP:3000"

# Acessar Prometheus
PROMETHEUS_IP=$(kubectl get service prometheus -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Prometheus: http://$PROMETHEUS_IP:9090"
```

---

## 🕸️ Dia 6: Service Mesh com Istio

### 🎯 Objetivos
- Instalar Istio no cluster
- Configurar traffic management
- Implementar mTLS entre serviços
- Observabilidade com Kiali e Jaeger

### 📦 Instalação do Istio

```bash
# Habilitar APIs necessárias
gcloud services enable container.googleapis.com
gcloud services enable gkehub.googleapis.com
gcloud services enable mesh.googleapis.com

# Download e instalação do Istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.19.3 sh -
cd istio-1.19.3
export PATH=$PWD/bin:$PATH

# Verificar instalação
istioctl version --remote=false

# Instalar com perfil demo
istioctl install --set values.defaultRevision=default

# Verificar componentes instalados
kubectl get pods -n istio-system
```

### 🔄 Configuração de Sidecar Proxy Automático

```bash
# Habilitar sidecar injection no namespace
kubectl label namespace devops-app istio-injection=enabled

# Verificar label no namespace
kubectl get namespace devops-app --show-labels

# Redeploy da aplicação para injetar sidecars
kubectl rollout restart deployment/devops-app -n devops-app

# Verificar sidecars
kubectl get pods -n devops-app
kubectl describe pod <pod-name> -n devops-app
```

### 📄 Traffic Management

#### `istio/destination-rule.yaml`

```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: devops-app-destination
  namespace: devops-app
spec:
  host: devops-app-service
  subsets:
  - name: v1
    labels:
      version: v1
    trafficPolicy:
      loadBalancer:
        simple: LEAST_CONN
  - name: v2
    labels:
      version: v2
    trafficPolicy:
      loadBalancer:
        simple: ROUND_ROBIN
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 10
      http:
        http1MaxPendingRequests: 10
        maxRequestsPerConnection: 2
    circuitBreaker:
      consecutiveErrors: 3
      interval: 30s
      baseEjectionTime: 30s
```

#### `istio/virtual-service.yaml`

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: devops-app-vs
  namespace: devops-app
spec:
  hosts:
  - devops-app-service
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: devops-app-service
        subset: v2
  - match:
    - uri:
        prefix: "/api/v2"
    route:
    - destination:
        host: devops-app-service
        subset: v2
  - route:
    - destination:
        host: devops-app-service
        subset: v1
      weight: 80
    - destination:
        host: devops-app-service
        subset: v2
      weight: 20
    timeout: 10s
    retries:
      attempts: 3
      perTryTimeout: 3s
```

#### `istio/gateway.yaml`

```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: devops-app-gateway
  namespace: devops-app
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: devops-app-gateway-vs
  namespace: devops-app
spec:
  hosts:
  - "*"
  gateways:
  - devops-app-gateway
  http:
  - route:
    - destination:
        host: devops-app-service
        port:
          number: 80
```

### 🔒 mTLS e Segurança

#### `istio/peer-authentication.yaml`

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: devops-app
spec:
  mtls:
    mode: STRICT
```

#### `istio/authorization-policy.yaml`

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: devops-app-authz
  namespace: devops-app
spec:
  selector:
    matchLabels:
      app: devops-app
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/devops-app/sa/default"]
    to:
    - operation:
        methods: ["GET", "POST"]
        paths: ["/health", "/api/*"]
  - from:
    - source:
        namespaces: ["istio-system"]
    to:
    - operation:
        methods: ["GET"]
        paths: ["/health", "/metrics"]
```

### 📊 Observabilidade com Kiali e Jaeger

```bash
# Instalar addons de observabilidade
kubectl apply -f samples/addons/

# Verificar instalação
kubectl get pods -n istio-system

# Port forward para acessar UIs
kubectl port-forward -n istio-system svc/kiali 20001:20001 &
kubectl port-forward -n istio-system svc/jaeger 16686:16686 &
kubectl port-forward -n istio-system svc/grafana 3000:3000 &

# Gerar tráfego para visualização
GATEWAY_IP=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

for i in {1..100}; do
  curl -H "Host: devops-app.local" http://$GATEWAY_IP/health
  curl -H "Host: devops-app.local" -H "canary: true" http://$GATEWAY_IP/api/info
  sleep 1
done
```

### 💻 Testes e Validação

```bash
# Obter IP do Gateway
export GATEWAY_IP=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Teste normal (80% v1, 20% v2)
for i in {1..10}; do
  curl -s http://$GATEWAY_IP/api/info | jq .version
done

# Teste com header canary (100% v2)
for i in {1..5}; do
  curl -s -H "canary: true" http://$GATEWAY_IP/api/info | jq .version
done

# Verificar mTLS
istioctl authn tls-check devops-app-service.devops-app.svc.cluster.local

# Ver certificados
istioctl proxy-config secret <pod-name> -n devops-app
```

---

## 💻 Comandos Úteis

### 🐳 Docker

```bash
# Build e tag
docker build -t devops-app-gcp:v1.0 .
docker tag devops-app-gcp:v1.0 gcr.io/$PROJECT_ID/devops-app-gcp:v1.0

# Push para Container Registry
docker push gcr.io/$PROJECT_ID/devops-app-gcp:v1.0

# Executar localmente
docker run -p 3000:3000 devops-app-gcp:v1.0

# Debugging
docker exec -it <container-id> sh
docker logs <container-id>

# Limpeza local
docker stop <container-id>
docker rm <container-id>
docker rmi devops-app-gcp:v1.0
docker system prune -a
```

### 🏗️ Terraform

```bash
# Workflow básico
terraform init
terraform plan
terraform apply
terraform destroy

# Verificar estado
terraform show
terraform state list

# Outputs
terraform output
terraform output -raw instance_ip

# Formatação e validação
terraform fmt
terraform validate
```

### ☸️ Kubernetes

```bash
# Contexts e clusters
kubectl config get-contexts
kubectl config use-context <context-name>

# Recursos
kubectl get all -n devops-app
kubectl describe deployment devops-app -n devops-app

# Logs
kubectl logs -f deployment/devops-app -n devops-app
kubectl logs <pod-name> -n devops-app --previous

# Port forwarding
kubectl port-forward service/devops-app-service 8080:80 -n devops-app

# Scaling
kubectl scale deployment devops-app --replicas=5 -n devops-app

# Rollout
kubectl rollout status deployment/devops-app -n devops-app
kubectl rollout history deployment/devops-app -n devops-app
kubectl rollout undo deployment/devops-app -n devops-app

# Debugging
kubectl exec -it <pod-name> -n devops-app -- sh
kubectl get events -n devops-app --sort-by='.lastTimestamp'
```

### ☁️ GCP

```bash
# Projetos
gcloud projects list
gcloud config set project <project-id>

# Compute Engine
gcloud compute instances list
gcloud compute ssh <instance-name>

# GKE
gcloud container clusters list
gcloud container clusters get-credentials <cluster-name> --region=<region>

# Container Registry
gcloud container images list
gcloud container images delete <image-url>
```

### 🕸️ Istio

```bash
# Análise de configuração
istioctl analyze

# Verificar proxy config
istioctl proxy-config routes <pod-name> -n devops-app

# Traffic management
istioctl proxy-config cluster <pod-name> -n devops-app

# Verificar mTLS
istioctl authn tls-check <service-name>.<namespace>.svc.cluster.local

# Debug
istioctl proxy-status
istioctl dashboard kiali
```

---

## 🔧 Troubleshooting

### 🐳 Docker build falha

**Problema:** Build do Docker falha ou demora muito

```bash
# Verificar Dockerfile
cat Dockerfile

# Build com logs detalhados
docker build --no-cache -t devops-app-gcp:v1.0 .

# Verificar espaço em disco
docker system df
docker system prune
```

### 🏗️ Terraform apply falha

**Problema:** Terraform não consegue aplicar mudanças

```bash
# Verificar credenciais
gcloud auth list
gcloud config list

# Verificar APIs habilitadas
gcloud services list --enabled

# Verificar quotas
gcloud compute project-info describe --project=$PROJECT_ID

# Reinicializar
terraform init -reconfigure
```

### ☸️ Pods em estado Pending

**Problema:** Pods ficam em estado Pending no Kubernetes

```bash
# Verificar events
kubectl get events -n devops-app --sort-by='.lastTimestamp'

# Verificar recursos dos nodes
kubectl top nodes
kubectl describe nodes

# Verificar pod específico
kubectl describe pod <pod-name> -n devops-app
```

### 🔄 GitHub Actions falhando

**Problema:** Pipeline de CI/CD falha

```bash
# Verificar secrets configurados
# Ir para Settings > Secrets and variables > Actions

# Testar localmente
act -l  # Lista workflows
act push  # Simula push event

# Verificar logs detalhados no GitHub Actions
```

### 📊 Prometheus não coletando métricas

**Problema:** Prometheus não consegue coletar métricas da aplicação

```bash
# Verificar se o endpoint /metrics está acessível
kubectl port-forward -n devops-app svc/devops-app-service 3000:80
curl http://localhost:3000/metrics

# Verificar configuração do Prometheus
kubectl logs -n monitoring deployment/prometheus
kubectl get configmap prometheus-config -n monitoring -o yaml

# Verificar service discovery
kubectl get endpoints -n devops-app
```

### 📈 Grafana não conectando ao Prometheus

**Problema:** Grafana não consegue se conectar ao Prometheus

```bash
# Verificar se o serviço do Prometheus está respondendo
kubectl exec -n monitoring deployment/grafana -- curl http://prometheus:9090/api/v1/query?query=up

# Verificar configuração do datasource
kubectl get configmap grafana-config -n monitoring -o yaml

# Reiniciar Grafana
kubectl rollout restart deployment/grafana -n monitoring
```

### 🕸️ Istio sidecar não injetado

**Problema:** Sidecar do Istio não está sendo injetado nos pods

```bash
# Verificar label do namespace
kubectl get namespace devops-app --show-labels

# Adicionar label se necessário
kubectl label namespace devops-app istio-injection=enabled --overwrite

# Verificar configuração do webhook
kubectl get mutatingwebhookconfiguration istio-sidecar-injector -o yaml

# Forçar recreação do pod
kubectl delete pod -l app=devops-app -n devops-app

# Debug de configuração
istioctl analyze -n devops-app
```

### 🔒 mTLS não funcionando

**Problema:** Comunicação mTLS entre serviços falha

```bash
# Verificar status TLS
istioctl authn tls-check devops-app-service.devops-app.svc.cluster.local

# Verificar peer authentication
kubectl get peerauthentication -n devops-app

# Ver certificados
istioctl proxy-config secret <pod-name> -n devops-app

# Verificar logs do proxy
kubectl logs <pod-name> -c istio-proxy -n devops-app
```

---

## 🧹 Limpeza de Recursos

### ⚠️ IMPORTANTE: Evitar Custos Desnecessários

Execute a limpeza para evitar cobranças no GCP!

```bash
# 1. Deletar recursos Kubernetes
kubectl delete namespace devops-app
kubectl delete namespace monitoring
kubectl delete namespace istio-system

# 2. Destruir infraestrutura Terraform
cd terraform
terraform destroy -auto-approve

# 3. Deletar imagens do Container Registry
gcloud container images delete gcr.io/$PROJECT_ID/devops-app-gcp:v1.0 --force-delete-tags

# 4. Verificar recursos restantes
gcloud compute instances list
gcloud container clusters list
gcloud compute networks list
gcloud compute disks list

# 5. Deletar projeto (opcional - remove tudo)
gcloud projects delete $PROJECT_ID
```

### 💰 Verificação de Custos

Antes de fazer a limpeza, você pode verificar os custos:

```bash
# Ver custos do projeto
gcloud billing projects describe $PROJECT_ID

# Listar recursos que geram custos
gcloud compute instances list
gcloud container clusters list
gcloud compute disks list
gcloud compute addresses list
```

---

## 🎓 Próximos Passos

### 📚 Recursos de Estudo

- [Documentação Oficial do Istio](https://istio.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Google Cloud Documentation](https://cloud.google.com/docs)

### 🏆 Certificações Recomendadas

- **CKAD** - Certified Kubernetes Application Developer
- **CKS** - Certified Kubernetes Security Specialist
- **Google Cloud Professional** - Cloud Architect
- **Google Cloud Professional** - DevOps Engineer
- **Terraform Associate** - HashiCorp Certified

### 📖 Livros Recomendados

- "Istio: Up and Running" - Lee Calcote & Zack Butcher
- "Production Kubernetes" - Josh Rosso, Rich Lander, Alex Brand, John Harris
- "The DevOps Handbook" - Gene Kim, Jez Humble, Patrick Debois
- "Site Reliability Engineering" - Google
- "Kubernetes Patterns" - Bilgin Ibryam & Roland Huß
  
---

## 📝 Notas Finais

**Este tutorial fornece uma base sólida para implementação de DevOps moderno.** Adapte as configurações conforme suas necessidades específicas e sempre teste em ambientes de desenvolvimento antes de aplicar em produção.

### 🤝 Contribuindo

Encontrou algum problema ou tem sugestões? Abra uma issue no GitHub!

### 📄 Licença

Este projeto está sob a licença MIT.

### 👏 Agradecimentos

Feito com ❤️ para a comunidade DevOps brasileira!

---

**⭐ Se este guia foi útil, dê uma estrela no [repositório GitHub](https://github.com/camilla-m/devops-app-gcp)!**
