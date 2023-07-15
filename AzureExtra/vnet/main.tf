resource "azurerm_resource_group" "vx_vm_rg" {
  name     = "vx-vm-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vx_vnet" {
  name                = "vx-vnet"
  location            = azurerm_resource_group.vx_vm_rg.location
  resource_group_name = azurerm_resource_group.vx_vm_rg.name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "vx_subnet" {
  name                 = "vx-subnet"
  resource_group_name  = azurerm_resource_group.vx_vm_rg.name
  virtual_network_name = azurerm_virtual_network.vx_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_network_security_group" "vx_sg" {
  name                = "vx-sg"
  location            = azurerm_resource_group.vx_vm_rg.location
  resource_group_name = azurerm_resource_group.vx_vm_rg.name
}

data "external" "my_public_ip" {
  program = ["bash", "vnet/get_ip.sh"]
}

resource "azurerm_network_security_rule" "vx_security_rules_SSH" {
  name                        = "vx-security-rules-SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = data.external.my_public_ip.result["my_public_ip"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vx_vm_rg.name
  network_security_group_name = azurerm_network_security_group.vx_sg.name
}

resource "azurerm_network_security_rule" "vx_security_rules_HTTP" {
  name                        = "vx-security-rules-HTTP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8000"
  source_address_prefix       = data.external.my_public_ip.result["my_public_ip"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vx_vm_rg.name
  network_security_group_name = azurerm_network_security_group.vx_sg.name
}

resource "azurerm_network_security_rule" "vx_security_rules_outbound" {
  name                        = "vx-security-rules-outbound"
  priority                    = 1003
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vx_vm_rg.name
  network_security_group_name = azurerm_network_security_group.vx_sg.name
}


resource "azurerm_subnet_network_security_group_association" "vx_subnet_nsg" {
  subnet_id = azurerm_subnet.vx_subnet.id
  network_security_group_id = azurerm_network_security_group.vx_sg.id
}
