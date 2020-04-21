provider "vsphere" {
  version              = "1.13.0"
  user                 = var.vsphere_credentials.terraform_username
  password             = var.vsphere_credentials.terraform_password
  vsphere_server       = var.vsphere.server_url
  allow_unverified_ssl = "true"
}

provider "rke" {
}

provider "rancher2" {
  version   = "1.8.3"
  api_url   = "https://${var.management_api.url.value}"
  token_key = var.management_api_token
  insecure  = true
}