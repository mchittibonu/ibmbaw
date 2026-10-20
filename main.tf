resource "azurerm_resource_group" "rg" {
  name     = "rg-cp4ba-aro"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-aro"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "master_subnet" {
  name                 = "master-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "worker_subnet" {
  name                 = "worker-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = "cp4ba-aro-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  cluster_profile {
    domain  = "cp4ba-demo"
    version = "4.14"
  }

  master_profile {
    vm_size   = "Standard_D8s_v3"
    subnet_id = azurerm_subnet.master_subnet.id
  }

  worker_profile {
    name         = "worker"
    vm_size      = "Standard_D16s_v3"
    disk_size_gb = 128
    subnet_id    = azurerm_subnet.worker_subnet.id
    node_count   = 3
  }

  network_profile {
    pod_cidr     = "10.128.0.0/14"
    service_cidr = "172.30.0.0/16"
  }
}