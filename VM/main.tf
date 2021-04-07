resource "azurerm_resource_group" "rg_VM" {
  name      = var.resource_group_name
  location  = var.resource_group_location
  tags      = {
    "diplomado" = "grupo1"
  }
}

resource "azurerm_public_ip" "pubip_VM" {
  name                  = "public-ip-grupo1-VM"
  resource_group_name   = azurerm_resource_group.rg_VM.name
  location              = azurerm_resource_group.rg_VM.location
  allocation_method     = "Static"
}

resource "azurerm_virtual_network" "vn_VM" {
  name                  = "virtual-net-grupo1-VM"
  address_space         = [ "10.0.0.0/16" ]
  resource_group_name   = azurerm_resource_group.rg_VM.name
  location              = azurerm_resource_group.rg_VM.location
}

resource "azurerm_subnet" "subnet_VM" {
  name                  = "subnet-grupo1-VM"
  address_prefixes      = [ "10.0.2.0/24" ]
  resource_group_name   = azurerm_resource_group.rg_VM.name
  virtual_network_name  = azurerm_virtual_network.vn_VM.name
}

resource "azurerm_network_interface" "netint_VM" {
  name                  = "net-interface-grupo1-VM"
  resource_group_name   = azurerm_resource_group.rg_VM.name
  location              = azurerm_resource_group.rg_VM.location

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_VM.id
    public_ip_address_id          = azurerm_public_ip.pubip_VM.id
  }
}

resource "azurerm_linux_virtual_machine" "virtualMachineVM" {
  name                              = "lvm-grupo1-VM"
  size                              = "Standard_B1s"
  resource_group_name               = azurerm_resource_group.rg_VM.name
  location                          = azurerm_resource_group.rg_VM.location

  computer_name                     = "vm-grupo1-VM"
  admin_username                    = "grupo1-VM"
  admin_password                    = "passVM123!"
  disable_password_authentication   = false

  network_interface_ids             = [ azurerm_network_interface.netint_VM.id ]

  os_disk {
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
  }

  source_image_reference {
    publisher               = "Canonical"
    offer                   = "UbuntuServer"
    sku                     = "16.04-LTS"
    version                 = "latest"
  }
}
