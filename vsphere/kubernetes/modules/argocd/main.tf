data "helm_repository" "argocd" {
  name = "argocd"
  url  = "https://argoproj.github.io/argo-helm"
}

data "rancher2_cluster" "cluster" {
  depends_on    = [null_resource.dependency_getter]
  name = lower(var.cluster_name)
}

data "rancher2_project" "system" {
    cluster_id = data.rancher2_cluster.cluster.id
    name = "System"
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}


resource "kubernetes_namespace" "argocd" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
  metadata {
    annotations = {
      "field.cattle.io/projectId" = "${data.rancher2_project.system.id}"
    }
    name = var.argocd.bootstrap_namespace
  }
}

resource "kubernetes_secret" "argocd" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name      = "argocd"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  data = {
    username = var.argocd.username
    password = var.argocd.password
  }
}

resource "helm_release" "argocd" {
  lifecycle {
    ignore_changes = [
      metadata[0]
    ]
  }
  name       = "argocd"
  chart      = "argo-cd"
  repository = data.helm_repository.argocd.metadata[0].url
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  values = [templatefile(
    "${path.module}/argocd-bootstrap-values.yaml.tmpl", {
      bootstrap_path          = var.argocd.bootstrap_path,
      bootstrap_branch        = var.argocd.bootstrap_branch,
      bootstrap_environment   = var.argocd.bootstrap_environment,
      bootstrap_namespace     = var.argocd.bootstrap_namespace,
      bootstrap_repository    = var.argocd.bootstrap_repository,
      cluster_name            = lower(var.cluster_name)
  })]
}
