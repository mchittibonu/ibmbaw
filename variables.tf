variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

variable "ibm_entitlement_key" {
  type        = string
  description = "IBM Container Library Entitlement Key"
  sensitive   = true
}

variable "openshift_token" {
  type        = string
  description = "OpenShift Cluster Admin Bearer Token"
  sensitive   = true
}

variable "db_connection_url" {
  type        = string
  description = "JDBC connection string for external BAW PostgreSQL database"
  default     = "jdbc:postgresql://your-azure-pg-server.postgres.database.azure.com:5432/bawdb"
}