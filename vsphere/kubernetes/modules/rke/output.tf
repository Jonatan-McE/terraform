output "api_server_url" {
  value = rke_cluster.cluster.api_server_url
}
output "kube_admin_user" {
  value = rke_cluster.cluster.kube_admin_user
}
output "client_key" { 
    value = rke_cluster.cluster.client_key
}
output "client_cert" { 
    value = rke_cluster.cluster.client_cert
}
output "ca_crt" { 
    value = rke_cluster.cluster.ca_crt
}
output "kubeconfig_filename" { 
    value = abspath(local_file.kube_cluster_yaml.filename)
}