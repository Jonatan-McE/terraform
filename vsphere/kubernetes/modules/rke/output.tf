
output "depended_on" {
  value = length(null_resource.dependency_setter) > 0 ? null_resource.dependency_setter[0].id : ""
}

output "rke" {
  value = {
    api_server_url      = rke_cluster.cluster.api_server_url
    kube_admin_user     = rke_cluster.cluster.kube_admin_user
    client_key          = rke_cluster.cluster.client_key
    client_cert         = rke_cluster.cluster.client_cert
    ca_crt              = rke_cluster.cluster.ca_crt
    kubeconfig_filename = abspath(local_file.kube_cluster_yaml.filename)
  }
}