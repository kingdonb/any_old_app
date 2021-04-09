// Copyright 2021 The FluxCD project, 2017 kubecfg authors
//
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

// Simple kubecfg example interpretation based on bitnami-labs/kube-libsonnet
// This interpretation should not be considered a model jsonnet example to
// build upon.

// This is a simple manifest generation example to demo some simple tasks that
// can be automated through Flux, with Flux configs rehydrated through Jsonnet.

// This example uses kube.libsonnet from Bitnami.  There are other
// Kubernetes libraries available, or write your own!
local kube = import 'https://github.com/bitnami-labs/kube-libsonnet/raw/73bf12745b86718083df402e89c6c903edd327d2/kube.libsonnet';

// The declaration below adds configuration to a more verbose base, defined in
// more detail at the neighbor libsonnet file here:
local example = import 'example.libsonnet';
local kubecfg = import 'kubecfg.libsonnet';
local kustomize = import 'kustomize.libsonnet';

local config_ns = 'yebyen-okd4';

local flux_config = [
  kube.ConfigMap('any-old-app-version') {
    data+: {
      VERSION: std.extVar('VERSION'),
    },
  },
  example.gitrepository('any-old-app-prod') {
    spec+: {
      url: 'https://github.com/kingdonb/any_old_app',
    },
  },
] + kubecfg.parseYaml(importstr 'examples/configMap.yaml');

local kustomization = kustomize.applyList([
  kustomize.namespace(config_ns),
]);

local kustomization_output = std.map(kustomization, flux_config);

{ flux_config: kustomization_output } + {

  local items = ['test', 'prod'],

  joined: {
    [ns + '_flux_kustomization']: {
      data: example.any_old_app(ns) {
        spec+: {
          prune: if ns == 'prod' then false else true,
        },
      },
    }
    for ns in items

    // Credit:
    // https://groups.google.com/g/jsonnet/c/ky6sjYj4UZ0/m/d4lZxWbhAAAJ
    // thanks Dave for showing how to do something like this in Jsonnet
  },
}
