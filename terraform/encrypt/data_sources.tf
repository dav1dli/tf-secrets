data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.resource_group
}
data "sops_file" "db-secret" {
  source_file = "db-secret.enc.json"
}