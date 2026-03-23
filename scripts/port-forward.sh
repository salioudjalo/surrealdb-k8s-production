#!/usr/bin/env bash
set -euo pipefail

kubectl -n surrealdb port-forward svc/surrealdb 8000:8000