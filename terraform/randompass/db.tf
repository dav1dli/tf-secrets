resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mariadb_server" "db" {
  name                         = local.db_name
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  administrator_login          = "dbadmin"
  administrator_login_password = random_password.password.result
  sku_name   = "B_Gen5_1"
  version    = "10.3"
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  tags       = var.tags
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name         = "dbpassword"
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}