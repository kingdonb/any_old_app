// Copyright 2017 The kubecfg authors
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

// Simple to demonstrate kubecfg using kube-libsonnet
// This should not necessarily be considered a model jsonnet example
// to build upon.

// This is a simple port to jsonnet of the standard guestbook example
// https://github.com/kubernetes/kubernetes/tree/master/examples/guestbook
//
// ```
// kubecfg update guestbook.jsonnet
//
// # poke at
// - $(minikube service frontend), etc
// - kubectl proxy # then visit http://localhost:8001/api/v1/namespaces/default/services/frontend/proxy/
// kubecfg delete guestbook.jsonnet
// ```

// This example uses kube.libsonnet from Bitnami.  There are other
// Kubernetes libraries available, or write your own!
local kube = import 'https://github.com/bitnami-labs/kube-libsonnet/raw/73bf12745b86718083df402e89c6c903edd327d2/kube.libsonnet';

local example = import 'example.libsonnet';

{
  version_configmap: kube.ConfigMap('any-old-app-version') {
    stringData+: {
      VERSION: 'v1.0.0',
    },
  },
  flux_kustomization: example.kustomization('any-old-app-prod') {
    namespace: 'yebyen-okd4',
    spec+: {
      postBuild+: {
        substituteFrom+: [
          {
            kind: 'ConfigMap',
            name: 'any-old-app-version',
          },
        ],
      },
    },
  },
  flux_gitrepository: example.gitrepository('any-old-app-prod') {
    namespace: 'yebyen-okd4',
    spec+: {
      url: 'https://github.com/kingdonb/any_old_app',
    },
  },
}
