
resource "azurerm_resource_group" "networking_rg" {
    name = "networking"
    location = vars.location
}

resource "azurerm_network_security_group" "compute_nsg" {
  name                = "compute"
  location            = azurerm_resource_group.networking_rg.location
  resource_group_name = azurerm_resource_group.networking_rg.name
}

resource "azurerm_network_security_group" "data_nsg" {
  name                = "data"
  location            = azurerm_resource_group.networking_rg.location
  resource_group_name = azurerm_resource_group.networking_rg.name
}

resource "azurerm_virtual_network" "networking_vnet" {
  name                = "networking"
  location            = azurerm_resource_group.networking_rg.location
  resource_group_name = azurerm_resource_group.networking_rg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "aks"
    address_prefix = "10.0.20.0/22"
    security_group = azurerm_network_security_group.compute.id
  }

  subnet {
    name           = "data"
    address_prefix = "10.0.40.0/24"
    security_group = azurerm_network_security_group.data.id
  }

}
