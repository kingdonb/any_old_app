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

{
  version_configmap: kube.ConfigMap('any-old-app-version') {
    metadata+: {
      namespace: 'yebyen-okd4',
    },
    data+: {
      VERSION: std.extVar('VERSION'),
    },
  },
  test_flux_kustomization: example.kustomization('any-old-app-test') {
    metadata+: {
      namespace: 'yebyen-okd4',
    },
    spec+: {
      path: './flux-config/',
      postBuild+: {
        substituteFrom+: [
          {
            kind: 'ConfigMap',
            name: 'any-old-app-version',
          },
        ],
      },
      targetNamespace: 'test-yebyen',
    },
  },
  prod_flux_kustomization: example.kustomization('any-old-app-prod') {
    metadata+: {
      namespace: 'yebyen-okd4',
    },
    spec+: {
      path: './flux-config/',
      postBuild+: {
        substituteFrom+: [
          {
            kind: 'ConfigMap',
            name: 'any-old-app-version',
          },
        ],
      },
      targetNamespace: 'prod-yebyen',
    },
  },
  flux_gitrepository: example.gitrepository('any-old-app-prod') {
    metadata+: {
      namespace: 'yebyen-okd4',
    },
    spec+: {
      url: 'https://github.com/kingdonb/any_old_app',
    },
  },
}
