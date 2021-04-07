output "url-acr" {
    value = azurerm_container_registry.cr_K8s.login_server
}

output "username-acr" {
    value = azurerm_container_registry.cr_K8s.admin_username
}

output "password-acr" {
    value = azurerm_container_registry.cr_K8s.admin_password
}