data "helm_repository" "argocd" {
  name = "argocd"
  url  = "https://argoproj.github.io/argo-helm"
}

data "rancher2_cluster" "cluster" {
  depends_on = [null_resource.dependency_getter]
  name       = lower(var.cluster_name)
}

data "rancher2_project" "system" {
  cluster_id = data.rancher2_cluster.cluster.id
  name       = "System"
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
    name = var.argocd_settings.namespace
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
    username = var.argocd_settings.git_username
    password = var.argocd_settings.git_password
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
      cluster_name          = lower(var.cluster_name)
      namespace             = var.argocd_settings.namespace,
      environment           = var.argocd_settings.environment,
      git_repository        = var.argocd_settings.git_repository,
      git_path              = var.argocd_settings.git_path,
      git_branch            = var.argocd_settings.git_branch,
  })]
}
