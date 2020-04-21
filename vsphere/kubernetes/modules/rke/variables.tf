# Inhareted
variable "kubernetes_version" {
  type = string
}
variable "management" {
  type = bool
  default = false
}

variable "cluster_name" {
  type = string
}
variable "cluster_settings" {
  type = map(any)
}

variable "management_api" {
  type = map(any)
}
variable "management_api_token" {
  type = string
}


variable "vsphere" {
  type = map(string)
}

variable "vsphere_credentials" {
  type = map(string)
}
