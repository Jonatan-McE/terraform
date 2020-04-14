provider "kubernetes" {
  version                = "1.11.1"
  host                   = var.rke-cluster_api_server_url
  username               = var.rke-cluster_kube_admin_user
  client_key             = var.rke-cluster_client_key
  client_certificate     = var.rke-cluster_client_cert
  cluster_ca_certificate = var.rke-cluster_ca_crt
  load_config_file       = false
}
provider "helm" {
  version = "1.1.1"
  kubernetes {
    host                   = var.rke-cluster_api_server_url
    username               = var.rke-cluster_kube_admin_user
    client_key             = var.rke-cluster_client_key
    client_certificate     = var.rke-cluster_client_cert
    cluster_ca_certificate = var.rke-cluster_ca_crt
    load_config_file       = false
  }
}

provider "rancher2" {
  version   = "1.8.3"
  alias     = "bootstrap"
  api_url   = "https://${var.management_url}"
  bootstrap = true
  insecure  = true
}
