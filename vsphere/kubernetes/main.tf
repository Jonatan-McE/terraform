
module "deploy-management-cluster" {
  source = "./modules/rke/"

  kubernetes_version   = var.kubernetes_version
  management           = true
  cluster_name         = "Management"
  cluster_settings     = var.cluster_settings_management
  management_api       = var.management_api
  management_api_token = module.deploy-rancher.token
  vsphere_settings     = var.vsphere_settings
  vsphere_credentials  = var.vsphere_credentials
  argocd_settings      = var.argocd_settings
}

module "deploy-application-cluster" {
  source = "./modules/rke/"

  kubernetes_version   = var.kubernetes_version
  management           = false
  cluster_name         = "App01"
  cluster_settings     = var.cluster_settings_application
  management_api       = var.management_api
  management_api_token = module.deploy-rancher.token
  vsphere_settings     = var.vsphere_settings
  vsphere_credentials  = var.vsphere_credentials
  argocd_settings      = var.argocd_settings
}

module "deploy-rancher" {
  source = "./modules/rancher"

  management_api = var.management_api
  rke            = module.deploy-management-cluster.rke
}
