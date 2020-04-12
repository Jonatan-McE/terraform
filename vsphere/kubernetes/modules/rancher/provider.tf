provider "kubernetes" {
  version          = "1.10.0"
    host                   = var.api_server_url
    username               = var.kube_admin_user
    client_key             = var.client_key
    client_certificate     = var.client_cert
    cluster_ca_certificate = var.ca_crt
    load_config_file = false
}
provider "helm" {
  version              = "1.0.0"
  kubernetes {
    host                   = var.api_server_url
    username               = var.kube_admin_user
    client_key             = var.client_key
    client_certificate     = var.client_cert
    cluster_ca_certificate = var.ca_crt
    load_config_file = false
  }
}

provider "rancher2" {
  api_url   = "https://${var.management_cluster_url}"
  bootstrap = true
  insecure  = true
}
provider "rancher2" {
  alias     = "admin"
  api_url   = "https://${var.management_cluster_url}"
  token_key = var.management_cluster_apikey
  insecure  = true
}