
variable "rke_api_server_url" {
  type = string
}
variable "rke_kube_admin_user" {
  type = string
}
variable "rke_client_key" {
  type = string
}
variable "rke_client_cert" {
  type = string
}
variable "rke_ca_crt" {
  type = string
}
variable rke_kubeconfig_filename {
  type = string
}
variable "management_url" {
  type = string
}
variable "management_certificates" {
  type = map(any)
}
variable "management_default_password" {
  type = string
}
