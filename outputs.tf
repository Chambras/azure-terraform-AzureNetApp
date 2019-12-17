output "generic_RG" {
  value = "${azurerm_resource_group.genericRG.name}"
}

output "vnetName" {
  value = "${azurerm_virtual_network.genericVNet.name}"
}

output "publicSubnet" {
  value = "${azurerm_subnet.public.name}"
}

output "internalSubnet" {
  value = "${azurerm_subnet.internal.name}"
}

output "netAppSubnet" {
  value = "${azurerm_subnet.netApp.name}"
}

output "CentOSPublicIP" {
  value = "${azurerm_public_ip.centospublicip.ip_address}"
}

output "CentOSPrivateIP" {
  value = "${azurerm_network_interface.centosNI.private_ip_address}"
}

output "netAppAccountName" {
  value = "${azurerm_netapp_account.netAppAccount.name}"
}

output "netAppPool" {
  value = "${azurerm_netapp_pool.netAppPool.name}"
}

output "poolSize" {
  value = var.poolSize
}

output "serviceLevel" {
  value = var.serviceLevel
}
