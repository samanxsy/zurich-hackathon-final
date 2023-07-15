output "vx_public_ip" {
  value = azurerm_public_ip.vx_public_ip.ip_address
  depends_on = [ azurerm_public_ip.vx_public_ip ]
}
