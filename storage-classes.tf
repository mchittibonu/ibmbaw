resource "kubernetes_storage_class_v1" "azure_disk_premium" {
  metadata {
    name = "azure-disk-premium-csi"
  }
  storage_provisioner = "disk.csi.azure.com"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    skuName = "Premium_LRS"
  }
}

resource "kubernetes_storage_class_v1" "azure_file_premium" {
  metadata {
    name = "azure-file-premium-csi"
  }
  storage_provisioner = "file.csi.azure.com"
  reclaim_policy      = "Delete"
  parameters = {
    skuName = "Premium_LRS"
  }
}
