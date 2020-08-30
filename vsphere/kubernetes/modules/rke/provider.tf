provider "vsphere" {
  user                 = var.vsphere_credentials.terraform_username
  password             = var.vsphere_credentials.terraform_password
  vsphere_server       = var.vsphere_settings.server_url
  allow_unverified_ssl = "true"
}

provider "rke" {
  log_file = ".logs/rke_debug.log"
}

provider "rancher2" {
  api_url   = "https://${var.management_api.url.value}"
  token_key = var.management_api_token
  insecure  = true
}