# Variable set in credentials.tfvars
variable "kubernetes_version" {
  type = string
}
variable "vsphere" {
  type = map(string)
}

variable "vsphere_credentials" {
  type = map(string)
}




variable "management_api" {
  type = map(any)
}


variable "management_cluster_name" {
  type = string
}
variable "management_cluster_settings" {
  type = map(any)
}
variable "application_cluster_name" {
  type = string
}

variable "application_cluster_settings" {
  type = map(any)
}

variable "argocd_settings" {
  type = map(string)
}
