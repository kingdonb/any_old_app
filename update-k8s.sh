#!/bin/bash

set -feuo pipefail

GIT_SHA=${1:0:8}
sed -i '.backup' "s|image: kingdonb/any-old-app:.*|image: kingdonb/any-old-app:$GIT_SHA|" k8s.yml
sed -i '.backup' "s|git-sha: .*|git-sha: $GIT_SHA|" flux/app-version-configmap.yaml
