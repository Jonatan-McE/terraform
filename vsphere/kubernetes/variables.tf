# Variable set in credentials.tfvars
variable "vsphere_server_url" {
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
variable "kubernetes_vsphere_username" {
  type = string
}
variable "kubernetes_vsphere_password" {
  type = string
}


variable "kubernetes_version" {
  type = string
}
variable "management_url" {
  type = string
}
variable "management_default_password" {
  type = string
}
variable "management_certificates" {
  type = map(any)
}


variable "management_cluster_name" {
  type = string
}
variable "management_cluster_nodes" {
  type = map(any)
}
variable "application_cluster_name" {
  type = string
}
variable "application_cluster_nodes" {
  type = map(any)
}
