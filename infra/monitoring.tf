resource "azurerm_log_analytics_workspace" "arc" {
  name                = "edge-${random_string.suffix.result}"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.edge.name
  sku                 = "PerGB2018"
}