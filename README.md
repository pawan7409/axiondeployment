# Axion Deployment Project

This repository contains the Axion telemetry ingestion service and the deployment pipeline for shipping it to Azure Kubernetes Service (AKS) through Azure Container Registry (ACR).

## Architecture Overview

```text
Developer
   |
   v
GitHub Repository
   |
   v
GitHub Actions CI/CD
   |
   +--> Prisma Cloud Security Scan
   |       |
   |       +--> Vulnerability found? Yes -> fail pipeline
   |                                  No  -> continue
   |
   v
Docker Build
   |
   v
Azure Container Registry (ACR)
   |
   v
Azure Kubernetes Service (AKS)
   |
   +--> Prometheus (metrics collection)
   |
   +--> Grafana (visualization)
   |
   v
Pods / Nodes / Application Health
```

## Repository Structure

```text
axiondeployment/
├── .github/
│   └── workflows/
│       └── docker-build-push.yml
├── FinalProject/
│   └── axion-ingestion-service/
│       ├── .github/
│       ├── .env.example
│       ├── Dockerfile
│       ├── README.md
│       ├── config.py
│       ├── database.py
│       ├── main.py
│       ├── models.py
│       ├── requirements.txt
│       ├── manifests/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   └── monitoring/
│       │       ├── prometheus-config.yaml
│       │       └── grafana-datasource.yaml
│       └── Terraform/
├── README.md
└── .gitignore
```

## Current Application

The service is a FastAPI application that:

- accepts telemetry payloads from industrial devices
- validates data and stores it into PostgreSQL
- exposes `/health` for liveness/readiness checks
- exposes telemetry endpoints for querying recent events

## CI/CD Pipeline

The GitHub workflow in .github/workflows/docker-build-push.yml does the following:

1. triggers on push to `main` or `feature/axion`
2. runs a Prisma Cloud security scan before build
3. builds the Docker image from the ingestion service folder
4. pushes the image to ACR
5. authenticates to Azure using service principal credentials
6. deploys the app to AKS
7. waits for the rollout to complete

## Required GitHub Secrets

Set these repository secrets before running the workflow:

- `AZURE_CREDENTIALS`
- `ACR_USERNAME`
- `ACR_PASSWORD`
- `PRISMA_CLOUD_URL` (optional if scan is disabled)
- `PRISMA_CLOUD_USER` (optional if scan is disabled)
- `PRISMA_CLOUD_PASSWORD` (optional if scan is disabled)

Example `AZURE_CREDENTIALS` JSON:

```json
{
  "clientId": "<app-client-id>",
  "clientSecret": "<app-client-secret>",
  "subscriptionId": "<subscription-id>",
  "tenantId": "<tenant-id>"
}
```

## AKS Deployment Notes

The Kubernetes deployment includes:

- private image pull using `acr-secret`
- readiness and liveness probes on `/health`
- load-balanced service on port 80 to the app container on port 8000

Deployment files are under:

- FinalProject/axion-ingestion-service/manifests/deployment.yaml
- FinalProject/axion-ingestion-service/manifests/service.yaml

## Monitoring Notes

Prometheus and Grafana configuration files are provided to support metrics scraping and dashboard connectivity:

- FinalProject/axion-ingestion-service/manifests/monitoring/prometheus-config.yaml
- FinalProject/axion-ingestion-service/manifests/monitoring/grafana-datasource.yaml

## Local Run

```bash
cd FinalProject/axion-ingestion-service
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Then open:

- http://localhost:8000/health
- http://localhost:8000/docs

## Security and Production Hardening

A few important improvements still recommended before production use:

- remove hardcoded database URLs from source files
- store secrets only in GitHub or Kubernetes secret stores
- restrict ACR and AKS permissions to least privilege
- add application metrics and alerting rules
- configure TLS and ingress for public exposure

## License

This project is part of the Axion platform and is intended for internal delivery and deployment workflows.

axion-ingestion-service/
├── main.py              # FastAPI app, routes, and lifespan management
├── config.py            # Environment-based configuration (Settings dataclass)
├── database.py          # asyncpg connection pool and query helpers
├── models.py            # Pydantic request/response schemas
├── requirements.txt     # Python dependencies
├── Dockerfile           # Container image definition
├── .env.example         # Sample environment variables
├── .gitignore           # Git ignore rules
└── README.md            # This file
```

---

## License

This project is part of the **Axion** platform by [DevOps Insiders](https://github.com/devopsinsiders).# axiondeployment