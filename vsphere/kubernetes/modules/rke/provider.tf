provider "vsphere" {
  version              = "1.13.0"
  user                 = var.vsphere_credentials.terraform_username
  password             = var.vsphere_credentials.terraform_password
  vsphere_server       = var.vsphere_settings.server_url
  allow_unverified_ssl = "true"
}

provider "rke" {
}

