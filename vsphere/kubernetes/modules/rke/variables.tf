# Inhareted
variable "kubernetes_version" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "cluster_nodes" {
  type = map(any)
}

variable "management_url" {
  type = string
}
variable "management_api_token" {
  type = string
}

variable vsphere_server_url {
  type = string
}
variable "vsphere_datacenter" {
  type = string
}
variable "vsphere_cluster" {
  type = string
}
variable "vsphere_datastore" {
  type = string
}
variable "vsphere_network" {
  type = string
}
variable "vsphere_template" {
  type = string
}

variable "terraform_vsphere_username" {
  type = string
}
variable "terraform_vsphere_password" {
  type = string
}
variable kubernetes_vsphere_username {
  type = string
}
variable kubernetes_vsphere_password {
  type = string
}

variable management_cluster {
  type    = bool
  default = false
}