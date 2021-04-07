output "public-ip" {
    value = azurerm_public_ip.pubip_VM.ip_address
}

output "username" {
    value = azurerm_linux_virtual_machine.virtualMachineVM.admin_username
}

output "password" {
    value = azurerm_linux_virtual_machine.virtualMachineVM.admin_password
}