data "helm_repository" "argocd" {
  name = "argocd"
  url  = "https://argoproj.github.io/argo-helm"
}

resource "kubernetes_namespace" "argo-namespace" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
  metadata {
    name = var.argo_bootstrap.namespace
    labels = {
      owner = "administrators"
    }
  }
}

resource "kubernetes_secret" "argo" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name      = "argo-bootstrap"
    namespace = kubernetes_namespace.argo-namespace.metadata[0].name
  }
  data = {
    username = var.argo_bootstrap.username
    password = var.argo_bootstrap.password
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
  // repository = "https://argoproj.github.io/argo-helm"
  namespace  = kubernetes_namespace.argo-namespace.metadata[0].name
    values = [templatefile(
    "${path.module}/argo-bootstrap-values.yaml.tmpl", {
      bootstrap_path        = var.argo_bootstrap.path,
      bootstrap_namespace   = var.argo_bootstrap.namespace,
      bootstrap_branch      = var.argo_bootstrap_config.branch,
      bootstrap_environment = var.argo_bootstrap_config.environment,
      cluster_name          = var.cluster_name
  })]
}
