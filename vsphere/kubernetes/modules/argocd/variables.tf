variable "cluster_name" {
  type = string
}
variable "argocd" {
  type = map(string)
}

variable "management_url" {
  type = string
}
variable "management_api_token" {
  type = string
}

variable "rke-cluster_api_server_url" {
  type = string
}
variable "rke-cluster_kube_admin_user" {
  type = string
}
variable "rke-cluster_client_key" {
  type = string
}
variable "rke-cluster_client_cert" {
  type = string
}
variable "rke-cluster_ca_crt" {
  type = string
}

variable "dependencies" {
  type    = list
  default = []
}
