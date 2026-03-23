# SurrealDB on Kubernetes (Production-Style)

Production-oriented deployment of SurrealDB on Kubernetes using a StatefulSet, persistent storage, health checks, secrets, and basic reliability controls.

## Why I built this

I built this project to explore how to run a stateful database workload on Kubernetes with production-minded concerns: persistence, rollout safety, resource management, and operational readiness.

The goal was not to build a full DBaaS platform, but to demonstrate a realistic foundation for running SurrealDB in Kubernetes.

## Architecture

- A dedicated Kubernetes namespace
- A Secret for database credentials
- A ClusterIP Service for internal access
- A StatefulSet for stable network identity and persistent storage
- A PersistentVolumeClaim for database persistence
- Liveness and readiness probes for safer operations
- Resource requests and limits
- A PodDisruptionBudget for basic availability protection
- Kustomize for deployment management

## Repository structure

```text
surrealdb-k8s-production/
├── README.md
├── manifests/
│   ├── namespace.yaml
│   ├── secret.yaml
│   ├── service.yaml
│   ├── statefulset.yaml
│   ├── pdb.yaml
│   └── kustomization.yaml
├── scripts/
│   ├── deploy.sh
│   ├── port-forward.sh
│   └── cleanup.sh
└── .github/workflows/
    └── validate.yaml
```

## Deployment choices

### Why StatefulSet

SurrealDB is a stateful workload, so I used a StatefulSet instead of a Deployment. This gives the pod a stable identity and works better with persistent storage — both important for a database workload.

### Storage

The database uses file-backed storage mounted through a PersistentVolumeClaim. This keeps the setup simple while still demonstrating persistence in Kubernetes.

### Security

Credentials are stored in a Kubernetes Secret rather than being hardcoded in the manifest.

### Reliability

The deployment includes:

- Readiness probes
- Liveness probes
- Resource requests and limits
- A PodDisruptionBudget

These are small additions that reflect production-oriented thinking.

## Prerequisites

- A Kubernetes cluster
- `kubectl`
- Kustomize support via `kubectl apply -k`

This project is simple enough to run on a local Kubernetes environment or a managed cluster.

## How to deploy

Apply the manifests:

```sh
kubectl apply -k manifests/
```

Wait for the StatefulSet rollout:

```sh
kubectl -n surrealdb rollout status statefulset/surrealdb
```

Check the resources:

```sh
kubectl -n surrealdb get pods,svc,pvc
```

Or use the helper script:

```sh
./scripts/deploy.sh
```

## How to access SurrealDB

Use port-forwarding:

```sh
./scripts/port-forward.sh
```

This forwards local port 8000 to the SurrealDB service in the cluster.

## Cleanup

To delete the deployed resources:

```sh
./scripts/cleanup.sh
```

## Operational considerations

### Backups

This version does not automate backups. In a real production setup, I would add a backup and restore strategy based on the selected storage backend and recovery objectives.

### Scaling

This project focuses on a single-node persistent deployment. That keeps the setup simple and highlights the operational basics of running a stateful workload on Kubernetes. Scaling a database workload requires additional design decisions around replication, consistency, failover, and storage architecture.

### Monitoring

In a larger setup, I would extend this with metrics collection, dashboards, and alerting integrated with Prometheus and Grafana.

### Security hardening

This project uses a Secret for credentials, but more could be added in a production environment:

- NetworkPolicies
- Stricter pod security settings
- Secret management through an external system (e.g. Vault)
- TLS and ingress controls

## Tradeoffs

To keep the project focused, I intentionally made a few tradeoffs:

- Single-node setup instead of a highly available cluster
- File-backed persistence for simplicity
- No automated backup workflow
- No operator or custom controller
- No full observability stack

These were deliberate. The aim was to demonstrate a strong Kubernetes foundation for a stateful database workload, not to over-engineer a full database platform.

## What this project demonstrates

How I approach running a stateful service on Kubernetes with attention to:

- Persistence
- Rollout safety
- Resource management
- Reliability basics
- Operational tradeoffs
- Clean deployment structure

## Next improvements

- Add NetworkPolicy
- Add Ingress or secure external access
- Add Prometheus monitoring
- Add automated backup jobs
- Pin and document the exact SurrealDB image version
- Move to Helm if packaging becomes necessary

## Disclaimer

This is a production-oriented example, not a full production DBaaS platform. The purpose is to demonstrate how to deploy and reason about a stateful database workload on Kubernetes using practical engineering choices.
