variable "cluster_name" {
  type = string
}
variable "argo_bootstrap" {
  type = map(string)
}
variable "argo_bootstrap_config" {
  type = map(string)
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
