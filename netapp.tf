resource "azurerm_netapp_account" "netAppAccount" {
  name                = "netAppAccount"
  resource_group_name = azurerm_resource_group.genericRG.name
  location            = azurerm_resource_group.genericRG.location

  /* active_directory {
    username            = "aduser"
    password            = "aduserpwd"
    smb_server_name     = "SMBSERVER"
    dns                 = ["1.2.3.4"]
    domain              = "westcentralus.com"
    organizational_unit = "OU=FirstLevel"
  }*/
}

resource "azurerm_netapp_pool" "netAppPool" {
  name                = "netAppPool"
  account_name        = azurerm_netapp_account.netAppAccount.name
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name
  service_level       = var.serviceLevel
  size_in_tb          = var.poolSize
}