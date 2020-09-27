data "rancher2_cluster" "cluster" {
  count      = var.management ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  name       = var.management ? "local" : lower(var.cluster_name)
}

data "rancher2_project" "system" {
  count      = var.management ? 1 : 0
  cluster_id = data.rancher2_cluster.cluster[0].id
  name       = "System"
}

resource "null_resource" "dependency_getter" {
  count      = var.management ? 1 : 0
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "kubernetes_namespace" "argocd" {
  count      = var.management ? 1 : 0
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
  metadata {
    annotations = {
      "field.cattle.io/projectId" = "${data.rancher2_project.system[0].id}"
    }
    name = var.argocd_settings.namespace
  }
}

resource "kubernetes_secret" "argocd" {
  count      = var.management ? 1 : 0
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name      = "argocd"
    namespace = kubernetes_namespace.argocd[0].metadata[0].name
  }
  data = {
    username = var.argocd_settings.git_username
    password = var.argocd_settings.git_password
  }
}

resource "helm_release" "argocd" {
  count      = var.management ? 1 : 0
  lifecycle {
    ignore_changes = [
      metadata[0]
    ]
  }
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "2.7.4"
  namespace  = kubernetes_namespace.argocd[0].metadata[0].name
  values = [templatefile(
    "${path.module}/argocd-values.tmpl.yaml", {
      cluster_name          = lower(var.cluster_name)
      namespace             = var.argocd_settings.namespace,
      git_repository        = var.argocd_settings.git_repository,
      git_path              = var.argocd_settings.git_path,
  })]
}
