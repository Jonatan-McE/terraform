provider "kubernetes" {
  version                = "1.11.1"
  host                   = var.rke.api_server_url
  username               = var.rke.kube_admin_user
  client_key             = var.rke.client_key
  client_certificate     = var.rke.client_cert
  cluster_ca_certificate = var.rke.ca_crt
  load_config_file       = false
}
provider "helm" {
  version = "1.1.1"
  kubernetes {
    host                   = var.rke.api_server_url
    username               = var.rke.kube_admin_user
    client_key             = var.rke.client_key
    client_certificate     = var.rke.client_cert
    cluster_ca_certificate = var.rke.ca_crt
    load_config_file       = false
  }
}

provider "rancher2" {
  version   = "1.8.3"
  alias     = "bootstrap"
  api_url   = "https://${var.management_api.url.value}"
  bootstrap = true
  insecure  = true
}
