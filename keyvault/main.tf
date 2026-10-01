terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
  use_cli                         = false

  environment   = "stack"
  metadata_host = "localhost:4577"

  subscription_id = "00000000-0000-0000-0000-000000000001"
  tenant_id       = "00000000-0000-0000-0000-000000000002"
  client_id       = "00000000-0000-0000-0000-000000000003"
  client_secret   = "fake-secret"
}

resource "azurerm_resource_group" "keyvault_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "keyvault" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.keyvault_rg.location
  resource_group_name = azurerm_resource_group.keyvault_rg.name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  rbac_authorization_enabled = false

  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = "my-secret-value"
  key_vault_id = azurerm_key_vault.keyvault.id
}
