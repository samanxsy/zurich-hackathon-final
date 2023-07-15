resource "azurerm_network_interface" "vx_nic" {
  name     = "vx-nic"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location

  ip_configuration {
    name                          = "vx-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vx_public_ip.id
  }
}

resource "azurerm_public_ip" "vx_public_ip" {
  name                = "vx-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# # VIRTUAL MACHINE
resource "azurerm_virtual_machine" "vx_vm" {
  name                  = "vx-vm"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vx_nic.id]
  vm_size               = "Standard_B1s"

  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "vx-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  os_profile {
    computer_name  = "vx-vm"
    admin_username = "vxadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/vxadmin/.ssh/authorized_keys"
      key_data = file("vm/vmkey.pub")
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${azurerm_public_ip.vx_public_ip.ip_address},' -u vxadmin ansible/playbook.yml --private-key=vm/vmkey"
  }
}
