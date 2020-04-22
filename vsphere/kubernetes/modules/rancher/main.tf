data "helm_repository" "rancher" {
  name = "latest"
  url  = "https://releases.rancher.com/server-charts/latest"
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
    "tls.crt" = var.management_api.certificates.cert
    "tls.key" = var.management_api.certificates.key
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
    "cacerts.pem" = var.management_api.certificates.ca
  }
}

resource "helm_release" "rancher" {
  name       = "rancher"
  repository = data.helm_repository.rancher.metadata[0].name
  chart      = "rancher"
  namespace  = "cattle-system"
  set {
    name  = "hostname"
    value = var.management_api.url.value
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
  password   = var.management_api.default-password.value
  telemetry  = false
}

resource "rancher2_auth_config_okta" "okta" {
  depends_on = [rancher2_bootstrap.bootstrap]
  provider   = rancher2.admin
  display_name_field = "displayName"
  groups_field = "groups"
  idp_metadata_content = var.management_api.okta.metadata
  rancher_api_host = "https://${var.management_api.url.value}"
  sp_cert = var.management_api.certificates.cert
  sp_key = var.management_api.certificates.key
  uid_field = "uid"
  user_name_field = "userName"
}
/*
resource "null_resource" "dependency_setter" {
  depends_on = [
    rancher2_bootstrap.bootstrap,
  ]
}
*/

