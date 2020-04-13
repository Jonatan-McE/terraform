data "helm_repository" "rancher" {
  name = "stable"
  url  = "https://releases.rancher.com/server-charts/stable"
}

resource "kubernetes_namespace" "cattle-system" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
  metadata {
    name = "cattle-system"
  }
}

resource "kubernetes_secret" "ingress-secrets" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name      = "tls-rancher-ingress"
    namespace = "cattle-system"
  }
  data = {
    "tls.crt" = var.management_certificates.cert
    "tls.key" = var.management_certificates.key
  }
  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "ca-secrets" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name      = "tls-ca"
    namespace = "cattle-system"
  }
  data = {
    "cacerts.pem" = var.management_certificates.ca
  }
}

resource "helm_release" "rancher" {
  name       = "rancher"
  repository = data.helm_repository.rancher.metadata[0].name
  chart      = "rancher"
  namespace  = "cattle-system"
  set {
    name  = "hostname"
    value = var.management_url
  }
  set {
    name  = "ingress.tls.source"
    value = "secret"
  }
  set {
    name  = "privateCA"
    value = true
  }
}

resource "rancher2_bootstrap" "bootstrap" {
  depends_on = [helm_release.rancher]
  provider   = rancher2.bootstrap
  password   = var.management_default_password
  telemetry  = false
}
