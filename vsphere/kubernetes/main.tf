
module "deploy-rancher" {
  source = "./modules/rancher"

  management_api = var.management_api
  rke            = module.deploy-management-cluster.rke
}

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

module "deploy-private-cluster" {
  source = "./modules/rke/"

  kubernetes_version   = var.kubernetes_version
  management           = false
  cluster_name         = "Private"
  cluster_settings     = var.cluster_settings_private
  management_api       = var.management_api
  management_api_token = module.deploy-rancher.token
  vsphere_settings     = var.vsphere_settings
  vsphere_credentials  = var.vsphere_credentials
  argocd_settings      = var.argocd_settings

  dependencies = [
    module.deploy-rancher.depended_on
  ] 
}

module "deploy-public-cluster" {
  source = "./modules/rke/"

  kubernetes_version   = var.kubernetes_version
  management           = false
  cluster_name         = "Public"
  cluster_settings     = var.cluster_settings_public
  management_api       = var.management_api
  management_api_token = module.deploy-rancher.token
  vsphere_settings     = var.vsphere_settings
  vsphere_credentials  = var.vsphere_credentials
  argocd_settings      = var.argocd_settings

  dependencies = [
    module.deploy-rancher.depended_on
  ] 
}