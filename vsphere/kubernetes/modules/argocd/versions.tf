terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "1.3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.12.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.10.1"
    }
  }
  required_version = ">= 0.13"
}
