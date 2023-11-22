resource "azurerm_mariadb_server" "db" {
  name                         = local.db_name
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  administrator_login          = "dbadmin"
  administrator_login_password = data.sops_file.db-secret.data["password"]
  sku_name   = "B_Gen5_1"
  version    = "10.3"
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  tags       = var.tags
}