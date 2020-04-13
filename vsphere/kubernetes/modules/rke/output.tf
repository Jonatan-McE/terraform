output "rke_api_server_url" {
  value = rke_cluster.cluster.api_server_url
}
output "rke_kube_admin_user" {
  value = rke_cluster.cluster.kube_admin_user
}
output "rke_client_key" {
  value = rke_cluster.cluster.client_key
}
output "rke_client_cert" {
  value = rke_cluster.cluster.client_cert
}
output "rke_ca_crt" {
  value = rke_cluster.cluster.ca_crt
}
output "rke_kubeconfig_filename" {
  value = abspath(local_file.kube_cluster_yaml.filename)
}