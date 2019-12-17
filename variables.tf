variable "location" {
  type        = string
  default     = "eastus2"
  description = "Location where the resoruces are going to be created."
}

variable "suffix" {
  type        = string
  default     = "usri"
  description = "To be added at the beginning of each resource."
}

variable "rgName" {
  type        = string
  default     = "NetAppRG"
  description = "Resource Group Name."
}

variable "tags" {
  type = map
  default = {
    "Environment" = "Dev"
    "Project"     = "Demo"
    "BillingCode" = "Internal"
    "Customer"    = "USRI"
  }
}

## Networking variables
variable "vnetName" {
  type        = string
  default     = "Main"
  description = "VNet name."
}

## Security variables
variable "sgName" {
  type        = string
  default     = "defaultSG"
  description = "Default Security Group Name to be applied by default to VMs and subnets."
}

variable "sourceIPs" {
  type        = list
  default     = ["173.66.39.236", "167.220.148.21"]
  description = "Public IPs to allow inboud communications."
}

## compute variables
variable "VMName" {
  type        = string
  default     = "Server"
  description = "Default Windows VM server name."
}

variable "vmSize" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "Default VM size."
}

variable "publicIPName" {
  type        = string
  default     = "PublicIP"
  description = "Default Public IP name."
}

variable "publicIPAllocation" {
  type        = string
  default     = "Static"
  description = "Default Public IP allocation. Could be Static or Dynamic."
}

variable "networkInterfaceName" {
  type        = string
  default     = "NIC"
  description = "Default Windows Network Interface Name."
}

variable "sshKeyPath" {
  type        = string
  default     = "~/.ssh/vm_ssh.pub"
  description = "SSH Key to use when creating the VM."
}

# NetApp
variable "serviceLevel" {
  type        = string
  default     = "Standard"
  description = "he service level of the file system. Valid values include Premium, Standard, or Ultra."
}

variable "poolSize" {
  type        = number
  default     = 4
  description = "The service level of the file system. Valid values include Premium, Standard, or Ultra."
}

