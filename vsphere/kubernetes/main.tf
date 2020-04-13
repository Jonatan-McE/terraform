
module "kubernetes-management-cluster-deploy" {
  source = "./modules/rke/"

  kubernetes_version          = var.kubernetes_version
  cluster_name                = var.management_cluster_name
  cluster_nodes               = var.management_cluster_nodes
  management_url              = var.management_url
  management_cluster          = true
  management_api_token        = ""
  vsphere_server_url          = var.vsphere_server_url
  vsphere_datacenter          = var.vsphere_datacenter
  vsphere_cluster             = var.vsphere_cluster
  vsphere_datastore           = var.vsphere_datastore
  vsphere_network             = var.vsphere_network
  vsphere_template            = var.vsphere_template
  terraform_vsphere_username  = var.terraform_vsphere_username
  terraform_vsphere_password  = var.terraform_vsphere_password
  kubernetes_vsphere_username = var.kubernetes_vsphere_username
  kubernetes_vsphere_password = var.kubernetes_vsphere_password
}


module "kubernetes-management-instance-deploy" {
  source                      = "./modules/rancher"
  management_url              = var.management_url
  management_certificates     = var.management_certificates
  management_default_password = var.management_default_password
  rke_api_server_url          = module.kubernetes-management-cluster-deploy.rke_api_server_url
  rke_kube_admin_user         = module.kubernetes-management-cluster-deploy.rke_kube_admin_user
  rke_client_key              = module.kubernetes-management-cluster-deploy.rke_client_key
  rke_client_cert             = module.kubernetes-management-cluster-deploy.rke_client_cert
  rke_ca_crt                  = module.kubernetes-management-cluster-deploy.rke_ca_crt
  rke_kubeconfig_filename     = module.kubernetes-management-cluster-deploy.rke_kubeconfig_filename
}

module "kubernetes-application-cluster-deploy" {
  source = "./modules/rke/"

  kubernetes_version          = var.kubernetes_version
  cluster_name                = var.application_cluster_name
  cluster_nodes               = var.application_cluster_nodes
  management_url              = var.management_url
  management_api_token        = module.kubernetes-management-instance-deploy.token
  vsphere_server_url          = var.vsphere_server_url
  vsphere_datacenter          = var.vsphere_datacenter
  vsphere_cluster             = var.vsphere_cluster
  vsphere_datastore           = var.vsphere_datastore
  vsphere_network             = var.vsphere_network
  vsphere_template            = var.vsphere_template
  terraform_vsphere_username  = var.terraform_vsphere_username
  terraform_vsphere_password  = var.terraform_vsphere_password
  kubernetes_vsphere_username = var.kubernetes_vsphere_username
  kubernetes_vsphere_password = var.kubernetes_vsphere_password
}
