module "kubernetes-rancher-cluster" {
  source = "./modules/rke/"

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

  cluster_name              = var.cluster_name
  kubernetes_version        = var.kubernetes_version 
  cluster_nodes             = var.management_cluster_nodes
}

module "kubernetes-rancher-instance" {
  source = "./modules/rancher"
  cluster_name                    = var.cluster_name
  management_cluster              = var.management_cluster
  management_cluster_url          = var.management_cluster_url
  management_cluster_certs        = var.management_cluster_certs
  management_cluster_apikey       = var.management_cluster_apikey
  management_cluster_admin_password  = var.management_cluster_admin_password
  api_server_url                  = module.kubernetes-rancher-cluster.api_server_url
  kube_admin_user                 = module.kubernetes-rancher-cluster.kube_admin_user
  client_key                      = module.kubernetes-rancher-cluster.client_key
  client_cert                     = module.kubernetes-rancher-cluster.client_cert
  ca_crt                          = module.kubernetes-rancher-cluster.ca_crt
  kubeconfig_filename             = module.kubernetes-rancher-cluster.kubeconfig_filename
  
  
}