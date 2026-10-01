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

resource "azurerm_resource_group" "storage_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [
      access_tier,
      https_traffic_only_enabled,
      min_tls_version,
      queue_encryption_key_type,
      table_encryption_key_type,
      tags,
      blob_properties,
      network_rules,
      routing,
      share_properties
    ]
  }
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}
