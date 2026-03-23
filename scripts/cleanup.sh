#!/usr/bin/env bash
set -euo pipefail

kubectl delete -k manifests/ --ignore-not-found=true