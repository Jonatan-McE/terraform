provider "vsphere" {
  version              = "1.13.0"
  user                 = var.terraform_vsphere_username
  password             = var.terraform_vsphere_password
  vsphere_server       = var.vsphere_server_url
  allow_unverified_ssl = "true"
}

provider "rke" {
}

provider "rancher2" {
  version   = "1.8.3"
  alias     = "admin"
  api_url   = "https://${var.management_url}"
  token_key = var.management_api_token
  insecure  = true
}