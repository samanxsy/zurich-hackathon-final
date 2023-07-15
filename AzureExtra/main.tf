terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.31.1"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vnet" {
  source = "./vnet"
}

module "vm" {
  source = "./vm"

  resource_group_name = module.vnet.resource_group_name
  resource_group_location = module.vnet.resource_group_location
  subnet_id = module.vnet.subnet_id
  network_security_group_id = module.vnet.network_security_group_id
}
