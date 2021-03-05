#!/bin/bash

set -feuo pipefail

GIT_SHA=${1:0:8}
sed -i "s|image: kingdonb/any-old-app:.*|image: kingdonb/any-old-app:$GIT_SHA|" k8s.yml
sed -i "s|git-sha: .*|git-sha: $GIT_SHA|" flux/app-version-configmap.yaml
