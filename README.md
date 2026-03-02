# GCP Production GKE Containerized App

A production-grade containerized Flask app running on Google Kubernetes Engine (GKE).
Self-healing, auto-scaling, zero-downtime deployments — all on GCP.

## Architecture

![Architecture Diagram](diagram.png)

**Services Used:**

- GKE (Google Kubernetes Engine) — managed Kubernetes cluster
- Artifact Registry — private Docker image storage
- GCP Load Balancer — external traffic distribution
- HPA (Horizontal Pod Autoscaler) — auto-scales pods on CPU
- VPC + Subnets — private networking for the cluster
- Terraform — all infrastructure as code

## Live Demo

▶️ [Watch the full demo on YouTube](https://youtube.com/YOUR_VIDEO_URL)

## How to Deploy

### Prerequisites

- GCP account with billing enabled
- gcloud CLI installed and configured
- kubectl installed
- Docker Desktop installed
- Terraform v1.7+

### 1. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

### 2. Build and Push Docker Image

```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
docker build -t flask-app:latest app/
docker tag flask-app:latest us-central1-docker.pkg.dev/cloud-portfolio/flask-app/flask-app:latest
docker push us-central1-docker.pkg.dev/cloud-portfolio/flask-app/flask-app:latest
```

### 3. Deploy to Kubernetes

```bash
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl apply -f kubernetes/hpa.yaml
```

### 4. Get External IP

```bash
kubectl get service flask-app-service
```

## Self-Healing Demo

```bash
# Delete a pod — Kubernetes replaces it automatically
kubectl delete pod <pod-name>
kubectl get pods --watch
```

## Zero-Downtime Deployment

```bash
# Update image — no downtime
kubectl set image deployment/flask-app flask-app=<new-image>
kubectl rollout status deployment/flask-app
```

## Destroy

```bash
kubectl delete -f kubernetes/
terraform destroy
```

## Cost

- GKE cluster: ~$0.10/hour cluster management fee
- e2-medium nodes: ~$0.034/hour each (2 nodes = ~$1.63/day)
- Destroy immediately after demo to save credits

## Skills Demonstrated

- Docker containerization
- Kubernetes (GKE) deployment
- Self-healing and auto-scaling
- Zero-downtime rolling deployments
- GCP Artifact Registry
- Infrastructure as Code (Terraform)
- CI/CD (GitHub Actions)
