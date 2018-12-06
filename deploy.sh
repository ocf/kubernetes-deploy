#!/bin/bash

set -euo pipefail

NAMESPACE="app-$1"
VERSION="$2"

./generate-namespace.py "$NAMESPACE" | kubectl apply -f -
kubernetes-deploy $NAMESPACE k8s --template-dir . --bindings=version="$VERSION"
