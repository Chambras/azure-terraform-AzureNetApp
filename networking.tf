
resource "azurerm_virtual_network" "genericVNet" {
  name                = "${var.suffix}${var.vnetName}"
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name
  address_space       = ["10.20.0.0/22"]

  tags = var.tags
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.genericRG.name
  virtual_network_name = azurerm_virtual_network.genericVNet.name
  address_prefix       = "10.20.2.0/24"
}

resource "azurerm_subnet" "public" {
  name                 = "public"
  resource_group_name  = azurerm_resource_group.genericRG.name
  virtual_network_name = azurerm_virtual_network.genericVNet.name
  address_prefix       = "10.20.3.0/24"
}

resource "azurerm_subnet" "netApp" {
  name                 = "netApp"
  resource_group_name  = azurerm_resource_group.genericRG.name
  virtual_network_name = azurerm_virtual_network.genericVNet.name
  address_prefix       = "10.20.1.0/28"

  delegation {
    name = "NetAppDelegation"

    service_delegation {
      name = "Microsoft.Netapp/volumes"
      actions = [
        "Microsoft.Network/networkinterfaces/*",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

}