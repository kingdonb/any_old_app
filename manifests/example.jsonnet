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

local release_config = kube.ConfigMap('any-old-app-version');
local namespace_list = ['prod', 'stg', 'qa', 'uat', 'dev'];

local release_version = '0.10.3';
local latest_candidate = '0.10.3-alpha1';

{
  [ns + '_tenant']: {
    [ns + '_namespace']: {
      namespace: kube.Namespace(ns),
    },
    [ns + '_configmap']: {
      version_data: release_config {
        metadata+: {
          namespace: ns,
        },
        data+: {
          VERSION: if ns == 'prod' || ns == 'stg' then release_version else latest_candidate,
        },
      },
    },
  }
  for ns in namespace_list
}
