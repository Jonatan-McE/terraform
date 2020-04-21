
module "kubernetes-management-cluster-deploy" {
  source = "./modules/rke/"

  kubernetes_version   = var.kubernetes_version
  management           = true
  cluster_name         = "Management"
  cluster_settings     = var.management_cluster_settings
  management_api       = var.management_api
  management_api_token = ""
  vsphere              = var.vsphere
  vsphere_credentials  = var.vsphere_credentials
}


module "kubernetes-rancher-deploy" {
  source = "./modules/rancher"

  management_api = var.management_api
  rke            = module.kubernetes-management-cluster-deploy.rke
}

module "kubernetes-application-cluster-deploy" {
  source = "./modules/rke/"

  kubernetes_version   = var.kubernetes_version
  management           = false
  cluster_name         = "App01"
  cluster_settings     = var.application_cluster_settings
  management_api       = var.management_api
  management_api_token = module.kubernetes-rancher-deploy.token
  vsphere              = var.vsphere
  vsphere_credentials  = var.vsphere_credentials
}


module "kubernetes-argo-deploy" {
  source = "./modules/argocd"

  cluster_name         = "App01"
  argocd_settings      = var.argocd_settings
  management_api       = var.management_api
  management_api_token = module.kubernetes-rancher-deploy.token
  rke                  = module.kubernetes-application-cluster-deploy.rke

  dependencies = [
    module.kubernetes-rancher-deploy.depended_on,
    module.kubernetes-application-cluster-deploy.depended_on,
  ]
}
