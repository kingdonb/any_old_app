#!/bin/bash

# ./ci/kubecfg.sh
set -feux   # Usage: $0 VERSION=<VERSION>   # Fails when VERSION is not provided
VERSION_VAR_SETTER="$1"

kubecfg show \
	-V $VERSION_VAR_SETTER \
	manifests/example.jsonnet > output/production.yaml
