#!/bin/bash

set -feuo pipefail

GIT_SHA=${1:0:8}
sed -i "s|image: kingdonb/any-old-app:.*|image: kingdonb/any-old-app:$GIT_SHA|" k8s.yml
sed -i "s|GIT_SHA: .*|GIT_SHA: $GIT_SHA|" flux-config/app-version-configmap.yaml
