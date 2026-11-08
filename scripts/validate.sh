#!/usr/bin/env bash
# Validate the manifests and the OpenTofu module. No credentials, no plan, no apply.
set -euo pipefail
cd "$(dirname "$0")/.."

kubeconform -summary -strict -kubernetes-version 1.31.0 deploy/kubernetes/*.yaml
tofu fmt -check -recursive infra
tofu -chdir=infra init -input=false -backend=false
tofu -chdir=infra validate
