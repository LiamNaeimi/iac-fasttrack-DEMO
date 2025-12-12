terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40"
    }
  }
}

provider "azurerm" {
  features {}
  use_cli = true               # Bruker Azure CLI-login
  subscription_id = "7a3c6854-0fe1-42eb-b5b9-800af1e53d70"
}
data "azurerm_client_config" "current" {}
output "current_user" {
  value = data.azurerm_client_config.current.object_id
}

output "current_subscription" {
  value = data.azurerm_client_config.current.subscription_id
}
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hent innlogget bruker fra Entra ID



# Storage Account for Terraform backend
resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true

  tags = var.tags
}

# Container for Terraform state files
resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# Key Vault for secrets
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  public_network_access_enabled = true

  # RBAC authorization
  rbac_authorization_enabled = true

  tags = var.tags
}

# RBAC: Blob Data Contributor for Service Principal
resource "azurerm_role_assignment" "sp_blob_contributor" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.service_principal_object_id
}

# RBAC: Reader for Service Principal (Portal access)
resource "azurerm_role_assignment" "sp_reader" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Reader"
  principal_id         = var.service_principal_object_id
}

# RBAC: Blob Data Contributor for User
resource "azurerm_role_assignment" "user_blob_contributor" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.user_object_id
}

# RBAC: Reader for User (Portal access)
resource "azurerm_role_assignment" "user_reader" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Reader"
  principal_id         = var.user_object_id
}

# RBAC: Key Vault Secrets Officer for Service Principal
resource "azurerm_role_assignment" "sp_kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.service_principal_object_id
}

# RBAC: Key Vault Secrets Officer for User
resource "azurerm_role_assignment" "user_kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.user_object_id
}