# Networking
resource "azurerm_virtual_network" "edge" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.edge.location
  resource_group_name = azurerm_resource_group.edge.name
}

resource "azurerm_subnet" "edge" {
  name                 = "edge"
  resource_group_name  = azurerm_resource_group.edge.name
  virtual_network_name = azurerm_virtual_network.edge.name
  address_prefixes     = ["10.0.0.0/24"]
}
