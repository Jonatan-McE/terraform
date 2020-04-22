resource "rancher2_cluster" "cluster_import" {
  count = var.management ? 0 : 1
  lifecycle {
    ignore_changes = [
      annotations
    ]
  }
  name        = lower(var.cluster_name)
  description = "${var.cluster_name}-Cluster"
  annotations = {
    "capabilities/pspEnabled" = "false"
  }
}

data "http" "cluster_import_manifest" {
  depends_on = [rancher2_cluster.cluster_import]
  count      = var.management ? 0 : 1
  url        = rancher2_cluster.cluster_import[0].cluster_registration_token[0].manifest_url
}

resource "local_file" "kube_cluster_import_yaml" {
  depends_on = [data.http.cluster_import_manifest]
  count      = var.management ? 0 : 1
  lifecycle {
    ignore_changes = [
      content
    ]
  }
  filename = ".kube/kubeconfig_${var.cluster_name}_cluster_import_manifest.yml"
  content  = data.http.cluster_import_manifest[0].body
}

resource "null_resource" "cluster_import" {
  depends_on = [rancher2_cluster.cluster_import, data.http.cluster_import_manifest]
  count      = var.management ? 0 : 1
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kube_cluster_yaml} --insecure-skip-tls-verify apply -f ${abspath(local_file.kube_cluster_import_yaml[0].filename)} "
  }
}

resource "null_resource" "dependency_setter" {
  count = var.management ? 0 : 1
  depends_on = [
    null_resource.cluster_import,
  ]
}
