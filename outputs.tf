output "aro_cluster_console_url" {
  description = "OpenShift Web Console URL"
  value       = azurerm_redhat_openshift_cluster.aro.console_profile[0].url
}

output "resource_group_name" {
  description = "Azure Resource Group Name"
  value       = azurerm_resource_group.rg.name
}