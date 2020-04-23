# Variable set in credentials.tfvars
variable "kubernetes_version" {
  type = string
}
variable "vsphere_settings" {
  type = map(string)
}
variable "vsphere_credentials" {
  type = map(string)
}


variable "management_api" {
  type = map(any)
}

variable "argocd_settings" {
  type = map(string)
}



variable "cluster_settings_management" {
  type = map(any)
}
variable "cluster_settings_private" {
  type = map(any)
}
variable "cluster_settings_public" {
  type = map(any)
}
