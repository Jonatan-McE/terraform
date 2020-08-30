terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "1.23.0"
    }
    rke = {
      source = "rancher/rke"
      version = "1.1.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.10.1"
    }
  }
  required_version = ">= 0.13"
}
