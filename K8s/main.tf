resource "azurerm_resource_group" "rg_K8s" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = {
    "diplomado" = "grupo1"
  }
}

resource "azurerm_virtual_network" "vn_K8s" {
  name                  = "virtual-net-grupo1-K8s"
  address_space         = [ "20.0.0.0/16" ]
  resource_group_name   = azurerm_resource_group.rg_K8s.name
  location              = azurerm_resource_group.rg_K8s.location
}

resource "azurerm_subnet" "subnet_K8s" {
  name                  = "subnet-grupo1-K8s"
  address_prefixes      = [ "20.0.0.0/20" ]
  resource_group_name   = azurerm_resource_group.rg_K8s.name
  virtual_network_name  = azurerm_virtual_network.vn_K8s.name
}

resource "azurerm_container_registry" "cr_K8s" {
  name                  = "contRegGrupo1K8s"
  resource_group_name   = azurerm_resource_group.rg_K8s.name
  location              = azurerm_resource_group.rg_K8s.location
  sku                   = "basic"
  admin_enabled         = true
}

resource "azurerm_kubernetes_cluster" "kc_K8s" {
  name                  = "kcluster-grupo1-K8s"
  resource_group_name   = azurerm_resource_group.rg_K8s.name
  location              = azurerm_resource_group.rg_K8s.location
  dns_prefix            = "grupo1-K8s"
  kubernetes_version    = "1.19.6"

  default_node_pool {
    name                  = "default"
    node_count            = 1
    vm_size               = "Standard_D2_v2"
    vnet_subnet_id        = azurerm_subnet.subnet_K8s.id
    enable_auto_scaling   = true
    max_count             = 3
    min_count             = 1
    type                  = "VirtualMachineScaleSets"
    max_pods              = 80
  }

  service_principal {
    client_id       = var.client_id
    client_secret   = var.client_secret
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  role_based_access_control {
    enabled = true
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "np_K8s" {
  name                    = "adicional"
  vm_size                 = "Standard_D2_v2"
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.kc_K8s.id
  enable_auto_scaling     = true
  max_count               = 3
  min_count               = 1
  max_pods                = 80

  tags = {
    Label = "Adicional"
  }
}