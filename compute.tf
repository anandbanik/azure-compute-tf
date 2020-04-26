# Create virtual machine
resource "azurerm_virtual_machine" "az-compute-vm" {
    name                  = var.compute_name
    location              = var.resource_group_location
    resource_group_name   = azurerm_resource_group.az-compute-rg.name
    network_interface_ids = [azurerm_network_interface.az-compute-nic.id]
    vm_size               = var.compute_size

    storage_os_disk {
        name              = "vmOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    /*
    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }
    */

    os_profile {
        computer_name  = var.compute_vm_name
        admin_username = var.compute_vm_user
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.compute_vm_user}/.ssh/authorized_keys"
            key_data = var.compute_ssh
        }
    }

    boot_diagnostics {
        enabled = "false"
        storage_uri = azurerm_storage_account.storageaccounttfdemo.primary_blob_endpoint
    }

}