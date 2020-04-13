provider "kubernetes" {
  version                = "1.10.0"
  host                   = var.rke_api_server_url
  username               = var.rke_kube_admin_user
  client_key             = var.rke_client_key
  client_certificate     = var.rke_client_cert
  cluster_ca_certificate = var.rke_ca_crt
  load_config_file       = false
}
provider "helm" {
  version = "1.0.0"
  kubernetes {
    host                   = var.rke_api_server_url
    username               = var.rke_kube_admin_user
    client_key             = var.rke_client_key
    client_certificate     = var.rke_client_cert
    cluster_ca_certificate = var.rke_ca_crt
    load_config_file       = false
  }
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${var.management_url}"
  bootstrap = true
  insecure  = true
}
