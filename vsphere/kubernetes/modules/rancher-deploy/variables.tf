variable cluster_name {
  type = string
}
variable kubeconfig_filename {
  type = string
}
variable "api_server_url" {
    type = string
}
variable "kube_admin_user" {
    type = string
}
variable "client_key" {
    type = string
}
variable "client_cert" {
    type = string
}
variable "ca_crt" {
    type = string
}
variable "management_cluster_url" {
  type = string
}
variable "management_cluster_certs" {
  type = map(any)
}
variable "management_cluster_admin_password" {
  type = string
}
