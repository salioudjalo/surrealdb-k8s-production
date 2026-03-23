#!/usr/bin/env bash
set -euo pipefail

kubectl apply -k manifests/
kubectl -n surrealdb rollout status statefulset/surrealdb
kubectl -n surrealdb get pods,svc,pvc