module "kubernetes-rancher-cluster-deploy" {
  source = "./modules/rke-deploy/"

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

  kubernetes_version        = var.kubernetes_version 
  cluster_name              = var.management_cluster_name
  cluster_nodes             = var.management_cluster_nodes
}


module "kubernetes-rancher" {
  source = "./modules/rancher-deploy"
  cluster_name                    = var.management_cluster_name
  management_cluster_url          = var.management_cluster_url
  management_cluster_certs        = var.management_cluster_certs
  management_cluster_admin_password  = var.management_cluster_admin_password
  api_server_url                  = module.kubernetes-rancher-cluster-deploy.api_server_url
  kube_admin_user                 = module.kubernetes-rancher-cluster-deploy.kube_admin_user
  client_key                      = module.kubernetes-rancher-cluster-deploy.client_key
  client_cert                     = module.kubernetes-rancher-cluster-deploy.client_cert
  ca_crt                          = module.kubernetes-rancher-cluster-deploy.ca_crt
  kubeconfig_filename             = module.kubernetes-rancher-cluster-deploy.kubeconfig_filename
}


module "kubernetes-deplyment-cluster-deploy" {
  source = "./modules/rke-deploy/"

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

  kubernetes_version        = var.kubernetes_version 
  cluster_name              = var.deployment_cluster_name
  cluster_nodes             = var.deployment_cluster_nodes
}


module "kubernetes-deployment-cluster-join" {
  source = "./modules/rancher-join"
  cluster_name                    = var.deployment_cluster_name
  management_cluster_url          = var.management_cluster_url
  management_cluster_token        = module.kubernetes-rancher.token
  api_server_url                  = module.kubernetes-deplyment-cluster-deploy.api_server_url
  kube_admin_user                 = module.kubernetes-deplyment-cluster-deploy.kube_admin_user
  client_key                      = module.kubernetes-deplyment-cluster-deploy.client_key
  client_cert                     = module.kubernetes-deplyment-cluster-deploy.client_cert
  ca_crt                          = module.kubernetes-deplyment-cluster-deploy.ca_crt
  kubeconfig_filename             = module.kubernetes-deplyment-cluster-deploy.kubeconfig_filename
}
