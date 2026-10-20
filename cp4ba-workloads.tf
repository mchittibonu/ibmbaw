resource "kubernetes_namespace" "cp4ba" {
  metadata {
    name = "cp4ba"
  }
}

resource "kubernetes_secret" "ibm_entitlement" {
  metadata {
    name      = "admin.registrykey"
    namespace = kubernetes_namespace.cp4ba.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "cp.icr.io" = {
          username = "cp"
          password = var.ibm_entitlement_key
          auth     = base64encode("cp:${var.ibm_entitlement_key}")
        }
      }
    })
  }
}

resource "kubernetes_secret" "baw_db_secret" {
  metadata {
    name      = "baw-db-secret"
    namespace = kubernetes_namespace.cp4ba.metadata[0].name
  }

  type = "Opaque"

  data = {
    "db-user"     = "bawadmin"
    "db-password" = "SecurePassword123!"
    "db-jdbc-url" = var.db_connection_url
  }
}

resource "kubectl_manifest" "cp4ba_cluster" {
  depends_on = [
    kubernetes_storage_class_v1.azure_disk_premium,
    kubernetes_storage_class_v1.azure_file_premium,
    kubernetes_secret.ibm_entitlement,
    kubernetes_secret.baw_db_secret
  ]

  yaml_body = <<-EOF
    apiVersion: icp4a.ibm.com/v1
    kind: ICP4ACluster
    metadata:
      name: icp4adeploy
      namespace: cp4ba
    spec:
      app_version: "24.0.1"
      shared_configuration:
        sc_deployment_license: "production"
        sc_deployment_patterns: "workflow"
        sc_deployment_platform: "openshift"
        image_pull_secrets:
          - admin.registrykey
        storage_configuration:
          sc_data_storage_classname: "azure-disk-premium-csi"
          sc_slow_storage_classname: "azure-file-premium-csi"
      baw_configuration:
        - name: workflow-server
          zone: zone1
          database_configuration_ref: "baw-db-secret"
          replica_count: 1
      navigator_configuration:
        - name: navigator
          replica_count: 1
      sc_optional_components: "elasticsearch, cmis, ae"
  EOF
}