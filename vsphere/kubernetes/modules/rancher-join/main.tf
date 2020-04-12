resource "rancher2_cluster" "cluster_join" {
  lifecycle {
    ignore_changes = [
      annotations
    ]
  }
  name        = var.cluster_name
  description = "${var.cluster_name}-Cluster"
  annotations = {
    "capabilities/pspEnabled" = "true"
  }
}

data "http" "cluster_join_yaml" {
  depends_on = [rancher2_cluster.cluster_join]
  url        = rancher2_cluster.cluster_join.cluster_registration_token[0].manifest_url
}

resource "local_file" "kube_cluster_yaml" {
  depends_on = [data.http.cluster_join_yaml]
  filename   = ".kube/kubeconfig_${var.cluster_name}_join.yml"
  content    = data.http.cluster_join_yaml.body
}

resource "null_resource" "cluster_join" {
  depends_on = [rancher2_cluster.cluster_join, data.http.cluster_join_yaml]
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kubeconfig_filename} --insecure-skip-tls-verify apply -f .kube/kubeconfig_${var.cluster_name}_join.yml"
  }
}