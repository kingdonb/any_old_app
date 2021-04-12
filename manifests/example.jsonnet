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

local tenant =
  kubecfg.parseYaml(importstr 'examples/tenant.yaml');
local pull_secrets =
  kubecfg.parseYaml(importstr 'examples/sops-image-pull-secret.yaml');

local config_ns = 'yebyen-okd4';
local prod_ns = 'prod-yebyen';
local image_pull_secret = 'prod-docker-pull-secret';

// kubecfg doesn't support client-side strategic-merge-patch (yet),
// but we can do better in jsonnet anyway:
local updateConfig(o) = (
  if o.kind == 'ServiceAccount' then o {
    imagePullSecrets: [{ name: image_pull_secret }],
  } else o
);

local prod_tenant = [
  //  kube.Namespace(prod_ns),
] + pull_secrets + tenant;

local prod_kustomization = kustomize.applyList([
  updateConfig,
]);

local staging_kustomization = kustomize.applyList([
  updateConfig,
  kustomize.namespace('test-yebyen'),
]);

{
  prod: std.map(prod_kustomization, prod_tenant),
  stg: std.map(staging_kustomization, prod_tenant),
}
