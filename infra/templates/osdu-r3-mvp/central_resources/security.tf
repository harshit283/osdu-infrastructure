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


/*
.Synopsis
   Terraform Security Control
.DESCRIPTION
   This file holds security settings.
*/


#-------------------------------
# Private Variables
#-------------------------------
locals {
  rbac_principals = [
    azurerm_user_assigned_identity.osduidentity.principal_id,
    var.principal_objectId
  ]


  ai_key_name   = "appinsights-key"
  logs_id_name  = "log-workspace-id"
  logs_key_name = "log-workspace-key"
}


// *** NOTE ***
// Contributor Role Scopes are set automatically by the Principal Module itself. (main.tf)


#-------------------------------
# Key Vault
#-------------------------------

// Add Reader Role Access
resource "azurerm_role_assignment" "kv_roles" {
  count = length(local.rbac_principals)

  role_definition_name = "Reader"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.keyvault.keyvault_id
}



#-------------------------------
# Application Insights
#-------------------------------

// Add the App Insights Key to the Vault
resource "azurerm_key_vault_secret" "insights" {
  name         = local.ai_key_name
  value        = module.app_insights.app_insights_instrumentation_key
  key_vault_id = module.keyvault.keyvault_id
}


#-------------------------------
# Log Analytics
#-------------------------------

// Add the Log Analytics Id to the Vault
resource "azurerm_key_vault_secret" "workspace_id" {
  name         = local.logs_id_name
  value        = module.log_analytics.log_workspace_id
  key_vault_id = module.keyvault.keyvault_id
}

// Add the Log Analtyics Key to the Vault
resource "azurerm_key_vault_secret" "workspace_key" {
  name         = local.logs_key_name
  value        = module.log_analytics.log_workspace_key
  key_vault_id = module.keyvault.keyvault_id
}


#-------------------------------
# AD Principal and Applications
#-------------------------------

// Add the Service Principal Id
resource "azurerm_key_vault_secret" "principal_id" {
  name         = "app-dev-sp-username"
  value        = module.service_principal.client_id
  key_vault_id = module.keyvault.keyvault_id
}

// Add the Service Principal Id
resource "azurerm_key_vault_secret" "principal_secret" {
  name         = "app-dev-sp-password"
  value        = module.service_principal.client_secret
  key_vault_id = module.keyvault.keyvault_id
}


#-------------------------------
# OSDU Identity
#-------------------------------

// Add Reader Role