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
  debug   = true
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
  api_url   = "https://${var.management_api.url.value}"
  token_key = var.management_api_token
  insecure  = true
}