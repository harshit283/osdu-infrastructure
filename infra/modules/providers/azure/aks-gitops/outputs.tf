//  Copyright © Microsoft Corporation
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

output "cluster_id" {
  value = module.aks.id
}

output "cluster_name" {
  value = module.aks.name
}

output "cluster_principal_id" {
  value = module.aks.principal_id
}

output "node_resource_group" {
  value = module.aks.node_resource_group
}

output "kube_config" {
  value = module.aks.kube_config_block
}

output "kubeconfig_done" {
  value = module.aks.kubeconfig_done
}

output "aks_flux_kubediff_done" {
  value = "${module.aks.kubeconfig_done}_${module.flux.flux_done}_${module.kubediff.kubediff_done}"
}

output "kubelet_identity_id" {
  value = module.aks.kubelet_identity_id
}

output "kubelet_client_id" {
  value = module.aks.kubelet_client_id
}

output "kubelet_object_id" {
  value = module.aks.kubelet_object_id
}

