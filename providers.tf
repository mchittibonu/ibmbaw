terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_redhat_openshift_cluster.aro.apiserver_profile[0].url
  cluster_ca_certificate = base64decode(azurerm_redhat_openshift_cluster.aro.cluster_profile.0.pull_secret)
  token                  = var.openshift_token
}

provider "kubectl" {
  host                   = azurerm_redhat_openshift_cluster.aro.apiserver_profile[0].url
  token                  = var.openshift_token
  load_config_file       = false
}