variable "management" {
  type = bool
  default = false
}
variable "cluster_name" {
  type = string
}
variable "management_api" {
  type = map(any)
}
variable "management_api_token" {
  type = string
}
variable "kube_cluster_yaml" {
  type = string
}