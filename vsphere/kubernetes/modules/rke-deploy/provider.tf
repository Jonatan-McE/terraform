provider "vsphere" {
  user                 = var.terraform_vsphere_username
  password             = var.terraform_vsphere_password
  vsphere_server       = var.vsphere_server_url
  allow_unverified_ssl = "true"
  version              = "1.13.0"
}

provider "rke" {
}