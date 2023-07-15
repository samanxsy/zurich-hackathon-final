output "resource_group_name" {
  value = azurerm_resource_group.vx_vm_rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.vx_vm_rg.location
}

output "subnet_id" {
  value = azurerm_subnet.vx_subnet.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.vx_sg.id
}
