resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "keyvault" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
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
